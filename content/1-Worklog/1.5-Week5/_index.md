---
title: "Week 5 Worklog"
date: 2026-10-12
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
| 2 | - Attach IAM instance profiles and verify SSM Agent on EC2<br>- Start interactive shell sessions via Session Manager without opening port 22<br>- Run fleet-wide commands with SSM Run Command and Patch Manager | 12/10/2026 | 12/10/2026 | https://000058.awsfcaj.com/ |
| 3 | - Author declarative CloudFormation YAML templates for VPC & EC2<br>- Parameterize templates with Mappings, Parameters, and Outputs<br>- Deploy stacks, test drift detection, and verify rollback protection | 13/10/2026 | 13/10/2026 | https://000037.awsfcaj.com/ |
| 4 | - Author Python Lambda function to stop idle EC2 instances off-hours<br>- Schedule automated execution with Amazon EventBridge cron rules<br>- Send operational notifications to Slack using Incoming Webhooks | 14/10/2026 | 14/10/2026 | https://000022.awsfcaj.com/ |
| 5 | - Configure AWS IAM Identity Center (AWS SSO) directory & users<br>- Define multi-account Permission Sets with least-privilege policies<br>- Test single sign-on access across developer and admin accounts | 15/10/2026 | 15/10/2026 | https://000012.awsfcaj.com/ |
| 6 | - Create IAM Permission Boundaries to cap maximum delegable permissions<br>- Verify privilege escalation prevention on delegated admin users<br>- Watch FCAJ YouTube Lessons 111 - 135 | 16/10/2026 | 16/10/2026 | https://000030.awsfcaj.com/ <br> https://www.youtube.com/@AWSStudyGroup |

### Week 5 Achievements:

* Managed EC2 instances securely with SSM Session Manager
* Automated VPC and EC2 deployments using CloudFormation templates
* Built automated server shutdown bot with Lambda, EventBridge, and Slack
* Configured AWS SSO access and enforced IAM Permission Boundaries

AWS services used:

* AWS Systems Manager (SSM)
* AWS CloudFormation
* AWS Lambda
* Amazon EventBridge
* AWS IAM Identity Center (SSO)
* AWS IAM (Permission Boundaries)

Skills gained:

* Bastionless remote server administration
* Infrastructure as Code (IaC) template authoring
* Event-driven serverless operational automation
* Enterprise identity federation and permission boundary guardrails
