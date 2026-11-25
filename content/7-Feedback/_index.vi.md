---
title: "Chia sẻ, đóng góp ý kiến"
date: 2024-01-01
weight: 7
chapter: false
pre: " <b> 7. </b> "
---

> Khép lại hành trình thực tập 3 tháng tại chương trình **First Cloud AI Journey (FCAJ)** do **Amazon Web Services (AWS) Việt Nam** tổ chức, đây là những cảm nhận, đúc kết thực tế và một số đóng góp chân thành của bản thân nhằm giúp chương trình ngày càng hoàn thiện và lan tỏa giá trị hơn nữa tới các bạn sinh viên thế hệ sau.

---

### Đánh giá trải nghiệm thực tập

**1. Môi trường học tập và làm việc**  
Môi trường tại FCAJ thực sự năng động, cởi mở và mang đậm tinh thần công nghệ quốc tế. Điểm em ấn tượng nhất là văn hóa **"Learn and Be Curious"** và sự tôn trọng đối với mọi ý kiến đóng góp. Dù chỉ là thực tập sinh, em vẫn luôn được tạo không gian tự chủ để tự nghiên cứu, tự thử nghiệm các ý tưởng kiến trúc mới và chịu trách nhiệm với giải pháp của mình mà không bị gò bó trong khuôn mẫu cố định.

**2. Sự đồng hành của Mentor và Ban tổ chức (FCAJ Team)**  
Mentor không chỉ là người hỗ trợ giải đáp khó khăn kỹ thuật mà còn là người định hướng tư duy giải quyết vấn đề (problem-solving mindset) theo chuẩn **AWS Well-Architected Framework**. Thay vì chỉ đưa ra câu trả lời ngay lập tức, mentor luôn đặt ra những câu hỏi gợi mở: *"Kiến trúc này scale ra sao?", "Chi phí tháng này tính thế nào?", "Nếu dịch vụ này chạm quota thì fallback ở đâu?"* — chính cách tiếp cận này đã giúp em trưởng thành rất nhanh về mặt tư duy hệ thống. Đội ngũ admin cũng luôn nhiệt tình hỗ trợ tài khoản, cấp credit thực hành và nhắc nhở tiến độ kịp thời.

**3. Sự gắn kết giữa chuyên ngành AI và Hạ tầng Cloud**  
Là sinh viên chuyên ngành **Trí tuệ nhân tạo (AI) tại Đại học FPT**, trước khi tham gia chương trình, em chủ yếu quen thuộc với việc xây dựng và huấn luyện mô hình (model training) trên môi trường cục bộ hoặc notebook. Kỳ thực tập đã giúp em nhìn thấy bức tranh lớn hơn: **làm thế nào để đưa một giải pháp AI vào môi trường Production thực tế** bằng kiến trúc Serverless, kết nối các dịch vụ thị giác máy tính như Amazon Rekognition với API Gateway, Lambda, S3 Event Trigger và DynamoDB, đồng thời giải quyết bài toán độ trễ, phân quyền bảo mật IAM và tối ưu hóa chi phí vận hành.

**4. Cơ hội học hỏi và phát triển kỹ năng toàn diện**  
Bên cạnh kiến thức chuyên môn sâu về AWS Cloud, chương trình đã rèn luyện cho em rất nhiều kỹ năng mềm quan trọng:
- Kỹ năng viết tài liệu kỹ thuật chuẩn mực (Technical Writing) qua các bài proposal và hướng dẫn workshop song ngữ.
- Kỹ năng chia sẻ tri thức cộng đồng qua các bài viết kỹ thuật trên nhóm [AWS Study Group](https://www.facebook.com/groups/awsstudygroupfcj).
- Kỹ năng tư duy chi phí (FinOps) — biết cách dự toán, kiểm soát ngân sách qua AWS Budgets và tối ưu từng phần trăm chi phí tài nguyên.

**5. Văn hóa đồng đội và tinh thần chia sẻ**  
Cộng đồng sinh viên và các anh chị kỹ sư trong chương trình luôn sẵn sàng trao đổi, hỗ trợ nhau khi gặp bug hóc búa (từ cấu hình CORS, IAM policy conflict cho đến DLQ message handling). Tinh thần tương trợ này tạo nên một môi trường học tập vô cùng tích cực và không có khoảng cách.

**6. Chính sách hỗ trợ thực tập sinh**  
Chương trình cung cấp tài nguyên AWS Cloud bài bản, voucher thi chứng chỉ quốc tế và các buổi đào tạo chuyên đề chất lượng cao. Đây là sự đầu tư rất thiết thực và có ý nghĩa lớn đối với hành trang nghề nghiệp của sinh viên ngành công nghệ.

---

### Đúc kết & Cảm nhận cá nhân

- **Điều hài lòng nhất:** Được tự tay thiết kế và triển khai một dự án AI Serverless hoàn chỉnh từ đầu đến cuối (**ImageGuard**), nhìn thấy từng dòng log xử lý hình ảnh hoạt động trơn tru theo thời gian thực và đo lường được chi phí vận hành thực tế ở mức tối ưu.
- **Thử thách lớn nhất:** Quá trình chuyển dịch tư duy từ việc "chạy được code" sang "vận hành hệ thống an toàn và có khả năng phục hồi" (Zero-Trust, IAM Least Privilege, Dead-Letter Queue và CloudWatch Alarms).
- **Nếu giới thiệu cho bạn bè:** Em chắc chắn sẽ khuyên các bạn tham gia 100%. FCAJ không chỉ là một kỳ thực tập, mà là một bước nhảy vọt (leap) giúp sinh viên xóa bỏ khoảng cách giữa giảng đường đại học và yêu cầu thực tế của ngành công nghệ đám mây.

---

### Đóng góp ý kiến & Đề xuất cải tiến

1. **Bổ sung các buổi "Architecture Review / Office Hours" nhóm nhỏ:** Ở giai đoạn đầu khi các nhóm lên Proposal và vẽ sơ đồ kiến trúc, nếu có thêm 1–2 buổi review trực tiếp 1-1 với các Cloud Architect hoặc Solution Architect để phản biện sâu về security và trade-off thì các giải pháp sẽ còn hoàn thiện nhanh hơn nữa.
2. **Tăng cường giao lưu chéo giữa các hướng đề tài:** Tổ chức thêm một buổi demo ngắn giữa kỳ để các nhóm làm về các mảng khác nhau (GenAI/Bedrock, Serverless, Containers/ECS, DevOps/CI-CD) có cơ hội giao lưu, chia sẻ bài học kinh nghiệm và học hỏi các pattern thiết kế từ nhau.
3. **Mong muốn trong tương lai:** Em rất mong muốn tiếp tục được đồng hành, đóng góp các bài viết chuyên môn cho cộng đồng **AWS Study Group** và tham gia các hoạt động công nghệ tiếp theo của AWS tại Việt Nam.

---

*Em xin gửi lời cảm ơn chân thành nhất đến Ban tổ chức chương trình First Cloud AI Journey, các anh chị Mentor và toàn thể team AWS Việt Nam đã luôn tận tâm hỗ trợ và truyền cảm hứng trong suốt kỳ thực tập vừa qua!*
