---
title: "Event 3"
date: 2026-10-24
weight: 3
chapter: false
pre: " <b> 4.3. </b> "
---

# Bài thu hoạch: “First Cloud AI Journey Meetup – 24/10/2026”

### Mục Đích Của Sự Kiện

- Tiếp thu kiến thức thực chiến về Cloud và AI Agent từ các Tech Lead và kỹ sư giàu kinh nghiệm đến từ các doanh nghiệp công nghệ lớn.
- Khám phá kiến trúc Voice AI tiếng Việt với độ trễ siêu thấp ứng dụng trong Contact Center thế hệ mới trên AWS.
- Nắm bắt giải pháp chia sẻ tài nguyên an toàn và tối ưu chi phí đa tài khoản qua AWS Resource Access Manager (RAM).
- Tìm hiểu quy trình kiểm thử an ninh hạ tầng tự động (DevSecOps) và ứng dụng Security Agent để pentest hệ thống trước khi release.
- Hiểu sâu kiến trúc vận hành AI Agent quy mô lớn với Amazon Bedrock AgentCore (Agent Runtime & cơ chế phân tầng Memory).
- Khám phá mô hình Kiro Crew: cách vận hành AI Agent 24/7 để review code, kiểm soát hệ thống, quản trị Context Window và thiết lập Guardrails an toàn.

### Danh Sách Diễn Giả & Khách Mời

- **Anh Kiệt Trần** – AI Engineer tại Revve AI (*Session 1: Voice-AI Contact Center*)
- **Anh Long Huỳnh** – Solution Architect tại Styl Solution (*Session 2: AWS Resource Access Manager*)
- **Anh Thịnh Nguyễn** – Cloud Security Engineer tại Styl Solution (*Session 3: AWS Pentest with Security Agent*)
- **Anh Xuân An** – Leader AWS Student Builder Group HCMUTE (*Session 4: Amazon Bedrock AgentCore*)
- **Anh Khoa Kiều** – Tech Lead tại Ngân hàng ACB & **Anh Nghi Danh** – AWS Community Builder (*Session 5: Kiro Crew*)

### Nội Dung Nổi Bật

#### Session 1: Hear, Think, Speak – Xây dựng Voice-AI Contact Center tiếng Việt trên AWS
- Phân tích kiến trúc Voice AI hai chiều với bài toán giảm thiểu độ trễ đàm thoại xuống ~1.8s để đảm bảo phản hồi tức thời, tự nhiên như người thật.
- Màn live demo trực tiếp ấn tượng: Hệ thống Voice AI tự động gọi điện phỏng vấn sơ tuyển ứng viên vị trí Cloud Engineer hoàn toàn bằng tiếng Việt với khả năng xử lý ngắt lời và phản xạ cực kỳ linh hoạt.

#### Session 2: Chia sẻ tài nguyên an toàn với AWS Resource Access Manager (RAM)
- Phương pháp chia sẻ tài nguyên đám mây (VPC Subnets, Transit Gateway, Route 53 Resolver Rules) giữa các tài khoản độc lập trong AWS Organizations.
- Giải pháp gom cụm quản trị mạng tập trung, tiết kiệm chi phí băng thông liên tài khoản.
- Cơ chế phối hợp chặt chẽ giữa IAM Policy và Service Control Policies (SCP) để thiết lập rào chắn bảo mật (guardrail), đảm bảo không một tài khoản thành viên nào vượt quá trần quyền hạn cho phép.

#### Session 3: Đánh giá an ninh hạ tầng sớm (DevSecOps & AI Pentest)
- Chiến lược "Shift-Left Security": Tích hợp công cụ quét mã nguồn hạ tầng (IaC Terraform) trực tiếp vào luồng Pull Request trên GitLab/GitHub để phát hiện sớm các lỗ hổng cấu hình sai.
- Ứng dụng **Security Agent** tự động đóng vai người dùng thật để thực hiện pentest tự động trên các môi trường SIT/UAT, phát hiện các điểm yếu tiềm ẩn trước khi triển khai chính thức lên Production.

#### Session 4: Amazon Bedrock AgentCore – Nền tảng đưa AI Agent lên Production
- **Agent Runtime:** Tối ưu hóa chi phí vận hành tác tử bằng việc khởi chạy MicroVM trên hạ tầng EC2 Spot instances với độ sẵn sàng cao và chi phí cực thấp.
- **Hệ thống Memory phân tầng:** Phân biệt rõ giữa *Short-term Memory* (đồng bộ, lưu ngữ cảnh phiên làm việc tức thời) và *Long-term Memory* (bất đồng bộ, tích lũy kiến thức sâu về hành vi và sở thích người dùng qua thời gian).

