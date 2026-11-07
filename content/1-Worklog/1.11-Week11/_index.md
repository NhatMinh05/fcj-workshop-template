---
title: "Week 11 Worklog"
date: 2026-11-23
weight: 11
chapter: false
pre: " <b> 1.11. </b> "
---

### Week 11 Objectives:

* Build Serverless Document Management System with S3 presigned URLs
* Develop real-time chat application using API Gateway WebSocket APIs
* Deploy Node.js applications using AWS Elastic Beanstalk PaaS
* Host highly available WordPress CMS on EC2 with Amazon Aurora
* Deploy public container images to Amazon ECS / Lightsail

### Tasks to be carried out this week:

| Day | Task | Start Date | Completion Date | Reference Material |
| --- | --- | --- | --- | --- |
| 2 | - Build S3 Presigned URL document upload and download workflow<br>- Extract document metadata with Lambda and index records in DynamoDB<br>- Enforce fine-grained user access controls on document buckets | 23/11/2026 | 23/11/2026 | https://000133.awsfcaj.com/ |
| 3 | - Build WebSocket API in Amazon API Gateway ($connect, $disconnect, sendMessage)<br>- Store real-time connection IDs in DynamoDB<br>- Broadcast chat messages across connected clients using Lambda | 24/11/2026 | 24/11/2026 | https://000066.awsfcaj.com/ <br> https://000117.awsfcaj.com/ |
| 4 | - Deploy Node.js application to AWS Elastic Beanstalk environment<br>- Configure Elastic Beanstalk Auto Scaling, load balancer, and rolling deployments<br>- Set up AWS CDK Pipeline for automated infrastructure updates | 25/11/2026 | 25/11/2026 | https://000112.awsfcaj.com/ <br> https://000113.awsfcaj.com/ |
| 5 | - Deploy high-availability WordPress application on EC2 behind ALB<br>- Offload static uploads to Amazon S3 and connect database to Amazon Aurora<br>- Configure Memcached caching for sub-second page delivery | 26/11/2026 | 26/11/2026 | https://000091.awsfcaj.com/ |
| 6 | - Deploy containerized services from public registries to Amazon ECS<br>- Configure health checks, container port mappings, and CloudWatch Logs<br>- Watch FCAJ YouTube Lessons 261 - 280 | 27/11/2026 | 27/11/2026 | https://000046.awsfcaj.com/ <br> https://www.youtube.com/@AWSStudyGroup |

### Week 11 Achievements:

* Built serverless document management workflow with presigned URLs
* Created real-time WebSocket chat app with DynamoDB connection tracking
* Deployed web applications using Elastic Beanstalk with rolling updates
* Configured WordPress on EC2 with decoupled S3 storage and Aurora MySQL
* Deployed and monitored public container services on Amazon ECS

AWS services used:

* Amazon S3 & AWS Lambda
* Amazon API Gateway (WebSocket API)
* Amazon DynamoDB
* AWS Elastic Beanstalk
* Amazon EC2 & Amazon Aurora
* Amazon Lightsail / ECS

Skills gained:

* Secure file upload pipelines with presigned URLs
* Real-time bi-directional communication with WebSockets
* Platform-as-a-Service (PaaS) deployment and environment scaling
* Traditional decoupled web CMS architectures
