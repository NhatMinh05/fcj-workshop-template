---
title: "Event 3"
date: 2026-10-24
weight: 3
chapter: false
pre: " <b> 4.3. </b> "
---

# Summary Report: “First Cloud AI Journey Meetup – October 24, 2026”

### Event Objectives

- Absorb practical insights on Cloud and AI Agents directly from tech leads and senior engineers representing enterprise tech organizations.
- Explore low-latency Vietnamese Voice-AI architectures powering next-generation Contact Centers on AWS.
- Master multi-account resource sharing and cost governance using AWS Resource Access Manager (RAM).
- Examine automated infrastructure security testing (DevSecOps) and the role of autonomous Security Agents prior to production releases.
- Gain deep architectural knowledge on scaling AI Agents to production with Amazon Bedrock AgentCore (Agent Runtime & Tiered Memory).
- Discover Kiro Crew's 24/7 autonomous AI Agent model: automated code review, system monitoring, Context Window management, and security guardrails.

### Speakers & Industry Experts

- **Mr. Kiet Tran** – AI Engineer at Revve AI (*Session 1: Voice-AI Contact Center*)
- **Mr. Long Huynh** – Solution Architect at Styl Solution (*Session 2: AWS Resource Access Manager*)
- **Mr. Thinh Nguyen** – Cloud Security Engineer at Styl Solution (*Session 3: AWS Pentest with Security Agent*)
- **Mr. Xuan An** – Leader of AWS Student Builder Group HCMUTE (*Session 4: Amazon Bedrock AgentCore*)
- **Mr. Khoa Kieu** – Tech Lead at ACB & **Mr. Nghi Danh** – AWS Community Builder (*Session 5: Kiro Crew*)

### Key Highlights

#### Session 1: Hear, Think, Speak – Building a Vietnamese Voice-AI Contact Center on AWS
- Deep dive into two-way Voice AI architecture, minimizing conversation latency down to ~1.8s for smooth, near-instant human-like dialogue.
- Compelling live demonstration: An automated voice AI agent conducting a screening interview for a Cloud Engineer candidate in Vietnamese with natural cadence and responsive conversational interruption handling.

#### Session 2: Secure Resource Sharing with AWS Resource Access Manager (RAM)
- Architectural blueprints for sharing core cloud assets (VPC Subnets, Transit Gateway, Route 53 Resolver Rules) across accounts in AWS Organizations.
- Consolidated network management strategies that substantially reduce cross-account bandwidth costs.
- Tight integration between IAM Policies and Service Control Policies (SCPs) to implement mandatory organizational guardrails.

#### Session 3: Shift-Left Security & Autonomous AI Pentesting
- Static analysis of Terraform Infrastructure as Code (IaC) embedded directly into GitLab/GitHub Pull Request pipelines to intercept misconfigurations early.
- Deploying autonomous **Security Agents** that simulate realistic user attacks to conduct automated penetration testing on SIT/UAT environments before production deployment.

#### Session 4: Amazon Bedrock AgentCore – Production-Grade Agent Runtimes
- **Agent Runtime:** Cost-optimized microVM execution utilizing EC2 Spot instances, delivering maximum resilience at minimal infrastructure expense.
- **Tiered Memory Systems:** Clear distinction between *Short-term Memory* (synchronous context retention within the active session) and *Long-term Memory* (asynchronous, continuous accumulation of user knowledge and preferences).

#### Session 5: Kiro Crew – 24/7 Autonomous AI Agent for Software Systems
- Operating continuous autonomous AI agents to automate software code review and monitor system availability around the clock.
- **Dynamic Artifact Generation:** AI agent autonomously scraping live tech employment data, synthesizing trends, and rendering charts directly within the chat UI.
- **Precision Context Window Governance:**
  - *Auto Compact* triggered when context volume reaches 70–90% capacity to avoid token overflow.
  - *Break down context* tooling to inspect exact token consumption across system instructions, message history, and retrieved assets.
- **Memory Hygiene & Enterprise Guardrails:** Automated memory cleanup to prevent unbounded storage expenses; enforced guardrails blocking destructive infrastructure operations and secret disclosures.

### Key Takeaways

#### Systems Architecture & Enterprise Thinking
- Understood how tech enterprises (such as ACB Bank) operationalize AI Agents for real engineering workflows rather than simplistic chatbots.
- Recognized that real-world AI viability hinges on latency reduction, token/compute efficiency, and long-term architectural stability.

#### Advanced Engineering & Cloud Security
- Mastered the inner workings of Context Window management and tiered memory architectures in modern Agentic frameworks.
- Gained comprehensive understanding of multi-account governance on AWS through the synergy of RAM, IAM, and SCPs.

### Applying to Work & Study

- **Context Window Discipline in AI Projects**: Implement context-compaction techniques and task decomposition in university coursework and Capstone projects at FPT University.
- **Cost-Conscious Lab Architecture**: Apply EC2 Spot instance patterns and token budget tracking in personal AWS lab environments.
- **Adopting Shift-Left DevSecOps**: Establish rigorous IaC security reviews and explicit guardrails early in the software design phase.

### Event Experience

The **“First Cloud AI Journey Meetup (October 24, 2026)”** at the 26th floor of Bitexco was an intellectually rich and inspiring milestone:

#### High Density of Practical Knowledge
- 5 back-to-back technical sessions focused on real-world engineering hurdles rather than generic high-level concepts.
- Witnessing live Vietnamese Voice-AI call demonstrations and listening to ACB's Tech Lead share production battle lessons provided immense value.

#### Open Technical Discussions & Deep-Dive Q&A
- The concluding Q&A session was extraordinarily interactive, with speakers dissecting complex edge cases raised by practicing engineers.
- Gained practical tips regarding token optimization and memory cleanup that are seldom found in textbook documentation.

#### Inspiring Community Environment
- Interacted directly with respected tech leads, mentors, and talented students from top universities within the FCAJ network.
- Strengthened confidence and dedication toward pursuing a specialized career in Cloud Architecture and AI Engineering.

### Some Event Photos

![Check-in at Bitexco Financial Tower - First Cloud AI Journey Meetup](https://nhatminh05.github.io/fcj-workshop-template/images/4-EventParticipated/4.3-Event3/event3_checkin.jpg)
