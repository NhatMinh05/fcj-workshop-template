---
title: "Tổng quan về Workshop & Kiến trúc Hệ thống"
date: 2024-01-01
weight: 1
chapter: false
pre: " <b> 5.1. </b> "
---

# 5.1 Tổng quan về Workshop & Kiến trúc Hệ thống

### 1. Bối Cảnh Thực Tế & Đặt Vấn Đề

Trong xu hướng chuyển dịch mạnh mẽ lên điện toán đám mây (**Cloud Migration**), các tổ chức doanh nghiệp ngày càng phụ thuộc vào **Infrastructure as Code (IaC)** – đặc biệt là mã nguồn **Terraform (HCL)** – để tự động hóa quá trình cấp phát hạ tầng. Mặc dù IaC mang lại tốc độ triển khai vượt trội, nó cũng tiềm ẩn nguy cơ bảo mật diện rộng nếu các cấu hình sai sót (**Misconfigurations**) không được phát hiện từ sớm.

Theo các thống kê an ninh mạng đám mây toàn cầu:
- Hơn **80% các vụ rò rỉ dữ liệu trên Cloud** bắt nguồn từ các lỗi cấu hình cơ bản của con người (như mở cổng SSH 22 ra `0.0.0.0/0`, S3 bucket để chế độ công khai, không bật mã hóa dữ liệu nhàn rỗi SSE-KMS).
- Chi phí khắc phục lỗ hổng sau khi đã triển khai lên môi trường Production đắt hơn gấp **30 lần** so với việc phát hiện và sửa chữa ngay tại giai đoạn viết mã (nguyên lý **Shift-Left Security**).
- Các công cụ quét mã tĩnh truyền thống (như Checkov, tfsec) thường chỉ đối chiếu theo quy tắc cứng (Hardcoded regex), tỷ lệ cảnh báo giả (**False Positive**) cao, không có khả năng hiểu ngữ cảnh kiến trúc và không tự động viết lại đoạn mã đã sửa lỗi cho kỹ sư DevOps.

**CloudGuard AI** ra đời nhằm giải quyết triệt để vấn đề này bằng cách kết hợp sức mạnh suy luận logic sâu sắc của **Amazon Bedrock (Anthropic Claude 3.5 Sonnet)** cùng hệ thống tri thức chuẩn mực **CIS AWS Foundations Benchmark v3.0** thông qua kỹ thuật **RAG (Retrieval-Augmented Generation)**.

---

### 2. Sơ Đồ Kiến Trúc Giải Pháp (Solution Architecture)

Toàn bộ hệ thống CloudGuard AI được thiết kế theo chuẩn **AWS Well-Architected Framework**, vận hành hoàn toàn trên kiến trúc Serverless hướng sự kiện (**Event-Driven Serverless Architecture**), đảm bảo tính sẵn sàng cao, bảo mật nhiều lớp và chi phí tiệm cận 0 VNĐ khi không có yêu cầu quét.

Dưới đây là sơ đồ kiến trúc hoàn chỉnh của giải pháp:

![Sơ Đồ Kiến Trúc Hệ Thống CloudGuard AI](https://nhatminh05.github.io/fcj-workshop-template/images/2-Proposal/cloudguard_architecture.jpg)

---

### 3. Phân Tích Các Phân Tầng Hệ Thống (Architecture Layers)

Hệ thống được chia thành 6 phân tầng chức năng rõ rệt, kết nối mạch lạc với nhau:

1. **Phân tầng Cửa ngõ Toàn cầu & Bảo mật Biên (Global Services & Edge Security)**:
   - **AWS WAF**: Thiết lập bộ lọc Web ACL chặn đứng các cuộc tấn công DDoS, quét tự động và SQLi/XSS ngay tại biên mạng.
   - **AWS IAM**: Cung cấp các chính sách phân quyền theo nguyên tắc đặc quyền tối thiểu (Least Privilege) cho Lambda và Bedrock Agent.
   - **Amazon CloudFront**: Mạng phân phối nội dung CDN toàn cầu, chuyển tiếp lưu lượng an toàn với chứng chỉ số SSL/TLS do **AWS Certificate Manager (ACM)** quản lý tại vùng `us-east-1`.
   - **Amazon Cognito**: Cung cấp User Pools xác thực kỹ sư DevOps bằng chuỗi mã hóa JSON Web Token (JWT), bảo vệ toàn bộ các lời gọi API.

2. **Phân tầng Giao tiếp API & Quản lý Cấu hình (API Layer)**:
   - **Amazon API Gateway (HTTP API)**: Điểm tiếp nhận các yêu cầu quét mã (`POST /scan`) và tra cứu lịch sử (`GET /history`), hỗ trợ xác thực JWT và cơ chế giới hạn lưu lượng (Rate Limiting).
   - **AWS Systems Manager (SSM) Parameter Store**: Lưu trữ bảo mật các tham số hệ thống, ARN của Bedrock Knowledge Base và Webhook URL.
   - **AWS ACM (ap-southeast-1)**: Cấp phát chứng chỉ số SSL/TLS nội vùng cho tên miền API Gateway.

3. **Phân tầng Điều phối & Tính toán Cốt lõi (Compute & Scheduling Layer)**:
   - **AWS Lambda (Core Audit Engine)**: Trái tim tính toán Serverless chạy runtime Python 3.12, chịu trách nhiệm bóc tách cú pháp cây AST tệp Terraform, gửi truy vấn sang Bedrock RAG, tính điểm bảo mật và định dạng phản hồi.
   - **AWS Amplify**: Nền tảng phân phối giao diện web hiện đại (Next.js / React) giúp người dùng dán mã và xem kết quả trực quan.
   - **Amazon EventBridge Scheduler**: Bộ điều phối lịch trình Serverless tự động kích hoạt Lambda kiểm toán trạng thái hạ tầng định kỳ mỗi ngày.

4. **Phân tầng Dữ liệu & Lưu trữ (Data Layer)**:
   - **Amazon S3**: Lưu trữ tài liệu quy tắc tiêu chuẩn CIS Benchmark v3.0, các file Terraform mẫu và báo cáo kiểm toán xuất bản dạng PDF.
   - **Amazon DynamoDB**: Cơ sở dữ liệu NoSQL với độ trễ phản hồi tính bằng mili-giây, lưu trữ lịch sử các phiên quét, bảng điểm tuân thủ và danh sách lỗ hổng.
   - **Amazon SES**: Dịch vụ gửi email thông báo định kỳ và tóm tắt kết quả kiểm toán an ninh cho quản trị viên.

5. **Phân tầng Trí Tuệ Nhân Tạo Lõi (GenAI & RAG Brain Layer)**:
   - **Amazon Bedrock Agent**: Tác tử AI được trang bị mô hình **Anthropic Claude 3.5 Sonnet**, thực hiện suy luận logic đa bước, phân tích ngữ cảnh hạ tầng và sinh mã Terraform khắc phục lỗi chính xác.
   - **Bedrock Knowledge Bases (RAG)**: Sử dụng mô hình véc-tơ hóa **Amazon Titan Text Embeddings V2** kết hợp cơ sở dữ liệu véc-tơ (Vector Database) để tìm kiếm và trích xuất chính xác các điều khoản trong bộ tiêu chuẩn CIS AWS Foundations Benchmark.
   - **Bedrock Guardrails**: Vòng đai bảo vệ AI, ngăn ngừa tấn công tiêm nhiễm câu lệnh (Prompt Injection), lọc bỏ và che giấu các khóa bí mật (Secrets, AWS Access Keys) và thông tin định danh cá nhân (PII).

6. **Phân tầng Giám sát & Cảnh báo Tức thời (Monitoring & Alerting Layer)**:
   - **Amazon CloudWatch**: Thu thập tập trung nhật ký thực thi (Logs), số lượng token Bedrock tiêu thụ và các chỉ số vận hành.
   - **Amazon SNS**: Kênh phát tán thông báo tức thời (Pub/Sub), tự động gửi tin nhắn cảnh báo khẩn cấp tới quản trị viên ngay khi phát hiện lỗ hổng ở mức độ Nghiêm trọng (**CRITICAL**).

---

### 4. Quy Trình Vận Hành 5 Bước (End-to-End Workflow)

```
[Developer / CI-CD] --(1. Gửi mã Terraform)--> [API Gateway / CloudFront]
                                                        |
                                            (2. Kích hoạt Invoke)
                                                        v
                                             [AWS Lambda Core Engine]
                                               |                   |
                     (3. Truy vấn quy tắc CIS) |                   | (5. Lưu lịch sử)
                                               v                   v
                                      [Bedrock RAG Engine]    [DynamoDB Table]
                                               |                   |
                               (4. Claude 3.5 Sonnet Suy Luận)     | (6. Bắn Alert nếu CRITICAL)
                                               v                   v
                                      [Auto-Fix Code & Score]  [Amazon SNS / Email]
```

1. **Bước 1 (Gửi mã)**: Kỹ sư DevOps dán đoạn mã Terraform vào Dashboard hoặc hệ thống CI/CD (GitHub Actions) kích hoạt Webhook gửi payload chứa mã nguồn qua API Gateway (`POST /scan`).
2. **Bước 2 (Bóc tách)**: Lambda Core Engine tiếp nhận request, bóc tách cấu trúc cú pháp tài nguyên (Resource Types, Ingress/Egress Rules, Buckets, IAM Policies).
3. **Bước 3 (Truy vấn RAG)**: Lambda gửi ngữ cảnh tài nguyên vào Bedrock Knowledge Base để tìm kiếm các điều luật CIS Benchmark tương ứng.
4. **Bước 4 (AI Suy luận & Sinh mã)**: Mô hình Claude 3.5 Sonnet đối chiếu các điều khoản CIS được trích xuất, phân loại mức độ nghiêm trọng (CRITICAL / HIGH / MEDIUM / LOW), tính toán điểm số tuân thủ (0-100) và viết lại mã nguồn Terraform đã khắc phục hoàn chỉnh.
5. **Bước 5 (Lưu trữ & Cảnh báo)**: Bản ghi kiểm toán được lưu tức thì vào DynamoDB; nếu điểm số < 70 hoặc có lỗ hổng CRITICAL, Amazon SNS sẽ kích hoạt gửi email cảnh báo khẩn cấp cho ban quản trị.

---

### 5. Thông Số Bài Thực Hành (Lab Specifications)

- **Thời lượng dự kiến**: ~90 phút
- **Độ khó**: Trung cấp (Intermediate)
- **Khu vực AWS đề xuất**: `ap-southeast-1` (Singapore) hoặc `us-east-1` (N. Virginia)
- **Chi phí dự tính**: **0.00 USD** (Hoàn toàn nằm trong hạn mức miễn phí **AWS Free Tier** và gói Bedrock dùng thử).