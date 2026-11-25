---
title: "Blog 3"
date: 2024-01-01
weight: 3
chapter: false
pre: " <b> 3.3. </b> "
---

# ĐỊNH TUYẾN INFERENCE AI ĐA VÙNG VỚI AMAZON SAGEMAKER HYPERPOD GLOBAL INFERENCE GATEWAY

Khi triển khai suy luận (inference) cho các mô hình nền tảng và mô hình ngôn ngữ lớn (LLM) quy mô doanh nghiệp, việc phân tán năng lực tính toán qua nhiều cụm máy chủ và nhiều AWS Region là bắt buộc do tình trạng khan hiếm tài nguyên GPU. Tuy nhiên, kiến trúc phân tán truyền thống thường đặt ra 3 trở ngại lớn trong vận hành:

* **Tải phân bổ không đồng đều (Uneven load):** Vào các khung giờ cao điểm, request xếp hàng dài trên một cụm máy chủ bị nghẽn (saturated), trong khi GPU ở cụm khác hoặc ở Region khác lại đang nhàn rỗi (idle) dù bạn đã chi trả chi phí cho toàn bộ dung lượng này.
* **Xử lý sự cố thủ công (Manual failover):** Khi một cụm gặp sự cố, kỹ sư vận hành phải can thiệp thủ công vào cấu hình DNS hoặc hệ thống định tuyến để điều hướng lưu lượng sang nơi khác.
* **Hạ tầng kết nối phức tạp (Custom plumbing):** Việc phân phối lưu lượng giữa nhiều vùng đòi hỏi đội ngũ kỹ thuật phải tự thiết kế, duy trì hệ thống Application Load Balancers, DNS phân tán và cấu hình mạng liên vùng (cross-Region networking) phức tạp.

Để giải quyết bài toán trên, AWS đã giới thiệu **Amazon SageMaker HyperPod Global Inference Gateway** — kiến trúc định tuyến hai tầng (two-tier routing architecture), cung cấp một điểm cuối (endpoint) duy nhất được quản lý bởi SageMaker để điều phối request thông minh qua toàn bộ các cụm HyperPod trong cùng một Region hoặc giữa các Region khác nhau.

Các thành phần và cơ chế cốt lõi trong giải pháp:

* **Kiến trúc định tuyến hai tầng (Two-Tier Routing):**
  * *Tầng 1 - Global Inference Gateway:* Đóng vai trò là cổng vào trung tâm cấp vùng/toàn cầu, tiếp nhận request từ client, thực hiện xác thực SigV4/IAM, chấm điểm cụm tối ưu và chuyển lưu lượng qua đường trục AWS (AWS backbone).
  * *Tầng 2 - Cluster Inference Gateway:* Nằm bên trong từng cụm HyperPod, tiếp nhận lưu lượng từ tầng 1 và phân bổ trực tiếp đến từng model pod phù hợp nhất dựa trên tình trạng GPU nội bộ.
* **Điểm cuối duy nhất cho toàn bộ hệ thống (Single Managed Endpoint):** Thay vì client phải theo dõi và quản lý hàng chục endpoint riêng biệt (mỗi model trên từng cluster), toàn bộ ứng dụng chỉ cần giao tiếp với một endpoint duy nhất của Global Inference Gateway.
* **Định tuyến thông minh theo thời gian thực (Capacity-aware Routing):** Gateway liên tục chấm điểm (score) từng cụm dựa trên 4 tín hiệu tải thực tế được cung cấp bởi bộ phát chỉ số (metrics publisher):
  * *KVHeadroom (0.20):* Bộ nhớ đệm Key-Value (KV cache) và dung lượng GPU khả dụng trên cụm.
  * *QueueDepth (0.25):* Mức độ ùn tắc và số lượng request đang chờ trong hàng đợi của cụm.
  * *RegionProximity (0.40):* Khoảng cách địa lý giữa client gateway và cụm đích nhằm giảm thiểu độ trễ mạng.
  * *ErrorRate (0.15):* Tỷ lệ request gặp lỗi gần nhất để chủ động tránh gửi thêm tải vào cụm đang suy giảm hiệu năng.
* **Tự động tràn lưu lượng & chuyển vùng dự phòng (Auto Overflow & Failover):** Khi một cụm chạm ngưỡng công suất hoặc gặp sự cố phần cứng, gateway tự động chuyển hướng request sang cụm còn dư năng lực tính toán trong cùng Region hoặc sang Region khác mà không làm gián đoạn dịch vụ của người dùng cuối.
* **Bảo mật và cô lập mạng cấp Enterprise:** Mọi kết nối giữa Global Inference Gateway và các cụm HyperPod đều đi qua **AWS PrivateLink** (VPC Endpoint Service) chạy trên mạng riêng AWS backbone, loại bỏ rủi ro đi qua Internet công cộng và được bảo vệ nghiêm ngặt bởi AWS Identity and Access Management (IAM) và chữ ký điện tử SigV4.

Hiệu quả thực tế và giá trị mang lại:

* **Tối đa hóa hiệu suất GPU:** Tận dụng triệt để năng lực tính toán nhàn rỗi ở các Region khác, loại bỏ tình trạng lãng phí tài nguyên đã đầu tư.
* **Đơn giản hóa vận hành:** Không cần xây dựng hay bảo trì hạ tầng load balancer, DNS liên vùng hay các script định tuyến tự chế.
* **Độ bền bỉ cao (High Resilience):** Đảm bảo tính liên tục của các dịch vụ GenAI quan trọng ở cấp độ High Availability (HA) và Disaster Recovery (DR).

*Nguồn tham khảo:* [Introducing Amazon SageMaker HyperPod Global Inference Gateway: One endpoint across Regions and clusters – AWS Machine Learning Blog](https://aws.amazon.com/blogs/machine-learning/introducing-amazon-sagemaker-hyperpod-global-inference-gateway-one-endpoint-across-regions-and-clusters/)

![Kiến trúc Amazon SageMaker HyperPod Global Inference Gateway](https://nhatminh05.github.io/fcj-workshop-template/images/3-BlogsPosted/3.3-Blog3/HyperPodGlobalInferenceGatewayArchitecture.png)

[Link bài viết gốc](https://www.facebook.com/groups/awsstudygroupfcj/permalink/2346835766081382/)
