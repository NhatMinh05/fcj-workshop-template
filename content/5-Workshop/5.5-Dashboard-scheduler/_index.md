---
title: "Deploying Dashboard & Automated Scheduler"
date: 2024-01-01
weight: 5
chapter: false
pre: " <b> 5.5. </b> "
---

# 5.5 Deploying Dashboard & Automated Scheduler

An enterprise security platform cannot remain confined to terminal command lines. To empower DevOps engineers and security stakeholders, **CloudGuard AI** provides:
1. An **interactive Web Dashboard** (built on React / Next.js and deployed via **AWS Amplify**).
2. A **Serverless Scheduled Automation** system using **Amazon EventBridge Scheduler** for hands-free daily posture reviews.
3. An **emergency alerting pipeline** powered by **Amazon SNS** dispatching alerts when **CRITICAL** severity vulnerabilities are discovered.

---

### Step 1: Web Dashboard Architecture

The CloudGuard AI interface is designed with a modern, high-contrast, security-focused aesthetic:

```
+-----------------------------------------------------------------------------------+
|  🛡️ CloudGuard AI - DevSecOps & FinOps Posture Dashboard                         |
+-----------------------------------------------------------------------------------+
|  [ Paste Terraform Code Here ]                                                    |
|  resource "aws_security_group" "web" { ... }                                      |
|                                                                                   |
|  [ ⚡ Run Security & Cost Audit Now ]                                             |
+-----------------------------------------+-----------------------------------------+
|  📊 COMPLIANCE SCORE:                   |  🚨 DETECTED VIOLATIONS (2):            |
|     [ 45 / 100 ] (POOR - CRITICAL)      |  • CIS-4.1 [CRITICAL] SSH Port 22 Open  |
|                                         |  • CIS-2.1.1 [HIGH] S3 Unencrypted      |
+-----------------------------------------+-----------------------------------------+
|  ✨ REMEDIATED CODE (READY TO DEPLOY):                                            |
|  resource "aws_security_group" "web" {                                            |
|    cidr_blocks = ["10.0.0.0/16"]  # Fixed by Claude 3.5 Sonnet                     |
|  }                                                                                |
|  [ 📋 Copy Remediated Code ]                                                      |
+-----------------------------------------------------------------------------------+
```

#### Core UI Components:
1. **Code Editor Input**: Clean input area for pasting `main.tf`, `security.tf`, and `iam.tf` templates.
2. **Security Gauge Visualizer**: Calibrated posture score wheel:
   - **Red (0 - 49)**: Unacceptable risk posture, immediate blocker for deployment.
   - **Amber (50 - 79)**: Moderate risks present, remediation recommended before production merge.
   - **Green (80 - 100)**: Compliant with CIS Benchmark standards, approved for release.
3. **Findings Accordion**: Granular issue breakdown tagged with severity badges (**CRITICAL**, **HIGH**, **MEDIUM**, **LOW**), linking specific offending lines to governing CIS clauses.
4. **Auto-Remediation Diff Viewer**: Displays clean, syntactically valid remediated Terraform code with a single-click copy action.

---

### Step 2: Configure Recurring Scans via Amazon EventBridge Scheduler

To ensure running infrastructure does not drift into an insecure state, we configure **Amazon EventBridge Scheduler** to invoke our Lambda engine at 1:00 AM daily.

1. Create the trust policy granting EventBridge Scheduler execution permissions (`scheduler-trust-policy.json`):
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "scheduler.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
```

2. Create the IAM Role `CloudGuard_Scheduler_Role`:
```bash
aws iam create-role \
    --role-name CloudGuard_Scheduler_Role \
    --assume-role-policy-document file://scheduler-trust-policy.json
```

3. Attach the inline invocation policy:
```bash
aws iam put-role-policy \
    --role-name CloudGuard_Scheduler_Role \
    --policy-name InvokeLambdaPolicy \
    --policy-document "{
        \"Version\": \"2012-10-17\",
        \"Statement\": [
            {
                \"Effect\": \"Allow\",
                \"Action\": \"lambda:InvokeFunction\",
                \"Resource\": \"${LAMBDA_ARN}\"
            }
        ]
    }"
```

4. Create the recurring schedule:
```bash
aws scheduler create-schedule \
    --name "CloudGuard-DailyPosturedAudit" \
    --schedule-expression "cron(0 1 * * ? *)" \
    --flexible-time-window '{"Mode": "OFF"}' \
    --target "{
        \"Arn\": \"${LAMBDA_ARN}\",
        \"RoleArn\": \"arn:aws:iam::${AWS_ACCOUNT_ID}:role/CloudGuard_Scheduler_Role\",
        \"Input\": \"{\\\"terraform_code\\\": \\\"resource \\\\\"aws_security_group\\\\\" \\\\\"default\\\\\" { ingress { from_port = 22 to_port = 22 protocol = \\\\\"tcp\\\\\" cidr_blocks = [\\\\\"0.0.0.0/0\\\\\"] } }\\\"}\"
    }" \
    --region ${AWS_REGION}
```

Verify schedule creation:
```bash
aws scheduler get-schedule --name "CloudGuard-DailyPosturedAudit" --region ${AWS_REGION}
```

---

### Step 3: Configure Amazon SNS for Real-Time Escalation

When lethal misconfigurations are identified (unrestricted database ports, wildcard IAM permissions), the system broadcasts urgent notifications via **Amazon SNS**.

1. Create the SNS topic:
```bash
SNS_TOPIC_ARN=$(aws sns create-topic \
    --name cloudguard-critical-alerts \
    --query "TopicArn" \
    --output text \
    --region ${AWS_REGION})

echo "SNS Topic ARN: ${SNS_TOPIC_ARN}"
```

2. Subscribe an administrative email address:
```bash
aws sns subscribe \
    --topic-arn ${SNS_TOPIC_ARN} \
    --protocol email \
    --notification-endpoint "your-email@example.com" \
    --region ${AWS_REGION}
```
*(Check your inbox and click the **Confirm subscription** link).*

3. Update the Lambda logic to publish critical alerts:
```python
has_critical = any(f.get('severity') == 'CRITICAL' for f in audit_result.get('findings', []))

if has_critical or audit_result.get('score', 100) < 70:
    sns_client = boto3.client('sns', region_name=os.environ.get('AWS_REGION', 'ap-southeast-1'))
    sns_topic_arn = os.environ.get('SNS_TOPIC_ARN')
    if sns_topic_arn:
        alert_message = (
            f"🚨 [CloudGuard AI ALERT] CRITICAL Misconfiguration Detected!\n"
            f"Scan ID: {scan_id}\n"
            f"Posture Score: {audit_result.get('score')}/100\n"
            f"Summary: {audit_result.get('summary')}\n\n"
            f"Please review the audit findings immediately on CloudGuard Dashboard."
        )
        sns_client.publish(
            TopicArn=sns_topic_arn,
            Subject="[URGENT] CloudGuard Security Violation Detected",
            Message=alert_message
        )
```

Update the Lambda environment variables:
```bash
aws lambda update-function-configuration \
    --function-name cloudguard-core-audit-engine \
    --environment "Variables={KNOWLEDGE_BASE_ID=${KNOWLEDGE_BASE_ID},DYNAMODB_TABLE=CloudGuard_ScanHistory,SNS_TOPIC_ARN=${SNS_TOPIC_ARN},AWS_REGION=${AWS_REGION}}" \
    --region ${AWS_REGION}
```

We now possess an integrated ecosystem: Visual Dashboard, Scheduled Cron Audit, and Instantaneous SNS Notification. In the final module, we conduct **End-to-End Validation and Execute Clean Resource Teardown**!