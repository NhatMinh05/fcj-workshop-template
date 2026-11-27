---
title: "Demo Video"
date: 2026-11-20
weight: 8
chapter: false
pre: " <b> 5.8. </b> "
---

**Live Demonstration:** [https://imageguard-app.vercel.app/](https://imageguard-app.vercel.app/) | [https://d1726d6l9yiqcj.cloudfront.net/](https://d1726d6l9yiqcj.cloudfront.net/)

**Demo Video:** `[Paste the YouTube / Google Drive link after recording]` *(Pre-rendered HD walkthrough available at `D:\ImageGuard_Review_VI.mp4` and English version at `D:\ImageGuard_Review_EN.mp4`)*

---

## Core Application Screens in ImageGuard

### 1. Guest Landing Page
Intuitive modern UI with rotating LED beam effects, explaining the 3-step automated workflow and previewing the public feed.

![ImageGuard Landing Page](../../images/5-workshop/21-4-web-first-load-v2.jpg)
*Figure: ImageGuard guest landing page served through CloudFront with Cognito sign-in*

### 2. Moderation Overview Dashboard
High-level KPIs showing total items, 50% approval pass rate, published count, Rekognition label frequency charts, and recent activity timeline.

![ImageGuard Overview Dashboard](../../images/5-workshop/26-2-web-overview-v2.png)
*Figure: ImageGuard Moderation Overview Dashboard*

### 3. Personal Image Vault
User image management console showing AI label tags, blocked moderation categories, and publish / unpublish controls.

![ImageGuard Vault](../../images/5-workshop/26-3-web-gallery-v2.png)
*Figure: Image Vault displaying APPROVED (beer bottle) and REJECTED (wooden toy gun) classifications*

### 4. Moderated Public Feed
Displays verified safe images that passed automated Amazon Rekognition moderation and were published by users to the community feed.

![ImageGuard Public Feed](../../images/5-workshop/26-4-web-feed-v2.png)
*Figure: ImageGuard Public Feed interface on desktop PC*

---

## Video script (5–7 minutes)

| Time | Content |
|---|---|
| 0:00 | The problem and the architecture diagram (section 5.3) |
| 1:00 | Open the site via CloudFront → sign in / sign up with Cognito |
| 2:00 | Upload a beer image → **APPROVED** within seconds, labels shown |
| 2:45 | Upload the toy gun → **REJECTED**, open the alert email (mention the false positive) |
| 3:30 | DynamoDB: the item has `userId` = `sub`, `moderationLabels`, `labels` |
| 4:00 | CloudWatch dashboard: APPROVED/REJECTED counts, processing time, alarms |
| 4:45 | Security: API without a token → 401; direct S3 access → AccessDenied |
| 5:30 | Cost: AWS Pricing Calculator, USD 8.37/month |
| 6:00 | Summary and next steps (admin review of REJECTED images, AWS WAF, presigned POST with a size limit) |
