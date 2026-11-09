---
title: "Tự đánh giá"
date: 2024-01-01
weight: 6
chapter: false
pre: " <b> 6. </b> "
---

Trong suốt thời gian thực tập tại **Công ty TNHH Amazon Web Services Việt Nam (Amazon Web Services Viet Nam Company Limited)** từ **14/09/2026** đến **14/12/2026**, tôi đã có cơ hội học hỏi, rèn luyện và áp dụng kiến thức chuyên sâu đã được trang bị tại trường Đại học FPT vào môi trường làm việc đám mây thực tế chuẩn doanh nghiệp.  

Tôi đã trực tiếp nghiên cứu, thiết kế kiến trúc và triển khai dự án **CloudGuard AI: Automated AWS Infrastructure Security & Cost Auditor trên nền tảng AWS Serverless kết hợp Amazon Bedrock GenAI & RAG**. Qua quá trình phát triển dự án này, tôi đã được trau dồi và làm chủ toàn diện các mảng kiến thức kỹ thuật then chốt từ bản Proposal:

* **Trí tuệ nhân tạo tạo sinh & RAG (GenAI & RAG):** Tích hợp dịch vụ nền tảng Amazon Bedrock sử dụng mô hình ngôn ngữ lớn Anthropic Claude 3.5 Sonnet và mô hình nhúng vector Amazon Titan Text Embeddings V2 (1.024 chiều); xây dựng Bedrock Knowledge Bases kết nối OpenSearch Serverless vector collection nhằm triệt tiêu hoàn toàn hiện tượng ảo tưởng (hallucination).
* **Kiểm toán an ninh đám mây (DevSecOps & CIS Benchmark):** Áp dụng bộ tiêu chuẩn an ninh quốc tế CIS AWS Foundations Benchmark v3.0 để rà soát tự động mã nguồn hạ tầng Terraform HCL, phát hiện tức thì các lỗ hổng nghiêm trọng (như mở cổng SSH 22 toàn cầu `0.0.0.0/0`, S3 không mã hóa, wildcard IAM `*`) và tự động sinh mã khắc phục (remediation code) chuẩn xác.
* **Kiến trúc Serverless 100%:** Thiết kế hệ thống tính toán phi máy chủ bằng AWS Lambda (Python 3.12 tối ưu cold-start) đứng sau Amazon API Gateway (HTTP API), lưu trữ phi cấu trúc trên Amazon S3 và cơ sở dữ liệu NoSQL Amazon DynamoDB chế độ On-Demand pay-per-request.
* **Tự động hóa, Lập lịch & Giám sát:** Cấu hình EventBridge Scheduler kích hoạt quét tự động hằng ngày (`cron(0 1 * * ? *)`), thiết lập giám sát toàn diện với CloudWatch Logs/Metrics, và kích hoạt cảnh báo khẩn cấp theo thời gian thực qua Amazon SNS khi phát hiện vi phạm mức High/Critical.
* **Bảo vệ biên & Quản trị danh tính:** Thiết lập tường lửa ứng dụng AWS WAF gắn tại CloudFront Edge, cấp phát chứng chỉ số bảo mật ACM (us-east-1 và ap-southeast-1), xác thực người dùng bằng Amazon Cognito User Pools qua cơ chế JWT Auth, và lưu trữ bảo mật secrets/API keys bằng AWS Systems Manager Parameter Store.
* **Phát triển Frontend & Tối ưu phân phối:** Xây dựng dashboard kiểm toán trực quan bằng Next.js (TypeScript, TailwindCSS) với Server-Side Rendering (SSR) triển khai tự động qua AWS Amplify và phân phối nội dung toàn cầu qua Amazon CloudFront CDN.
* **Tối ưu hóa chi phí hạ tầng (FinOps):** Hiện thực hóa tư duy tiết kiệm chi phí vượt trội: kết nối nội bộ an toàn giữa Lambda và các dịch vụ AWS qua TLS giúp loại bỏ hoàn toàn NAT Gateway (~$32/tháng) và không cần thuê GPU EC2 cố định (~$100–$200/tháng), đưa tổng chi phí vận hành 24/7 chỉ vào khoảng ~$11–15/tháng và tiệm cận 0 VNĐ khi nhàn rỗi.
* **Tư duy Shift-Left Security & Kỹ năng tài liệu:** Tích hợp kiểm toán tự động ngay từ vòng CI/CD Pull Request Webhook, đồng thời biên soạn workshop kỹ thuật song ngữ 6 lab thực hành hands-on step-by-step.

Về tác phong, tôi luôn cố gắng hoàn thành tốt nhiệm vụ, tuân thủ nghiêm túc nội quy làm việc, chủ động tìm kiếm giải pháp và tích cực trao đổi với mentor cùng đồng nghiệp để nâng cao hiệu quả công việc.

Để phản ánh một cách khách quan quá trình thực tập, tôi xin tự đánh giá bản thân dựa trên các tiêu chí dưới đây:

| STT | Tiêu chí | Mô tả | Tốt | Khá | Trung bình |
| --- | --- | --- | :---: | :---: | :---: |
| 1 | **Kiến thức và kỹ năng chuyên môn** | Hiểu biết về ngành, áp dụng kiến thức vào thực tế, kỹ năng sử dụng công cụ, chất lượng công việc | ☐ | ✅ | ☐ |
| 2 | **Khả năng học hỏi** | Tiếp thu kiến thức mới, học hỏi nhanh | ☐ | ✅ | ☐ |
| 3 | **Chủ động** | Tự tìm hiểu, nhận nhiệm vụ mà không chờ chỉ dẫn | ✅ | ☐ | ☐ |
| 4 | **Tinh thần trách nhiệm** | Hoàn thành công việc đúng hạn, đảm bảo chất lượng | ✅ | ☐ | ☐ |
| 5 | **Kỷ luật** | Tuân thủ giờ giấc, nội quy, quy trình làm việc | ✅ | ☐ | ☐ |
| 6 | **Tính cầu tiến** | Sẵn sàng nhận feedback và cải thiện bản thân | ☐ | ✅ | ☐ |
| 7 | **Giao tiếp** | Trình bày ý tưởng, báo cáo công việc rõ ràng | ✅ | ☐ | ☐ |
| 8 | **Hợp tác nhóm** | Làm việc hiệu quả với đồng nghiệp, tham gia nhóm | ✅ | ☐ | ☐ |
| 9 | **Ứng xử chuyên nghiệp** | Tôn trọng đồng nghiệp, đối tác, môi trường làm việc | ✅ | ☐ | ☐ |
| 10 | **Tư duy giải quyết vấn đề** | Nhận diện vấn đề, đề xuất giải pháp, sáng tạo | ☐ | ✅ | ☐ |
| 11 | **Đóng góp vào dự án/tổ chức** | Hiệu quả công việc, sáng kiến cải tiến, ghi nhận từ team | ✅ | ☐ | ☐ |
| 12 | **Tổng thể** | Đánh giá chung về toàn bộ quá trình thực tập | ✅ | ☐ | ☐ |

### Cần cải thiện

* Cải thiện trong cách tư duy giải quyết vấn đề để xử lý các sự cố kiến trúc phức tạp nhanh chóng hơn
* Nâng cao khả năng học hỏi để tiếp thu kiến thức mới và các dịch vụ đám mây chuyên sâu nhanh hơn
* Tiếp tục rèn luyện kỹ năng giao tiếp và thuyết trình kỹ thuật để truyền đạt giải pháp tự tin, rõ ràng hơn
