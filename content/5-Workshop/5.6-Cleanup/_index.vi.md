---
title: "Kiểm thử Thực Tế & Dọn dẹp Tài nguyên"
date: 2024-01-01
weight: 6
chapter: false
pre: " <b> 5.6. </b> "
---

# 5.6 Kiểm thử Thực Tế & Dọn dẹp Tài nguyên

Chào mừng bạn đến với bài thực hành cuối cùng trong chuỗi workshop **CloudGuard AI**! Trong bài này, chúng ta sẽ:
1. **Chạy kịch bản kiểm thử toàn diện (End-to-End Validation)** với một tệp mã nguồn Terraform phức tạp chứa đồng thời nhiều lỗi an ninh kinh điển.
2. **Xác nhận luồng vận hành khép kín**: Phân tích cú pháp -> Truy vấn RAG CIS Benchmark -> Claude 3.5 Sonnet suy luận -> Chấm điểm -> Sinh mã sửa lỗi -> Lưu DynamoDB -> Gửi cảnh báo SNS qua Email.
3. **Thực hiện quy trình dọn dẹp tài nguyên (Clean up)** an toàn, đảm bảo bạn không phải chi trả bất kỳ khoản phí ngoài ý muốn nào trên tài khoản AWS của mình.

---

### Bước 1: Kịch Bản Kiểm Thử Toàn Diện (End-to-End Test Case)

Chúng ta chuẩn bị một đoạn mã Terraform đại diện cho một dự án thực tế nhưng mắc phải 4 lỗi cấu hình an ninh nghiêm trọng nhất:
1. **Lỗi CIS-4.1**: Security Group mở toang cổng SSH 22 ra toàn bộ Internet (`0.0.0.0/0`).
2. **Lỗi CIS-2.1.1**: S3 Bucket không cấu hình mã hóa phía máy chủ (SSE).
3. **Lỗi CIS-2.1.2**: S3 Bucket không kích hoạt tính năng Block Public Access.
4. **Lỗi CIS-1.16**: IAM Policy gán quyền toàn năng wildcard (`"Action": "*", "Resource": "*"`).

1. Tạo tệp kiểm thử `vulnerable_infrastructure.tf`:
```hcl
# 1. Security Group mở cổng SSH 22 nguy hiểm
resource "aws_security_group" "bastion_host" {
  name        = "bastion-sg"
  description = "Public Bastion Host Security Group"
  vpc_id      = "vpc-0123456789abcdef0"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # VI PHẠM CIS-4.1
  }
}

# 2. S3 Bucket không mã hóa và không chặn Public
resource "aws_s3_bucket" "financial_reports" {
  bucket = "company-financial-reports-2026"
  # VI PHẠM CIS-2.1.1 (Thiếu encryption) & CIS-2.1.2 (Thiếu Public Access Block)
}

# 3. IAM Policy cấp quyền wildcard nguy hiểm
resource "aws_iam_policy" "dev_admin" {
  name        = "dev-admin-policy"
  description = "Excessive developer privileges"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "*" # VI PHẠM CIS-1.16
        Resource = "*"
      }
    ]
  })
}
```

2. Gửi tệp này tới API Gateway của CloudGuard AI:
```bash
# Đọc file và chuyển thành chuỗi JSON payload
TF_CONTENT=$(cat vulnerable_infrastructure.tf | python -c "import json, sys; print(json.dumps(sys.stdin.read()))")

curl -X POST "https://${API_ID}.execute-api.${AWS_REGION}.amazonaws.com/scan" \
  -H "Content-Type: application/json" \
  -d "{"terraform_code": ${TF_CONTENT}}"
```

---

### Bước 2: Phân Tích Kết Quả Kiểm Toán Trả Về

Kết quả trả về từ CloudGuard AI sẽ đạt độ chuẩn xác vượt bậc so với các công cụ tĩnh:

```json
{
  "scan_id": "9e24a1b8-6d20-410a-b271-93c4e0987114",
  "scanned_at": "2026-11-09T09:50:15Z",
  "score": 25,
  "summary": "CRITICAL RISK: Found 4 severe misconfigurations violating CIS AWS Foundations Benchmark v3.0. Deployment halted.",
  "findings": [
    {
      "rule_id": "CIS-4.1",
      "severity": "CRITICAL",
      "resource": "aws_security_group.bastion_host",
      "description": "Port 22 SSH is open to the public internet (0.0.0.0/0), exposing instance to brute-force credential stuffing.",
      "recommendation": "Restrict ingress to internal corporate CIDR (/16 or /24) or use AWS Systems Manager Session Manager."
    },
    {
      "rule_id": "CIS-1.16",
      "severity": "CRITICAL",
      "resource": "aws_iam_policy.dev_admin",
      "description": "IAM Policy grants full administrative privileges (*) across all resources, violating Principle of Least Privilege.",
      "recommendation": "Enumerate granular service actions and define specific ARNs in Resource block."
    },
    {
      "rule_id": "CIS-2.1.1",
      "severity": "HIGH",
      "resource": "aws_s3_bucket.financial_reports",
      "description": "Default server-side encryption is not enforced on the S3 bucket.",
      "recommendation": "Define aws_s3_bucket_server_side_encryption_configuration with AES256 or KMS."
    },
    {
      "rule_id": "CIS-2.1.2",
      "severity": "CRITICAL",
      "resource": "aws_s3_bucket.financial_reports",
      "description": "S3 Public Access Block configuration is missing, allowing potential public exposure of financial data.",
      "recommendation": "Attach aws_s3_bucket_public_access_block with all 4 guardrails enabled."
    }
  ],
  "remediated_code": "# REMEDIATED BY CLOUDGUARD AI (CLAUDE 3.5 SONNET)\n\nresource "aws_security_group" "bastion_host" {\n  name        = "bastion-sg"\n  description = "Secure Bastion Host Security Group"\n  vpc_id      = "vpc-0123456789abcdef0"\n\n  ingress {\n    from_port   = 22\n    to_port     = 22\n    protocol    = "tcp"\n    cidr_blocks = ["10.0.0.0/16"] # Fixed: restricted to internal VPC\n  }\n}\n\nresource "aws_s3_bucket" "financial_reports" {\n  bucket = "company-financial-reports-2026"\n}\n\nresource "aws_s3_bucket_server_side_encryption_configuration" "financial_reports_enc" {\n  bucket = aws_s3_bucket.financial_reports.id\n  rule {\n    apply_server_side_encryption_by_default {\n      sse_algorithm = "AES256"\n    }\n  }\n}\n\nresource "aws_s3_bucket_public_access_block" "financial_reports_pab" {\n  bucket                  = aws_s3_bucket.financial_reports.id\n  block_public_acls       = true\n  block_public_policy     = true\n  ignore_public_acls      = true\n  restrict_public_buckets = true\n}\n\nresource "aws_iam_policy" "dev_admin" {\n  name        = "dev-scoped-policy"\n  description = "Scoped developer permissions following Least Privilege"\n\n  policy = jsonencode({\n    Version = "2012-10-17"\n    Statement = [\n      {\n        Effect   = "Allow"\n        Action   = ["ec2:Describe*", "s3:ListBucket", "s3:GetObject"]\n        Resource = "*"\n      }\n    ]\n  })\n}"
}
```

