---
title: "Bản đề xuất"
date: 2026-09-14
weight: 2
chapter: false
pre: " <b> 2. </b> "
---

# CloudGuard AI: Nền Tảng Tự Động Hóa Rà Soát An Toàn & Tối Ưu Chi Phí Đám Mây Bằng GenAI & RAG trên AWS

## Giải pháp kiểm toán an ninh Infrastructure as Code (IaC) thông minh theo tiêu chuẩn CIS AWS Foundations Benchmark v3.0

---

### 1. Tóm Tắt Điều Hành (Executive Summary)

Trong bối cảnh làn sóng chuyển đổi số và di chuyển hạ tầng lên điện toán đám mây bùng nổ, **Infrastructure as Code (IaC)** — đặc biệt là mã nguồn Terraform — đã trở thành tiêu chuẩn cốt lõi để các tổ chức xây dựng và quản trị tài nguyên AWS. Tuy nhiên, theo các báo cáo bảo mật đám mây từ Gartner và Palo Alto Networks, hơn **80% sự cố lộ lọt dữ liệu và vi phạm an ninh đám mây bắt nguồn từ lỗi cấu hình sai (misconfigurations)** do con người vô tình tạo ra trong mã IaC (ví dụ: mở cổng SSH 22 ra Internet `0.0.0.0/0`, gán quyền IAM quá mức `AdministratorAccess`, không bật mã hóa S3 Bucket SSE-KMS, hoặc kích hoạt tài nguyên nhàn rỗi gây lãng phí hàng nghìn USD mỗi tháng).

**CloudGuard AI** ra đời như một giải pháp đột phá, kết hợp sức mạnh của **Generative AI** và kiến trúc **RAG (Retrieval-Augmented Generation)** trên nền tảng **Amazon Bedrock** nhằm tự động hóa hoàn toàn quy trình rà soát an ninh, đánh giá mức độ tuân thủ và tối ưu hóa chi phí hạ tầng AWS. Hệ thống sử dụng mô hình ngôn ngữ tiên tiến **Anthropic Claude 3.5 Sonnet** được trang bị bộ cơ sở tri thức véc-tơ hóa từ bộ tài liệu tiêu chuẩn an ninh quốc tế **CIS AWS Foundations Benchmark v3.0** và **AWS Well-Architected Framework**. 

Với kiến trúc **100% Serverless & Event-Driven** (AWS Lambda, Amazon API Gateway, Amazon DynamoDB, Amazon S3, AWS Amplify), CloudGuard AI cung cấp khả năng phân tích ngữ cảnh hạ tầng theo thời gian thực, chấm điểm tư thế an ninh **Security Posture Score (0–100)**, chỉ rõ điều khoản vi phạm và **tự động sinh mã nguồn Terraform đã vá lỗi (Auto-Remediation)** chỉ với 1 cú click. Dự án vận hành với chi phí cực kỳ tối ưu (**chỉ ~1$ - 2$/tháng**, tận dụng tối đa gói AWS Free Tier và không tốn phí duy trì server nhàn rỗi), mang lại giải pháp DevSecOps thiết thực cho cả doanh nghiệp khởi nghiệp lẫn môi trường nghiên cứu học thuật.

---

### 2. Tuyên Bố Vấn Đề (Problem Statement)

#### Bối Cảnh Thực Tế & Khó Khăn Hiện Tại
1. **Kiểm toán thủ công chậm trễ và dễ bỏ sót**: Việc rà soát an ninh mã hạ tầng (Terraform, CloudFormation) trước khi triển khai thường được thực hiện thủ công bởi đội ngũ bảo mật hạn hẹp. Khi số lượng tài nguyên tăng vọt, quy trình này trở thành "nút thắt cổ chai" (bottleneck), kéo dài chu kỳ phát hành sản phẩm và dễ bỏ lọt các lỗ hổng nghiêm trọng.
2. **Công cụ rà soát tĩnh (Static Code Analysis) thiếu ngữ cảnh**: Các công cụ mã nguồn mở truyền thống (như tfsec, checkov) sử dụng các luật biểu thức chính quy (regex) cố định. Chúng thường sinh ra số lượng lớn cảnh báo giả (false positives), không hiểu được ngữ cảnh kiến trúc liên kết giữa các tài nguyên (ví dụ: EC2 nằm trong Private Subnet không thể bị tấn công trực tiếp từ Internet dù Security Group mở cổng), và quan trọng nhất là **không có khả năng giải thích và tự động sửa code**.
3. **Ảo giác của mô hình AI tạo sinh thông thường**: Khi lập trình viên sử dụng các công cụ LLM đại trà (ChatGPT, Claude thông thường) để hỏi về an ninh, mô hình dễ gặp hiện tượng **ảo tưởng (hallucination)**, trích dẫn sai số hiệu điều khoản bảo mật hoặc gợi ý các cú pháp Terraform đã lỗi thời (deprecated), dẫn đến rủi ro nghiêm trọng khi áp dụng vào production.

