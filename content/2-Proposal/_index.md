---
title: "Proposal"
date: 2024-01-01
weight: 2
chapter: false
pre: " <b> 2. </b> "
---

# CloudGuard AI: Automated AWS Infrastructure Security & Cost Auditor
## GenAI & RAG-Powered Automated Security Compliance (CIS Benchmark v3.0) and Cloud Cost Optimization

### 1. Executive Summary
This project builds a complete cloud infrastructure security auditing and cost optimization platform (**DevSecOps & FinOps**), consisting of two decoupled applications: **Backend** — a serverless REST API built with Python 3.12 on AWS Lambda + API Gateway, orchestrating **Anthropic Claude 3.5 Sonnet** and **Retrieval-Augmented Generation (RAG)** via **Amazon Titan Text Embeddings V2** to parse Terraform HCL Abstract Syntax Trees (AST), cross-reference the **CIS AWS Foundations Benchmark v3.0**, calculate compliance posture scores (0–100), and generate automated remediation code — and **Frontend** — a Next.js SSR application built on React, featuring a bilingual vi/en UI, dark/light themes, a visual Security Gauge, severity-tagged finding accordions, and a side-by-side diff viewer with a one-click code copy action.

The goal of this workshop is to deploy the entire system onto AWS Serverless infrastructure (region ap-southeast-1): the Next.js SSR frontend runs on AWS Amplify, the Python core engine runs on Lambda + API Gateway, all behind CloudFront and secured by AWS WAF and Amazon Cognito — demonstrating the ability to apply AWS services to a real, end-to-end use case. Target customers are DevOps/Cloud Engineers requiring automated pre-merge security verification (Shift-Left Security), SecOps compliance officers auditing cloud postures, and FinOps administrators seeking cloud waste reduction.

### 2. Problem Statement
What’s the Problem?
- Infrastructure misconfigurations causing widespread data exposure: over 80% of cloud security incidents stem from human configuration errors (SSH port 22 open to `0.0.0.0/0`, unencrypted S3 storage, overly permissive wildcard IAM policies).
- Manual code reviews create release bottlenecks: manual line-by-line inspection takes 2–3 days, delaying sprint delivery.
- Traditional static analysis linters lack architectural context: regex-based linters (Checkov, tfsec) suffer from high false-positive rates, cannot interpret inter-resource relationships, and cannot rewrite compliant code.
- Generative AI hallucination risks: general-purpose LLMs hallucinate non-existent compliance clauses or produce deprecated Terraform syntax without grounding.
- Idle server costs: provisioning dedicated GPU-enabled EC2 instances wastes hundreds of dollars per month during inactive scanning windows.

The Solution
A serverless, pay-per-request, auto-scaling architecture: Python Core Engine runs on Lambda + API Gateway (HTTP API), Next.js SSR is hosted on AWS Amplify, and CloudFront (with an edge-attached WAF Web ACL) distributes assets and routes API requests. The RAG architecture in Bedrock Knowledge Base (Titan Text Embeddings V2 + Vector DB) anchors reasoning strictly to the CIS AWS Foundations Benchmark v3.0, eliminating hallucinations. Bedrock Agent (Claude 3.5 Sonnet) evaluates contextual risk, computes scores, and generates compliant remediation snippets. CloudWatch Logs/Metrics + Alarm + SNS provide centralized observability and instant admin escalation; WAF, IAM least-privilege, Cognito, and SSM Parameter Store enforce security; EventBridge Scheduler + Lambda handles daily automated posture scans.

Benefits and Return on Investment
The platform auto-scales on demand at a monthly operating cost of only ~$11–15/month — the serverless design eliminates 100% of idle costs (Zero Idle Cost), avoiding dedicated EC2/GPU instances and saving >95% compared to static infrastructure. It accelerates review cycles by 90% (from 2–3 days to <10 seconds), eliminates 100% of baseline misconfigurations pre-deployment, and the bilingual step-by-step workshop produced at the end serves as an enduring educational asset for the cloud engineering community.

### 3. Solution Architecture
User requests flow through CloudFront (WAF Web ACL attached at the edge) to two origins: Amplify (Next.js SSR frontend, Static/SSR flow) and API Gateway (HTTP API) → Lambda (Python Core Audit Engine, API Calls flow); Amplify also performs “SSR fetch” calls back to the API during server rendering. DevOps engineers authenticate via Amazon Cognito (JWT Auth). External CI/CD pipelines (GitHub/GitLab PR) dispatch automated webhook scan payloads to API Gateway. Lambda parses Terraform AST, queries CIS Benchmark v3.0 rules via Bedrock Knowledge Bases (RAG), prompts Claude 3.5 Sonnet, reads configuration from SSM Parameter Store, saves PDF summaries in S3 via Pre-signed URLs, writes audit records to DynamoDB, and dispatches email via SES. EventBridge Scheduler triggers a daily Lambda scan. CloudWatch aggregates logs/metrics; on threshold breach or CRITICAL finding, an Alarm publishes to SNS, alerting administrators via email. The architecture is detailed below:

