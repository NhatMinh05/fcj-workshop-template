---
title: "Chuẩn bị Môi trường & Cấp quyền IAM"
date: 2024-01-01
weight: 2
chapter: false
pre: " <b> 5.2. </b> "
---

# 5.2 Chuẩn bị Môi trường & Cấp quyền IAM

Trước khi tiến hành xây dựng các thành phần của hệ thống CloudGuard AI, bạn cần chuẩn bị môi trường tài khoản AWS, kích hoạt quyền sử dụng các mô hình Trí tuệ Nhân tạo trong **Amazon Bedrock**, và khởi tạo các tài nguyên phụ trợ ban đầu (S3, DynamoDB, IAM Role).

---

### Bước 1: Kiểm Tra Tài Khoản & Cấu Hình AWS CLI

Bạn có thể thực hiện bài lab trực tiếp thông qua **AWS CloudShell** (giao diện dòng lệnh tích hợp sẵn trên AWS Management Console) hoặc trên máy tính cá nhân đã cài đặt **AWS CLI v2**.

1. Mở terminal và kiểm tra danh tính tài khoản AWS đang đăng nhập:
```bash
aws sts get-caller-identity
```

Kết quả trả về sẽ có dạng:
```json
{
    "UserId": "AIDASAMPLEUSERIDEXAMPLE",
    "Account": "123456789012",
    "Arn": "arn:aws:iam::123456789012:user/devops-admin"
}
```

2. Lưu lại mã số tài khoản AWS (**AWS Account ID**) của bạn (ví dụ: `123456789012`) vì bạn sẽ cần sử dụng nó để đặt tên cho các tài nguyên duy nhất trên toàn cầu (S3 Bucket).

3. Đặt biến môi trường cho khu vực triển khai (ưu tiên chọn `ap-southeast-1` Singapore hoặc `us-east-1` N. Virginia nơi có đầy đủ các mô hình Bedrock mới nhất):
```bash
export AWS_REGION="ap-southeast-1"
export AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
```

---

### Bước 2: Kích Hoạt Quyền Truy Cập Mô Hình Trong Amazon Bedrock

Amazon Bedrock yêu cầu người dùng phải chủ động gửi yêu cầu cấp quyền (**Request Model Access**) trước khi có thể gọi API tới các mô hình nền tảng (Foundation Models).

1. Truy cập vào **AWS Management Console** và tìm kiếm dịch vụ **Amazon Bedrock**.
2. Ở thanh điều hướng bên trái, cuộn xuống mục **Bedrock configurations** và chọn **Model access**.
3. Nhấp vào nút **Modify model access** (hoặc **Enable specific models**).
4. Đánh dấu chọn 2 mô hình cốt lõi sau:
   - **Anthropic**: Chọn `Claude 3.5 Sonnet` (hoặc `Claude 3 Sonnet`).
   - **Amazon**: Chọn `Titan Text Embeddings V2`.
5. Nhấp **Next**, chấp nhận các điều khoản sử dụng (EULA) và nhấp **Submit**.
6. Chờ từ 1-2 phút cho đến khi cột **Access status** của cả 2 mô hình chuyển sang trạng thái màu xanh lá: **Access granted**.

---

### Bước 3: Khởi Tạo Amazon S3 Bucket Cho Tri Thức CIS

Amazon S3 sẽ đóng vai trò làm kho lưu trữ nguồn dữ liệu (**Data Source**) cho Bedrock Knowledge Base.

1. Tạo một S3 bucket mới với tên duy nhất toàn cầu:
```bash
aws s3 mb s3://cloudguard-audit-data-${AWS_ACCOUNT_ID} --region ${AWS_REGION}
```

2. Bật tính năng chặn toàn bộ truy cập công khai (**Block Public Access**) để bảo mật tuyệt đối dữ liệu:
```bash
aws s3api put-public-access-block \
    --bucket cloudguard-audit-data-${AWS_ACCOUNT_ID} \
    --public-access-block-configuration "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true"
```