#### Giải Pháp Đột Phá Từ CloudGuard AI
CloudGuard AI giải quyết triệt để 3 thách thức trên bằng giải pháp tích hợp thông minh:
- **Trí tuệ nhân tạo RAG chuẩn xác 100%**: Chỉ mục toàn bộ văn bản tiêu chuẩn CIS AWS Foundations Benchmark v3.0 và AWS Best Practices vào **Amazon Bedrock Knowledge Bases** (sử dụng mô hình embedding **Amazon Titan Text Embeddings V2** và cơ sở dữ liệu véc-tơ). Mọi nhận định vi phạm đều được đối chiếu trực tiếp từ điều luật thực tế, loại bỏ hoàn toàn hiện tượng ảo tưởng.
- **Tác tử AI tự động lập kế hoạch và sửa lỗi**: **Amazon Bedrock Agent** đóng vai trò như một chuyên gia DevSecOps ảo cao cấp, phân tích cây cú pháp trừu tượng (AST) của file Terraform, đối chiếu với tri thức RAG và tự động sinh ra đoạn mã Terraform đã sửa chuẩn xác (diff view).
- **Tích hợp liền mạch CI/CD Pipeline**: Hỗ trợ tiếp nhận mã nguồn trực tiếp qua giao diện web hiện đại (AWS Amplify) hoặc tự động kích hoạt thông qua Webhook khi lập trình viên tạo Pull Request trên GitHub/GitLab, ngăn chặn lỗ hổng ngay tại cửa ngõ phát triển (Shift-Left Security).

#### Lợi Ích & Khả Năng Hoàn Vốn (ROI)
- **Giảm 90% thời gian rà soát an ninh**: Thời gian thẩm định một bộ mã hạ tầng rút ngắn từ 2–3 ngày xuống còn dưới 10 giây.
- **Ngăn chặn 100% các lỗ hổng an ninh cơ bản trước khi lên Production**: Đảm bảo toàn bộ tài nguyên lưu trữ (S3, EBS, RDS) được mã hóa, các cổng nhạy cảm (22, 3389, 3306) không bị phơi nhiễm ra Internet và tài khoản IAM tuân thủ nguyên tắc quyền tối thiểu.
- **Tiết kiệm ngân sách vượt trội**: Mô hình Serverless giúp loại bỏ 100% chi phí nhàn rỗi (Zero Idle Cost). Doanh nghiệp chỉ chi trả khi có lượt quét thực tế với mức phí chỉ khoảng 0,001$ cho mỗi lần phân tích file. Thời gian hoàn vốn đầu tư (Break-even) đạt được ngay trong tháng đầu tiên vận hành.

---

### 3. Kiến Trúc Giải Pháp (Solution Architecture)

CloudGuard AI được thiết kế theo chuẩn **AWS Well-Architected Framework**, tuân thủ nghiêm ngặt 6 trụ cột (Bảo mật, Độ tin cậy, Hiệu năng, Tối ưu chi phí, Vận hành xuất sắc và Tính bền vững). 

Dưới đây là sơ đồ kiến trúc chính thức của hệ thống:

