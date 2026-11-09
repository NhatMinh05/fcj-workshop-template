---
title: "End-to-End Testing & Resource Cleanup"
date: 2024-01-01
weight: 6
chapter: false
pre: " <b> 5.6. </b> "
---

# 5.6 End-to-End Testing & Resource Cleanup

Congratulations on reaching the final module of the **CloudGuard AI** workshop series! In this capstone section, you will:
1. **Execute an End-to-End Validation Scenario** featuring an enterprise Terraform template injected with multiple real-world vulnerabilities.
2. **Verify the Integrated Lifecycle**: HCL parsing -> Bedrock RAG retrieval -> Claude 3.5 Sonnet reasoning -> Posture scoring -> Code auto-remediation -> DynamoDB persistence -> Emergency SNS email alert.
3. **Perform a Complete Resource Teardown (Clean up)** to guarantee you incur zero lingering charges on your AWS account.

---

### Step 1: Comprehensive End-to-End Test Scenario

We assemble a realistic Terraform script containing 4 catastrophic security misconfigurations:
1. **CIS-4.1 Violation**: Security Group opening SSH port 22 to `0.0.0.0/0`.
2. **CIS-2.1.1 Violation**: S3 bucket lacking server-side encryption (SSE).
3. **CIS-2.1.2 Violation**: S3 bucket lacking Public Access Block controls.
4. **CIS-1.16 Violation**: Overly permissive IAM policy with wildcard (`"Action": "*", "Resource": "*"`).

1. Create `vulnerable_infrastructure.tf`:
```hcl
# 1. Dangerous public SSH port 22 exposure
resource "aws_security_group" "bastion_host" {
  name        = "bastion-sg"
  description = "Public Bastion Host Security Group"
  vpc_id      = "vpc-0123456789abcdef0"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # CIS-4.1 VIOLATION
  }
}

# 2. Unencrypted, public-ready S3 Bucket
resource "aws_s3_bucket" "financial_reports" {
  bucket = "company-financial-reports-2026"
  # CIS-2.1.1 (No encryption) & CIS-2.1.2 (No Public Access Block)
}

# 3. Excessive IAM administrative policy
resource "aws_iam_policy" "dev_admin" {
  name        = "dev-admin-policy"
  description = "Excessive developer privileges"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "*" # CIS-1.16 VIOLATION
        Resource = "*"
      }
    ]
  })
}
```

2. Submit the payload to your CloudGuard API Gateway endpoint:
```bash
TF_CONTENT=$(cat vulnerable_infrastructure.tf | python -c "import json, sys; print(json.dumps(sys.stdin.read()))")

curl -X POST "https://${API_ID}.execute-api.${AWS_REGION}.amazonaws.com/scan" \
  -H "Content-Type: application/json" \
  -d "{"terraform_code": ${TF_CONTENT}}"
```

---

### Step 2: Analyze Audit Synthesis

The JSON response showcases contextual accuracy that far exceeds legacy static linters:

```json
{
  "scan_id": "9e24a1b8-6d20-410a-b271-93c4e0987114",
  "scanned_at": "2026-11-09T09:50:15Z",
  "score": 25,
  "summary": "CRITICAL RISK: Found 4 severe misconfigurations violating CIS AWS Foundations Benchmark v3.0. Deployment halted.",
  "findings": [
    {
      "rule_id": "CIS-4.1",
      "severity": "CRITICAL",
      "resource": "aws_security_group.bastion_host",
      "description": "Port 22 SSH is open to the public internet (0.0.0.0/0), exposing instance to brute-force credential stuffing.",
      "recommendation": "Restrict ingress to internal corporate CIDR (/16 or /24) or use AWS Systems Manager Session Manager."
    },
    {
      "rule_id": "CIS-1.16",
      "severity": "CRITICAL",
      "resource": "aws_iam_policy.dev_admin",
      "description": "IAM Policy grants full administrative privileges (*) across all resources, violating Principle of Least Privilege.",
      "recommendation": "Enumerate granular service actions and define specific ARNs in Resource block."
    },
    {
      "rule_id": "CIS-2.1.1",
      "severity": "HIGH",
      "resource": "aws_s3_bucket.financial_reports",
      "description": "Default server-side encryption is not enforced on the S3 bucket.",
      "recommendation": "Define aws_s3_bucket_server_side_encryption_configuration with AES256 or KMS."
    },
    {
      "rule_id": "CIS-2.1.2",
      "severity": "CRITICAL",
      "resource": "aws_s3_bucket.financial_reports",
      "description": "S3 Public Access Block configuration is missing, allowing potential public exposure of financial data.",
      "recommendation": "Attach aws_s3_bucket_public_access_block with all 4 guardrails enabled."
    }
  ],
  "remediated_code": "# REMEDIATED BY CLOUDGUARD AI (CLAUDE 3.5 SONNET)\n\nresource "aws_security_group" "bastion_host" {\n  name        = "bastion-sg"\n  description = "Secure Bastion Host Security Group"\n  vpc_id      = "vpc-0123456789abcdef0"\n\n  ingress {\n    from_port   = 22\n    to_port     = 22\n    protocol    = "tcp"\n    cidr_blocks = ["10.0.0.0/16"] # Fixed: restricted to internal VPC\n  }\n}\n\nresource "aws_s3_bucket" "financial_reports" {\n  bucket = "company-financial-reports-2026"\n}\n\nresource "aws_s3_bucket_server_side_encryption_configuration" "financial_reports_enc" {\n  bucket = aws_s3_bucket.financial_reports.id\n  rule {\n    apply_server_side_encryption_by_default {\n      sse_algorithm = "AES256"\n    }\n  }\n}\n\nresource "aws_s3_bucket_public_access_block" "financial_reports_pab" {\n  bucket                  = aws_s3_bucket.financial_reports.id\n  block_public_acls       = true\n  block_public_policy     = true\n  ignore_public_acls      = true\n  restrict_public_buckets = true\n}\n\nresource "aws_iam_policy" "dev_admin" {\n  name        = "dev-scoped-policy"\n  description = "Scoped developer permissions following Least Privilege"\n\n  policy = jsonencode({\n    Version = "2012-10-17"\n    Statement = [\n      {\n        Effect   = "Allow"\n        Action   = ["ec2:Describe*", "s3:ListBucket", "s3:GetObject"]\n        Resource = "*"\n      }\n    ]\n  })\n}"
}
```

