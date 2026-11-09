---
title: "Building RAG Knowledge Base with CIS Benchmark"
date: 2024-01-01
weight: 3
chapter: false
pre: " <b> 5.3. </b> "
---

# 5.3 Building RAG Knowledge Base with CIS Benchmark

The foundational breakthrough of **CloudGuard AI** over traditional regex-based static scanners lies in **Retrieval-Augmented Generation (RAG)**. Instead of permitting the LLM to hallucinate rules based on generic pre-training, we anchor its reasoning directly to the authoritative industry benchmark: **CIS AWS Foundations Benchmark v3.0**.

In this hands-on section, you will format benchmark rules, upload them to Amazon S3, and provision an **Amazon Bedrock Knowledge Base** vector-indexed by **Amazon Titan Text Embeddings V2**.

---

### Step 1: Prepare the Structured CIS Benchmark Dataset

We construct a clean, semantically structured text file containing critical regulatory rules from the CIS AWS Foundations Benchmark v3.0.

1. Create `cis_v3_benchmark_rules.txt` in your local directory or CloudShell:
```markdown
# CIS AWS FOUNDATIONS BENCHMARK V3.0 SECURITY SPECIFICATIONS

## SECTION 1: IDENTITY AND ACCESS MANAGEMENT (IAM)
### RULE CIS-1.16: Ensure IAM Policies Do Not Permit Full Administrative Privileges (*)
- Severity: CRITICAL
- Impact: Grants unauthorized entity total control over AWS infrastructure.
- Recommendation: Restrict permissions to specific actions and resources required for job duties. Avoid "Action": "*" and "Resource": "*".
- Terraform Fix Pattern:
  Avoid:
    Statement = [{ Action = "*", Resource = "*", Effect = "Allow" }]
  Enforce:
    Statement = [{ Action = ["s3:GetObject", "s3:PutObject"], Resource = "arn:aws:s3:::specific-bucket/*", Effect = "Allow" }]

## SECTION 2: STORAGE & AMAZON S3
### RULE CIS-2.1.1: Ensure S3 Bucket Has Default Encryption Enabled
- Severity: HIGH
- Impact: Unencrypted stored objects are susceptible to data exfiltration and compliance failure (HIPAA, PCI-DSS).
- Recommendation: Configure server-side encryption with SSE-S3 (AES256) or AWS KMS customer-managed keys (aws:kms).
- Terraform Fix Pattern:
  resource "aws_s3_bucket_server_side_encryption_configuration" "good" {
    bucket = aws_s3_bucket.target.id
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

### RULE CIS-2.1.2: Ensure S3 Bucket Has Public Access Block Configured
- Severity: CRITICAL
- Impact: Public buckets lead to catastrophic data leaks over the public internet.
- Recommendation: Enable block_public_acls, block_public_policy, ignore_public_acls, and restrict_public_buckets.
- Terraform Fix Pattern:
  resource "aws_s3_bucket_public_access_block" "good" {
    bucket                  = aws_s3_bucket.target.id
    block_public_acls       = true
    block_public_policy     = true
    ignore_public_acls      = true
    restrict_public_buckets = true
  }

## SECTION 4: NETWORKING & SECURITY GROUPS
### RULE CIS-4.1: Ensure No Security Group Allows Unrestricted Ingress to Port 22 (SSH)
- Severity: CRITICAL
- Impact: Exposing SSH port 22 to 0.0.0.0/0 allows brute-force attacks and unauthorized server takeover.
- Recommendation: Restrict port 22 access strictly to designated corporate VPN IP ranges (/32 or /24) or utilize AWS Systems Manager Session Manager (SSM) without open inbound ports.
- Terraform Fix Pattern:
  Avoid:
    cidr_blocks = ["0.0.0.0/0"]
  Enforce:
    cidr_blocks = ["10.0.0.0/16"] # Internal VPC or VPN gateway only

### RULE CIS-4.2: Ensure No Security Group Allows Unrestricted Ingress to Port 3389 (RDP)
- Severity: CRITICAL
- Impact: Exposing Windows RDP port 3389 to public CIDR ranges exposes workloads to ransomware and credential compromise.
- Recommendation: Restrict port 3389 inbound access to corporate bastion hosts or VPN CIDRs.

### RULE CIS-4.3: Ensure Database Ports (3306 MySQL, 5432 PostgreSQL) Are Not Open to 0.0.0.0/0
- Severity: HIGH
- Impact: Direct public internet exposure of databases enables automated injection and credential stuffing attacks.
- Recommendation: Database security groups must only accept traffic from application layer security groups.
```

