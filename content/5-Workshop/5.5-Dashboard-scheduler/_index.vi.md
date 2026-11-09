---
title: "Triển khai Dashboard & Lập lịch Quét Tự Động"
date: 2024-01-01
weight: 5
chapter: false
pre: " <b> 5.5. </b> "
---

# 5.5 Triển khai Dashboard & Lập lịch Quét Tự Động

Một hệ thống kiểm toán an ninh hiệu quả không thể chỉ dừng lại ở các dòng lệnh trong terminal. Để phục vụ tốt nhất cho các kỹ sư DevOps và đội ngũ quản lý, **CloudGuard AI** cung cấp:
1. **Giao diện Web Dashboard trực quan** (xây dựng bằng React / Next.js và triển khai trên **AWS Amplify**).
2. **Hệ thống lập lịch tự động hóa Serverless** bằng **Amazon EventBridge Scheduler** để tự động quét kiểm toán định kỳ mà không cần con người can thiệp thủ công.
3. **Kênh cảnh báo tức thời** qua **Amazon SNS** khi phát hiện lỗ hổng ở mức độ Nghiêm trọng (**CRITICAL**).

---

### Bước 1: Kiến Trúc Giao Diện Web Dashboard Trực Quan

Giao diện web của CloudGuard AI được thiết kế tối giản, hiện đại và tập trung vào trải nghiệm người dùng (**User Experience**):

```
+-----------------------------------------------------------------------------------+
|  🛡️ CloudGuard AI - DevSecOps & FinOps Posture Dashboard                         |
+-----------------------------------------------------------------------------------+
|  [ Paste Terraform Code Here ]                                                    |
|  resource "aws_security_group" "web" { ... }                                      |
|                                                                                   |
|  [ ⚡ Run Security & Cost Audit Now ]                                             |
+-----------------------------------------+-----------------------------------------+
|  📊 COMPLIANCE SCORE:                   |  🚨 DETECTED VIOLATIONS (2):            |
|     [ 45 / 100 ] (POOR - CRITICAL)      |  • CIS-4.1 [CRITICAL] SSH Port 22 Open  |
|                                         |  • CIS-2.1.1 [HIGH] S3 Unencrypted      |
+-----------------------------------------+-----------------------------------------+
|  ✨ REMEDIATED CODE (READY TO DEPLOY):                                            |
|  resource "aws_security_group" "web" {                                            |
|    cidr_blocks = ["10.0.0.0/16"]  # Fixed by Claude 3.5 Sonnet                     |
|  }                                                                                |
|  [ 📋 Copy Remediated Code ]                                                      |
+-----------------------------------------------------------------------------------+
```

#### Các Khối Chức Năng Chính:
1. **Code Editor Input**: Khung soạn thảo cho phép lập trình viên dán trực tiếp nội dung các file `main.tf`, `variables.tf`.
2. **Security Gauge Visualizer**: Vòng cung hiển thị trực quan điểm số từ 0 đến 100:
   - **Đỏ (0 - 49)**: Mức độ rủi ro rất cao, vi phạm các quy tắc nghiêm trọng (cấm deploy lên Production).
   - **Vàng (50 - 79)**: Có cảnh báo mức trung bình/cao, cần xem xét rà soát trước khi merge mã.
   - **Xanh lá (80 - 100)**: Đạt chuẩn tuân thủ CIS Benchmark, hạ tầng an toàn và tối ưu chi phí.
3. **Findings Accordion**: Danh sách các lỗi phát hiện có gắn nhãn Badge phân loại (**CRITICAL**, **HIGH**, **MEDIUM**, **LOW**), kèm theo mô tả nguyên nhân và điều luật CIS bị vi phạm.
4. **Auto-Remediation Diff Viewer**: Cung cấp đoạn mã Terraform chuẩn xác đã được AI viết lại, kèm nút **"Copy Code"** một chạm để dán ngược lại vào dự án.

---

### Bước 2: Thiết Lập Lập Lịch Quét Tự Động Bằng Amazon EventBridge Scheduler

Để đảm bảo các hạ tầng đang vận hành không bị phát sinh lỗ hổng mới theo thời gian (ví dụ: một kỹ sư vô tình mở thêm cổng bảo mật trong giờ bảo trì), ta thiết lập **Amazon EventBridge Scheduler** kích hoạt hàm Lambda tự động chạy vào lúc 1:00 AM mỗi ngày.

1. Tạo IAM Role cho phép EventBridge Scheduler invoke hàm Lambda (`scheduler-trust-policy.json`):
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "scheduler.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
```

2. Tạo Role `CloudGuard_Scheduler_Role`:
```bash
aws iam create-role \
    --role-name CloudGuard_Scheduler_Role \
    --assume-role-policy-document file://scheduler-trust-policy.json
