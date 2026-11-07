---
title: "Week 7 Worklog"
date: 2026-10-26
weight: 7
chapter: false
pre: " <b> 1.7. </b> "
---

### Week 7 Objectives:

* Set up shared Windows file storage with Amazon FSx
* Build multi-tier S3 Data Lake with automated lifecycle policies
* Design NoSQL database tables and indexes in Amazon DynamoDB
* Analyze cost optimization using Savings Plans and Reserved Instances
* Right-size EC2 instances using AWS Compute Optimizer

### Tasks to be carried out this week:

| Day | Task | Start Date | Completion Date | Reference Material |
| --- | --- | --- | --- | --- |
| 2 | - Provision Amazon FSx for Windows File Server with Active Directory integration<br>- Mount SMB network shares to Windows and Linux EC2 instances<br>- Configure shadow copies, data deduplication, and automated backups | 26/10/2026 | 26/10/2026 | https://000025.awsfcaj.com/ |
| 3 | - Design S3 Data Lake structure with raw, staged, and curated zones<br>- Configure S3 Lifecycle rules transitioning objects to Glacier tiers<br>- Set up S3 Object Lock and Cross-Region Replication (CRR) | 27/10/2026 | 27/10/2026 | https://000035.awsfcaj.com/ |
| 4 | - Create Amazon DynamoDB tables with Partition Key and Sort Key design<br>- Implement Global Secondary Indexes (GSI) for optimized querying<br>- Configure DynamoDB Auto Scaling, Point-in-Time Recovery (PITR), and TTL | 28/10/2026 | 28/10/2026 | https://000039.awsfcaj.com/ |
| 5 | - Analyze Cost Explorer recommendations for Compute Savings Plans<br>- Model EC2 and RDS Reserved Instances (RI) cost reductions<br>- Compare all-upfront, partial-upfront, and no-upfront commitment savings | 29/10/2026 | 29/10/2026 | https://000029.awsfcaj.com/ |
| 6 | - Review AWS Compute Optimizer CPU, memory, and network utilization insights<br>- Right-size over-provisioned EC2 instance types and migrate to Graviton<br>- Watch FCAJ YouTube Lessons 161 - 185 | 30/10/2026 | 30/10/2026 | https://000032.awsfcaj.com/ <br> https://www.youtube.com/@AWSStudyGroup |

### Week 7 Achievements:

* Provisioned Amazon FSx for Windows file shares with Active Directory
* Created S3 Data Lake tiers with lifecycle rules and Glacier transitions
* Designed DynamoDB tables with Global Secondary Indexes and TTL
* Modeled cloud savings using Compute Savings Plans and Reserved Instances
* Right-sized EC2 instances based on Compute Optimizer recommendations

AWS services used:

* Amazon FSx for Windows File Server
* Amazon S3 (Data Lake)
* Amazon DynamoDB
* AWS Cost Explorer (Savings Plans / RIs)
* AWS Compute Optimizer

Skills gained:

* Managed Windows network storage integration
* S3 Data Lake tiered storage architecture
* NoSQL data modeling with single-table design and GSIs
* Financial cost optimization and instance right-sizing
