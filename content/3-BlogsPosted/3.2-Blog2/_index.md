---
title: "Blog 2"
date: 2024-01-01
weight: 2
chapter: false
pre: " <b> 3.2. </b> "
---

# AUTOMATING AWS INFRASTRUCTURE SECURITY AUDIT & COST OPTIMIZATION WITH GENAI & RAG ON AMAZON BEDROCK

In modern DevOps workflows, managing cloud environments using Infrastructure as Code (IaC such as Terraform and CloudFormation) has become standard practice. However, manual security reviews and cost optimization audits before deployment are time-consuming and often miss dangerous misconfigurations, such as opening SSH port 22 to the public internet (0.0.0.0/0), unencrypted S3 buckets, or wildcard IAM permissions (*).

To address this challenge via Shift-Left Security, CloudGuard AI combines Generative AI and RAG on Amazon Bedrock.

Core architecture components:
* Amazon Bedrock (Claude 3.5 Sonnet & Titan Text Embeddings V2): parses Terraform HCL code structures, identifies vulnerabilities, and automatically generates remediation code
* Bedrock Knowledge Bases & OpenSearch Serverless: anchors RAG context to CIS AWS Foundations Benchmark v3.0, eliminating hallucinations
* AWS Lambda & Amazon API Gateway (HTTP API): serverless orchestration and audit execution in under 10 seconds at low cost ($1/million requests)
* Amazon DynamoDB & Amazon S3: stores scan history, compliance scores, and infrastructure templates
* EventBridge Scheduler & Amazon SNS: daily scheduled scans and instant emergency alerts for high-severity violations
* AWS WAF, Amazon Cognito & SSM Parameter Store: edge protection, user authentication, and secure secrets management

Architecture highlights:
* Shift-Left Security: scans directly from CI/CD pipelines via Webhooks, catching issues at the Pull Request stage
* Cost optimization (FinOps): 100% serverless, zero idle compute cost, total continuous 24/7 enterprise cost around $11–15/month (saving $100–$200/month vs dedicated EC2 GPU instances)
* NAT Gateway elimination: Lambda connects to internal AWS services over TLS, saving $32/month

Implementation notes:
* Set low temperature (0.1) on Bedrock for consistent compliance scoring
* Anchor Knowledge Bases to official benchmark versions for accurate regulatory citations
* Store secrets and model identifiers in SSM Parameter Store for secure configuration

![CloudGuard AI Architecture Diagram](https://nhatminh05.github.io/fcj-workshop-template/images/3-BlogsPosted/3.2-Blog2/CloudGuardAIArchitecture.jpg)

[Link to the original post](https://www.facebook.com/groups/awsstudygroupfcj/permalink/2330331201065172/)
