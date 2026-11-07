---
title: "Week 5 Worklog"
date: 2026-09-14
weight: 5
chapter: false
pre: " <b> 1.5. </b> "
---

### Week 5 Objectives:

* Connect to EC2 securely without open SSH ports via SSM Session Manager
* Define infrastructure as code templates with AWS CloudFormation
* Automate off-hours server shutdown with AWS Lambda and Slack alerts
* Set up enterprise single sign-on with AWS IAM Identity Center (SSO)
* Apply security guardrails with IAM Permission Boundaries

### Tasks to be carried out this week:

| Day | Task | Start Date | Completion Date | Reference Material |
| --- | --- | --- | --- | --- |
| 2 | - Attach IAM instance profile with SSM permissions to EC2<br>- Connect to EC2 instances using Systems Manager Session Manager<br>- Run remote commands on instances using SSM Run Command | 12/10/2026 | 12/10/2026 | https://000058.awsfcaj.com/ |
| 3 | - Learn CloudFormation template structure (Resources, Parameters, Outputs)<br>- Write YAML template to deploy VPC, subnets, and EC2 instance<br>- Create and update CloudFormation stacks via AWS Console and CLI | 13/10/2026 | 13/10/2026 | https://000037.awsfcaj.com/ |
| 4 | - Write Python Lambda function to stop running EC2 instances<br>- Create EventBridge rule to trigger Lambda function on a schedule<br>- Configure Lambda to send execution status messages to Slack | 14/10/2026 | 14/10/2026 | https://000022.awsfcaj.com/ |
| 5 | - Set up AWS IAM Identity Center (SSO) organization directory<br>- Create users and assign permissions to AWS accounts<br>- Test single sign-on access to the AWS Management Console | 15/10/2026 | 15/10/2026 | https://000012.awsfcaj.com/ |
| 6 | - Create and test IAM Permission Boundaries on test users<br>- Ensure delegated users cannot exceed assigned permission limits<br>- Watch FCAJ YouTube Lessons 111 - 135 | 16/10/2026 | 16/10/2026 | https://000030.awsfcaj.com/ <br> https://www.youtube.com/@AWSStudyGroup |

### Week 5 Achievements:

* Managed EC2 instances securely without SSH keys using Session Manager
* Automated cloud infrastructure provisioning using CloudFormation IaC
* Built automated EC2 shutdown solution with Lambda and EventBridge
* Configured AWS IAM Identity Center (SSO) for centralized login
* Enforced security guardrails using IAM Permission Boundaries

AWS services used:

* AWS Systems Manager (SSM)
* AWS CloudFormation
* AWS Lambda
* Amazon EventBridge
* AWS IAM Identity Center (SSO)
* AWS Identity and Access Management (IAM)

Skills gained:

* Secure remote server management without public ports
* Infrastructure as Code basics with CloudFormation YAML
* Serverless automation and cron-based scheduling
* User access governance with SSO and Permission Boundaries
