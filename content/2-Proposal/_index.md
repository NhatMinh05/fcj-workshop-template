---
title: "Proposal"
date: 2026-09-14
weight: 2
chapter: false
pre: " <b> 2. </b> "
---

# CloudGuard AI: GenAI & RAG-Powered Automated Cloud Infrastructure Security & Cost Optimization Auditor

## An Intelligent Serverless Infrastructure as Code (IaC) Auditing Platform Based on CIS AWS Foundations Benchmark v3.0

---

### 1. Executive Summary

As organizations accelerate their digital transformation and cloud migration, **Infrastructure as Code (IaC)** — particularly Terraform — has become the industry standard for provisioning and managing AWS cloud resources. However, according to recent cloud security research from Gartner and Palo Alto Networks, over **80% of cloud security breaches and data exposures stem from human-induced misconfigurations** within IaC templates. Common oversights include exposing SSH port 22 or RDP port 3389 to `0.0.0.0/0`, granting excessive IAM permissions (`AdministratorAccess`), leaving S3 buckets unencrypted without SSE-KMS, or provisioning oversized and idle cloud resources that waste thousands of dollars each month.

**CloudGuard AI** is engineered as a next-generation DevSecOps solution combining the capabilities of **Generative AI** and **Retrieval-Augmented Generation (RAG)** on **Amazon Bedrock** to automate cloud infrastructure security audits, compliance evaluations, and cost optimization. Powered by **Anthropic Claude 3.5 Sonnet** and integrated with an authoritative vector knowledge base derived from the **CIS AWS Foundations Benchmark v3.0** and the **AWS Well-Architected Framework**, the platform provides accurate, context-aware architectural evaluations without hallucination.

Designed with a **100% Serverless & Event-Driven Architecture** (AWS Lambda, Amazon API Gateway, Amazon DynamoDB, Amazon S3, and AWS Amplify), CloudGuard AI delivers real-time IaC parsing, calculates an objective **Security Posture Score (0–100)**, identifies non-compliant resources, and **automatically generates production-ready remediation code (Terraform diffs)** with a single click. The entire system operates at minimal overhead (**~$1.00 – $2.00/month**, fully compliant with the AWS Free Tier and incurring zero idle server costs), providing an enterprise-grade DevSecOps auditing mechanism accessible to startups, research labs, and academic institutions.

---

### 2. Problem Statement

#### Industry Context & Existing Bottlenecks
1. **Slow and Error-Prone Manual Security Reviews**: Auditing infrastructure configurations manually prior to production deployment is labor-intensive and bottlenecked by limited security personnel. As cloud deployment frequency increases, manual reviews either delay release cycles or inadvertently miss critical vulnerabilities.
2. **Static Code Analysis Tools Lack Contextual Understanding**: Conventional open-source scanners (such as tfsec and Checkov) rely on rigid regular expressions and static rule sets. They frequently generate high volumes of false positives, fail to comprehend resource relationships (e.g., an EC2 instance residing in a private subnet cannot be directly exploited via an open security group), and **cannot explain or auto-remediate identified issues**.
3. **Hallucination Risks in Generic Large Language Models**: When engineers query generic LLMs (such as base ChatGPT or Claude without external grounding) for security advice, the models often experience **hallucinations**, referencing deprecated Terraform syntax, incorrect resource arguments, or inaccurate compliance clause numbers.

#### The CloudGuard AI Solution
CloudGuard AI systematically overcomes these challenges through an integrated architectural approach:
- **Hallucination-Free Auditing via Bedrock Knowledge Bases (RAG)**: The platform indexes the official CIS AWS Foundations Benchmark v3.0 specifications and AWS Best Practice whitepapers into **Amazon Bedrock Knowledge Bases**, utilizing **Amazon Titan Text Embeddings V2** and an optimized vector index. Every finding is anchored directly to official benchmark guidelines.
- **Agentic Multi-Step Reasoning & Auto-Remediation**: An **Amazon Bedrock Agent** functions as a virtual DevSecOps engineer. It parses the Abstract Syntax Tree (AST) of the submitted Terraform files, retrieves pertinent compliance guidelines, reasons through resource dependencies, and generates validated, ready-to-merge remediation code.
- **Seamless Shift-Left CI/CD Pipeline Integration**: The solution supports both a modern web dashboard (hosted on AWS Amplify) for interactive testing and automated webhook triggers via GitHub Actions / GitLab CI for pull request validation before any resource is provisioned.

