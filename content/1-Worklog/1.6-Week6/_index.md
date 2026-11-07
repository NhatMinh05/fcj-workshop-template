---
title: "Week 6 Worklog"
date: 2026-10-19
weight: 6
chapter: false
pre: " <b> 1.6. </b> "
---

### Week 6 Objectives:

* Evaluate cloud security posture against CIS benchmarks with AWS Security Hub
* Protect web applications from OWASP top 10 threats using AWS WAF
* Manage envelope encryption and key rotation with AWS Key Management Service (KMS)
* Containerize web applications with Docker and deploy to Amazon ECS
* Automate container image builds and deployments with AWS CodePipeline
* Complete FCAJ YouTube Lessons 136 - 160

### Tasks to be carried out this week:

| Day | Task | Start Date | Completion Date | Reference Material |
| --- | --- | --- | --- | --- |
| 2 | - Enable AWS Security Hub and run CIS AWS Foundations Benchmark checks<br>- Prioritize and remediate critical security posture findings<br>- Configure AWS WAF web ACLs with managed rule groups on ALB | 19/10/2026 | 19/10/2026 | https://000018.awsfcaj.com/ <br> https://000026.awsfcaj.com/ |
| 3 | - Create Customer Managed Keys (CMKs) in AWS KMS<br>- Configure key policies, aliases, and automated annual key rotation<br>- Test envelope encryption on S3 buckets and EBS volumes with KMS | 20/10/2026 | 20/10/2026 | https://000033.awsfcaj.com/ |
| 4 | - Write optimized multi-stage Dockerfiles for Node.js application<br>- Build and run local Docker containers, verifying health endpoints<br>- Create Amazon ECR private repository and push tagged container images | 21/10/2026 | 21/10/2026 | https://000015.awsfcaj.com/ |
| 5 | - Create Amazon ECS cluster with EC2 and Fargate capacity providers<br>- Define Task Definitions specifying CPU, memory, and ECR image URI<br>- Deploy ECS Service with Application Load Balancer and target groups | 22/10/2026 | 22/10/2026 | https://000016.awsfcaj.com/ |
| 6 | - Build automated CI/CD pipeline connecting GitHub, CodeBuild, and ECS<br>- Configure buildspec.yml to build Docker images and update task definitions<br>- Test continuous deployment on git push<br>- Watch FCAJ YouTube Lessons 136 - 160 | 23/10/2026 | 23/10/2026 | https://000029.awsfcaj.com/ <br> https://www.youtube.com/@AWSStudyGroup |

### Week 6 Achievements:

* Hardened security posture with AWS Security Hub and AWS WAF web protection
* Implemented cryptographic data-at-rest encryption with AWS KMS
* Containerized applications with Docker and published images to Amazon ECR
* Built automated container deployment pipelines with Amazon ECS and CodePipeline