3. **Verify Urgent Email Alert**:
   - Check the email inbox subscribed in Step 5.5: You will see the incoming alert with subject:
     `[URGENT] CloudGuard Security Violation Detected`
   - The body accurately reports the 25/100 score and enumerates discovered critical findings!

---

### Step 3: Complete Resource Teardown (Clean Up)

To eliminate any potential AWS billing after completing this educational project, execute the following teardown commands:

#### 1. Delete EventBridge Schedule:
```bash
aws scheduler delete-schedule --name "CloudGuard-DailyPosturedAudit" --region ${AWS_REGION}
```

#### 2. Delete Amazon API Gateway:
```bash
aws apigatewayv2 delete-api --api-id ${API_ID} --region ${AWS_REGION}
```

#### 3. Delete AWS Lambda Function & CloudWatch Log Group:
```bash
aws lambda delete-function --function-name cloudguard-core-audit-engine --region ${AWS_REGION}
aws logs delete-log-group --log-group-name "/aws/lambda/cloudguard-core-audit-engine" --region ${AWS_REGION}
```

#### 4. Delete Amazon Bedrock Knowledge Base & Vector Index:
- Open **Amazon Bedrock Console** -> **Knowledge bases**.
- Select `CloudGuard-CIS-KnowledgeBase` and click **Delete**.
- Navigate to **Amazon OpenSearch Service** -> **Serverless: Collections**, delete the collection provisioned during knowledge base setup.

#### 5. Delete Amazon DynamoDB Table:
```bash
aws dynamodb delete-table --table-name CloudGuard_ScanHistory --region ${AWS_REGION}
```

#### 6. Purge Objects & Delete S3 Bucket:
```bash
aws s3 rm s3://cloudguard-audit-data-${AWS_ACCOUNT_ID} --recursive
aws s3 rb s3://cloudguard-audit-data-${AWS_ACCOUNT_ID} --force --region ${AWS_REGION}
```

#### 7. Delete Amazon SNS Topic:
```bash
aws sns delete-topic --topic-arn ${SNS_TOPIC_ARN} --region ${AWS_REGION}
```

#### 8. Delete IAM Roles & Policies:
```bash
aws iam delete-role-policy --role-name CloudGuard_Lambda_ExecutionRole --policy-name CloudGuard_Core_Policy
aws iam delete-role --role-name CloudGuard_Lambda_ExecutionRole

aws iam delete-role-policy --role-name CloudGuard_Scheduler_Role --policy-name InvokeLambdaPolicy
aws iam delete-role --role-name CloudGuard_Scheduler_Role
```

---

### Workshop Summary

Congratulations on successfully building **CloudGuard AI**!

Through this hands-on workshop, you have mastered mission-critical skills at the intersection of Cloud Engineering, Generative AI, and DevSecOps:
- **Production GenAI & RAG Engineering**: Structuring regulatory standards into high-dimension vector stores and guiding Claude 3.5 Sonnet to perform deterministic compliance reasoning without hallucination.
- **Shift-Left Security Philosophy**: Preventing misconfigurations before deployment by auditing IaC templates early in development cycles.
- **Event-Driven Serverless Mastery**: Architecting an automated, zero-idle-cost auditing pipeline compliant with the AWS Well-Architected Framework.