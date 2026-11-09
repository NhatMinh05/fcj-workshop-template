---
title: "Workshop Overview & Architecture"
date: 2024-01-01
weight: 1
chapter: false
pre: " <b> 5.1. </b> "
---

# 5.1 Workshop Overview & Solution Architecture

### 1. Real-World Context & Problem Statement

As organizations accelerate their migration to cloud infrastructure (**Cloud Migration**), engineering teams heavily rely on **Infrastructure as Code (IaC)** – predominantly **Terraform (HCL)** – to automate continuous provisioning. While IaC accelerates development velocity, it simultaneously introduces widespread security risks when configuration errors (**Misconfigurations**) are deployed unnoticed.

Industry cybersecurity telemetry reveals:
- Over **80% of enterprise cloud data breaches** originate from basic human misconfigurations (such as public SSH Port 22 exposure to `0.0.0.0/0`, publicly accessible S3 buckets, and unencrypted data volumes).
- Remediating security vulnerabilities post-deployment in production environments costs up to **30x more** than resolving them during the initial authoring phase (the core philosophy of **Shift-Left Security**).
- Traditional static application security testing (SAST) tools (e.g., Checkov, tfsec) rely on rigid regex rules, produce excessive **False Positives**, lack contextual understanding of interconnected cloud resources, and cannot generate automated remediation code for developers.

**CloudGuard AI** solves these limitations by combining the multi-step reasoning capabilities of **Amazon Bedrock (Anthropic Claude 3.5 Sonnet)** with the definitive compliance standards of the **CIS AWS Foundations Benchmark v3.0** through advanced **Retrieval-Augmented Generation (RAG)**.

---

### 2. Solution Architecture

CloudGuard AI is built strictly according to the **AWS Well-Architected Framework**, operating as a 100% event-driven serverless architecture that ensures continuous high availability, defense-in-depth security, and near-zero idle operating costs.

Below is the official solution architecture diagram:

![CloudGuard AI Official Architecture Diagram](https://nhatminh05.github.io/fcj-workshop-template/images/2-Proposal/cloudguard_architecture.jpg)

---

### 3. Architecture Layers Breakdown

The system is logically structured into 6 decoupled functional layers:

1. **Global Services & Edge Security Layer**:
   - **AWS WAF**: Enforces managed Web ACL rules blocking DDoS, volumetric scraping, and SQLi/XSS at the AWS network edge.
   - **AWS IAM**: Enforces least-privilege role-based access control (RBAC) execution roles for AWS Lambda and the Bedrock Agent.
   - **Amazon CloudFront**: Global CDN delivering low-latency distribution with edge SSL/TLS certificates managed via **AWS Certificate Manager (ACM)** in `us-east-1`.
   - **Amazon Cognito**: User Pools authenticating DevOps engineers via cryptographically signed JSON Web Tokens (JWT) protecting API endpoints.

2. **API & Configuration Layer**:
   - **Amazon API Gateway (HTTP API)**: High-throughput ingestion entry point for scan requests (`POST /scan`) and audit history queries (`GET /history`), equipped with built-in JWT authorizers and rate limiting.
   - **AWS Systems Manager (SSM) Parameter Store**: Encrypted centralized repository storing operational parameters, Bedrock Knowledge Base IDs, and notification webhooks.
   - **AWS ACM (ap-southeast-1)**: Regional SSL/TLS certificate management for regional API Gateway custom domains.

3. **Compute & Scheduling Layer**:
   - **AWS Lambda (Core Audit Engine)**: The primary serverless execution engine running Python 3.12, orchestrating AST parsing of Terraform files, Bedrock RAG querying, posture scoring, and JSON response formatting.
   - **AWS Amplify**: Full-stack hosting and delivery platform for the modern React/Next.js dashboard where users paste code and inspect visual scorecards.
   - **Amazon EventBridge Scheduler**: Serverless cron orchestrator invoking Lambda on a recurring daily cadence to assess running infrastructure states.

4. **Data & Storage Layer**:
   - **Amazon S3**: Secure object storage hosting CIS Benchmark v3.0 regulatory PDFs, raw sample Terraform templates, and generated PDF compliance reports.
   - **Amazon DynamoDB**: Single-digit millisecond latency NoSQL database storing audit sessions, posture scores, and granular finding records.
   - **Amazon SES**: Automated transactional email engine delivering scheduled audit summaries and executive posture reports.

5. **GenAI & RAG Brain Layer**:
   - **Amazon Bedrock Agent**: Intelligent reasoning agent powered by **Anthropic Claude 3.5 Sonnet**, conducting multi-step logical deduction, resource correlation, and precise Terraform code remediation.
   - **Bedrock Knowledge Bases (RAG)**: Uses **Amazon Titan Text Embeddings V2** coupled with a high-performance vector store to ingest, chunk, and semantically retrieve relevant CIS Benchmark sections.
   - **Bedrock Guardrails**: AI safety perimeter preventing prompt injection attacks, enforcing responsible AI boundaries, and masking credentials (AWS keys, passwords, JWTs) and Personally Identifiable Information (PII).

6. **Monitoring & Alerting Layer**:
   - **Amazon CloudWatch**: Centralized observability platform collecting Lambda execution logs, Bedrock token consumption, and operational health metrics.
   - **Amazon SNS**: Real-time pub/sub notification service dispatching immediate critical alerts to administrator channels (Slack, SMS, Email) upon detecting **CRITICAL** severity vulnerabilities.

---

### 4. End-to-End Operational Lifecycle

```
[Developer / CI-CD] --(1. Send Terraform code)--> [API Gateway / CloudFront]
                                                          |
                                              (2. Trigger Lambda Invoke)
                                                          v
                                               [AWS Lambda Core Engine]
                                                 |                   |
                       (3. Query CIS rules via RAG) |              | (5. Save history)
                                                 v                   v
                                        [Bedrock RAG Engine]    [DynamoDB Table]
                                                 |                   |
                                 (4. Claude 3.5 Sonnet Reasoning)    | (6. Alert if CRITICAL)
                                                 v                   v
                                        [Auto-Fix Code & Score]  [Amazon SNS / Email]
```

1. **Step 1 (Submission)**: Developers paste Terraform code into the web UI or external CI/CD pipelines (GitHub Actions) dispatch a webhook payload to API Gateway (`POST /scan`).
2. **Step 2 (Decomposition)**: The Lambda Core Engine parses the HCL syntax to isolate security-sensitive resource definitions (Security Group rules, S3 bucket encryption, IAM policies).
3. **Step 3 (RAG Retrieval)**: Lambda constructs a semantic search query against the Bedrock Knowledge Base to retrieve governing CIS Benchmark clauses.
4. **Step 4 (AI Reasoning & Auto-Fix)**: Claude 3.5 Sonnet evaluates the code against retrieved standards, assigns severity levels (CRITICAL / HIGH / MEDIUM / LOW), computes an aggregate compliance score (0-100), and synthesizes remediated Terraform code.
5. **Step 5 (Persistence & Escalation)**: Findings are persisted in DynamoDB; if the score is below 70 or CRITICAL flaws are discovered, an emergency SNS notification is dispatched.

---

### 5. Workshop Specifications

- **Estimated Duration**: ~90 minutes
- **Difficulty Level**: Intermediate
- **Recommended AWS Regions**: `ap-southeast-1` (Singapore) or `us-east-1` (N. Virginia)
- **Estimated Cost**: **$0.00 USD** (Fully compliant with the **AWS Free Tier** and Bedrock trial allocations).