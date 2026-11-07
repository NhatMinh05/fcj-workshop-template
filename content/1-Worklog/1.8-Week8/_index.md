---
title: "Week 8 Worklog"
date: 2026-11-02
weight: 8
chapter: false
pre: " <b> 1.8. </b> "
---

### Week 8 Objectives:

* Analyze AWS Cost and Usage Reports (CUR) with AWS Glue and Amazon Athena
* Plan application modernization from monolithic to microservices
* Build zero-downtime Blue/Green deployments with AWS CodeDeploy
* Create and run independent REST API microservices on Amazon ECS
* Separate monolithic databases into database-per-service patterns

### Tasks to be carried out this week:

| Day | Task | Start Date | Completion Date | Reference Material |
| --- | --- | --- | --- | --- |
| 2 | - Export AWS Cost and Usage Reports (CUR) to Amazon S3<br>- Crawl CUR datasets with AWS Glue Crawler to build Data Catalog<br>- Run SQL analytics queries in Amazon Athena to detect spending anomalies | 02/11/2026 | 02/11/2026 | https://000040.awsfcaj.com/ |
| 3 | - Analyze monolithic application architecture and identify bounded contexts<br>- Apply Strangler Fig pattern to decouple user management module<br>- Map legacy database dependencies to standalone microservices | 03/11/2026 | 03/11/2026 | https://000050.awsfcaj.com/ |
| 4 | - Configure automated CodeDeploy deployment groups for EC2 and ECS<br>- Implement Blue/Green deployment strategy with traffic shifting<br>- Set up CloudWatch alarms for automated rollback on deployment errors | 04/11/2026 | 04/11/2026 | https://000051.awsfcaj.com/ |
| 5 | - Develop standalone Node.js REST API microservice with container packaging<br>- Deploy microservice to Amazon ECS behind an Application Load Balancer<br>- Configure health check probes and path-based routing rules | 05/11/2026 | 05/11/2026 | https://000052.awsfcaj.com/ |
| 6 | - Decouple shared relational database into database-per-service architecture<br>- Implement transactional outbox pattern for reliable event publishing<br>- Watch FCAJ YouTube Lessons 186 - 210 | 06/11/2026 | 06/11/2026 | https://000053.awsfcaj.com/ <br> https://www.youtube.com/@AWSStudyGroup |

### Week 8 Achievements:

* Queried AWS billing and usage trends using Athena SQL and Glue catalog
* Decomposed monolithic modules into independent services
* Implemented Blue/Green deployment strategy with automated rollback
* Deployed containerized REST microservices on ECS with path routing
* Restructured application data into decoupled service databases

AWS services used:

* AWS Cost and Usage Reports (CUR)
* AWS Glue
* Amazon Athena
* AWS CodeDeploy
* Amazon ECS & Application Load Balancer

Skills gained:

* Serverless big data analytics on billing datasets
* Monolith-to-microservices migration patterns (Strangler Fig)
* Zero-downtime deployment strategies (Blue/Green)
* Microservices architecture and database decomposition