#### Session 5: Kiro Crew – Vận hành AI Agent 24/7 hỗ trợ kỹ thuật
- Mô hình tác tử tự trị chạy liên tục 24/7 phục vụ công tác rà soát mã nguồn (code review) và giám sát trạng thái hệ thống.
- **Cơ chế tạo Artifacts trực quan:** Tác tử tự động cào dữ liệu tuyển dụng việc làm thực tế, tổng hợp và vẽ biểu đồ thống kê trực quan ngay trong giao diện chat.
- **Quản trị Context Window hiệu quả:** 
  - Tính năng *Auto Compact* tự động tóm gọn ngữ cảnh khi chạm ngưỡng 70–90% dung lượng cửa sổ ngữ cảnh.
  - Tính năng *Break down context* cho phép bóc tách chi tiết lượng token tiêu thụ của từng thành phần (prompt hệ thống, lịch sử chat, dữ liệu truy xuất).
- **Quản lý Memory & Guardrails an toàn:** Cơ chế dọn dẹp bộ nhớ cũ tránh phình chi phí lưu trữ; đồng thời thiết lập các lớp chặn an toàn nghiêm ngặt để AI không thể tự ý xóa tài nguyên hạ tầng hay làm rò rỉ secret/credential máy chủ.

### Những Gì Học Được

#### Tư Duy Kiến Trúc & Vận Hành Doanh Nghiệp
- Hiểu được cách các kỹ sư và Tech Lead trong ngành giải quyết bài toán thực tế: từ ngân hàng (ACB) đến các startup AI chuyên sâu.
- Nhận thức rõ ràng rằng đưa AI vào doanh nghiệp không chỉ là gọi API mô hình lớn, mà bài toán cốt lõi nằm ở độ trễ (latency), chi phí (token/compute) và tính ổn định dài hạn.

#### Kỹ Năng Kỹ Thuật Chuyên Sâu
- Nắm vững nguyên lý quản trị Context Window và tối ưu phân tầng Memory trong các hệ thống Agentic AI hiện đại.
- Hiểu cách thức phân quyền bảo mật nâng cao trên AWS thông qua sự kết hợp của RAM, IAM và SCP.

### Ứng Dụng Vào Công Việc & Học Tập

- **Áp dụng quản lý ngữ cảnh vào các bài toán GenAI**: Áp dụng cơ chế chia nhỏ tác vụ và tự động tóm lược bối cảnh khi phát triển các ứng dụng AI đồ án tại trường.
- **Tối ưu hóa chi phí triển khai lab**: Vận dụng kiến thức EC2 Spot và tối ưu hóa token vào các bài thực hành trên AWS.
- **Ứng dụng tư duy an ninh Shift-Left**: Rèn luyện thói quen rà soát bảo mật mã nguồn IaC và thiết lập Guardrails chặt chẽ ngay từ các bước thiết kế ban đầu.

### Trải Nghiệm Trong Event

Buổi meetup **“First Cloud AI Journey (24/10/2026)”** tại Tầng 26 Bitexco mang lại cho tôi rất nhiều giá trị:

#### Lượng kiến thức thực tế chất lượng cao
- 5 session diễn ra liên tục với khối lượng kiến thức thực chiến dày đặc, đi thẳng vào các bài toán kỹ thuật gai góc nhất hiện nay.
- Được tận mắt chứng kiến live demo Voice AI phỏng vấn tiếng Việt và lắng nghe những chia sẻ sâu sắc từ anh Khoa Kiều (Tech Lead ACB) về vận hành Agent thực tế.

#### Hỏi đáp kỹ thuật chuyên sâu và cởi mở
- Không khí thảo luận cuối giờ cực kỳ sôi nổi; các diễn giả giải thích rất tận tình và chi tiết về các câu hỏi kỹ thuật hóc búa từ các kỹ sư tham dự.
- Học hỏi được thêm nhiều mẹo (tips & tricks) về tối ưu token và dọn dẹp memory mà sách vở hiếm khi đề cập.

#### Không gian kết nối truyền cảm hứng
- Được gặp gỡ và giao lưu với các anh chị Tech Lead, các bạn sinh viên xuất sắc từ các trường đại học trong cộng đồng FCAJ.
- Càng thêm tin tưởng và hào hứng với con đường theo đuổi chuyên ngành Cloud & AI mà mình đang theo học.

### Một Số Hình Ảnh Khi Tham Gia Sự Kiện

![Check-in tại Bitexco Financial Tower - First Cloud AI Journey Meetup](https://nhatminh05.github.io/fcj-workshop-template/images/4-EventParticipated/4.3-Event3/event3_checkin.jpg)