2. Confirm the line count of the created file:
```bash
wc -l cis_v3_benchmark_rules.txt
```

---

### Step 2: Upload Dataset to Amazon S3

Sync the rules file into the `knowledge-base/` prefix in the S3 bucket created previously:

```bash
aws s3 cp cis_v3_benchmark_rules.txt s3://cloudguard-audit-data-${AWS_ACCOUNT_ID}/knowledge-base/
```

Verify successful upload:
```bash
aws s3 ls s3://cloudguard-audit-data-${AWS_ACCOUNT_ID}/knowledge-base/
```

---

### Step 3: Create Amazon Bedrock Knowledge Base

We now bind the S3 source into a **Bedrock Knowledge Base**:

1. Open the **AWS Management Console** and navigate to **Amazon Bedrock**.
2. In the left navigation bar, choose **Knowledge bases** (under **Builder tools**).
3. Click **Create knowledge base**.
4. **Step 1 - Provide knowledge base details**:
   - **Knowledge base name**: Enter `CloudGuard-CIS-KnowledgeBase`.
   - **Description**: `Authoritative repository of CIS AWS Foundations Benchmark v3.0 rules for automated IaC security audits.`
   - **IAM Permissions**: Select **Create and use a new service role**.
   - Click **Next**.
5. **Step 2 - Configure data source**:
   - **Data source name**: `cis-benchmark-s3-source`.
   - **S3 URI**: Click **Browse S3** and select `s3://cloudguard-audit-data-[account-id]/knowledge-base/`.
   - Leave chunking strategies at **Default chunking** (300 tokens, 20% overlap).
   - Click **Next**.
6. **Step 3 - Select embeddings model and configure vector store**:
   - **Embeddings model**: Choose **Titan Text Embeddings V2** (`amazon.titan-embed-text-v2:0`) with 1,024 dimensions.
   - **Vector database**: Select **Quick create a new vector store** (Amazon Bedrock automatically orchestrates an **Amazon OpenSearch Serverless** vector collection).
   - Click **Next**.
7. **Step 4 - Review and create**:
   - Review all specifications and click **Create knowledge base**.
   - OpenSearch Serverless collection provisioning takes approximately 3-5 minutes.

---

### Step 4: Synchronize Data Source (Data Ingestion)

Once the Knowledge Base status transitions to active:

1. Scroll down to the **Data source** table.
2. Select `cis-benchmark-s3-source`.
3. Click the **Sync** button.
4. The ingestion pipeline reads `cis_v3_benchmark_rules.txt`, applies chunking, invokes Titan Text Embeddings V2 to generate mathematical vectors, and indexes them into OpenSearch Serverless.
5. In 1-2 minutes, the status updates to green: **Complete**.

Copy the **Knowledge Base ID** (e.g., `AB1CDE2FGH`) shown under the knowledge base header; this identifier is required for the Lambda function configuration in the next step!

---

### Step 5: Test Semantic Retrieval in the Bedrock Console

Amazon Bedrock provides a built-in interactive **Test knowledge base** panel:

1. On the right test drawer, under **Select model**, choose **Anthropic Claude 3.5 Sonnet**.
2. Enter the test prompt:
   > *"What is the CIS Benchmark severity and Terraform remediation for Security Group SSH port 22 open to 0.0.0.0/0?"*
3. Click **Run**.
4. Observe the synthesized answer:
   - Identifies rule **CIS-4.1** with **CRITICAL** severity.
   - Provides clean remediated code (`cidr_blocks = ["10.0.0.0/16"]`).
   - Click on **Citations** to verify that the answer references the exact chunk extracted from `cis_v3_benchmark_rules.txt`.

Our RAG system is verified and production-ready. Next, we build the **AWS Lambda Core Audit Engine** to expose this intelligence over an automated API!