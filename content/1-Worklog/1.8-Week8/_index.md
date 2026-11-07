---
title: "Week 8 Worklog"
date: 2026-11-02
weight: 8
chapter: false
pre: " <b> 1.8. </b> "
---

### Week 8 Objectives:

* Analyze AWS Cost and Usage Reports (CUR) using AWS Glue and Amazon Athena
* Plan and execute application migration from monolith to microservices
* Build automated canary and blue/green release pipelines
* Develop and deploy independent decoupled microservices
* Restructure database schemas and event-driven data workflows
* Complete FCAJ YouTube Lessons 186 - 210

### Tasks to be carried out this week:

| Day | Task | Start Date | Completion Date | Reference Material |
| --- | --- | --- | --- | --- |
| 2 | - Export AWS Cost and Usage Reports (CUR) to Amazon S3<br>- Crawl CUR datasets with AWS Glue Crawler to build Data Catalog<br>- Run SQL analytics queries in Amazon Athena to detect spending anomalies | 02/11/2026 | 02/11/2026 | https://000040.awsfcaj.com/ |
| 3 | - Analyze monolithic application architecture and identify bounded contexts<br>- Apply Strangler Fig pattern to decouple user management module<br>- Map legacy database dependencies to standalone microservices | 03/11/2026 | 03/11/2026 | https://000050.awsfcaj.com/ |
| 4 | - Configure automated CodeDeploy deployment groups for EC2 and ECS<br>- Implement Blue/Green deployment strategy with traffic shifting<br>- Set up CloudWatch alarms for automated rollback on deployment errors | 04/11/2026 | 04/11/2026 | https://000051.awsfcaj.com/ |
| 5 | - Develop standalone Node.js REST API microservice with container packaging<br>- Deploy microservice to Amazon ECS behind an Application Load Balancer<br>- Configure health check probes and path-based routing rules | 05/11/2026 | 05/11/2026 | https://000052.awsfcaj.com/ |
| 6 | - Decouple shared relational database into database-per-service architecture<br>- Implement transactional outbox pattern for reliable event publishing<br>- Watch FCAJ YouTube Lessons 186 - 210 | 06/11/2026 | 06/11/2026 | https://000053.awsfcaj.com/ <br> https://www.youtube.com/@AWSStudyGroup |

### Week 8 Achievements:

* Gained deep cost visibility querying AWS billing datasets with Athena SQL
* Successfully decomposed monolithic application into independent services
* Implemented zero-downtime Blue/Green deployments with automated rollback
* Built containerized microservices with dedicated databases and path routing
