---
title: "Blog 2"
date: 2024-01-01
weight: 2
chapter: false
pre: " <b> 3.2. </b> "
---

# TỰ ĐỘNG HÓA KIỂM TOÁN AN NINH & TỐI ƯU CHI PHÍ HẠ TẦNG AWS VỚI GENAI & RAG TRÊN AMAZON BEDROCK

Trong quy trình DevOps hiện đại, việc quản trị hạ tầng dưới dạng mã nguồn (Infrastructure as Code - IaC như Terraform, CloudFormation) là tiêu chuẩn bắt buộc. Tuy nhiên, việc rà soát an ninh và kiểm toán chi phí thủ công trước khi deploy thường tốn nhiều giờ, đồng thời rất dễ bỏ sót các cấu hình sai lệch nguy hiểm như: mở cổng SSH 22 cho toàn Internet (0.0.0.0/0), không mã hóa S3 bucket, hay cấp quyền IAM wildcard (*).

Để giải quyết bài toán theo hướng Shift-Left Security, mình xây dựng giải pháp CloudGuard AI kết hợp Generative AI và RAG trên Amazon Bedrock.

Các thành phần chính của kiến trúc:
* Amazon Bedrock (Claude 3.5 Sonnet & Titan Text Embeddings V2): phân tích cú pháp Terraform HCL, phát hiện lỗ hổng và tự động sinh mã khắc phục (remediation code)
* Bedrock Knowledge Bases & OpenSearch Serverless: ghim ngữ cảnh RAG vào tiêu chuẩn CIS AWS Foundations Benchmark v3.0, loại bỏ hoàn toàn hiện tượng ảo tưởng (hallucination)
* AWS Lambda & Amazon API Gateway (HTTP API): điều phối và phân tích serverless dưới 10 giây với chi phí tối ưu ($1/triệu request)
* Amazon DynamoDB & Amazon S3: lưu trữ lịch sử quét, điểm tuân thủ và mẫu hạ tầng
* EventBridge Scheduler & Amazon SNS: lập lịch quét định kỳ hằng ngày và gửi cảnh báo khẩn cấp khi có lỗ hổng nghiêm trọng
* AWS WAF, Amazon Cognito & SSM Parameter Store: bảo vệ ứng dụng tại biên, xác thực người dùng và quản lý secrets an toàn

Điểm hay của kiến trúc:
* Bảo mật Shift-Left: quét trực tiếp từ vòng CI/CD qua Webhook, chặn rủi ro ngay từ bước tạo Pull Request
* Tối ưu chi phí (FinOps): vận hành 100% Serverless, tiệm cận 0đ khi không có lượt quét, chi phí chạy 24/7 chỉ khoảng $11–15/tháng (tiết kiệm hơn $100–$200/tháng so với EC2 GPU)
* Loại bỏ NAT Gateway: Lambda kết nối nội bộ qua TLS, tiết kiệm thêm $32/tháng

Lưu ý khi triển khai:
* Cần đặt temperature thấp (0.1) trên Bedrock để kết quả chấm điểm tuân thủ nhất quán
* Knowledge Base cần ghim đúng phiên bản benchmark để trích dẫn điều luật chuẩn xác
* Quản lý API keys và secrets qua SSM Parameter Store để đảm bảo an toàn

![Sơ đồ kiến trúc giải pháp CloudGuard AI](https://nhatminh05.github.io/fcj-workshop-template/images/3-BlogsPosted/3.2-Blog2/CloudGuardAIArchitecture.jpg)

[Link bài viết gốc](https://www.facebook.com/groups/awsstudygroupfcj/permalink/2330331201065172/)
