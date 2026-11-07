---
title: "Week 4 Worklog"
date: 2026-10-05
weight: 4
chapter: false
pre: " <b> 1.4. </b> "
---

### Week 4 Objectives:

* Connect local storage to Amazon S3 using AWS Storage Gateway
* Distribute content with low latency using Amazon CloudFront CDN
* Connect multiple VPCs with VPC Peering and AWS Transit Gateway
* Manage resource permissions and costs with Resource Tags and Groups

### Tasks to be carried out this week:

| Day | Task | Start Date | Completion Date | Reference Material |
| --- | --- | --- | --- | --- |
| 2 | - Deploy AWS Storage Gateway (File Gateway configuration)<br>- Mount local NFS/SMB network shares connected to Amazon S3<br>- Verify local caching, bandwidth throttling, and cloud synchronization | 05/10/2026 | 05/10/2026 | https://000024.awsfcaj.com/ |
| 3 | - Create Amazon CloudFront distribution with S3 and ALB origins<br>- Enforce HTTPS with custom SSL certificates via AWS Certificate Manager<br>- Configure Cache Behaviors, TTLs, and Origin Access Control (OAC) | 06/10/2026 | 06/10/2026 | https://000094.awsfcaj.com/ |
| 4 | - Establish non-overlapping CIDR VPC Peering connections<br>- Update VPC Route Tables and Security Groups for inter-VPC traffic<br>- Validate bidirectional private connectivity between instances | 07/10/2026 | 07/10/2026 | https://000019.awsfcaj.com/ |
| 5 | - Provision AWS Transit Gateway and attach multiple VPCs<br>- Configure Transit Gateway Route Tables and route propagation<br>- Implement hub-and-spoke network topology with domain isolation | 08/10/2026 | 08/10/2026 | https://000020.awsfcaj.com/ |
| 6 | - Configure IAM ABAC policies controlling EC2 access by resource tags<br>- Group and manage resources using AWS Resource Groups<br>- Activate Cost Allocation Tags for team expense tracking<br>- Watch FCAJ YouTube Lessons 81 - 110 | 09/10/2026 | 09/10/2026 | https://000027.awsfcaj.com/ <br> https://000028.awsfcaj.com/ <br> https://www.youtube.com/@AWSStudyGroup |

### Week 4 Achievements:

* Mounted S3 file shares locally via File Storage Gateway
* Deployed CloudFront CDN with SSL certificate and Origin Access Control
* Linked VPCs using VPC Peering and centralized routing with Transit Gateway
* Implemented tag-based access control and cost allocation tracking

AWS services used:

* AWS Storage Gateway
* Amazon CloudFront
* AWS Certificate Manager (ACM)
* Amazon VPC (Peering)
* AWS Transit Gateway
* AWS Resource Groups & Tag Editor

Skills gained:

* Hybrid cloud file storage integration
* Global content delivery and edge caching optimization
* Multi-VPC routing topologies and hub-and-spoke networking
* Attribute-Based Access Control (ABAC) and cost allocation
