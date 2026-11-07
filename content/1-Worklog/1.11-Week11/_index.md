---
title: "Week 11 Worklog"
date: 2026-11-23
weight: 11
chapter: false
pre: " <b> 1.11. </b> "
---

### Week 11 Objectives:

* Build an enterprise Serverless Document Management System (DMS)
* Implement real-time bi-directional communication using WebSocket APIs
* Deploy scalable web applications with AWS Elastic Beanstalk and CDK
* Host highly available WordPress CMS on Amazon EC2 with Aurora MySQL
* Deploy public container images to lightweight container services
* Complete FCAJ YouTube Lessons 261 - 280

### Tasks to be carried out this week:

| Day | Task | Start Date | Completion Date | Reference Material |
| --- | --- | --- | --- | --- |
| 2 | - Build S3 Presigned URL document upload and download workflow<br>- Extract document metadata with Lambda and index records in DynamoDB<br>- Enforce fine-grained user access controls on document buckets | 23/11/2026 | 23/11/2026 | https://000133.awsfcaj.com/ |
| 3 | - Build WebSocket API in Amazon API Gateway ($connect, $disconnect, sendMessage)<br>- Store real-time connection IDs in DynamoDB<br>- Broadcast chat messages across connected clients using Lambda | 24/11/2026 | 24/11/2026 | https://000066.awsfcaj.com/ <br> https://000117.awsfcaj.com/ |
| 4 | - Deploy Node.js application to AWS Elastic Beanstalk environment<br>- Configure Elastic Beanstalk Auto Scaling, load balancer, and rolling deployments<br>- Set up AWS CDK Pipeline for automated infrastructure updates | 25/11/2026 | 25/11/2026 | https://000112.awsfcaj.com/ <br> https://000113.awsfcaj.com/ |
| 5 | - Deploy high-availability WordPress application on EC2 behind ALB<br>- Offload static uploads to Amazon S3 and connect database to Amazon Aurora<br>- Configure Memcached caching for sub-second page delivery | 26/11/2026 | 26/11/2026 | https://000091.awsfcaj.com/ |
| 6 | - Deploy containerized services from public registries to Amazon ECS<br>- Configure health checks, container port mappings, and CloudWatch Logs<br>- Watch FCAJ YouTube Lessons 261 - 280 | 27/11/2026 | 27/11/2026 | https://000046.awsfcaj.com/ <br> https://www.youtube.com/@AWSStudyGroup |

### Week 11 Achievements:

* Built production-ready serverless document repository with presigned URLs
* Developed real-time bi-directional chat application using WebSocket APIs
* Streamlined application deployments with AWS Elastic Beanstalk PaaS
* Architected decoupled, scalable WordPress CMS on EC2 and Amazon Aurora
