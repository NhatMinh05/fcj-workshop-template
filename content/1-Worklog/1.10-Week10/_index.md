---
title: "Week 10 Worklog"
date: 2026-09-14
weight: 10
chapter: false
pre: " <b> 1.10. </b> "
---

### Week 10 Objectives:

* Learn Kubernetes basics and create Amazon EKS cluster
* Build automated CI/CD pipelines with AWS CodePipeline
* Run serverless container workloads using AWS Fargate
* Deploy container image updates to EKS from GitHub
* Connect serverless frontend to Amazon API Gateway and Lambda

### Tasks to be carried out this week:

| Day | Task | Start Date | Completion Date | Reference Material |
| --- | --- | --- | --- | --- |
| 2 | - Get started with Kubernetes concepts on Amazon EKS<br>- Create a managed Amazon EKS cluster using eksctl<br>- Deploy a sample Nginx web application pod and service with kubectl | 16/11/2026 | 16/11/2026 | https://000126.awsfcaj.com/ |
| 3 | - Create CI/CD pipeline in AWS CodePipeline with GitHub source<br>- Configure CodeBuild step to run unit tests and produce build artifacts<br>- Test automated build execution on code commit | 17/11/2026 | 17/11/2026 | https://000017.awsfcaj.com/ |
| 4 | - Learn differences between ECS EC2 launch type and AWS Fargate<br>- Create ECS Task Definition using Fargate serverless launch type<br>- Run serverless container task without managing underlying EC2 hosts | 18/11/2026 | 18/11/2026 | https://000067.awsfcaj.com/ |
| 5 | - Build CI/CD workflow to update container image on EKS<br>- Connect GitHub repository to deploy updated pods to EKS cluster<br>- Verify rolling pod replacement with zero downtime | 19/11/2026 | 19/11/2026 | https://000062.awsfcaj.com/ |
| 6 | - Build a simple HTML/JavaScript frontend hosted on Amazon S3<br>- Create REST API in Amazon API Gateway to trigger backend Lambda<br>- Connect frontend AJAX requests to API Gateway endpoints<br>- Watch FCAJ YouTube Lessons 236 - 260 | 20/11/2026 | 20/11/2026 | https://000079.awsfcaj.com/ <br> https://www.youtube.com/@AWSStudyGroup |

### Week 10 Achievements:

* Created Amazon EKS Kubernetes cluster and deployed sample workloads
* Automated build testing and artifact delivery with AWS CodePipeline
* Deployed serverless containers on AWS Fargate without managing servers
* Implemented continuous deployment from GitHub to Amazon EKS
* Built complete frontend-to-backend connection with API Gateway and Lambda

AWS services used:

* Amazon Elastic Kubernetes Service (EKS)
* AWS CodePipeline & CodeBuild
* AWS Fargate
* Amazon API Gateway
* Amazon S3

Skills gained:

* Kubernetes fundamentals and basic cluster deployment on EKS
* Continuous integration and automated build pipelines
* Serverless container execution with AWS Fargate
* Full-stack serverless integration from frontend to API
