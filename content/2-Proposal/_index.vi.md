---
title: "Bản đề xuất"
date: 2024-01-01
weight: 2
chapter: false
pre: " <b> 2. </b> "
---

# CloudGuard AI: Nền Tảng Tự Động Hóa Kiểm Toán An Ninh & Tối Ưu Chi Phí AWS
## Giải pháp Serverless kết hợp GenAI & RAG kiểm toán mã nguồn Terraform theo chuẩn CIS Benchmark v3.0

### 1. Tóm tắt điều hành
Dự án xây dựng nền tảng kiểm toán an ninh hạ tầng mã nguồn (Infrastructure as Code - IaC) và tối ưu hóa chi phí điện toán đám mây (**DevSecOps & FinOps**) hoàn chỉnh, gồm hai ứng dụng độc lập: **Backend** — Serverless API viết bằng Python 3.12 chạy trên AWS Lambda + API Gateway, tích hợp mô hình ngôn ngữ lớn **Anthropic Claude 3.5 Sonnet** và kỹ thuật **RAG (Retrieval-Augmented Generation)** với **Amazon Titan Text Embeddings V2** để bóc tách cú pháp cây AST tệp Terraform HCL, đối chiếu tiêu chuẩn an ninh **CIS AWS Foundations Benchmark v3.0**, tính toán điểm tuân thủ (0–100) và tự động sinh mã sửa lỗi — và **Frontend** — ứng dụng Next.js SSR xây dựng trên React, hỗ trợ giao diện song ngữ vi/en, dark/light theme, đồng hồ đo điểm số bảo mật (Security Gauge), thẻ phân loại lỗ hổng theo mức độ nghiêm trọng và trình so sánh mã (Diff viewer) kèm nút sao chép mã đã sửa một chạm.

Mục tiêu của workshop là triển khai toàn bộ hệ thống lên hạ tầng AWS Serverless (region ap-southeast-1): frontend Next.js SSR chạy trên AWS Amplify, backend Python chạy trên Lambda + API Gateway, tất cả đặt phía sau CloudFront và được bảo vệ bởi AWS WAF cùng Amazon Cognito — thể hiện năng lực vận dụng các dịch vụ AWS vào một use-case thực tế, end-to-end. Khách hàng mục tiêu là các kỹ sư DevOps/Cloud Engineer cần kiểm toán an ninh tự động trước khi merge code vào production (nguyên lý Shift-Left Security), đội ngũ bảo mật (SecOps) cần báo cáo tuân thủ tiêu chuẩn an ninh quốc tế, và nhà quản trị (FinOps) muốn tối ưu chi phí hạ tầng.

### 2. Tuyên bố vấn đề
Vấn đề hiện tại
- Cấu hình sai hạ tầng gây rò rỉ dữ liệu diện rộng: hơn 80% sự cố an ninh đám mây bắt nguồn từ lỗi cấu hình cơ bản của con người (mở cổng SSH 22 ra `0.0.0.0/0`, S3 bucket không bật mã hóa SSE-S3/KMS, cấp quyền IAM wildcard `*`).
- Quy trình kiểm toán thủ công chậm trễ: việc rà soát code hạ tầng thủ công tốn 2–3 ngày, trở thành "nút thắt cổ chai" làm chậm tốc độ phát hành sản phẩm.
- Công cụ quét tĩnh truyền thống thiếu ngữ cảnh: các công cụ regex/linter thông thường (Checkov, tfsec) có tỷ lệ cảnh báo giả (False Positive) cao, không hiểu được mối liên kết giữa các tài nguyên và không có khả năng tự động sinh mã khắc phục.
- Hiện tượng ảo tưởng (Hallucination) của AI: sử dụng các LLM đại trà thường dẫn đến hiện tượng trích dẫn sai số hiệu điều khoản bảo mật hoặc gợi ý cú pháp Terraform lỗi thời nếu không có cơ sở tri thức RAG ghim chặt.
- Chi phí hạ tầng cao khi duy trì server AI: thuê các máy chủ EC2 có GPU chuyên dụng gây lãng phí hàng trăm USD/tháng khi hệ thống không có yêu cầu quét.

