---
title: "Prerequisites & IAM Configuration"
date: 2024-01-01
weight: 2
chapter: false
pre: " <b> 5.2. </b> "
---

# 5.2 Prerequisites & IAM Configuration

Before constructing the core components of CloudGuard AI, you must prepare your AWS account environment, activate Foundation Model access in **Amazon Bedrock**, and provision supporting serverless resources (Amazon S3, DynamoDB, and IAM Roles).

---

### Step 1: Verify AWS Account & Configure AWS CLI

You can complete this lab directly using **AWS CloudShell** (the integrated browser-based shell on the AWS Management Console) or via a local terminal configured with **AWS CLI v2**.

1. Verify your authenticated AWS identity:
```bash
aws sts get-caller-identity
```

Expected output:
```json
{
    "UserId": "AIDASAMPLEUSERIDEXAMPLE",
    "Account": "123456789012",
    "Arn": "arn:aws:iam::123456789012:user/devops-admin"
}
```

2. Note your 12-digit **AWS Account ID** (e.g., `123456789012`), as it is required to formulate globally unique S3 bucket names.

3. Export environment variables for the deployment region (prefer `ap-southeast-1` Singapore or `us-east-1` N. Virginia for comprehensive Bedrock model availability):
```bash
export AWS_REGION="ap-southeast-1"
export AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
```

---

### Step 2: Request Foundation Model Access in Amazon Bedrock

Amazon Bedrock enforces an explicit opt-in model before API access is granted for foundation models.

1. Navigate to the **AWS Management Console** and select **Amazon Bedrock**.
2. In the left navigation pane, scroll to **Bedrock configurations** and click **Model access**.
3. Select **Modify model access** (or **Enable specific models**).
4. Check the following two essential models:
   - **Anthropic**: `Claude 3.5 Sonnet` (or `Claude 3 Sonnet`).
   - **Amazon**: `Titan Text Embeddings V2`.
5. Click **Next**, review and accept the End User License Agreements (EULA), then click **Submit**.
6. Wait 1-2 minutes until the **Access status** for both models displays green: **Access granted**.

---

### Step 3: Create Amazon S3 Bucket for CIS Benchmark Knowledge Assets

Amazon S3 acts as the authoritative **Data Source** container for the Bedrock Knowledge Base.

1. Create a new globally unique S3 bucket:
```bash
aws s3 mb s3://cloudguard-audit-data-${AWS_ACCOUNT_ID} --region ${AWS_REGION}
```

2. Enable **Block Public Access** to guarantee complete data confidentiality:
```bash
aws s3api put-public-access-block \
    --bucket cloudguard-audit-data-${AWS_ACCOUNT_ID} \
    --public-access-block-configuration "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true"
```

3. Enable default Server-Side Encryption (**SSE-S3**):
```bash
aws s3api put-bucket-encryption \
    --bucket cloudguard-audit-data-${AWS_ACCOUNT_ID} \
    --server-side-encryption-configuration '{"Rules": [{"ApplyServerSideEncryptionByDefault": {"SSEAlgorithm": "AES256"}}]}'
```

4. Create the `knowledge-base/` prefix inside the bucket to organize CIS Benchmark rule files:
```bash
aws s3api put-object --bucket cloudguard-audit-data-${AWS_ACCOUNT_ID} --key knowledge-base/
```

---

### Step 4: Create Amazon DynamoDB Table for Audit Histories

The platform persists all audit findings (timestamp, compliance posture score, identified vulnerabilities, and remediated code). We use **Amazon DynamoDB** in **On-Demand (Pay-Per-Request)** mode to incur zero idle cost.

1. Provision the `CloudGuard_ScanHistory` table with `scan_id` as the Partition Key:
```bash
aws dynamodb create-table \
    --table-name CloudGuard_ScanHistory \
    --attribute-definitions AttributeName=scan_id,AttributeType=S \
    --key-schema AttributeName=scan_id,KeyType=HASH \
    --billing-mode PAY_PER_REQUEST \
    --region ${AWS_REGION}
```

2. Verify that the table status transitions to `ACTIVE`:
```bash
aws dynamodb describe-table \
    --table-name CloudGuard_ScanHistory \
    --query "Table.TableStatus" \
    --output text
```

---

### Step 5: Provision IAM Execution Role for AWS Lambda

The Lambda Core Audit Engine requires least-privilege permissions to query Bedrock RAG, access S3 objects, read/write DynamoDB records, and stream CloudWatch Logs.

1. Create the trust policy document allowing Lambda execution (`lambda-trust-policy.json`):
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
```

2. Create the IAM Role `CloudGuard_Lambda_ExecutionRole`:
```bash
aws iam create-role \
    --role-name CloudGuard_Lambda_ExecutionRole \
    --assume-role-policy-document file://lambda-trust-policy.json
```

3. Define the granular inline permissions policy (`lambda-permissions-policy.json`):
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "BedrockInvokePermissions",
      "Effect": "Allow",
      "Action": [
        "bedrock:InvokeModel",
        "bedrock:Retrieve",
        "bedrock:RetrieveAndGenerate"
      ],
      "Resource": "*"
    },
    {
      "Sid": "S3BucketAccess",
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:PutObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::cloudguard-audit-data-*",
        "arn:aws:s3:::cloudguard-audit-data-*/*"
      ]
    },
    {
      "Sid": "DynamoDBReadWrite",
      "Effect": "Allow",
      "Action": [
        "dynamodb:PutItem",
        "dynamodb:GetItem",
        "dynamodb:Query",
        "dynamodb:Scan"
      ],
      "Resource": "arn:aws:dynamodb:*:*:table/CloudGuard_ScanHistory"
    },
    {
      "Sid": "CloudWatchLogs",
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*"
    },
    {
      "Sid": "SNSPublish",
      "Effect": "Allow",
      "Action": [
        "sns:Publish"
      ],
      "Resource": "*"
    }
  ]
}
```

4. Attach the policy to the newly created role:
```bash
aws iam put-role-policy \
    --role-name CloudGuard_Lambda_ExecutionRole \
    --policy-name CloudGuard_Core_Policy \
    --policy-document file://lambda-permissions-policy.json
```

With initial environment prerequisites and IAM security boundaries established, we are ready to proceed to **Building the Bedrock Knowledge Base with CIS Benchmark v3.0**!