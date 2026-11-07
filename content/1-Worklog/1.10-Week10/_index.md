---
title: "Week 10 Worklog"
date: 2026-11-16
weight: 10
chapter: false
pre: " <b> 1.10. </b> "
---

### Week 10 Objectives:

* Deploy and manage Kubernetes clusters on Amazon EKS
* Build multi-stage CI/CD pipelines with AWS CodePipeline
* Run serverless container workloads using AWS Fargate
* Implement GitOps automated delivery to Amazon EKS from GitHub
* Build full-stack serverless frontend calling Amazon API Gateway REST APIs
* Complete FCAJ YouTube Lessons 236 - 260

### Tasks to be carried out this week:

| Day | Task | Start Date | Completion Date | Reference Material |
| --- | --- | --- | --- | --- |
| 2 | - Provision Amazon EKS cluster with managed node groups using eksctl<br>- Configure kubectl context and deploy Kubernetes Pods, Deployments & Services<br>- Set up AWS Load Balancer Controller for automated ingress provisioning | 16/11/2026 | 16/11/2026 | https://000126.awsfcaj.com/ |
| 3 | - Build multi-stage CodePipeline with manual review gates<br>- Configure AWS CodeBuild running automated unit tests and linting<br>- Deploy artifacts to staging and production target environments | 17/11/2026 | 17/11/2026 | https://000017.awsfcaj.com/ |
| 4 | - Configure Amazon ECS Task Definitions using Fargate launch type<br>- Deploy serverless container services without EC2 instance management<br>- Configure Fargate auto-scaling policies based on CPU and memory metrics | 18/11/2026 | 18/11/2026 | https://000067.awsfcaj.com/ |
| 5 | - Connect GitHub webhook triggers to AWS CodePipeline<br>- Automate Docker image build, push to ECR, and Kubernetes rolling update on EKS<br>- Verify zero-downtime rolling update across worker pods | 19/11/2026 | 19/11/2026 | https://000062.awsfcaj.com/ |
| 6 | - Build frontend application hosted on S3 and CloudFront<br>- Configure Amazon API Gateway REST endpoints with CORS and Cognito authorizer<br>- Connect frontend AJAX requests to Lambda backend and DynamoDB<br>- Watch FCAJ YouTube Lessons 236 - 260 | 20/11/2026 | 20/11/2026 | https://000079.awsfcaj.com/ <br> https://www.youtube.com/@AWSStudyGroup |

### Week 10 Achievements:

* Mastered container orchestration with Kubernetes on Amazon EKS
* Automated end-to-end continuous delivery pipelines from GitHub to EKS
* Deployed scalable serverless container microservices on AWS Fargate
* Built complete full-stack serverless web application with API Gateway and Lambda
