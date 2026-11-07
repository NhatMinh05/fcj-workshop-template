---
title: "Week 6 Worklog"
date: 2026-10-19
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
| 2 | - Enable AWS Security Hub and run CIS AWS Foundations Benchmark checks<br>- Prioritize and remediate critical security posture findings<br>- Configure AWS WAF web ACLs with managed rule groups on ALB | 19/10/2026 | 19/10/2026 | https://000018.awsfcaj.com/ <br> https://000026.awsfcaj.com/ |
| 3 | - Create Customer Managed Keys (CMKs) in AWS KMS<br>- Configure key policies, aliases, and automated annual key rotation<br>- Test envelope encryption on S3 buckets and EBS volumes with KMS | 20/10/2026 | 20/10/2026 | https://000033.awsfcaj.com/ |
| 4 | - Write optimized multi-stage Dockerfiles for Node.js application<br>- Build and run local Docker containers, verifying health endpoints<br>- Create Amazon ECR private repository and push tagged container images | 21/10/2026 | 21/10/2026 | https://000015.awsfcaj.com/ |
| 5 | - Create Amazon ECS cluster with EC2 and Fargate capacity providers<br>- Define Task Definitions specifying CPU, memory, and ECR image URI<br>- Deploy ECS Service with Application Load Balancer and target groups | 22/10/2026 | 22/10/2026 | https://000016.awsfcaj.com/ |
| 6 | - Build automated CI/CD pipeline connecting GitHub, CodeBuild, and ECS<br>- Configure buildspec.yml to build Docker images and update task definitions<br>- Test continuous deployment on git push<br>- Watch FCAJ YouTube Lessons 136 - 160 | 23/10/2026 | 23/10/2026 | https://000029.awsfcaj.com/ <br> https://www.youtube.com/@AWSStudyGroup |

### Week 6 Achievements:

* Evaluated CIS security benchmarks with Security Hub and added WAF rules
* Created Customer Managed Keys and configured KMS encryption
* Containerized Node.js applications with Docker and pushed to Amazon ECR
* Deployed scalable container services on Amazon ECS behind an ALB
* Built automated deployment pipeline connecting GitHub and ECS

AWS services used:

* AWS Security Hub
* AWS WAF
* AWS Key Management Service (KMS)
* Amazon Elastic Container Registry (ECR)
* Amazon Elastic Container Service (ECS)
* AWS CodePipeline & CodeBuild

Skills gained:

* Automated cloud security posture assessment
* Application layer protection and cryptographic key management
* Docker image optimization and container packaging
* Container orchestration and automated CI/CD pipelines