3. Bật tính năng mã hóa mặc định (**Server-Side Encryption with SSE-S3**):
```bash
aws s3api put-bucket-encryption \
    --bucket cloudguard-audit-data-${AWS_ACCOUNT_ID} \
    --server-side-encryption-configuration '{"Rules": [{"ApplyServerSideEncryptionByDefault": {"SSEAlgorithm": "AES256"}}]}'
```

4. Tạo thư mục con `knowledge-base/` bên trong bucket để sẵn sàng đón nhận các file quy tắc CIS Benchmark:
```bash
aws s3api put-object --bucket cloudguard-audit-data-${AWS_ACCOUNT_ID} --key knowledge-base/
```

---

### Bước 4: Khởi Tạo Bảng Amazon DynamoDB Lưu Trữ Lịch Sử Quét

Hệ thống cần lưu lại toàn bộ kết quả của các phiên kiểm toán (thời gian, điểm số an ninh, danh sách lỗ hổng và mã đã sửa). Ta sử dụng **Amazon DynamoDB** ở chế độ **On-Demand** để hoàn toàn miễn phí khi không có truy vấn.

1. Chạy lệnh tạo bảng `CloudGuard_ScanHistory` với Partition Key là `scan_id`:
```bash
aws dynamodb create-table \
    --table-name CloudGuard_ScanHistory \
    --attribute-definitions AttributeName=scan_id,AttributeType=S \
    --key-schema AttributeName=scan_id,KeyType=HASH \
    --billing-mode PAY_PER_REQUEST \
    --region ${AWS_REGION}
```

2. Kiểm tra xem bảng đã chuyển sang trạng thái `ACTIVE` hay chưa:
```bash
aws dynamodb describe-table \
    --table-name CloudGuard_ScanHistory \
    --query "Table.TableStatus" \
    --output text
```

---

### Bước 5: Cấp Quyền IAM Execution Role Cho AWS Lambda

Hàm Lambda Core Audit Engine cần có các quyền truy cập hạn chế (Least Privilege) để có thể gọi Bedrock RAG, đọc S3, ghi DynamoDB và xuất nhật ký CloudWatch Logs.

1. Tạo tệp Trust Policy cho phép dịch vụ Lambda đảm nhận vai trò (`lambda-trust-policy.json`):
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
```

2. Tạo IAM Role `CloudGuard_Lambda_ExecutionRole`:
```bash
aws iam create-role \
    --role-name CloudGuard_Lambda_ExecutionRole \
    --assume-role-policy-document file://lambda-trust-policy.json
```

3. Tạo tệp chính sách quyền hạn chi tiết (`lambda-permissions-policy.json`):
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "BedrockInvokePermissions",
      "Effect": "Allow",
      "Action": [
        "bedrock:InvokeModel",
        "bedrock:Retrieve",
        "bedrock:RetrieveAndGenerate"
      ],
      "Resource": "*"
    },
    {
      "Sid": "S3BucketAccess",
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:PutObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::cloudguard-audit-data-*",
        "arn:aws:s3:::cloudguard-audit-data-*/*"
      ]
    },
    {
      "Sid": "DynamoDBReadWrite",
      "Effect": "Allow",
      "Action": [
        "dynamodb:PutItem",
        "dynamodb:GetItem",
        "dynamodb:Query",
        "dynamodb:Scan"
      ],
      "Resource": "arn:aws:dynamodb:*:*:table/CloudGuard_ScanHistory"
    },
    {
      "Sid": "CloudWatchLogs",
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*"
    },
    {
      "Sid": "SNSPublish",
      "Effect": "Allow",
      "Action": [
        "sns:Publish"
      ],
      "Resource": "*"
    }
  ]
}
```

4. Gắn policy này vào Role vừa tạo:
```bash
aws iam put-role-policy \
    --role-name CloudGuard_Lambda_ExecutionRole \
    --policy-name CloudGuard_Core_Policy \
    --policy-document file://lambda-permissions-policy.json
```

Như vậy, toàn bộ môi trường và các quyền hạn cơ bản đã được thiết lập chuẩn mực. Trong bước tiếp theo, chúng ta sẽ bắt đầu xây dựng **Kho tri thức Bedrock Knowledge Base với CIS Benchmark v3.0**!