Giải pháp
Kiến trúc serverless, trả tiền theo request, tự scale: Lambda Core Engine chạy trên AWS Lambda + API Gateway (HTTP API), Next.js SSR host trên AWS Amplify, CloudFront (gắn WAF Web ACL tại edge) làm CDN phân phối static assets/SSR và định tuyến API. Cơ chế RAG với Bedrock Knowledge Base (Titan Text Embeddings V2 + Vector DB) ghim chặt tri thức chuẩn mực CIS AWS Foundations Benchmark v3.0, loại bỏ hoàn toàn hiện tượng ảo tưởng. Bedrock Agent (Claude 3.5 Sonnet) suy luận ngữ cảnh, tính điểm tuân thủ và tự động sinh mã Terraform đã vá lỗi hoàn chỉnh. CloudWatch Logs/Metrics + Alarm + SNS cung cấp giám sát tập trung và cảnh báo khẩn cấp cho admin qua Email; WAF, IAM least-privilege, Cognito và SSM Parameter Store đảm nhiệm bảo mật; EventBridge Scheduler + Lambda riêng xử lý cron job kiểm toán tự động hằng ngày.

Lợi ích và hoàn vốn đầu tư (ROI)
Nền tảng tự động scale theo nhu cầu với chi phí chỉ ~$11–15/tháng — kiến trúc Serverless loại bỏ hoàn toàn chi phí nhàn rỗi (Zero Idle Cost), không cần duy trì EC2/GPU liên tục, tiết kiệm hơn 95% so với thuê máy chủ AI cố định. Rút ngắn 90% thời gian rà soát an ninh (từ 2–3 ngày xuống dưới 10 giây), ngăn chặn 100% lỗ hổng cơ bản trước khi đưa lên Production, và workshop song ngữ step-by-step tạo ra ở cuối dự án là tài nguyên học tập tái sử dụng giá trị cho cộng đồng kỹ sư đám mây triển khai GenAI & DevSecOps trên AWS.

### 3. Kiến trúc giải pháp
Request từ người dùng đi qua CloudFront (WAF Web ACL gắn tại edge) đến hai origin: Amplify (frontend Next.js SSR, luồng Static/SSR) và API Gateway (HTTP API) → Lambda (backend Core Audit Engine, luồng API Calls); Amplify cũng “SSR fetch” ngược về API khi render phía server. Người dùng DevOps xác thực qua Amazon Cognito (JWT Auth). External CI/CD (GitHub/GitLab PR) gửi webhook quét mã tự động vào API Gateway. Lambda Core Engine bóc tách cú pháp Terraform AST, truy vấn tri thức CIS Benchmark v3.0 qua Bedrock Knowledge Bases (RAG), điều phối Claude 3.5 Sonnet suy luận, đọc cấu hình từ SSM Parameter Store, lưu báo cáo PDF vào S3 qua Pre-signed URL, ghi lịch sử kiểm toán vào DynamoDB, và gửi email qua SES. EventBridge Scheduler trigger Lambda hàng ngày để tự động rà soát posture. CloudWatch thu log/metric, khi vượt ngưỡng hoặc phát hiện lỗi CRITICAL thì Alarm đẩy sang SNS gửi email khẩn cấp cho admin. Chi tiết kiến trúc:

