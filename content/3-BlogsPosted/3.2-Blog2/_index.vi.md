---
title: "Blog 2"
date: 2024-01-01
weight: 2
chapter: false
pre: " <b> 3.2. </b> "
---

# TẠO ẢNH AI CHẤT LƯỢNG CAO VỚI CHI PHÍ TỐI ƯU TRÊN AMAZON ECS VÀ AWS INFERENTIA2

Tạo ảnh AI ở môi trường Production thường gặp phải 3 trở ngại lớn: tốc độ xử lý chậm, chi phí hạ tầng GPU đắt đỏ, và thời gian khởi động container (cold-start) kéo dài do phải biên dịch mô hình cho chip tăng tốc (mất từ 25–45 phút). Khi có lưu lượng truy cập tăng đột biến, người dùng phải chờ đợi lâu và hóa đơn điện toán đám mây tăng vọt.

Đội ngũ AWS Professional Services đã giới thiệu một giải pháp kiến trúc tối ưu để giải quyết triệt để bài toán này, kết hợp mô hình khuếch tán **Z-Image-Turbo (6 tỷ tham số)** chạy trên dịch vụ container **Amazon ECS** và chip tăng tốc chuyên dụng **AWS Inferentia2**.

Các thành phần và cơ chế cốt lõi trong giải pháp:

* **Mô hình Z-Image-Turbo:** Thuộc nhóm Diffusion Transformer (từ Alibaba), chỉ cần 8 bước khử nhiễu (thay vì 20–50 bước như các mô hình khác) và có tính tất định (cùng prompt và seed luôn tạo ra ảnh giống hệt nhau).
* **Chip tăng tốc AWS Inferentia2:** Chạy trên EC2 `inf2.8xlarge` với 2 NeuronCores và 32 GB HBM, tối ưu hóa cho tác vụ Transformer inference với chi phí chỉ $1.97/giờ (tiết kiệm hơn nhiều so với GPU NVIDIA).
* **Mô hình "Compile Once, Cache on EFS":** Mô hình được biên dịch trước một lần duy nhất trong CI/CD (Step Functions + AWS Batch) thành file NEFF rồi lưu vào **Amazon EFS**. Mã băm SHA-256 giúp nhận diện thay đổi: khi sửa code API thì không cần compile lại mô hình. Container mới khi scale-out chỉ cần mount EFS và sẵn sàng phục vụ chỉ sau **2 phút** thay vì hơn 30 phút.
* **Tách 3 ECS Service độc lập theo độ phân giải:** Phân tách rõ ràng thành 3 service (512×512, 768×768, 1024×1024) đứng sau Application Load Balancer (ALB). Header `X-Target-Resolution` điều phối request đến đúng service, giúp từng độ phân giải tự động scale theo nhu cầu tải thực tế.
* **Streaming thời gian thực qua WebSocket:** Từng khung hình JPEG trung gian sau mỗi bước khử nhiễu được stream trực tiếp về React frontend qua API Gateway WebSocket, giúp người dùng theo dõi bức ảnh nét dần theo thời gian thực (5–20 giây).

Hiệu năng và chi phí tạo ảnh thực tế:

* **Độ phân giải 512×512:** Thời gian 4.87s, chi phí chỉ **$0.003 / ảnh** (~$2.66 / 1.000 ảnh), throughput đạt ~739 ảnh/giờ/instance.
* **Độ phân giải 768×768:** Thời gian 9.81s, chi phí **$0.005 / ảnh** (~$5.36 / 1.000 ảnh), throughput đạt ~367 ảnh/giờ/instance.
* **Độ phân giải 1024×1024:** Thời gian 19.39s, chi phí **$0.011 / ảnh** (~$10.59 / 1.000 ảnh), throughput đạt ~186 ảnh/giờ/instance.
* Chi phí đủ thấp để tích hợp tính năng tạo ảnh trực tiếp vào ứng dụng web/mobile (embedded feature) mà không cần xây dựng hệ thống GPU đắt đỏ riêng biệt.

*Nguồn tham khảo:* [High-quality cost-effective AI image generation on Amazon ECS – AWS Containers Blog](https://aws.amazon.com/blogs/containers/high-quality-cost-effective-ai-image-generation-on-amazon-ecs/)

![Kiến trúc tạo ảnh AI trên Amazon ECS và AWS Inferentia2](https://nhatminh05.github.io/fcj-workshop-template/images/3-BlogsPosted/3.2-Blog2/ECSInferentia2Architecture.png)

[Link bài viết gốc](https://www.facebook.com/groups/awsstudygroupfcj/permalink/2340362116728747/)
