---
title: "Blog 1"
date: 2024-01-01
weight: 1
chapter: false
pre: " <b> 3.1. </b> "
---

# XÂY DỰNG CHUYÊN GIA KINH DOANH ĐA TÁC TỬ VỚI AMAZON BEDROCK

Các hệ thống AI đơn lẻ thường gặp khó khăn khi xử lý các quyết định kinh doanh phức tạp đòi hỏi nhiều chuyên môn (R&D, Pháp lý, Tài chính). Việc dồn mọi dữ liệu vào một prompt duy nhất dễ làm quá tải ngữ cảnh, tăng chi phí token và gây nhầm lẫn thông tin.

AWS giới thiệu giải pháp cộng tác đa tác tử (Multi-Agent Collaboration) trên Amazon Bedrock. Các thành phần chính:

* **Amazon Bedrock Agents:** Xây dựng các agent tự trị theo từng chuyên môn.
* **Supervisor Agent:** Tác tử điều phối, phân chia nhiệm vụ và tổng hợp kết quả.
* **Knowledge Bases:** Kết nối tài liệu nghiên cứu và pháp lý làm nguồn tham chiếu.
* **AWS Lambda:** Công cụ (Action Groups) để truy vấn số liệu và API tài chính.
* **Amazon Bedrock Guardrails:** Lọc nội dung và bảo vệ dữ liệu nhạy cảm.

Hệ thống phân chia 3 agent chuyên trách phối hợp cùng Supervisor:

* **R&D Agent:** Tra cứu dữ liệu kỹ thuật và thử nghiệm sản phẩm.
* **Legal Agent:** Rà soát hợp đồng và rủi ro tuân thủ pháp lý.
* **Finance Agent:** Phân tích chi phí, định giá và dự báo thị trường.

Điểm hay là tính cô lập ngữ cảnh (context isolation), mỗi agent chỉ xử lý đúng phạm vi chuyên môn giúp câu trả lời chính xác hơn và tiết kiệm token. Khi mở rộng, doanh nghiệp chỉ cần ghép thêm agent mới mà không phải viết lại hệ thống.

**Lưu ý từ bài viết:**

* Cần viết hướng dẫn (instruction) rõ ràng cho Supervisor để chia việc chuẩn xác.
* Dữ liệu trong bài là mô phỏng ngành dược, khi dùng thật cần chuẩn bị Knowledge Base riêng.
* Chi phí phụ thuộc vào số lượt gọi giữa các agent.
* Nên dùng Bedrock Guardrails để kiểm soát quyền xem dữ liệu giữa các phòng ban.

*Nguồn tham khảo:* [Build an intelligent multi-agent business expert using Amazon Bedrock – AWS Machine Learning Blog](https://aws.amazon.com/blogs/machine-learning/build-an-intelligent-multi-agent-business-expert-using-amazon-bedrock/)

![Kiến trúc Multi-Agent Collaboration với Amazon Bedrock](https://nhatminh05.github.io/fcj-workshop-template/images/3-BlogsPosted/3.1-Blog1/AmazonBedrockMultiAgent.jpg)

[Link bài viết gốc](https://www.facebook.com/groups/awsstudygroupfcj/permalink/2330331201065172/)