#### Benefits & Return on Investment (ROI)
- **90% Reduction in Infrastructure Audit Latency**: Reduces code review cycles from multiple business days to under 10 seconds per scan.
- **100% Prevention of Critical Misconfigurations in Staging**: Ensures all persistent storage volumes (S3, EBS, RDS) are encrypted, administrative ports are closed to the public Internet, and IAM policies adhere strictly to the principle of least privilege.
- **Superior Cost Efficiency & Rapid Payback**: The serverless event-driven architecture eliminates 100% of idle infrastructure costs. Average audit operational costs average approximately $0.001 per file scan. Break-even ROI is realized within the first month of deployment.

---

### 3. Solution Architecture

CloudGuard AI is built in strict adherence to the **AWS Well-Architected Framework**, balancing Security, Reliability, Performance Efficiency, Cost Optimization, Operational Excellence, and Sustainability.

The official architecture diagram of the system is illustrated below:

![CloudGuard AI Official Architecture Diagram](https://nhatminh05.github.io/fcj-workshop-template/images/2-Proposal/cloudguard_architecture.jpg)

#### AWS Services Utilized
- **AWS WAF (Web Application Firewall)**: Deploys managed Web ACL rule sets protecting CloudFront distributions and API Gateway endpoints against distributed denial-of-service (DDoS), SQL injection (SQLi), cross-site scripting (XSS), and malicious automated scanners.
- **AWS IAM (Identity and Access Management)**: Enforces granular role-based access control (RBAC) and least-privilege execution roles for AWS Lambda and the Bedrock Agent.
- **Amazon CloudFront**: Global content delivery network (CDN) providing low-latency edge distribution, static asset caching, and global SSL/TLS termination.
- **Amazon Cognito**: Provides user directory management (User Pools) for DevOps engineers, securing all system interactions through cryptographically signed JSON Web Tokens (JWT).
- **AWS Certificate Manager (ACM)**: Manages and automatically renews public SSL/TLS certificates for custom domain bindings in both `us-east-1` (CloudFront) and `ap-southeast-1` (API Gateway).
- **Amazon API Gateway (HTTP API)**: High-throughput, low-latency RESTful API gateway exposing endpoints (`POST /scan`, `GET /history`, `GET /report/{id}`) with built-in rate-limiting and throttling controls.
- **AWS Systems Manager (SSM) Parameter Store**: Securely stores encrypted application environment parameters, Bedrock Agent IDs, and webhook notification URLs.
- **AWS Lambda (Core Audit Engine)**: The primary serverless computing unit running Python 3.12, responsible for parsing Terraform HCL syntax, orchestrating Bedrock Agent interactions, computing compliance scores, and compiling PDF audit summaries.
- **AWS Amplify**: Full-stack hosting and CI/CD platform delivering the modern Next.js/React dashboard for code submission, interactive visualizations, and diff reviews.
- **Amazon EventBridge Scheduler**: Serverless cron scheduler executing automated daily infrastructure security posture scans.
- **Amazon Bedrock Agent**: An intelligent agent powered by Anthropic Claude 3.5 Sonnet, capable of multi-step logical reasoning, policy correlation, and automated Terraform code remediation.
- **Amazon Bedrock Knowledge Bases (RAG)**: Retrieval-augmented generation engine indexing CIS benchmark guidelines and AWS pricing tables using Amazon Titan Text Embeddings V2 and a vector database.
- **Amazon Bedrock Guardrails**: Comprehensive safety guardrails preventing prompt injection attacks, enforcing responsible AI boundaries, and masking sensitive secrets (API keys, AWS credentials) and Personally Identifiable Information (PII).
- **Amazon S3 (Simple Storage Service)**: Multi-purpose object storage maintaining CIS compliance standards, raw uploaded IaC files, and compiled PDF audit reports.
- **Amazon DynamoDB**: Low-latency NoSQL database recording scan histories, compliance scores, finding severities, and execution timestamps.
- **Amazon SES (Simple Email Service)**: Automated transactional email engine delivering executive security summaries and scheduled audit reports to DevSecOps teams.
- **Amazon CloudWatch**: Centralized observability platform collecting Lambda execution logs, Bedrock token consumption metrics, API latencies, and error alarms.
- **Amazon SNS (Simple Notification Service)**: Multi-channel pub/sub messaging service broadcasting high-priority alerts to administrator channels (Slack, SMS, Email) upon detecting CRITICAL severity misconfigurations.

#### Detailed Component Design
1. **Edge Security & Ingress Layer**:
   - All inbound traffic from developers or external CI/CD systems enters through AWS WAF and Amazon CloudFront. Authentication is verified through Amazon Cognito, issuing short-lived JWT tokens that authorize subsequent API requests.
2. **API & Request Routing Layer**:
   - Amazon API Gateway inspects incoming JWT tokens via a Cognito Authorizer. Upon successful authentication, the request payload is validated against JSON schemas and proxied to the backend Lambda service under configured rate limits.
3. **Core Serverless Audit Engine (Lambda)**:
   - The Lambda function ingests the Terraform payload, converts the HCL configuration into an Abstract Syntax Tree (AST), and extracts declared cloud resources. Secret keys and environment configurations are retrieved dynamically from SSM Parameter Store.
4. **GenAI & RAG Brain Layer**:
   - The Bedrock Agent receives the sanitized infrastructure context and executes vector similarity queries against Bedrock Knowledge Bases to retrieve corresponding CIS benchmark rules.
   - Guardrails sanitize inputs and outputs against credential leaks and prompt injection. Claude 3.5 Sonnet evaluates resource configurations, computes an overall Security Posture Score (0–100), classifies findings by severity (CRITICAL, HIGH, MEDIUM, LOW), and produces clean, remediation Terraform blocks.
5. **Data Persistence & Alerting Layer**:
   - Audit metadata and scores are committed to Amazon DynamoDB, while generated PDF audit reports are written to Amazon S3.
   - In the event of CRITICAL vulnerabilities (such as unrestricted administrative ports or unencrypted storage buckets), CloudWatch metric alarms trigger Amazon SNS topics to deliver real-time push alerts to engineers.

---

### 4. Technical Implementation

#### Implementation Phases
The project is executed systematically across four distinct technical phases:

1. **Phase 1: Knowledge Base Engineering & Compliance Grounding (Month 1)**:
   - Compile, clean, and standardize the CIS AWS Foundations Benchmark v3.0 and AWS Well-Architected Framework documentation into modular Markdown files.
   - Configure an Amazon S3 knowledge repository and establish an **Amazon Bedrock Knowledge Base** with a chunking strategy of 512 tokens with a 20% overlap.
   - Generate embeddings using **Amazon Titan Text Embeddings V2** and link the collection to a high-performance vector index.
   - Define custom prompt templates and configure safety guardrails in **Amazon Bedrock Guardrails**.

2. **Phase 2: Serverless Core Engine & Orchestration Backend (Month 2)**:
   - Provision an Amazon DynamoDB table (`CloudGuard_ScanHistory`) structured with `ScanId` (Partition Key) and `Timestamp` (Sort Key).
   - Implement the core AWS Lambda handler in Python 3.12 utilizing the AWS SDK (`boto3`) to interface with Bedrock Runtime, DynamoDB, S3, and SES.
   - Develop custom HCL parsing logic to validate syntax, detect structural dependencies, and extract cloud resource attributes.
   - Configure Amazon API Gateway (HTTP API) routes and attach Cognito JWT Authorizers.

3. **Phase 3: Web Dashboard Development & CI/CD Automation (Month 2 – Month 3)**:
   - Build a responsive web application using **Next.js (App Router)** and **Tailwind CSS**, integrating the Monaco Code Editor for in-browser Terraform editing.
   - Design dynamic visualization components: an overall Security Posture radar chart, color-coded finding breakdowns, and a side-by-side Diff Viewer highlighting original vs. remediated code.
   - Deploy the web interface to **AWS Amplify** backed by CloudFront and ACM SSL certificates.
   - Configure **Amazon EventBridge Scheduler** to execute automated daily infrastructure posture audits at 00:00 UTC.
   - Author reference GitHub Actions workflows demonstrating automated pull request security scanning via webhooks.

4. **Phase 4: Comprehensive Verification, Performance Tuning & Workshop Authoring (Month 3)**:
   - Execute test suites against 50 diverse Terraform configurations featuring typical security misconfigurations and anti-patterns.
   - Benchmark RAG retrieval accuracy (demonstrating over 96% precision with 0% hallucination rates).
   - Optimize Lambda memory allocations and cold-start latencies to achieve sub-8-second execution times for 500-line configurations.
   - Complete the hands-on lab tutorial documentation (Section 5) for the final project submission.

---

### 5. Roadmap & Milestones

| Timeline | Project Phase | Core Objectives & Deliverables | Status |
| :--- | :--- | :--- | :---: |
| **Month 1 (Weeks 1–4)** | Research & Architecture | • Analyze CIS AWS Foundations Benchmark v3.0 specifications.<br>• Author comprehensive project proposal documentation.<br>• Prototype Bedrock RAG vector indexing pipeline. | **Completed 100%** |
| **Month 2 (Weeks 5–8)** | Backend & AI Engineering | • Implement Serverless Core backend (Lambda, API Gateway, DynamoDB).<br>• Integrate Bedrock Agent with Claude 3.5 Sonnet and Knowledge Bases.<br>• Implement automated scoring algorithms and remediation generators. | **In Progress** |
| **Month 3 (Weeks 9–11)**| Frontend & Automation | • Finalize Next.js Dashboard deployed on AWS Amplify.<br>• Configure EventBridge scheduled triggers and SNS/SES notifications.<br>• Implement GitHub Actions pull request audit workflows. | **Ready** |
| **Month 3 (Week 12)**  | Verification & Defense | • Validate end-to-end against 50 representative benchmark cases.<br>• Complete 5-chapter hands-on Workshop documentation.<br>• Prepare final presentation deck and defense Q&A script. | **Planned** |

---

### 6. Cost Estimation & Return on Investment (ROI)

CloudGuard AI is built from the ground up on FinOps best practices, eliminating fixed infrastructure overhead and leveraging the **AWS Free Tier**.

The projected monthly operating expenses (based on a workload of 1,000 infrastructure code scans per month) are detailed below:

| AWS Service | Estimated Monthly Capacity / Configuration | Free Tier Coverage | Actual Monthly Cost |
| :--- | :--- | :---: | :---: |
| **AWS Lambda** | 1,000 invocations/month, 5s average duration, 512 MB memory | Fully covered (1,000,000 free requests/month) | **$0.00 USD** |
| **Amazon API Gateway** | 2,000 HTTP API calls/month | Fully covered (1,000,000 free calls for first 12 months) | **$0.00 USD** |
| **Amazon S3 Standard** | 2 GB document & report storage, 3,000 PUT/GET requests | Fully covered (5 GB standard storage free) | **$0.00 USD** |
| **Amazon DynamoDB** | 1 table, 500 MB storage, on-demand read/write mode | Fully covered (25 GB free permanent NoSQL storage) | **$0.00 USD** |
| **AWS Amplify** | Static web hosting, 5 GB bandwidth/month | Fully covered (15 GB bandwidth free) | **$0.00 USD** |
| **Amazon Bedrock (Claude 3.5)**| ~1,000 AI invocations, avg 1,500 input / 800 output tokens | Billed strictly per consumed token | **~$1.20 USD** |
| **Amazon Bedrock (Titan V2)** | Vector embedding storage & queries (500,000 tokens) | Billed per token query and storage | **~$0.15 USD** |
| **Amazon SES & SNS** | 200 report emails/month, 50 SMS/SNS notifications | Fully covered (62,000 free emails/month from Lambda) | **$0.00 USD** |
| **CloudWatch & WAF** | 1 GB log ingestion, basic Web ACL inspection | Within standard baseline monitoring allocations | **~$0.25 USD** |
| **ESTIMATED MONTHLY TOTAL** | **Full Serverless DevSecOps Security Auditing Platform** | **Over 95% Cost Reduction** | **~$1.60 USD / month** |

> **Total annualized operational expenditure is approximately ~$19.20 USD**. Compared to legacy architectures requiring dedicated EC2 instances (minimum $15–$20/month for small instances running 24/7) or commercial proprietary scanners (costing thousands of dollars annually), CloudGuard AI achieves unprecedented cost efficiency with an ROI exceeding 98%.

---

### 7. Risk Assessment & Mitigation Strategies

| Identified Risk | Severity | Likelihood | Proactive Mitigation Strategy |
| :--- | :---: | :---: | :--- |
| **AI Model Hallucinations** | High | Low | Implement **Bedrock Knowledge Bases (RAG)** to strictly constrain Claude 3.5 Sonnet to cite verified clauses directly from indexed CIS Benchmark documents. |
| **Prompt Injection Attacks** | High | Medium | Configure **Amazon Bedrock Guardrails** with strict content filters and input sanitization rules that reject jailbreak attempts and instruction overrides. |
| **Accidental Secret Leaks in IaC Code** | Critical | Medium | Execute client-side and Lambda-side regular expression pattern scanning to redact AWS access keys and passwords before dispatching payloads to Bedrock. |
| **Unexpected Budget Overruns via API Abuse** | Medium | Low | Enforce strict rate limits on Amazon API Gateway (10 requests/minute per client IP) and configure automated **AWS Budgets** alerts triggered at a $5.00 threshold. |
| **Lambda Invocation Timeouts on Large Files** | Medium | Medium | Set a generous 60-second Lambda timeout window, implement code modularization, and introduce asynchronous processing with webhook/email callbacks for large templates. |

---

### 8. Expected Outcomes & Project Value

#### Technical Achievements
- **Fully Functional, Production-Ready Platform**: Delivers an end-to-end DevSecOps cloud auditor featuring a modern web UI, automated CI/CD webhooks, and verified AWS serverless backends.
- **Mastery of Frontier Cloud & AI Technologies**: Demonstrates deep practical expertise with advanced AWS services: **Amazon Bedrock Agents**, **Knowledge Bases (RAG)**, **Guardrails**, and **Event-Driven Serverless Architecture**.
- **High-Quality Open-Source Artifacts**: Publishes clean, modular, and maintainable source code accompanied by infrastructure provisioning scripts (Terraform) and comprehensive documentation.

#### Academic & Industry Impact
- **Fulfillment of Internship & Graduation Objectives**: Serves as a capstone internship project for an Artificial Intelligence major at FPT University, demonstrating strong architectural independence, engineering rigor, and real-world problem-solving skills.
- **Contribution to the AWS First Cloud AI Journey (FCAJ)**: Provides a comprehensive, production-grade workshop tutorial (Section 5) that enables fellow students and junior cloud engineers to build secure, generative AI-powered automation on AWS.
