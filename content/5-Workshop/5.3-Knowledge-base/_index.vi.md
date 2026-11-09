---
title: "Thiết lập RAG & Tri thức CIS Benchmark"
date: 2024-01-01
weight: 3
chapter: false
pre: " <b> 5.3. </b> "
---

# 5.3 Thiết lập RAG & Tri thức CIS Benchmark

Trọng tâm khác biệt của **CloudGuard AI** so với các công cụ kiểm toán truyền thống chính là kỹ thuật **RAG (Retrieval-Augmented Generation)**. Thay vì phó mặc cho mô hình AI tự "suy đoán" dựa trên kiến thức cũ (dễ dẫn đến hiện tượng ảo tưởng - Hallucination), chúng ta cung cấp cho AI cuốn "sách luật" chính thống: **Bộ tiêu chuẩn CIS AWS Foundations Benchmark v3.0**.

Trong bài thực hành này, bạn sẽ chuẩn hóa dữ liệu quy tắc, tải lên S3 Data Source, và khởi tạo một **Amazon Bedrock Knowledge Base** được véc-tơ hóa bằng mô hình **Amazon Titan Text Embeddings V2**.

---

### Bước 1: Chuẩn Bị Bộ Quy Tắc CIS Benchmark v3.0

Chúng ta tạo một tệp văn bản có cấu trúc rõ ràng chứa các điều khoản cốt lõi của bộ tiêu chuẩn an ninh quốc tế CIS AWS Foundations Benchmark v3.0.

1. Tạo tệp tin `cis_v3_benchmark_rules.txt` trên máy hoặc CloudShell:
```markdown
# CIS AWS FOUNDATIONS BENCHMARK V3.0 SECURITY SPECIFICATIONS

## SECTION 1: IDENTITY AND ACCESS MANAGEMENT (IAM)
### RULE CIS-1.16: Ensure IAM Policies Do Not Permit Full Administrative Privileges (*)
- Severity: CRITICAL
- Impact: Grants unauthorized entity total control over AWS infrastructure.
- Recommendation: Restrict permissions to specific actions and resources required for job duties. Avoid "Action": "*" and "Resource": "*".
- Terraform Fix Pattern:
  Avoid:
    Statement = [{ Action = "*", Resource = "*", Effect = "Allow" }]
  Enforce:
    Statement = [{ Action = ["s3:GetObject", "s3:PutObject"], Resource = "arn:aws:s3:::specific-bucket/*", Effect = "Allow" }]

## SECTION 2: STORAGE & AMAZON S3
### RULE CIS-2.1.1: Ensure S3 Bucket Has Default Encryption Enabled
- Severity: HIGH
- Impact: Unencrypted stored objects are susceptible to data exfiltration and compliance failure (HIPAA, PCI-DSS).
- Recommendation: Configure server-side encryption with SSE-S3 (AES256) or AWS KMS customer-managed keys (aws:kms).
- Terraform Fix Pattern:
  resource "aws_s3_bucket_server_side_encryption_configuration" "good" {
    bucket = aws_s3_bucket.target.id
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

### RULE CIS-2.1.2: Ensure S3 Bucket Has Public Access Block Configured
- Severity: CRITICAL
- Impact: Public buckets lead to catastrophic data leaks over the public internet.
- Recommendation: Enable block_public_acls, block_public_policy, ignore_public_acls, and restrict_public_buckets.
- Terraform Fix Pattern:
  resource "aws_s3_bucket_public_access_block" "good" {
    bucket                  = aws_s3_bucket.target.id
    block_public_acls       = true
    block_public_policy     = true
    ignore_public_acls      = true
    restrict_public_buckets = true
  }

## SECTION 4: NETWORKING & SECURITY GROUPS
### RULE CIS-4.1: Ensure No Security Group Allows Unrestricted Ingress to Port 22 (SSH)
- Severity: CRITICAL
- Impact: Exposing SSH port 22 to 0.0.0.0/0 allows brute-force attacks and unauthorized server takeover.
- Recommendation: Restrict port 22 access strictly to designated corporate VPN IP ranges (/32 or /24) or utilize AWS Systems Manager Session Manager (SSM) without open inbound ports.
- Terraform Fix Pattern:
  Avoid:
    cidr_blocks = ["0.0.0.0/0"]
  Enforce:
    cidr_blocks = ["10.0.0.0/16"] # Internal VPC or VPN gateway only

### RULE CIS-4.2: Ensure No Security Group Allows Unrestricted Ingress to Port 3389 (RDP)
- Severity: CRITICAL
- Impact: Exposing Windows RDP port 3389 to public CIDR ranges exposes workloads to ransomware and credential compromise.
- Recommendation: Restrict port 3389 inbound access to corporate bastion hosts or VPN CIDRs.

### RULE CIS-4.3: Ensure Database Ports (3306 MySQL, 5432 PostgreSQL) Are Not Open to 0.0.0.0/0
- Severity: HIGH
- Impact: Direct public internet exposure of databases enables automated injection and credential stuffing attacks.
- Recommendation: Database security groups must only accept traffic from application layer security groups.
```

2. Kiểm tra lại nội dung tệp vừa tạo:
```bash
wc -l cis_v3_benchmark_rules.txt
```

---

### Bước 2: Tải Bộ Dữ Liệu Lên Amazon S3 Data Source

