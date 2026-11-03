---
title: "Week 5 Worklog"
date: 2026-09-14
weight: 5
chapter: false
pre: " <b> 1.5. </b> "
---

### Week 5 Objectives:

* Secure server management without open SSH/RDP ports using AWS Systems Manager.
* Automate infrastructure deployment using Infrastructure as Code (IaC) with AWS CloudFormation.
* Build serverless automation workflows using AWS Lambda and EventBridge.
* Configure enterprise Single Sign-On with AWS IAM Identity Center.
* Establish delegation guardrails using IAM Permission Boundaries.
* Complete FCAJ YouTube video lessons 111 - 135.

### Tasks to be carried out this week:
| Day | Task | Start Date | Completion Date | Reference Material |
| --- | --- | --- | --- | --- |
| 2 | - Bastionless server administration with AWS Systems Manager (SSM):<br>&emsp;+ Configure SSM Agent and attach IAM instance profiles.<br>&emsp;+ Start interactive shell sessions via Session Manager without opening port 22/3389.<br>&emsp;+ Automate fleet patching with SSM Run Command and Patch Manager. | 12/10/2026 | 12/10/2026 | <https://000058.awsfcaj.com/> |
| 3 | - Infrastructure as Code (IaC) with AWS CloudFormation:<br>&emsp;+ Author declarative YAML/JSON templates modeling VPC, EC2, and Security Groups.<br>&emsp;+ Manage stack lifecycles, parameters, outputs, and rollback safety controls. | 13/10/2026 | 13/10/2026 | <https://000037.awsfcaj.com/> |
| 4 | - Event-driven serverless operational automation:<br>&emsp;+ Author Python AWS Lambda function to stop non-production EC2 instances off-hours.<br>&emsp;+ Schedule execution with Amazon EventBridge rules.<br>&emsp;+ Post automated incident and status messages to Slack via Incoming Webhooks. | 14/10/2026 | 14/10/2026 | <https://000022.awsfcaj.com/> |
| 5 | - Enterprise Identity Management with AWS IAM Identity Center (AWS SSO):<br>&emsp;+ Configure organizational identity directory and multi-account permissions.<br>&emsp;+ Assign permission sets and enable single sign-on access across AWS accounts. | 15/10/2026 | 15/10/2026 | <https://000012.awsfcaj.com/> |
| 6 | - Advanced IAM Governance:<br>&emsp;+ Create IAM Permission Boundaries to cap maximum permissions delegated administrators can grant.<br>&emsp;+ Test privilege escalation prevention.<br>&emsp;+ Complete FCAJ YouTube Lessons 111 - 135. | 16/10/2026 | 16/10/2026 | <https://000030.awsfcaj.com/> |

### Week 5 Achievements:

* Eliminated bastion hosts and open inbound management ports via AWS Systems Manager.
* Automated repeatable cloud infrastructure provisioning with AWS CloudFormation.
* Developed serverless cost-saving routines with AWS Lambda and Slack notifications.
* Hardened organizational access using IAM Identity Center and Permission Boundaries.