3. **Kiểm tra thông báo Email khẩn cấp**:
   - Mở hòm thư đã đăng ký SNS ở Bài 5.5: Bạn sẽ thấy ngay một email cảnh báo với tiêu đề:
     `[URGENT] CloudGuard Security Violation Detected`
   - Nội dung thư tóm tắt đúng điểm số 25/100 và danh sách các lỗi nghiêm trọng vừa phát hiện!

---

### Bước 3: Quy Trình Dọn Dẹp Tài Nguyên (Clean Up)

Sau khi hoàn tất bài workshop, để tránh phát sinh chi phí duy trì tài nguyên trên tài khoản AWS của bạn, hãy thực hiện dọn dẹp theo thứ tự các bước dưới đây:

#### 1. Xóa Lịch Trình EventBridge Scheduler:
```bash
aws scheduler delete-schedule --name "CloudGuard-DailyPosturedAudit" --region ${AWS_REGION}
```

#### 2. Xóa Amazon API Gateway:
```bash
aws apigatewayv2 delete-api --api-id ${API_ID} --region ${AWS_REGION}
```

#### 3. Xóa Hàm AWS Lambda & Nhóm Nhật Ký CloudWatch:
```bash
aws lambda delete-function --function-name cloudguard-core-audit-engine --region ${AWS_REGION}
aws logs delete-log-group --log-group-name "/aws/lambda/cloudguard-core-audit-engine" --region ${AWS_REGION}
```

#### 4. Xóa Amazon Bedrock Knowledge Base & Vector Store:
- Mở **Amazon Bedrock Console** -> **Knowledge bases**.
- Chọn `CloudGuard-CIS-KnowledgeBase` và nhấp nút **Delete**.
- Chuyển sang dịch vụ **Amazon OpenSearch Service** -> mục **Serverless: Collections**, xóa collection véc-tơ tương ứng do Bedrock sinh ra để không bị tính phí lưu trữ OpenSearch.

#### 5. Xóa Bảng Amazon DynamoDB:
```bash
aws dynamodb delete-table --table-name CloudGuard_ScanHistory --region ${AWS_REGION}
```

#### 6. Xóa Toàn Bộ Đối Tượng & S3 Bucket:
```bash
aws s3 rm s3://cloudguard-audit-data-${AWS_ACCOUNT_ID} --recursive
aws s3 rb s3://cloudguard-audit-data-${AWS_ACCOUNT_ID} --force --region ${AWS_REGION}
```

#### 7. Xóa Kênh Thông Báo Amazon SNS:
```bash
aws sns delete-topic --topic-arn ${SNS_TOPIC_ARN} --region ${AWS_REGION}
```

#### 8. Xóa Các IAM Roles & Policies Đã Tạo:
```bash
aws iam delete-role-policy --role-name CloudGuard_Lambda_ExecutionRole --policy-name CloudGuard_Core_Policy
aws iam delete-role --role-name CloudGuard_Lambda_ExecutionRole

aws iam delete-role-policy --role-name CloudGuard_Scheduler_Role --policy-name InvokeLambdaPolicy
aws iam delete-role --role-name CloudGuard_Scheduler_Role
```

---

### Tổng Kết Thành Quả (Workshop Summary)

Chúc mừng bạn đã hoàn thành xuất sắc chuỗi bài thực hành **CloudGuard AI**! 

Qua bài workshop này, bạn đã tự tay tích lũy được những kỹ năng thực chiến giá trị bậc nhất của một kỹ sư Cloud / DevSecOps hiện đại:
- **Kiến trúc GenAI & RAG chuyên sâu**: Nắm rõ cách biến bộ tiêu chuẩn an ninh quốc tế (CIS Benchmark) thành vector database và khai phóng sức mạnh suy luận của Claude 3.5 Sonnet.
- **Tư duy Shift-Left Security**: Nhận thức sâu sắc tầm quan trọng của việc kiểm toán an ninh ngay từ giai đoạn viết mã Terraform (IaC) trước khi triển khai.
- **Thiết kế hệ thống Serverless hướng sự kiện (Event-Driven)**: Vận hành một hệ thống bảo mật tự động hóa hoàn toàn với chi phí tối ưu tối đa (Zero Idle Cost).