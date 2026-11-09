---
title: "Workshop"
date: 2024-01-01
weight: 5
chapter: false
pre: " <b> 5. </b> "
---

# Workshop: Xây Dựng Hệ Thống Kiểm Toán An Ninh & Tối Ưu Chi Phí AWS Bằng GenAI & RAG (CloudGuard AI)

#### Tổng Quan Bài Thực Hành

Chào mừng bạn đến với chuỗi bài thực hành chuyên sâu **CloudGuard AI** – Hệ thống tự động hóa kiểm toán an ninh hạ tầng điện toán đám mây và tối ưu chi phí (DevSecOps & FinOps) ứng dụng công nghệ Trí tuệ Nhân tạo Tạo sinh (**Generative AI**) và Kỹ thuật Tìm kiếm Tăng cường (**RAG - Retrieval-Augmented Generation**) trên nền tảng **Amazon Web Services (AWS)**.

Trong kỷ nguyên phát triển phần mềm hiện đại, việc ứng dụng **Infrastructure as Code (IaC)** với Terraform giúp doanh nghiệp triển khai hạ tầng với tốc độ vượt bậc. Tuy nhiên, việc thiếu hụt quy trình rà soát an ninh tự động từ sớm (**Shift-Left Security**) thường dẫn đến các lỗi cấu hình nghiêm trọng (Misconfigurations) như: mở toang cổng quản trị SSH (Port 22) ra toàn bộ Internet, lưu trữ dữ liệu nhạy cảm trên S3 không mã hóa, hoặc cấp quyền IAM quản trị toàn năng (`AdministratorAccess`).

Bài workshop này sẽ hướng dẫn bạn từng bước tự tay xây dựng một giải pháp hoàn chỉnh từ gốc đến ngọn: sử dụng **Amazon Bedrock** (Anthropic Claude 3.5 Sonnet & Titan Text Embeddings V2), **Amazon Bedrock Knowledge Bases**, **AWS Lambda**, **Amazon API Gateway**, **Amazon S3**, **Amazon DynamoDB**, và **Amazon EventBridge Scheduler** để tự động bóc tách mã nguồn, đối chiếu chuẩn an ninh **CIS AWS Foundations Benchmark v3.0**, chấm điểm tuân thủ (0-100), và tự động sinh mã sửa lỗi tức thời.

---

#### Mục Tiêu Học Tập (Learning Objectives)

Sau khi hoàn thành bài workshop này, bạn sẽ:
1. **Làm chủ kiến trúc RAG trên AWS Bedrock**: Biết cách tạo và cấu hình Amazon Bedrock Knowledge Bases, nạp tài liệu tiêu chuẩn an ninh CIS Benchmark, và thực hiện véc-tơ hóa bằng mô hình Amazon Titan Text Embeddings V2.
2. **Xây dựng Serverless Core Audit Engine**: Viết hàm AWS Lambda xử lý bóc tách cú pháp cây AST của tệp Terraform HCL, điều phối Agent AI và tính toán điểm số bảo mật.
3. **Triển khai API Gateway bảo mật**: Cung cấp giao diện lập trình ứng dụng RESTful API cho phép các công cụ CI/CD (GitHub Actions / GitLab CI) hoặc ứng dụng ngoài gửi yêu cầu quét mã.
4. **Tự động hóa & Cảnh báo thời gian thực**: Thiết lập EventBridge Scheduler kích hoạt kiểm toán tự động hằng ngày và Amazon SNS bắn cảnh báo tức thì qua Email/Slack khi phát hiện lỗ hổng nghiêm trọng (CRITICAL).
5. **Tối ưu hóa chi phí vận hành (FinOps)**: Vận hành toàn bộ hệ thống trên nền tảng Serverless với chi phí tiệm cận 0 VNĐ (Zero Idle Cost), hoàn toàn nằm trong hạn mức miễn phí (AWS Free Tier).

---

#### Danh Mục Các Bài Thực Hành (Table of Contents)

1. [**5.1 Tổng quan về Workshop & Kiến trúc Hệ thống**](5.1-Workshop-overview/)
   - Bối cảnh bài toán, luồng dữ liệu 6 bước và sơ đồ kiến trúc tổng thể.
2. [**5.2 Chuẩn bị Môi trường & Cấp quyền IAM**](5.2-Prerequiste/)
   - Kích hoạt mô hình Amazon Bedrock, tạo IAM Execution Roles, S3 Bucket và bảng DynamoDB.
3. [**5.3 Thiết lập RAG & Tri thức CIS Benchmark**](5.3-Knowledge-base/)
   - Nạp tiêu chuẩn CIS Benchmark v3.0 lên S3, tạo Knowledge Base và đồng bộ cơ sở dữ liệu véc-tơ.
4. [**5.4 Xây dựng Lõi Kiểm toán Lambda & API Gateway**](5.4-Core-engine/)
   - Viết mã nguồn Python cho Lambda Engine, tích hợp Bedrock RAG và cấu hình HTTP API.
5. [**5.5 Triển khai Dashboard & Lập lịch Quét Tự Động**](5.5-Dashboard-scheduler/)
   - Xây dựng giao diện web kiểm toán trực quan và cấu hình EventBridge Scheduler quét định kỳ.
6. [**5.6 Kiểm thử Thực Tế & Dọn dẹp Tài nguyên**](5.6-Cleanup/)
   - Chạy kịch bản kiểm thử End-to-End với mã Terraform chứa lỗi kinh điển và quy trình Clean up tránh phát sinh chi phí.