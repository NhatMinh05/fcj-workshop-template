---
title: "Workshop"
date: 2024-01-01
weight: 5
chapter: false
pre: " <b> 5. </b> "
---

# Workshop: Building GenAI & RAG Automated AWS Infrastructure Security & Cost Auditor (CloudGuard AI)

#### Workshop Overview

Welcome to the comprehensive, hands-on **CloudGuard AI** workshop – an end-to-end automated cloud infrastructure security and cost optimization platform (DevSecOps & FinOps) powered by Generative AI and Retrieval-Augmented Generation (**RAG**) on **Amazon Web Services (AWS)**.

In modern cloud engineering, adopting **Infrastructure as Code (IaC)** with Terraform enables teams to deploy architectures at unprecedented speed. However, without automated **Shift-Left Security** verification, dangerous misconfigurations frequently slip into production environments: unrestricted SSH Port 22 open to the public internet (`0.0.0.0/0`), unencrypted Amazon S3 storage buckets, and overly permissive wildcard IAM policies (`AdministratorAccess`).

This workshop provides step-by-step guidance to build an enterprise-grade auditor from scratch: orchestrating **Amazon Bedrock** (Anthropic Claude 3.5 Sonnet & Titan Text Embeddings V2), **Amazon Bedrock Knowledge Bases**, **AWS Lambda**, **Amazon API Gateway**, **Amazon S3**, **Amazon DynamoDB**, and **Amazon EventBridge Scheduler** to parse code syntax, cross-reference the **CIS AWS Foundations Benchmark v3.0**, compute posture scores (0-100), and generate automated code remediation snippets in real time.

---

#### Learning Objectives

Upon completing this workshop, you will be able to:
1. **Master RAG Architecture on AWS Bedrock**: Provision and manage Amazon Bedrock Knowledge Bases, index authoritative CIS Benchmark standards, and embed documents using Amazon Titan Text Embeddings V2.
2. **Develop a Serverless Core Audit Engine**: Write AWS Lambda logic to parse Terraform HCL Abstract Syntax Trees (AST), orchestrate reasoning agents, and calculate security scores.
3. **Deploy Secure API Endpoints**: Expose high-throughput RESTful HTTP API routes via Amazon API Gateway for seamless integration with external CI/CD pipelines (GitHub Actions, GitLab CI).
4. **Implement Event-Driven Automation & Alerting**: Configure EventBridge Scheduler for automated daily posture scans and leverage Amazon SNS for real-time alerting on CRITICAL misconfigurations.
5. **Optimize Operational Costs (FinOps)**: Maintain zero idle runtime costs through 100% serverless architecture, remaining well within the AWS Free Tier.

---

#### Table of Contents

1. [**5.1 Workshop Overview & Solution Architecture**](5.1-Workshop-overview/)
   - Problem context, 6-stage data flow lifecycle, and high-level architectural design.
2. [**5.2 Prerequisites & IAM Configuration**](5.2-Prerequiste/)
   - Enabling Bedrock model access, configuring IAM execution roles, S3 buckets, and DynamoDB tables.
3. [**5.3 Building RAG Knowledge Base with CIS Benchmark**](5.3-Knowledge-base/)
   - Storing CIS Benchmark v3.0 standards in S3, creating Knowledge Bases, and running vector sync.
4. [**5.4 Building Lambda Core Engine & API Gateway**](5.4-Core-engine/)
   - Developing Python audit logic, integrating Bedrock retrieve-and-generate APIs, and binding HTTP routes.
5. [**5.5 Deploying Dashboard & Automated Scheduler**](5.5-Dashboard-scheduler/)
   - Designing an interactive web UI and setting up EventBridge Scheduler for continuous compliance.
6. [**5.6 End-to-End Testing & Resource Cleanup**](5.6-Cleanup/)
   - Executing real-world validation scenarios against flawed Terraform scripts and executing clean resource teardown.