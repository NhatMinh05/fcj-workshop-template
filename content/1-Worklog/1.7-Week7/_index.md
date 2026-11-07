---
title: "Week 7 Worklog"
date: 2026-09-14
weight: 7
chapter: false
pre: " <b> 1.7. </b> "
---

### Week 7 Objectives:

* Set up shared Windows file storage with Amazon FSx
* Build S3 Data Lake with lifecycle tiering rules
* Design NoSQL database tables and indexes in Amazon DynamoDB
* Analyze cost optimization using Savings Plans and Reserved Instances
* Right-size EC2 instances using AWS Compute Optimizer

### Tasks to be carried out this week:

| Day | Task | Start Date | Completion Date | Reference Material |
| --- | --- | --- | --- | --- |
| 2 | - Provision Amazon FSx for Windows File Server in private subnet<br>- Join FSx file system to Active Directory and mount to EC2<br>- Test file sharing and configure automated daily backups | 26/10/2026 | 26/10/2026 | https://000025.awsfcaj.com/ |
| 3 | - Create S3 bucket structure for Data Lake (raw, processed, curated)<br>- Configure S3 Lifecycle rules to transition older data to Glacier<br>- Enable S3 bucket versioning and default encryption | 27/10/2026 | 27/10/2026 | https://000035.awsfcaj.com/ |
| 4 | - Create DynamoDB table with Partition Key and Sort Key<br>- Add items and query data using DynamoDB Console and AWS CLI<br>- Create a Global Secondary Index (GSI) to support alternative query patterns | 28/10/2026 | 28/10/2026 | https://000039.awsfcaj.com/ |
| 5 | - Review AWS Cost Explorer recommendations for Savings Plans<br>- Compare cost savings between On-Demand and Reserved Instances (RI)<br>- Calculate monthly budget impact of 1-year vs 3-year commitments | 29/10/2026 | 29/10/2026 | https://000029.awsfcaj.com/ |
| 6 | - Run AWS Compute Optimizer to identify underutilized EC2 instances<br>- Right-size test EC2 instance to optimal instance family<br>- Watch FCAJ YouTube Lessons 161 - 185 | 30/10/2026 | 30/10/2026 | https://000032.awsfcaj.com/ <br> https://www.youtube.com/@AWSStudyGroup |

### Week 7 Achievements:

* Provisioned managed Windows file storage with Amazon FSx
* Organized S3 Data Lake storage tiers with automated lifecycle archiving
* Designed and queried NoSQL tables and indexes in Amazon DynamoDB
* Analyzed cost reduction strategies with Savings Plans and Reserved Instances
* Right-sized EC2 instances using AWS Compute Optimizer recommendations

AWS services used:

* Amazon FSx for Windows File Server
* Amazon S3
* Amazon DynamoDB
* AWS Cost Explorer
* AWS Compute Optimizer

Skills gained:

* Enterprise shared file systems setup on AWS
* S3 storage tiering and lifecycle management
* NoSQL data modeling and querying with DynamoDB
* Cloud cost analysis and instance right-sizing
