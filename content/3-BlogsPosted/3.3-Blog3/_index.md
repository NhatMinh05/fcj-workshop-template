---
title: "Blog 3"
date: 2024-01-01
weight: 3
chapter: false
pre: " <b> 3.3. </b> "
---

# MULTI-REGION AI INFERENCE ROUTING WITH AMAZON SAGEMAKER HYPERPOD GLOBAL INFERENCE GATEWAY

When serving enterprise foundation models and large language models (LLMs) in production, spreading compute capacity across multiple clusters and AWS Regions is necessary due to tight GPU supply constraints. However, traditional multi-cluster setups introduce three major operational headaches:

* **Uneven load:** During peak hours, requests queue up on a saturated cluster while GPUs on another cluster—often in another AWS Region—sit idle even though you have already paid for that capacity.
* **Manual failover:** When a cluster experiences hardware or software failures, engineers must intervene manually to reconfigure DNS or update routing endpoints.
* **Custom plumbing:** Spreading traffic across Regions requires building and maintaining custom Application Load Balancers, complex DNS records, and cross-Region networking layers.

To eliminate these bottlenecks, AWS introduced **Amazon SageMaker HyperPod Global Inference Gateway** — a two-tier routing architecture that provides a single, SageMaker-managed endpoint to intelligently route requests across all registered HyperPod clusters within one Region or across multiple Regions.

Core architectural components and mechanisms:

* **Two-Tier Routing Architecture:**
  * *Tier 1 - Global Inference Gateway:* Operates at the regional/global level, receiving incoming client requests, performing SigV4/IAM authentication, scoring clusters, and forwarding traffic across the private AWS backbone.
  * *Tier 2 - Cluster Inference Gateway:* Operates inside each HyperPod cluster, taking over incoming traffic from Tier 1 and placing requests onto the optimal model pod based on local GPU conditions.
* **Single Managed Endpoint:** Rather than requiring clients to track dozens of endpoints (one per model per cluster), all client applications target a single SageMaker-managed gateway endpoint.
* **Real-Time Capacity-Aware Routing:** The gateway dynamically scores each cluster using four real-time telemetry signals supplied by a service-managed metrics publisher:
  * *KVHeadroom (0.20):* Available Key-Value (KV) cache and GPU memory headroom on the cluster.
  * *QueueDepth (0.25):* How backed up the cluster's inference request queue currently is.
  * *RegionProximity (0.40):* Physical distance between the gateway and target cluster to minimize latency.
  * *ErrorRate (0.15):* Recent error rates to avoid directing new requests to degraded clusters.
* **Automated Traffic Overflow & Failover:** When a cluster reaches capacity or encounters an outage, the gateway automatically overflows excess traffic to healthy clusters with available capacity in the same Region or another Region with zero client intervention.
* **Enterprise Security via AWS PrivateLink:** All cross-cluster and cross-Region traffic travels over **AWS PrivateLink** (VPC Endpoint Services) on the private AWS network backbone, never traversing the public internet, secured by SigV4 request signing and AWS IAM.

Key benefits and impact:

* **Maximum GPU Utilization:** Puts idle GPUs to work across different clusters and Regions, extracting full value from provisioned accelerators.
* **Zero Operational Overhead:** Eliminates the burden of building custom cross-region load balancers, health checkers, or DNS failover scripts.
* **High Resilience:** Provides built-in High Availability (HA) and Disaster Recovery (DR) capabilities for mission-critical Generative AI workloads.

*Source:* [Introducing Amazon SageMaker HyperPod Global Inference Gateway: One endpoint across Regions and clusters – AWS Machine Learning Blog](https://aws.amazon.com/blogs/machine-learning/introducing-amazon-sagemaker-hyperpod-global-inference-gateway-one-endpoint-across-regions-and-clusters/)

![Amazon SageMaker HyperPod Global Inference Gateway Architecture](https://nhatminh05.github.io/fcj-workshop-template/images/3-BlogsPosted/3.3-Blog3/HyperPodGlobalInferenceGatewayArchitecture.png)

[Link to the original post](https://www.facebook.com/groups/awsstudygroupfcj/permalink/2346835766081382/)
