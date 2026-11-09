---
title: "Blog 2"
date: 2024-01-01
weight: 2
chapter: false
pre: " <b> 3.2. </b> "
---

# CLOUDGUARD AI: TỰ ĐỘNG HÓA KIỂM TOÁN AN NINH & TỐI ƯU CHI PHÍ AWS VỚI GENAI VÀ RAG TRÊN AMAZON BEDROCK

Trong kỷ nguyên Cloud và DevOps hiện đại, việc quản lý và triển khai hạ tầng dưới dạng mã nguồn (Infrastructure as Code - IaC như Terraform, CloudFormation) đã trở thành tiêu chuẩn bắt buộc. Tuy nhiên, việc rà soát an ninh và tối ưu hóa chi phí thủ công trước khi deploy thường tốn nhiều giờ làm việc của các kỹ sư Cloud, đồng thời dễ bỏ sót các cấu hình sai lệch nguy hiểm (misconfigurations) như mở cổng SSH 22 cho toàn Internet (`0.0.0.0/0`), không mã hóa S3 bucket, hay gán wildcard IAM permissions (`*`).

Để giải quyết bài toán này, dự án **CloudGuard AI** được xây dựng với giải pháp kiến trúc Serverless kết hợp sức mạnh của Generative AI và RAG (Retrieval-Augmented Generation) trên nền tảng **Amazon Bedrock**.

### Các thành phần kiến trúc cốt lõi:

* **Amazon Bedrock (Claude 3.5 Sonnet & Titan Text Embeddings V2):** Đóng vai trò hạt nhân AI thông minh, thực hiện phân tích sâu cấu trúc file Terraform HCL, phát hiện lỗ hổng và tự động sinh mã khắc phục (remediation code) chuẩn xác.
* **Bedrock Knowledge Bases & OpenSearch Serverless:** Ghim ngữ cảnh RAG trực tiếp vào bộ tiêu chuẩn bảo mật quốc tế **CIS AWS Foundations Benchmark v3.0**, loại trừ hoàn toàn hiện tượng ảo tưởng (hallucination) và đảm bảo các đánh giá tuân thủ đều có cơ sở dữ liệu pháp quy rõ ràng.
* **AWS Lambda (Python 3.12) & Amazon API Gateway (HTTP API):** Xử lý bóc tách cú pháp IaC và điều phối phân tích hoàn toàn theo mô hình Serverless không máy chủ, phản hồi kết quả kiểm toán chỉ trong vòng dưới 10 giây với chi phí siêu tiết kiệm (~$1/triệu request).
* **Amazon DynamoDB & Amazon S3:** Lưu trữ an toàn lịch sử các phiên quét, bảng điểm tuân thủ bảo mật và các mẫu template hạ tầng.
* **EventBridge Scheduler & Amazon SNS:** Tự động kích hoạt lịch quét định kỳ hằng ngày và lập tức gửi thông báo cảnh báo khẩn cấp đến các kỹ sư DevOps/SecOps khi phát hiện lỗ hổng mức độ nghiêm trọng (High/Critical).
* **Bảo mật & Phân phối:** Được bảo vệ toàn diện bởi AWS WAF tại lớp CloudFront Edge, xác thực người dùng qua Amazon Cognito, và quản lý các tham số bí mật an toàn qua SSM Parameter Store.

### Điểm nổi bật & Giá trị thực tiễn:

* **Bảo mật Shift-Left (Shift-Left Security):** Tích hợp trực tiếp vào quy trình CI/CD qua Webhook, ngăn chặn triệt để các rủi ro bảo mật ngay từ bước tạo Pull Request trước khi hạ tầng được áp dụng vào môi trường thật.
* **Tối ưu chi phí vượt trội (Cost Optimization):** Kiến trúc vận hành 100% Serverless theo mô hình Pay-as-you-go, giúp chi phí hệ thống tiệm cận 0 VNĐ khi ở trạng thái nhàn rỗi (idle) và chỉ tốn khoảng ~$11–15/tháng trong môi trường doanh nghiệp liên tục 24/7 (tiết kiệm hơn $100–$200/tháng so với việc thuê GPU hay máy chủ EC2 chuyên dụng).
* **Tự động sinh mã khắc phục:** Không chỉ dừng lại ở việc chỉ ra lỗi vi phạm, CloudGuard AI cung cấp đoạn mã Terraform đúng chuẩn để kỹ sư có thể áp dụng sửa chữa ngay lập tức.

### Lưu ý thực chiến khi triển khai:

* Cần thiết lập `temperature = 0.1` trên Bedrock để đảm bảo tính nhất quán và khách quan của kết quả chấm điểm tuân thủ.
* Kết nối mạng nội bộ an toàn qua TLS giữa Lambda và các endpoint dịch vụ AWS giúp loại bỏ hoàn toàn nhu cầu sử dụng NAT Gateway, tiết kiệm thêm ~$32/tháng chi phí hạ tầng.
* Sử dụng SSM Parameter Store để lưu trữ secrets và cấu hình mô hình AI một cách linh hoạt mà không cần hard-code vào mã nguồn.

![Sơ đồ kiến trúc giải pháp CloudGuard AI](https://nhatminh05.github.io/fcj-workshop-template/images/3-BlogsPosted/3.2-Blog2/CloudGuardAIArchitecture.jpg)

[Link bài viết gốc](https://www.facebook.com/groups/awsstudygroupfcj/permalink/2330331201065172/)