Ta tải tệp quy tắc này vào thư mục `knowledge-base/` của S3 bucket đã tạo ở bài trước:

```bash
aws s3 cp cis_v3_benchmark_rules.txt s3://cloudguard-audit-data-${AWS_ACCOUNT_ID}/knowledge-base/
```

Kiểm tra để chắc chắn file đã có mặt trên S3:
```bash
aws s3 ls s3://cloudguard-audit-data-${AWS_ACCOUNT_ID}/knowledge-base/
```

---

### Bước 3: Khởi Tạo Amazon Bedrock Knowledge Base

Bây giờ chúng ta sẽ liên kết dữ liệu S3 vào **Amazon Bedrock Knowledge Bases**:

1. Mở **AWS Management Console**, chọn dịch vụ **Amazon Bedrock**.
2. Ở menu bên trái, nhấp vào **Knowledge bases** (dưới mục **Builder tools**).
3. Nhấp vào nút **Create knowledge base**.
4. **Bước 1 - Provide knowledge base details**:
   - **Knowledge base name**: Nhập `CloudGuard-CIS-KnowledgeBase`.
   - **Description**: `Authoritative repository of CIS AWS Foundations Benchmark v3.0 rules for automated IaC security audits.`
   - **IAM Permissions**: Chọn **Create and use a new service role** (Bedrock sẽ tự sinh Role phù hợp).
   - Nhấp **Next**.
5. **Bước 2 - Configure data source**:
   - **Data source name**: `cis-benchmark-s3-source`.
   - **S3 URI**: Nhấp nút **Browse S3** và chọn đường dẫn `s3://cloudguard-audit-data-[account-id]/knowledge-base/`.
   - Giữ nguyên các cấu hình chunking mặc định (**Default chunking** - 300 tokens, 20% overlap).
   - Nhấp **Next**.
6. **Bước 3 - Select embeddings model and configure vector store**:
   - **Embeddings model**: Chọn **Titan Text Embeddings V2** (`amazon.titan-embed-text-v2:0`) với kích thước 1,024 chiều.
   - **Vector database**: Chọn tùy chọn mặc định **Quick create a new vector store** (Amazon Bedrock sẽ tự động khởi tạo một collection **Amazon OpenSearch Serverless** được cấu hình tối ưu).
   - Nhấp **Next**.
7. **Bước 4 - Review and create**:
   - Rà soát lại toàn bộ thông số và nhấp **Create knowledge base**.
   - Quá trình khởi tạo OpenSearch Serverless và tạo index sẽ mất khoảng 3 đến 5 phút. Hãy kiên nhẫn chờ cho đến khi trang chi tiết Knowledge Base hiện lên.

---

### Bước 4: Đồng Bộ Dữ Liệu (Sync Data Source)

Sau khi Knowledge Base được tạo thành công:

1. Cuộn xuống phần **Data source** ở bên dưới trang chi tiết.
2. Chọn nguồn dữ liệu `cis-benchmark-s3-source`.
3. Nhấp vào nút **Sync**.
4. Quá trình Sync sẽ đọc tệp `cis_v3_benchmark_rules.txt`, cắt nhỏ thành các đoạn ngữ nghĩa (chunks), gọi mô hình Titan Text Embeddings V2 để biến các đoạn văn thành véc-tơ số học và lưu trữ vào OpenSearch Serverless.
5. Sau khoảng 1-2 phút, cột **Status** sẽ hiển thị màu xanh: **Complete**.

Ghi lại mã **Knowledge Base ID** (ví dụ: `AB1CDE2FGH`) hiển thị ngay dưới tên Knowledge Base, bạn sẽ cần truyền giá trị này vào mã nguồn hàm Lambda ở bước tiếp theo!

---

### Bước 5: Kiểm Thử Truy Vấn Ngữ Nghĩa Trực Tiếp Trên Console

Amazon Bedrock cung cấp sẵn cửa sổ **Test knowledge base** ngay bên cạnh màn hình cấu hình:

1. Ở khung bên phải, chọn mô hình sinh văn bản (**Select model**): Chọn **Anthropic Claude 3.5 Sonnet**.
2. Nhập câu hỏi kiểm thử:
   > *"Theo tiêu chuẩn CIS Benchmark, cổng SSH 22 mở ra 0.0.0.0/0 bị đánh giá mức độ nghiêm trọng nào và cách sửa mã Terraform như thế nào?"*
3. Nhấp **Run**.
4. Quan sát kết quả:
   - Mô hình sẽ trả lời chính xác: Lỗ hổng thuộc điều luật **CIS-4.1**, mức độ nghiêm trọng là **CRITICAL**.
   - Mô hình trích dẫn chuẩn xác đoạn mã Terraform khuyến nghị (`cidr_blocks = ["10.0.0.0/16"]` hoặc sử dụng AWS Systems Manager).
   - Nhấp vào phần **Citations (Trích dẫn)** bên dưới câu trả lời: Bạn sẽ thấy AI chỉ ra chính xác đoạn văn bản nằm trong tệp `cis_v3_benchmark_rules.txt` đã được truy xuất từ S3!

Điều này chứng minh hệ thống RAG đã vận hành chuẩn xác 100%. Tiếp theo, chúng ta sẽ xây dựng **Hàm Lambda Core Audit Engine** để tự động hóa toàn bộ quy trình này qua API!