![CloudGuard AI Official Architecture Diagram](https://nhatminh05.github.io/fcj-workshop-template/images/2-Proposal/cloudguard_architecture.jpg)

Note on WAF: WAF is not a standalone hop on the network path — the Web ACL is attached directly to the CloudFront distribution and evaluates requests at the edge location before CloudFront processes them. A Web ACL used with CloudFront must be created in the Global scope (us-east-1).

AWS Services Used
- AWS Lambda: Runs the Python 3.12 Core Audit Engine + cron jobs — serverless, 1M free requests/month, cold-start optimized.
- Amazon API Gateway (HTTP API): REST API front door — ~70% cheaper than REST API Gateway, native Lambda integration.
- AWS Amplify: Next.js SSR hosting with automated Git CI/CD.
- Amazon CloudFront: CDN serving static assets/SSR and API — global edge locations cut latency, attachment point for WAF Web ACL.
- Amazon Cognito: User directory management (User Pools) issuing cryptographically signed JWT tokens for DevOps access.
- Amazon Bedrock Agent: Intelligent reasoning agent powered by Anthropic Claude 3.5 Sonnet for multi-step policy deduction and code remediation.
- Amazon Bedrock Knowledge Bases (RAG): Semantic vector search engine indexing CIS Benchmark v3.0 using Amazon Titan Text Embeddings V2.
- Amazon Bedrock Guardrails: Enforces safety guardrails, blocking prompt injections and masking secrets (AWS keys, credentials, PII).
- Amazon S3: Object storage for CIS Benchmark standards, raw IaC templates, and compiled PDF reports via Pre-signed URLs; public access blocked.
- Amazon DynamoDB: Low-latency NoSQL database recording scan histories, compliance scores, and granular finding records.
- Amazon SES: Transactional email engine delivering audit summaries and executive posture reports.
- Amazon CloudWatch: Logs, metrics, and alarms integrated natively with Lambda and API Gateway.
- Amazon SNS: Real-time administrative alerting via direct email subscription upon CRITICAL findings.
- Amazon EventBridge Scheduler: Serverless cron trigger executing daily automated infrastructure compliance scans.
- AWS Systems Manager Parameter Store: Encrypted centralized store for application parameters and webhook secrets.
- IAM + ACM + WAF: Least-privilege roles; free SSL/TLS certificates (ACM in us-east-1 for CloudFront, ACM in ap-southeast-1 for API Gateway); layer-7 attack protection.

Component Design
- Content delivery & Edge: CloudFront serves static assets/SSR and API at global edge locations; WAF Web ACL filters requests at the edge; Cognito handles JWT authentication.
- Frontend: AWS Amplify hosts the Next.js 15 SSR application, deployed automatically from Git.
- Core Audit Processing: AWS Lambda wraps Terraform HCL AST parsing behind API Gateway HTTP API.
- Generative AI & RAG: Bedrock Knowledge Base vector store + Claude 3.5 Sonnet agent for multi-step reasoning and automated remediation.
- Data layer: DynamoDB persists audit session records; S3 stores regulatory standards and PDF reports via Pre-signed URLs.
- Automation & Alerting: EventBridge Scheduler invokes Lambda daily; CloudWatch + SNS broadcast instant critical alerts.
- Security & Certificates: Lambda Execution Role scoped to Least Privilege; HTTPS-only with ACM certificates; secrets stored in SSM Parameter Store.

### 4. Technical Implementation
Implementation Phases
- Research & design: learn AWS fundamentals (IAM, Lambda, Bedrock, S3, API Gateway); study serverless RAG patterns for IaC (Weeks 1–2).
- Application development & RAG: standardize CIS Benchmark v3.0 rules, build Terraform AST parser, integrate Bedrock RAG (Weeks 3–5).
- AWS infrastructure deployment: create IAM roles; deploy core engine to Lambda + API Gateway; deploy FE to Amplify; configure S3, DynamoDB, Bedrock Knowledge Base, CloudFront, WAF, SSM Parameter Store (Weeks 6–8).
- Monitoring & optimization: configure CloudWatch Logs/Metrics, Alarm → SNS, EventBridge cron; optimize Bedrock token consumption (Weeks 9–10).
- Testing & documentation: end-to-end testing with benchmark violation test suites; write bilingual step-by-step workshop and clean-up guide (Weeks 11–12).

Technical Requirements
- Backend: Python 3.12 (boto3, bedrock-agent-runtime, regex HCL parser), cold-start optimized, deployed behind API Gateway HTTP API.
- AI & RAG: Amazon Titan Text Embeddings V2 (1,024 dimensions), OpenSearch Serverless vector collection, Anthropic Claude 3.5 Sonnet.
- Frontend: Next.js (TypeScript, TailwindCSS) built and hosted on AWS Amplify with SSR support.
- Networking & security: WAF Web ACL in Global scope (us-east-1) attached to CloudFront; ACM certificates in us-east-1 (CloudFront) and ap-southeast-1 (API Gateway); secrets managed in SSM Parameter Store; Cognito JWT auth.

### 5. Timeline & Milestones
Project Timeline (12 weeks)
- Phase 1 — Research & design (Weeks 1–2): AWS fundamentals, serverless GenAI & RAG architecture study → deliverable: this proposal + draw.io architecture diagram.
- Phase 2 — Core Engine & RAG development (Weeks 3–5): CIS Benchmark dataset preparation, Terraform HCL parser, Bedrock RAG integration → deliverable: local prototype running end-to-end.
- Phase 3 — AWS infrastructure deployment (Weeks 6–8): IAM, Lambda + API Gateway, Amplify, S3, DynamoDB, Bedrock Knowledge Base, CloudFront, WAF, Cognito, SSM Parameter Store → deliverable: live system publicly accessible on AWS.
- Phase 4 — Monitoring & optimization (Weeks 9–10): CloudWatch, Alarm → SNS, EventBridge cron, cost optimization → deliverable: active monitoring dashboard + alerting pipeline.
- Phase 5 — Testing & documentation (Weeks 11–12): end-to-end validation, bilingual workshop, clean-up guide → deliverable: workshop website + final internship report.

### 6. Budget Estimation
Infrastructure Costs
- AWS Services:
  - AWS Lambda: ~$0/month (within free tier 1M requests/month, 512 MB memory).
  - Amazon Bedrock (Claude 3.5 Sonnet + Titan Embeddings V2): ~$2–3/month (~1,000–1,500 IaC audit requests, pay-per-token).
  - API Gateway (HTTP API): ~$1/month ($1/million requests).
  - AWS Amplify: ~$1/month (build minutes + Next.js SSR hosting).
  - Amazon S3: ~$0.05/month (storing Terraform templates, CIS rules, and compiled PDF reports).
  - Amazon DynamoDB: ~$0.50/month (audit session history and compliance scores, On-Demand mode).
  - Amazon SES: ~$0.10 per 1,000 emails (scheduled audit summaries and alerts).
  - AWS WAF: ~$6/month (Web ACL attached at CloudFront edge + managed rule sets).
  - CloudFront CDN: ~$1–2/month (static assets/SSR distribution and global API caching).
  - CloudWatch + SNS + EventBridge: ~$0–1/month (centralized logging, critical alerts, and daily cron triggers).
  - SSM Parameter Store: ~$0/month (standard parameters are free).

Total: ~$11–15/month

Cost-saving architecture choice: The platform leverages 100% serverless compute and Bedrock On-Demand pricing rather than provisioning dedicated EC2/GPU instances (saving $100–$200/month). It eliminates the NAT Gateway (~$32/month) by connecting Lambda directly to internal AWS service endpoints over TLS, keeping total idle operating costs at $0.

### 7. Risk Assessment
Risk Matrix
- LLM Hallucination: high severity.
- Bedrock Model Quota / Rate Limiting: medium severity.
- Sensitive credential leakage (AWS Keys, API Tokens, PII) in uploaded code: high severity.
- Lambda cold-start latency: low severity.
- Unexpected billing beyond free tier: low severity.

Mitigation Strategies
- Hallucination: Anchor retrieval to CIS Benchmark v3.0 via RAG, set temperature = 0.1 for deterministic scoring, mandate explicit rule citation.
- Rate limiting: Implement exponential backoff retry in Lambda; cache audit results for identical code hashes in DynamoDB.
- Sensitive data protection: Activate Bedrock Guardrails to automatically detect and redact secrets, credentials, and PII prior to model invocation.
- Cost control: Configure AWS Budgets and CloudWatch Billing Alarms at a $5/month threshold; tear down resources post-demo.
- Credentials: Store all secrets in SSM Parameter Store; git-ignore `.env`; rotate IAM keys periodically.

Contingency Plans
- If Claude 3.5 Sonnet experiences regional service throttling, failover dynamically to Claude 3 Haiku via SSM configuration.
- Local regex-based fallback scanner for foundational rules (port 22, port 3389) during AI network degradation.
- Complete clean-up guide ensures immediate teardown of all provisioned cloud resources post-presentation to halt all costs.

### 8. Expected Outcomes
Technical Improvements: The entire platform operates serverless on AWS — auto-scaling with traffic, HTTPS-only, WAF and Cognito protected, executing AI and RAG compliance analysis in under 10 seconds. Automated code remediation with CloudWatch monitoring and SNS alerting replaces manual reviews.
Long-term Value: A production-grade reference architecture for enterprise GenAI & RAG DevSecOps on AWS, a reusable bilingual step-by-step workshop for the cloud community, and a cost-optimized model (~$11–15/month) validated against real-world infrastructure code.