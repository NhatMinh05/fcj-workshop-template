---
title: "Blog 2"
date: 2024-01-01
weight: 2
chapter: false
pre: " <b> 3.2. </b> "
---

# CLOUDGUARD AI: AUTOMATED AWS INFRASTRUCTURE SECURITY & COST AUDITOR USING GENAI & RAG ON AMAZON BEDROCK

In modern Cloud and DevOps workflows, managing cloud environments using Infrastructure as Code (IaC) templates such as Terraform and CloudFormation has become industry standard. However, manual security reviews and cost optimization audits are notoriously time-consuming and prone to human oversight, often leaving critical misconfigurations undetected — such as wide-open SSH port 22 (`0.0.0.0/0`), unencrypted S3 buckets, or wildcard IAM policies (`*`).

To address this challenge, **CloudGuard AI** was designed as an enterprise-grade Serverless solution powered by Generative AI and Retrieval-Augmented Generation (RAG) on **Amazon Bedrock**.

### Core Architecture Components:

* **Amazon Bedrock (Claude 3.5 Sonnet & Titan Text Embeddings V2):** Serves as the intelligent AI reasoning engine, parsing Terraform HCL code structures, detecting compliance violations, and generating remediation code snippets.
* **Bedrock Knowledge Bases & OpenSearch Serverless:** Anchors the RAG context strictly to international security standards — **CIS AWS Foundations Benchmark v3.0**, eliminating hallucinations and ensuring every audit finding cites specific benchmark recommendations.
* **AWS Lambda (Python 3.12) & Amazon API Gateway (HTTP API):** Executes serverless syntax extraction and audit orchestration in under 10 seconds, delivering high throughput at ultra-low cost ($1/million requests).
* **Amazon DynamoDB & Amazon S3:** Securely stores scan session history, compliance scorecards, and audit report archives.
* **EventBridge Scheduler & Amazon SNS:** Triggers automated daily compliance scans and broadcasts instant emergency email alerts whenever high-severity vulnerabilities are detected.
* **Perimeter Defense & Distribution:** Secured with AWS WAF attached at the CloudFront Edge, user identity managed by Amazon Cognito, and secrets stored in SSM Parameter Store.

### Key Innovations & Practical Value:

* **Shift-Left Security:** Integrates seamlessly into CI/CD pipelines via Webhooks, intercepting misconfigurations at the Pull Request stage before any resource is provisioned into production environments.
* **Superior Cost Optimization:** Built on a 100% Serverless pay-as-you-go architecture, maintaining $0 idle operating cost and totaling just ~$11–15/month for continuous 24/7 enterprise operations (saving $100–$200/month compared to dedicated EC2 GPU instances).
* **Automated Code Remediation:** Beyond reporting violations, CloudGuard AI generates production-ready Terraform correction blocks that developers can merge immediately.

### Practical Engineering Considerations:

* Enforce a low temperature (`temperature = 0.1`) on Bedrock to ensure deterministic compliance scoring and repeatable audit reports.
* Route traffic securely over TLS between Lambda and internal AWS service endpoints, eliminating NAT Gateway requirements and saving ~$32/month.
* Manage secrets and model fallback identifiers inside SSM Parameter Store to prevent hard-coding credentials into application logic.

![CloudGuard AI Architecture Diagram](https://nhatminh05.github.io/fcj-workshop-template/images/3-BlogsPosted/3.2-Blog2/CloudGuardAIArchitecture.jpg)

[Link to the original post](https://www.facebook.com/groups/awsstudygroupfcj/permalink/2330331201065172/)
