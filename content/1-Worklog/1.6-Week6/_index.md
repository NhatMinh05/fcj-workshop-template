---
title: "Week 6 Worklog"
date: 2026-09-14
weight: 6
chapter: false
pre: " <b> 1.6. </b> "
---

### Week 6 Objectives:

* Assess cloud security posture with AWS Security Hub and AWS WAF
* Manage data encryption and keys using AWS KMS
* Containerize web applications with Docker and Amazon ECR
* Deploy container workloads on Amazon ECS with load balancing
* Build automated container CI/CD pipelines with AWS CodePipeline

### Tasks to be carried out this week:

| Day | Task | Start Date | Completion Date | Reference Material |
| --- | --- | --- | --- | --- |
| 2 | - Enable AWS Security Hub and review standard security score<br>- Identify and fix common security configuration findings<br>- Create AWS WAF Web ACL and attach to Application Load Balancer | 19/10/2026 | 19/10/2026 | https://000018.awsfcaj.com/ <br> https://000026.awsfcaj.com/ |
| 3 | - Create Customer Managed Keys (CMK) in AWS Key Management Service (KMS)<br>- Configure key policies and enable automatic key rotation<br>- Encrypt S3 buckets and EBS volumes using custom KMS keys | 20/10/2026 | 20/10/2026 | https://000033.awsfcaj.com/ |
| 4 | - Write a Dockerfile for a sample Node.js web application<br>- Build and run Docker container image on local machine<br>- Create Amazon ECR repository and push Docker image to ECR | 21/10/2026 | 21/10/2026 | https://000015.awsfcaj.com/ |
| 5 | - Create Amazon ECS cluster with EC2 launch type<br>- Create ECS Task Definition using the container image from ECR<br>- Deploy ECS Service behind an Application Load Balancer | 22/10/2026 | 22/10/2026 | https://000016.awsfcaj.com/ |
| 6 | - Set up AWS CodePipeline with CodeBuild to automate deployments<br>- Trigger pipeline on Git push to automatically build and deploy to ECS<br>- Watch FCAJ YouTube Lessons 136 - 160 | 23/10/2026 | 23/10/2026 | https://000029.awsfcaj.com/ <br> https://www.youtube.com/@AWSStudyGroup |

### Week 6 Achievements:

* Checked cloud security benchmarks with Security Hub and added WAF rules
* Managed encryption keys and encrypted storage resources using AWS KMS
* Built Docker container images and pushed them to Amazon ECR
* Deployed and load balanced containerized applications on Amazon ECS
* Created automated CI/CD deployment pipeline with AWS CodePipeline

AWS services used:

* AWS Security Hub
* AWS WAF
* AWS Key Management Service (KMS)
* Amazon Elastic Container Registry (ECR)
* Amazon Elastic Container Service (ECS)
* AWS CodePipeline & CodeBuild

Skills gained:

* Cloud security auditing and web application firewall protection
* Key management and data-at-rest encryption
* Container packaging with Docker and image registry management
* Container orchestration on ECS and automated CI/CD workflows
