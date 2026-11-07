---
title: "Week 5 Worklog"
date: 2026-10-12
weight: 5
chapter: false
pre: " <b> 1.5. </b> "
---

### Week 5 Objectives:

* Manage EC2 instances securely without open SSH ports via AWS Systems Manager
* Provision reproducible infrastructure as code with AWS CloudFormation
* Automate scheduled operational tasks using AWS Lambda and EventBridge
* Implement centralized enterprise identity management with AWS IAM Identity Center (SSO)
* Enforce security guardrails using IAM Permission Boundaries
* Complete FCAJ YouTube Lessons 111 - 135

### Tasks to be carried out this week:

| Day | Task | Start Date | Completion Date | Reference Material |
| --- | --- | --- | --- | --- |
| 2 | - Attach IAM instance profiles and verify SSM Agent on EC2<br>- Start interactive shell sessions via Session Manager without opening port 22<br>- Run fleet-wide commands with SSM Run Command and Patch Manager | 12/10/2026 | 12/10/2026 | https://000058.awsfcaj.com/ |
| 3 | - Author declarative CloudFormation YAML templates for VPC & EC2<br>- Parameterize templates with Mappings, Parameters, and Outputs<br>- Deploy stacks, test drift detection, and verify rollback protection | 13/10/2026 | 13/10/2026 | https://000037.awsfcaj.com/ |
| 4 | - Author Python Lambda function to stop idle EC2 instances off-hours<br>- Schedule automated execution with Amazon EventBridge cron rules<br>- Send operational notifications to Slack using Incoming Webhooks | 14/10/2026 | 14/10/2026 | https://000022.awsfcaj.com/ |
| 5 | - Configure AWS IAM Identity Center (AWS SSO) directory & users<br>- Define multi-account Permission Sets with least-privilege policies<br>- Test single sign-on access across developer and admin accounts | 15/10/2026 | 15/10/2026 | https://000012.awsfcaj.com/ |
| 6 | - Create IAM Permission Boundaries to cap maximum delegable permissions<br>- Verify privilege escalation prevention on delegated admin users<br>- Watch FCAJ YouTube Lessons 111 - 135 | 16/10/2026 | 16/10/2026 | https://000030.awsfcaj.com/ <br> https://www.youtube.com/@AWSStudyGroup |

### Week 5 Achievements:

* Eliminated bastion hosts and open SSH ports using SSM Session Manager
* Automated repeatable cloud infrastructure provisioning with CloudFormation IaC
* Built serverless operational cost-saving automation with Lambda and Slack alerts
* Enforced organizational governance with SSO and IAM Permission Boundaries