![Sơ Đồ Kiến Trúc Hệ Thống CloudGuard AI](https://nhatminh05.github.io/fcj-workshop-template/images/2-Proposal/cloudguard_architecture.jpg)

#### Danh Mục Dịch Vụ AWS Sử Dụng
- **AWS WAF (Web Application Firewall)**: Thiết lập bộ luật Web ACL bảo vệ điểm cuối CloudFront và API Gateway khỏi các cuộc tấn công DDoS, SQLi, Cross-Site Scripting (XSS) và ngăn chặn bot tự động quét lỗ hổng.
- **AWS IAM (Identity and Access Management)**: Áp dụng các vai trò thực thi (Execution Roles) tuân thủ nguyên tắc đặc quyền tối thiểu (Least Privilege), cấp quyền giới hạn cho AWS Lambda và Bedrock Agent.
- **Amazon CloudFront**: Mạng phân phối nội dung (CDN) toàn cầu, cung cấp khả năng phân phối mã tĩnh với độ trễ thấp và tích hợp chứng chỉ bảo mật SSL/TLS cạnh.
- **Amazon Cognito**: Hệ thống User Pools quản lý thông tin tài khoản của kỹ sư DevOps, xác thực người dùng an toàn bằng chuỗi mã hóa JSON Web Token (JWT).
- **AWS Certificate Manager (ACM)**: Cung cấp và tự động gia hạn chứng chỉ số SSL/TLS công khai cho tên miền tùy chỉnh tại cả vùng toàn cầu (us-east-1 cho CloudFront) và vùng cục bộ (ap-southeast-1 cho API Gateway).
- **Amazon API Gateway (HTTP API)**: Cổng giao tiếp RESTful API tiếp nhận các luồng yêu cầu quét mã (`POST /scan`), tra cứu lịch sử (`GET /history`) và xem chi tiết báo cáo (`GET /report/{id}`), hỗ trợ cơ chế giới hạn lưu lượng (rate-limiting).
- **AWS Systems Manager (SSM) Parameter Store**: Kho lưu trữ tập trung, mã hóa bảo mật các khóa cấu hình ứng dụng, ARN của Bedrock Agent và URL tích hợp Slack/Teams Webhook.
- **AWS Lambda (Core Audit Engine)**: Trái tim tính toán Serverless chạy môi trường runtime Python 3.12, chịu trách nhiệm bóc tách cú pháp Terraform HCL, điều phối Agent AI, tổng hợp điểm số và tạo file báo cáo kiểm toán PDF.
- **AWS Amplify**: Nền tảng lưu trữ và phân phối giao diện web hiện đại xây dựng trên Next.js và React, cho phép người dùng thao tác trực tiếp, dán mã nguồn và xem kết quả trực quan.
- **Amazon EventBridge Scheduler**: Bộ điều phối lịch trình Serverless tự động kích hoạt hàm Lambda thực hiện rà soát định kỳ toàn bộ trạng thái hạ tầng đám mây hàng ngày.
- **Amazon Bedrock Agent**: Tác tử trí tuệ nhân tạo xây dựng trên nền tảng Anthropic Claude 3.5 Sonnet, có khả năng suy luận logic chuyên sâu, đối chiếu vi phạm tiêu chuẩn an ninh và tự động sinh mã Terraform khắc phục lỗi.
- **Amazon Bedrock Knowledge Bases (RAG)**: Hệ sinh thái tìm kiếm tăng cường thông tin, sử dụng mô hình véc-tơ hóa Amazon Titan Text Embeddings V2 kết hợp cơ sở dữ liệu véc-tơ để truy xuất chính xác các điều khoản trong bộ tiêu chuẩn CIS AWS Foundations Benchmark.
- **Amazon Bedrock Guardrails**: Lớp phòng thủ bảo vệ mô hình AI, ngăn ngừa các cuộc tấn công tiêm nhiễm câu lệnh (Prompt Injection), lọc và che giấu các thông tin bí mật công nghệ (như AWS Access Key, mật khẩu, JWT token) và dữ liệu định danh cá nhân (PII).
- **Amazon S3 (Simple Storage Service)**: Lưu trữ các tài liệu tiêu chuẩn CIS Benchmark PDF gốc, mã nguồn Terraform người dùng tải lên và các tệp báo cáo kiểm toán định dạng PDF hoàn chỉnh.
- **Amazon DynamoDB**: Cơ sở dữ liệu NoSQL với độ trễ tính bằng mili-giây, lưu trữ lịch sử các phiên quét, bảng điểm tuân thủ, danh sách các lỗ hổng phát hiện và mốc thời gian thực hiện.
- **Amazon SES (Simple Email Service)**: Dịch vụ gửi thư điện tử tự động, chuyển tiếp báo cáo kiểm toán định kỳ và tóm tắt an ninh tới hòm thư của đội ngũ quản trị DevSecOps.
- **Amazon CloudWatch**: Hệ thống giám sát tập trung thu thập toàn bộ nhật ký (Logs), số lượng token Bedrock tiêu thụ, thời gian phản hồi của Lambda và các chỉ số đo lường hiệu năng hệ thống.
- **Amazon SNS (Simple Notification Service)**: Kênh thông báo tức thời (Pub/Sub), tự động bắn tin nhắn cảnh báo khẩn cấp tới quản trị viên qua Slack, SMS hoặc Email ngay khi phát hiện lỗ hổng ở mức độ Nghiêm trọng (CRITICAL).

#### Thiết Kế Thành Phần Chi Tiết (Component Design)
1. **Phân Tầng Cửa Ngõ & Xác Thực (Edge & Security Layer)**:
   - Toàn bộ lưu lượng truy cập từ người dùng và hệ thống CI/CD bên ngoài đều đi qua lớp bảo vệ AWS WAF và mạng phân phối Amazon CloudFront. Người dùng bắt buộc phải đăng nhập thông qua Amazon Cognito để nhận JWT Bearer Token trước khi có thể gửi yêu cầu quét mã.
2. **Phân Tầng Giao Tiếp API (API Layer)**:
   - Amazon API Gateway kiểm tra tính hợp lệ của JWT Token từ Cognito Authorizer. Nếu hợp lệ, API Gateway chuyển tiếp payload mã nguồn Terraform tới AWS Lambda, đồng thời áp dụng cơ chế throttling để ngăn chặn tình trạng spam tài nguyên.
3. **Phân Tầng Xử Lý Trung Tâm (Core Audit Engine - Lambda)**:
   - Hàm Lambda bóc tách file Terraform thành cấu trúc cây cú pháp (AST) bằng thư viện phân tích cú pháp chuyên dụng. Lambda lấy các tham số nhạy cảm từ SSM Parameter Store, sau đó đóng gói ngữ cảnh hạ tầng và gọi đến Bedrock Agent.
4. **Phân Tầng Trí Tuệ Nhân Tạo Lõi (GenAI & RAG Brain Layer)**:
   - Bedrock Agent phân tích cấu trúc tài nguyên, đồng thời phát lệnh truy vấn véc-tơ sang Bedrock Knowledge Bases để tìm kiếm các điều luật CIS liên quan.
   - Dữ liệu trả về được kiểm duyệt qua Bedrock Guardrails để đảm bảo không bị rò rỉ khóa bí mật. Claude 3.5 Sonnet tổng hợp kết quả, tính điểm Security Posture Score (từ 0 đến 100), phân loại lỗ hổng theo 4 cấp độ (CRITICAL, HIGH, MEDIUM, LOW) và sinh ra khối mã Terraform sửa lỗi tương ứng.
5. **Phân Tầng Lưu Trữ & Phân Phối Kết Quả (Data & Notification Layer)**:
   - Lambda lưu toàn bộ kết quả chi tiết vào Amazon DynamoDB, đồng thời kết xuất file báo cáo PDF lưu trữ tại Amazon S3. 
   - Nếu phát hiện lỗ hổng mức độ CRITICAL (ví dụ: cổng 22 mở toàn bộ Internet, bucket S3 cho phép đọc công khai không xác thực), CloudWatch Alarms sẽ ngay lập tức kích hoạt Amazon SNS để bắn cảnh báo khẩn cấp tới điện thoại và kênh Slack của kỹ sư trực vận hành.

---

### 4. Triển Khai Kỹ Thuật (Technical Implementation)

#### Các Giai Đoạn Triển Khai Chi Tiết
Dự án được cấu trúc bài bản qua 4 giai đoạn kỹ thuật rõ ràng:

1. **Giai đoạn 1: Thiết Kế Tri Thức RAG & Chuẩn Hóa Bộ Tiêu Chuẩn (Tháng 1)**:
   - Thu thập và tiền xử lý văn bản tài liệu tiêu chuẩn quốc tế CIS AWS Foundations Benchmark v3.0 và AWS Security Best Practices sang định dạng Markdown chuẩn.
   - Thiết lập Amazon S3 Bucket lưu trữ dữ liệu tri thức nguồn, cấu hình Chunking Strategy (độ dài đoạn văn 512 tokens, tỷ lệ gối đầu 20%) trong **Amazon Bedrock Knowledge Bases**.
   - Tạo vector embeddings với mô hình **Amazon Titan Text Embeddings V2** và liên kết với OpenSearch Serverless / Vector Index.
   - Thử nghiệm các câu lệnh Prompt System và thiết lập bộ quy tắc an toàn trong **Bedrock Guardrails**.

2. **Giai đoạn 2: Xây Dựng Hệ Thống Serverless Backend & Lõi Phân Tích (Tháng 2)**:
   - Khởi tạo bảng Amazon DynamoDB (`CloudGuard_ScanHistory`) với Partition Key là `ScanId` và Sort Key là `Timestamp`.
   - Viết mã nguồn hàm AWS Lambda (Python 3.12) tích hợp AWS SDK (boto3) để tương tác với Bedrock Runtime, DynamoDB, S3 và SES.
   - Xây dựng các hàm bóc tách mã nguồn Terraform, kiểm tra lỗi cú pháp và trích xuất danh sách tài nguyên (EC2, S3, IAM, Security Groups, RDS).
   - Thiết lập cấu hình Amazon API Gateway (HTTP API) tích hợp xác thực JWT từ Amazon Cognito.

3. **Giai đoạn 3: Phát Triển Giao Diện Người Dùng & Tích Hợp Tự Động Hóa (Tháng 2 – Tháng 3)**:
   - Xây dựng ứng dụng web hiện đại bằng **Next.js (App Router)** và **Tailwind CSS**, tích hợp trình biên tập mã Monaco Editor (tương tự VS Code) để người dùng dán và chỉnh sửa trực tiếp mã Terraform.
   - Thiết kế bảng điều khiển trực quan: Biểu đồ điểm số an ninh (Radar Chart), danh sách lỗi vi phạm phân loại theo màu sắc, và công cụ so sánh trực quan (Diff Viewer) giữa mã gốc và mã đã được AI sửa.
   - Triển khai ứng dụng lên **AWS Amplify**, kết nối với CloudFront CDN và gắn chứng chỉ bảo mật ACM.
   - Cấu hình **Amazon EventBridge Scheduler** để tự động quét kiểm toán định kỳ vào lúc 00:00 hàng ngày.
   - Xây dựng kịch bản GitHub Actions Workflow mẫu, hướng dẫn tích hợp gọi Webhook API của CloudGuard AI khi có Pull Request mới.

4. **Giai đoạn 4: Kiểm Thử Toàn Diện, Tối Ưu Hiệu Năng & Đóng Gói Workshop (Tháng 3)**:
   - Tiến hành kiểm thử hộp trắng và hộp đen với 50 kịch bản file Terraform chứa các lỗi bảo mật điển hình (từ cơ bản đến nâng cao).
   - Đo lường độ chính xác của mô hình RAG (đạt tỷ lệ phát hiện chính xác trên 96% và loại trừ hoàn toàn hiện tượng ảo tưởng thông tin).
   - Tối ưu hóa thời gian thực thi của AWS Lambda (dưới 8 giây cho mỗi tệp kiểm toán 500 dòng code).
   - Hoàn thiện tài liệu hướng dẫn thực hành từng bước (Hands-on Lab) cho bài viết Workshop.

---

### 5. Lộ Trình & Mốc Triển Khai (Roadmap & Milestones)

| Mốc Thời Gian | Giai Đoạn Triển Khai | Nhiệm Vụ Trọng Tâm & Sản Phẩm Đầu Ra | Trạng Thái |
| :--- | :--- | :--- | :---: |
| **Tháng 1 (Tuần 1–4)** | Nghiên cứu & Thiết kế | • Nắm vững các tiêu chuẩn CIS AWS Foundations Benchmark v3.0.<br>• Hoàn thành tài liệu đề xuất giải pháp (Proposal).<br>• Xây dựng và kiểm thử sơ bộ kiến trúc RAG trên Amazon Bedrock. | **Hoàn thành 100%** |
| **Tháng 2 (Tuần 5–8)** | Phát triển Backend & AI | • Xây dựng hệ thống Serverless Core (Lambda, API Gateway, DynamoDB).<br>• Tích hợp Bedrock Agent với Claude 3.5 Sonnet và Knowledge Bases.<br>• Viết kịch bản tự động chấm điểm và sinh mã vá lỗi Terraform. | **Đang triển khai** |
| **Tháng 3 (Tuần 9–11)**| Frontend & Automation | • Hoàn thiện giao diện Next.js Dashboard trên AWS Amplify.<br>• Cấu hình EventBridge Scheduler và cơ chế cảnh báo qua SNS/SES.<br>• Tích hợp luồng CI/CD GitHub Actions Webhook. | **Sẵn sàng** |
| **Tháng 3 (Tuần 12)**  | Đánh giá & Báo cáo | • Kiểm thử toàn diện 50 test cases hạ tầng mẫu.<br>• Soạn thảo hoàn chỉnh tài liệu Workshop thực hành 5 chương.<br>• Chuẩn bị slide và kịch bản vấn đáp bảo vệ trước hội đồng giám khảo. | **Kế hoạch** |

---

### 6. Ước Tính Ngân Sách (Cost Estimation & ROI)

Hệ thống CloudGuard AI được thiết kế theo tư duy kiến trúc tối ưu hóa chi phí (FinOps), tận dụng tối đa mô hình Serverless và gói miễn phí **AWS Free Tier**.

Bảng dự toán chi phí vận hành hàng tháng (ước tính cho quy mô 1.000 lượt quét kiểm toán mã nguồn hạ tầng/tháng):

| Dịch Vụ AWS | Cấu Hình / Quy Mô Định Mức Ước Tính | Chi Phí Trong Gói Free Tier | Chi Phí Vận Hành Thực Tế |
| :--- | :--- | :---: | :---: |
| **AWS Lambda** | 1.000 lượt gọi/tháng, thời gian chạy trung bình 5 giây, cấp phát 512 MB RAM | Miễn phí (thuộc 1.000.000 requests/tháng miễn phí) | **0,00 USD** |
| **Amazon API Gateway** | 2.000 HTTP API calls/tháng | Miễn phí (thuộc 1.000.000 calls đầu tiên trong 12 tháng) | **0,00 USD** |
| **Amazon S3 Standard** | 2 GB lưu trữ tài liệu CIS & báo cáo PDF, 3.000 yêu cầu PUT/GET | Miễn phí (thuộc 5 GB lưu trữ Standard miễn phí) | **0,00 USD** |
| **Amazon DynamoDB** | 1 bảng, dung lượng lưu trữ 500 MB, chế độ On-Demand Read/Write | Miễn phí (thuộc 25 GB lưu trữ NoSQL miễn phí trọn đời) | **0,00 USD** |
| **AWS Amplify** | Lưu trữ mã nguồn tĩnh Next.js, băng thông 5 GB/tháng | Miễn phí (thuộc định mức 15 GB băng thông miễn phí) | **0,00 USD** |
| **Amazon Bedrock (Claude 3.5)**| ~1.000 lượt gọi AI, trung bình 1.500 input tokens và 800 output tokens/lượt | Tính theo lượng token tiêu thụ thực tế | **~1,20 USD** |
| **Amazon Bedrock (Titan V2)** | Véc-tơ hóa tài liệu CIS Benchmark (lưu trữ 500.000 tokens véc-tơ) | Chi phí một lần và truy vấn véc-tơ hàng tháng | **~0,15 USD** |
| **Amazon SES & SNS** | 200 emails báo cáo/tháng, 50 tin nhắn cảnh báo SNS | Miễn phí (thuộc gói 62.000 emails/tháng miễn phí từ EC2/Lambda) | **0,00 USD** |
| **CloudWatch & WAF** | Thu thập 1 GB logs giám sát, bộ luật WAF cơ bản | Nằm trong ngưỡng giám sát cơ bản | **~0,25 USD** |
| **TỔNG CỘNG HÀNG THÁNG** | **Hệ thống Serverless hoàn chỉnh phục vụ kiểm toán an ninh** | **Tiết kiệm 95% chi phí** | **~1,60 USD / tháng** |

> **Tổng chi phí vận hành cho cả năm chỉ khoảng ~19,20 USD (tương đương chưa tới 500.000 VNĐ)**. So với chi phí thuê máy chủ ảo EC2 truyền thống (tối thiểu 15–20 USD/tháng cho instance cỡ nhỏ chạy liên tục) hoặc mua bản quyền các phần mềm kiểm toán thương mại (hàng nghìn USD/năm), CloudGuard AI mang lại hiệu quả kinh tế vượt trội (ROI đạt trên 98%).

---

### 7. Đánh Giá Rủi Ro & Chiến Lược Giảm Thiểu (Risk Assessment & Mitigation)

| Rủi Ro Nhận Diện | Mức Độ | Xác Suất | Chiến Lược Phòng Ngừa & Giảm Thiểu Chủ Động |
| :--- | :---: | :---: | :--- |
| **Nguy cơ AI "ảo tưởng" (Hallucination)** | Cao | Thấp | Ứng dụng kiến trúc **Bedrock Knowledge Bases (RAG)** ép mô hình Claude 3.5 Sonnet chỉ được phép trích dẫn căn cứ từ bộ tài liệu CIS Benchmark v3.0 đã được thẩm định trong S3. |
| **Tấn công tiêm nhiễm câu lệnh (Prompt Injection)** | Cao | Trung bình | Kích hoạt bộ lọc an toàn **Amazon Bedrock Guardrails**, thiết lập danh sách từ khóa cấm, phát hiện nỗ lực bẻ khóa hướng dẫn hệ thống (jailbreak) và chặn đứng yêu cầu độc hại ngay từ đầu vào. |
| **Rò rỉ khóa bí mật (API Keys / Secrets trong mã IaC)** | Rất cao | Trung bình | Tích hợp thuật toán quét regex nhận dạng chuỗi bí mật (AWS Secret Keys, Private Keys) ngay tại hàm Lambda; sử dụng Guardrails tự động bôi đen (masking) các thông tin nhạy cảm trước khi gửi sang mô hình AI. |
| **Vượt ngân sách do lạm dụng API Bedrock** | Trung bình | Thấp | Thiết lập hạn mức **Rate-Limiting** trên Amazon API Gateway (tối đa 10 requests/phút cho mỗi người dùng); cài đặt cảnh báo ngân sách tự động **AWS Budgets** khi chi phí chạm mốc 5,00 USD. |
| **Thời gian phản hồi AI vượt ngưỡng Timeout** | Trung bình | Trung bình | Cấu hình thời gian chờ (Timeout) của AWS Lambda ở mức hợp lý (60 giây); tối ưu hóa kích thước cửa sổ phân tích cú pháp mã nguồn; gửi phản hồi bất đồng bộ (Asynchronous processing) kèm thông báo qua email/webhook khi hoàn tất rà soát file lớn. |

---

### 8. Kết Quả Kỳ Vọng & Giá Trị Đồ Án (Expected Outcomes & Value)

#### Giá Trị Kỹ Thuật Đạt Được
- **Sản phẩm hoàn chỉnh, hoạt động thực tế 100%**: Xây dựng thành công một nền tảng DevSecOps tự động hóa rà soát hạ tầng hiện đại, có giao diện đồ họa trực quan và luồng CI/CD hoạt động mượt mà trên môi trường AWS thực tế.
- **Làm chủ công nghệ Cloud & GenAI hàng đầu**: Áp dụng thành công các công nghệ tiên tiến nhất hiện nay của AWS: **Amazon Bedrock Agent**, **Knowledge Bases (RAG)**, **Guardrails**, kết hợp kiến trúc **Serverless** hướng sự kiện (Event-Driven).
- **Bộ mã nguồn mở chất lượng cao**: Đóng gói mã nguồn sạch sẽ, có cấu trúc module rõ ràng, đi kèm kịch bản triển khai tự động (Terraform IaC) và tài liệu hướng dẫn chi tiết giúp cộng đồng kỹ sư trẻ dễ dàng thực hành và mở rộng.

#### Giá Trị Học Thuật & Đóng Góp Thực Tiễn
- **Phục vụ đồ án tốt nghiệp xuất sắc**: Dự án thể hiện rõ năng lực nghiên cứu độc lập, tư duy kiến trúc hệ thống chuẩn quốc tế và khả năng giải quyết bài toán nhức nhối thực tế của sinh viên chuyên ngành Trí tuệ Nhân tạo tại Đại học FPT.
- **Lan tỏa giá trị cho cộng đồng AWS First Cloud AI Journey (FCAJ)**: Đóng góp một bài thực hành Workshop mẫu mực (Section 5) mang tính thực chiến cao, giúp các bạn sinh viên và kỹ sư mới bắt đầu làm quen với phương pháp xây dựng AI Agent trên nền tảng AWS một cách bài bản, an toàn và tối ưu chi phí.
