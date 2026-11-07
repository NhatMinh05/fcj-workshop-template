---
title: "Week 10 Worklog"
date: 2026-11-16
weight: 10
chapter: false
pre: " <b> 1.10. </b> "
---

### Week 10 Objectives:

* Provision and manage Kubernetes clusters on Amazon EKS
* Build multi-stage CI/CD pipelines with manual approval gates
* Deploy serverless containers using AWS Fargate
* Set up GitOps automated delivery from GitHub to EKS
* Connect serverless frontend to Amazon API Gateway and Lambda

### Tasks to be carried out this week:

| Day | Task | Start Date | Completion Date | Reference Material |
| --- | --- | --- | --- | --- |
| 2 | - Provision Amazon EKS cluster with managed node groups using eksctl<br>- Configure kubectl context and deploy Kubernetes Pods, Deployments & Services<br>- Set up AWS Load Balancer Controller for automated ingress provisioning | 16/11/2026 | 16/11/2026 | https://000126.awsfcaj.com/ |
| 3 | - Build multi-stage CodePipeline with manual review gates<br>- Configure AWS CodeBuild running automated unit tests and linting<br>- Deploy artifacts to staging and production target environments | 17/11/2026 | 17/11/2026 | https://000017.awsfcaj.com/ |
| 4 | - Configure Amazon ECS Task Definitions using Fargate launch type<br>- Deploy serverless container services without EC2 instance management<br>- Configure Fargate auto-scaling policies based on CPU and memory metrics | 18/11/2026 | 18/11/2026 | https://000067.awsfcaj.com/ |
| 5 | - Connect GitHub webhook triggers to AWS CodePipeline<br>- Automate Docker image build, push to ECR, and Kubernetes rolling update on EKS<br>- Verify zero-downtime rolling update across worker pods | 19/11/2026 | 19/11/2026 | https://000062.awsfcaj.com/ |
| 6 | - Build frontend application hosted on S3 and CloudFront<br>- Configure Amazon API Gateway REST endpoints with CORS and Cognito authorizer<br>- Connect frontend AJAX requests to Lambda backend and DynamoDB<br>- Watch FCAJ YouTube Lessons 236 - 260 | 20/11/2026 | 20/11/2026 | https://000079.awsfcaj.com/ <br> https://www.youtube.com/@AWSStudyGroup |

### Week 10 Achievements:

* Deployed containerized applications to Amazon EKS with kubectl
* Built multi-stage CI/CD pipelines in AWS CodePipeline
* Ran serverless container tasks on AWS Fargate without managing servers
* Automated continuous deployment from GitHub to EKS
* Built full-stack serverless web app with API Gateway and S3 hosting

AWS services used:

* Amazon Elastic Kubernetes Service (EKS)
* AWS Fargate
* AWS CodePipeline & CodeBuild
* Amazon API Gateway
* Amazon S3 & Amazon CloudFront

Skills gained:

* Kubernetes cluster management and container orchestration
* Serverless container execution with Fargate
* GitOps continuous deployment workflows
* Full-stack serverless frontend-to-backend integration