![Sơ Đồ Kiến Trúc Hệ Thống CloudGuard AI](https://nhatminh05.github.io/fcj-workshop-template/images/2-Proposal/cloudguard_architecture.jpg)

Lưu ý về WAF: WAF không phải một “trạm” độc lập trên đường truyền — Web ACL được gắn trực tiếp vào CloudFront distribution và đánh giá request ngay tại edge location trước khi CloudFront xử lý. Web ACL cho CloudFront bắt buộc tạo ở scope Global (us-east-1).

Dịch vụ AWS sử dụng
- AWS Lambda: Chạy Core Audit Engine (Python 3.12) + cron jobs — serverless, free tier 1M request/tháng, code đã tối ưu cold-start.
- Amazon API Gateway (HTTP API): Cửa ngõ REST API — rẻ hơn REST API Gateway ~70%, tích hợp Lambda native.
- AWS Amplify: Hosting Next.js SSR, CI/CD tự động từ Git.
- Amazon CloudFront: CDN phân phối static assets/SSR và API — edge location toàn cầu giảm độ trễ, là điểm gắn WAF Web ACL.
- Amazon Cognito: Quản lý User Pools và xác thực kỹ sư DevOps bằng JWT Bearer Token.
- Amazon Bedrock Agent: Tác tử AI dùng Anthropic Claude 3.5 Sonnet suy luận logic, đối chiếu vi phạm và sinh mã tự sửa lỗi.
- Amazon Bedrock Knowledge Bases (RAG): Sử dụng Amazon Titan Text Embeddings V2 kết hợp vector database lập chỉ mục bộ quy tắc CIS Benchmark v3.0.
- Amazon Bedrock Guardrails: Ngăn ngừa Prompt Injection, che giấu AWS Secrets / API Keys và dữ liệu cá nhân PII.
- Amazon S3: Lưu trữ tài liệu quy tắc CIS Benchmark, file Terraform thô và báo cáo kiểm toán PDF hoàn chỉnh; upload qua Pre-signed URL, chặn toàn bộ public access.
- Amazon DynamoDB: Cơ sở dữ liệu NoSQL lưu trữ lịch sử các phiên quét, bảng điểm tuân thủ và danh sách lỗi.
- Amazon SES: Gửi email thông báo định kỳ và tóm tắt kiểm toán cho quản trị viên.
- Amazon CloudWatch: Log + metric + alarm, tích hợp sẵn với Lambda/API Gateway.
- Amazon SNS: Cảnh báo admin qua email subscription trực tiếp khi có lỗi CRITICAL.
- Amazon EventBridge Scheduler: Trigger cron quét tự động hằng ngày trong môi trường serverless.
- AWS Systems Manager Parameter Store: Lưu tập trung secrets và cấu hình (Bedrock ARN, Webhooks).
- IAM + ACM + WAF: Least-privilege roles; chứng chỉ SSL/TLS miễn phí (ACM us-east-1 cho CloudFront, ACM ap-southeast-1 cho API Gateway); chặn tấn công lớp 7.

Thiết kế thành phần
- Phân phối nội dung & Biên: CloudFront phục vụ static assets/SSR và API tại edge location toàn cầu; WAF Web ACL lọc request tại edge; Cognito quản lý xác thực người dùng bằng JWT token.
- Giao diện người dùng: AWS Amplify host ứng dụng Next.js 15 SSR, deploy tự động từ Git.
- Xử lý kiểm toán cốt lõi: AWS Lambda đóng gói logic bóc tách Terraform HCL phía sau API Gateway HTTP API.
- Trí tuệ nhân tạo RAG: Bedrock Knowledge Base vector store + Claude 3.5 Sonnet agent suy luận ngữ cảnh và sinh mã khắc phục.
- Tầng dữ liệu: DynamoDB lưu trữ lịch sử các phiên quét; S3 lưu trữ tài liệu quy tắc CIS và báo cáo PDF qua Pre-signed URL.
- Lập lịch & Cảnh báo: EventBridge Scheduler kích hoạt Lambda kiểm toán hằng ngày; CloudWatch + SNS phát cảnh báo khẩn cấp khi phát hiện lỗi CRITICAL.
- Bảo mật & Chứng chỉ: Lambda Execution Role tuân thủ Least Privilege; HTTPS-only với chứng chỉ ACM; secrets lưu trong SSM Parameter Store, không hard-code credentials.

### 4. Triển khai kỹ thuật
Các giai đoạn triển khai
- Nghiên cứu & thiết kế: học AWS cơ bản (IAM, Lambda, Bedrock, S3, API Gateway); khảo sát kiến trúc RAG cho IaC (Tuần 1–2).
- Hoàn thiện ứng dụng & RAG: chuẩn hóa bộ quy tắc CIS Benchmark v3.0, viết mã nguồn bóc tách cú pháp Terraform, kết nối Bedrock RAG (Tuần 3–5).
- Triển khai hạ tầng AWS: tạo IAM roles; deploy core engine lên Lambda + API Gateway; deploy FE lên Amplify; cấu hình S3, DynamoDB, Bedrock Knowledge Base, CloudFront, WAF, SSM Parameter Store (Tuần 6–8).
- Giám sát & tối ưu: cấu hình CloudWatch Logs/Metrics, Alarm → SNS, EventBridge cron; tối ưu chi phí token Bedrock (Tuần 9–10).
- Kiểm thử & tài liệu: test end-to-end với các test case lỗi kinh điển, kiểm thử độ chuẩn xác; viết workshop song ngữ step-by-step, hướng dẫn clean-up (Tuần 11–12).

Yêu cầu kỹ thuật
- Backend: Python 3.12 (boto3, bedrock-agent-runtime, regex HCL parser), tối ưu cold-start cho Lambda, deploy sau API Gateway HTTP API.
- AI & RAG: Amazon Titan Text Embeddings V2 (1.024 dimensions), OpenSearch Serverless vector collection, Anthropic Claude 3.5 Sonnet.
- Frontend: Next.js (TypeScript, TailwindCSS) build và host trên AWS Amplify với hỗ trợ SSR.
- Mạng & bảo mật: WAF Web ACL scope Global (us-east-1) gắn vào CloudFront; chứng chỉ ACM us-east-1 (CloudFront) và ap-southeast-1 (API Gateway); secrets quản lý qua SSM Parameter Store; Cognito JWT auth.

### 5. Lộ trình & Mốc triển khai
Lộ trình dự án (12 tuần)
- Giai đoạn 1 — Nghiên cứu & thiết kế (Tuần 1–2): học AWS cơ bản, khảo sát kiến trúc Serverless GenAI & RAG → bàn giao: bản proposal này + sơ đồ kiến trúc draw.io.
- Giai đoạn 2 — Hoàn thiện ứng dụng & RAG (Tuần 3–5): chuẩn hóa data source CIS Benchmark, xây dựng parser Terraform HCL, kết nối Bedrock RAG → bàn giao: core engine chạy thử nghiệm ở local.
- Giai đoạn 3 — Triển khai hạ tầng AWS (Tuần 6–8): IAM, Lambda + API Gateway, Amplify, S3, DynamoDB, Bedrock Knowledge Base, CloudFront, WAF, Cognito, SSM Parameter Store → bàn giao: hệ thống chạy trên AWS, truy cập công khai.
- Giai đoạn 4 — Giám sát & tối ưu (Tuần 9–10): CloudWatch, Alarm → SNS, EventBridge cron, tối ưu chi phí token → bàn giao: dashboard giám sát + alert hoạt động.
- Giai đoạn 5 — Kiểm thử & tài liệu (Tuần 11–12): test end-to-end, workshop song ngữ, hướng dẫn clean-up → bàn giao: workshop website + báo cáo hoàn chỉnh.

### 6. Ước tính ngân sách
Chi phí hạ tầng
- Dịch vụ AWS:
  - AWS Lambda: ~$0/tháng (nằm trong free tier 1M request/tháng, 512 MB memory).
  - Amazon Bedrock (Claude 3.5 Sonnet + Titan Embeddings V2): ~$2–3/tháng (~1.000–1.500 lượt kiểm toán IaC, tính theo token thực tế).
  - API Gateway (HTTP API): ~$1/tháng ($1/triệu requests).
  - AWS Amplify: ~$1/tháng (build minutes + hosting Next.js SSR).
  - Amazon S3: ~$0.05/tháng (lưu trữ file mã nguồn Terraform, tài liệu CIS và báo cáo kiểm toán PDF).
  - Amazon DynamoDB: ~$0.50/tháng (lưu lịch sử quét và bảng điểm tuân thủ, chế độ On-Demand).
  - Amazon SES: ~$0.10/1.000 email (gửi báo cáo định kỳ và tóm tắt kiểm toán).
  - AWS WAF: ~$6/tháng (Web ACL gắn tại CloudFront edge + các bộ quy tắc bảo vệ).
  - Amazon CloudFront CDN: ~$1–2/tháng (phân phối static assets/SSR và API caching toàn cầu).
  - CloudWatch + SNS + EventBridge: ~$0–1/tháng (thu thập logs, bắn alert khẩn và trigger cron hằng ngày).
  - SSM Parameter Store: ~$0/tháng (standard parameters hoàn toàn miễn phí).

Tổng: ~$11–15/tháng

Lựa chọn kiến trúc tiết kiệm chi phí: Hệ thống ứng dụng 100% Serverless kết hợp mô hình On-Demand của Amazon Bedrock thay vì thuê GPU/EC2 chuyên dụng (tiết kiệm hơn $100–$200/tháng chi phí thuê máy chủ AI cố định). Kiến trúc không dùng NAT Gateway (~$32/tháng), Lambda kết nối Bedrock trực tiếp qua mạng nội bộ AWS, giúp đưa chi phí vận hành tiệm cận 0 VNĐ khi không có lượt quét.

### 7. Đánh giá rủi ro
Ma trận rủi ro
- Hiện tượng ảo tưởng (Hallucination) của AI: mức độ cao.
- Vượt hạn mức Bedrock Model Quota/Rate Limit: mức độ trung bình.
- Lộ lọt thông tin nhạy cảm (AWS Secrets, API Keys, PII) trong code gửi lên: mức độ cao.
- Lambda cold-start làm chậm request đầu tiên: mức độ thấp.
- Vượt free tier gây phát sinh chi phí ngoài ý muốn: mức độ thấp.

Chiến lược giảm thiểu
- Ảo tưởng: Sử dụng RAG với CIS Benchmark v3.0 ghim chặt ngữ cảnh, cấu hình temperature = 0.1 để AI trả lời khách quan, bắt buộc trích dẫn mã điều luật thực tế.
- Rate limit: Thiết lập retry backoff trong Lambda, cache kết quả quét đối với các đoạn code trùng lặp trên DynamoDB.
- Bảo mật dữ liệu: Kích hoạt Bedrock Guardrails tự động phát hiện và che giấu Secrets, API Keys và PII trước khi gửi tới mô hình LLM.
- Chi phí: Cài đặt AWS Budgets và CloudWatch Billing Alarm ở ngưỡng $5/tháng; dọn dẹp tài nguyên sau khi demo.
- Credentials: lưu secrets trong SSM Parameter Store; không commit file `.env` lên GitHub; IAM key xoay vòng định kỳ.

Kế hoạch dự phòng
- Nếu mô hình Claude 3.5 Sonnet gặp sự cố vùng, chuyển hướng tự động sang Claude 3 Haiku qua cấu hình SSM Parameter Store.
- Bộ regex scanner cục bộ dự phòng cho các quy tắc cơ bản (cổng 22, cổng 3389) khi mất kết nối tới AI.
- Hướng dẫn clean-up đảm bảo có thể gỡ toàn bộ tài nguyên nhanh chóng sau demo để dừng mọi chi phí.

### 8. Kết quả kỳ vọng
Cải tiến kỹ thuật: Toàn bộ nền tảng chạy serverless trên AWS — tự scale theo traffic, HTTPS-only, được WAF & Cognito bảo vệ, phân tích an ninh dựa trên AI và RAG trong vòng dưới 10 giây thay cho kiểm toán thủ công hàng ngày. Tự động sinh mã khắc phục chuẩn xác, kèm giám sát CloudWatch và cảnh báo tức thời qua SNS.
Giá trị dài hạn: Kiến trúc tham chiếu production-grade cho việc ứng dụng GenAI & RAG vào quy trình DevSecOps / FinOps trên AWS, workshop song ngữ step-by-step tái sử dụng được cho cộng đồng kỹ sư đám mây, và mô hình chi phí siêu tiết kiệm (~$11–15/tháng) đã được kiểm chứng thực tế.