```

3. Cấp quyền cho Role được gọi hàm Lambda:
```bash
aws iam put-role-policy \
    --role-name CloudGuard_Scheduler_Role \
    --policy-name InvokeLambdaPolicy \
    --policy-document "{
        \"Version\": \"2012-10-17\",
        \"Statement\": [
            {
                \"Effect\": \"Allow\",
                \"Action\": \"lambda:InvokeFunction\",
                \"Resource\": \"${LAMBDA_ARN}\"
            }
        ]
    }"
```

4. Tạo một Schedule chạy định kỳ hàng ngày bằng biểu thức Cron:
```bash
aws scheduler create-schedule \
    --name "CloudGuard-DailyPosturedAudit" \
    --schedule-expression "cron(0 1 * * ? *)" \
    --flexible-time-window '{"Mode": "OFF"}' \
    --target "{
        \"Arn\": \"${LAMBDA_ARN}\",
        \"RoleArn\": \"arn:aws:iam::${AWS_ACCOUNT_ID}:role/CloudGuard_Scheduler_Role\",
        \"Input\": \"{\\\"terraform_code\\\": \\\"resource \\\\\"aws_security_group\\\\\" \\\\\"default\\\\\" { ingress { from_port = 22 to_port = 22 protocol = \\\\\"tcp\\\\\" cidr_blocks = [\\\\\"0.0.0.0/0\\\\\"] } }\\\"}\"
    }" \
    --region ${AWS_REGION}
```

Kiểm tra trạng thái Schedule vừa tạo:
```bash
aws scheduler get-schedule --name "CloudGuard-DailyPosturedAudit" --region ${AWS_REGION}
```

---

### Bước 3: Cấu Hình Amazon SNS Cảnh Báo Khẩn Cấp Khi Phát Hiện Lỗ Hổng CRITICAL

Khi phát hiện các lỗ hổng mang tính đe dọa sinh tử tới hệ thống (như lộ khóa truy cập AWS, mở cổng cơ sở dữ liệu hoặc mở SSH ra công cộng), hệ thống sẽ lập tức phát đi cảnh báo qua **Amazon SNS**.

1. Tạo một SNS Topic có tên `cloudguard-critical-alerts`:
```bash
SNS_TOPIC_ARN=$(aws sns create-topic \
    --name cloudguard-critical-alerts \
    --query "TopicArn" \
    --output text \
    --region ${AWS_REGION})

echo "SNS Topic ARN: ${SNS_TOPIC_ARN}"
```

2. Đăng ký địa chỉ Email nhận thông báo khẩn cấp:
```bash
aws sns subscribe \
    --topic-arn ${SNS_TOPIC_ARN} \
    --protocol email \
    --notification-endpoint "your-email@example.com" \
    --region ${AWS_REGION}
```
*(Thay thế `your-email@example.com` bằng địa chỉ email thực tế của bạn, sau đó mở hòm thư và nhấp vào đường link **Confirm subscription** do AWS gửi tới).*

3. Cập nhật hàm Lambda để tự động bắn cảnh báo lên SNS Topic này:
Trong hàm `lambda_function.py`, bổ sung khối logic kiểm tra:
```python
# Bổ sung logic gửi cảnh báo nếu phát hiện vi phạm CRITICAL
has_critical = any(f.get('severity') == 'CRITICAL' for f in audit_result.get('findings', []))

if has_critical or audit_result.get('score', 100) < 70:
    sns_client = boto3.client('sns', region_name=os.environ.get('AWS_REGION', 'ap-southeast-1'))
    sns_topic_arn = os.environ.get('SNS_TOPIC_ARN')
    if sns_topic_arn:
        alert_message = (
            f"🚨 [CloudGuard AI ALERT] CRITICAL Misconfiguration Detected!\n"
            f"Scan ID: {scan_id}\n"
            f"Posture Score: {audit_result.get('score')}/100\n"
            f"Summary: {audit_result.get('summary')}\n\n"
            f"Please review the audit findings immediately on CloudGuard Dashboard."
        )
        sns_client.publish(
            TopicArn=sns_topic_arn,
            Subject="[URGENT] CloudGuard Security Violation Detected",
            Message=alert_message
        )
```

Cập nhật lại biến môi trường `SNS_TOPIC_ARN` cho Lambda:
```bash
aws lambda update-function-configuration \
    --function-name cloudguard-core-audit-engine \
    --environment "Variables={KNOWLEDGE_BASE_ID=${KNOWLEDGE_BASE_ID},DYNAMODB_TABLE=CloudGuard_ScanHistory,SNS_TOPIC_ARN=${SNS_TOPIC_ARN},AWS_REGION=${AWS_REGION}}" \
    --region ${AWS_REGION}
```

Bây giờ hệ thống đã có đầy đủ: Giao diện trực quan cho người dùng, Lập lịch quét tự động định kỳ, và Cơ chế cảnh báo khẩn cấp tức thời qua Email. Ở bài thực hành cuối cùng, chúng ta sẽ thực hiện **Kiểm thử toàn diện và Dọn dẹp tài nguyên để không tốn chi phí**!