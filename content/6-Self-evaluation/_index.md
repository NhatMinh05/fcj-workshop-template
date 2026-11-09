---
title: "Self-Assessment"
date: 2024-01-01
weight: 6
chapter: false
pre: " <b> 6. </b> "
---

During my internship at **Amazon Web Services Viet Nam Company Limited** from **14/09/2026** to **14/12/2026**, I had the opportunity to learn, practice, and apply the advanced knowledge acquired at FPT University into an enterprise-grade cloud computing environment.  

I directly researched, architected, and implemented the **CloudGuard AI: Automated AWS Infrastructure Security & Cost Auditor project on AWS Serverless infrastructure powered by Amazon Bedrock GenAI & RAG**. Through developing this project, I strengthened and mastered the complete spectrum of technical expertise established in the Proposal:

* **Generative AI & RAG Engineering:** Integrated foundational Amazon Bedrock services using Anthropic Claude 3.5 Sonnet and Amazon Titan Text Embeddings V2 (1,024 dimensions); established Bedrock Knowledge Bases anchored to OpenSearch Serverless vector collections to eliminate model hallucinations.
* **Cloud Security & Compliance Auditing (DevSecOps):** Applied the international CIS AWS Foundations Benchmark v3.0 standard to automatically inspect Terraform HCL infrastructure templates, detecting critical vulnerabilities (such as wide-open SSH port 22 `0.0.0.0/0`, unencrypted S3 buckets, and wildcard IAM `*`) and automatically generating remediation code.
* **100% Serverless Architecture:** Designed a fully decoupled serverless backend with AWS Lambda (Python 3.12, cold-start optimized) fronted by Amazon API Gateway (HTTP API), object storage with Amazon S3, and NoSQL data persistence with Amazon DynamoDB in On-Demand pay-per-request mode.
* **Automation, Scheduling & Telemetry:** Configured EventBridge Scheduler for automated daily scans (`cron(0 1 * * ? *)`), centralized logging and metrics with Amazon CloudWatch, and real-time emergency alerting via Amazon SNS for high/critical security breaches.
* **Perimeter Security & Identity Governance:** Deployed AWS WAF Web ACLs at CloudFront Edge, provisioned SSL/TLS certificates via ACM (us-east-1 and ap-southeast-1), managed user authentication with Amazon Cognito User Pools via JWT Auth, and secured secrets and Model IDs within AWS Systems Manager Parameter Store.
* **Frontend Engineering & Content Delivery:** Built a responsive analytics dashboard using Next.js (TypeScript, TailwindCSS) with Server-Side Rendering (SSR), deployed continuously via AWS Amplify, and globally accelerated through Amazon CloudFront CDN.
* **Cloud Financial Engineering (FinOps):** Realized significant architectural cost savings: routed traffic internally between Lambda and AWS service endpoints over TLS to eliminate NAT Gateway costs (~$32/month) and avoid dedicated EC2 GPU instances (~$100–$200/month), reducing total continuous 24/7 operating costs to just ~$11–15/month and approaching $0 when idle.
* **Shift-Left Security & Technical Writing:** Embedded automated security checks directly into CI/CD Pull Request Webhooks, and authored a comprehensive bilingual 6-lab hands-on technical workshop.

In terms of work ethic, I always strived to complete tasks well, strictly complied with workplace regulations, proactively resolved challenges, and actively engaged with mentors and colleagues to improve work efficiency.

To objectively reflect on my internship period, I would like to evaluate myself based on the following criteria:

| No. | Criteria | Description | Good | Fair | Average |
| --- | --- | --- | :---: | :---: | :---: |
| 1 | **Professional knowledge & skills** | Understanding of the field, applying knowledge in practice, proficiency with tools, work quality | ☐ | ✅ | ☐ |
| 2 | **Ability to learn** | Ability to absorb new knowledge and learn quickly | ☐ | ✅ | ☐ |
| 3 | **Proactiveness** | Taking initiative, seeking out tasks without waiting for instructions | ✅ | ☐ | ☐ |
| 4 | **Sense of responsibility** | Completing tasks on time and ensuring quality | ✅ | ☐ | ☐ |
| 5 | **Discipline** | Adhering to schedules, rules, and work processes | ✅ | ☐ | ☐ |
| 6 | **Progressive mindset** | Willingness to receive feedback and improve oneself | ☐ | ✅ | ☐ |
| 7 | **Communication** | Presenting ideas and reporting work clearly | ✅ | ☐ | ☐ |
| 8 | **Teamwork** | Working effectively with colleagues and participating in teams | ✅ | ☐ | ☐ |
| 9 | **Professional conduct** | Respecting colleagues, partners, and the work environment | ✅ | ☐ | ☐ |
| 10 | **Problem-solving skills** | Identifying problems, proposing solutions, and showing creativity | ☐ | ✅ | ☐ |
| 11 | **Contribution to project/team** | Work effectiveness, innovative ideas, recognition from the team | ✅ | ☐ | ☐ |
| 12 | **Overall** | General evaluation of the entire internship period | ✅ | ☐ | ☐ |

### Needs Improvement

* Improve problem-solving thinking to troubleshoot complex architectural edge cases more efficiently
* Strengthen the ability to learn and absorb new advanced cloud services and concepts more quickly
* Continue refining technical communication and presentation skills to convey solutions with greater clarity and confidence
