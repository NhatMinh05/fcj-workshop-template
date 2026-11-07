---
title: "Week 9 Worklog"
date: 2026-11-09
weight: 9
chapter: false
pre: " <b> 1.9. </b> "
---

### Week 9 Objectives:

* Implement asynchronous messaging with Amazon SNS and Amazon SQS
* Add user authentication to Single Page Apps using Amazon Cognito
* Explore pre-trained AI services and Amazon Bedrock models
* Orchestrate multi-step workflows with AWS Step Functions
* Build event-driven data processing with S3, Lambda, and DynamoDB

### Tasks to be carried out this week:

| Day | Task | Start Date | Completion Date | Reference Material |
| --- | --- | --- | --- | --- |
| 2 | - Create Amazon SNS topics and Amazon SQS queues with dead-letter queues (DLQ)<br>- Configure fanout pub/sub pattern broadcasting events to multiple queues<br>- Implement message deduplication, FIFO ordering, and batch processing | 09/11/2026 | 09/11/2026 | https://000054.awsfcaj.com/ |
| 3 | - Create Amazon Cognito User Pool with email verification and MFA<br>- Configure App Client and OAuth 2.0 authorization code grant flow<br>- Integrate JWT token verification in Single Page Application frontend | 10/11/2026 | 10/11/2026 | https://000055.awsfcaj.com/ |
| 4 | - Test Amazon Rekognition image label detection and facial analysis APIs<br>- Run Amazon Comprehend sentiment analysis and entity extraction on reviews<br>- Test Amazon Bedrock Claude foundation model invocation via SDK | 11/11/2026 | 11/11/2026 | https://000056.awsfcaj.com/ |
| 5 | - Design visual Step Functions state machine with Parallel and Choice states<br>- Implement automated error retries, catch blocks, and task timeouts<br>- Integrate human-in-the-loop approval task using SNS email tokens | 12/11/2026 | 12/11/2026 | https://000047.awsfcaj.com/ |
| 6 | - Configure S3 ObjectCreated event triggering Python Lambda function<br>- Process uploaded files and write structured metadata to DynamoDB<br>- Watch FCAJ YouTube Lessons 211 - 235 | 13/11/2026 | 13/11/2026 | https://000078.awsfcaj.com/ <br> https://www.youtube.com/@AWSStudyGroup |

### Week 9 Achievements:

* Built pub/sub fanout messaging using Amazon SNS and SQS queues
* Added user registration, login, and JWT verification with Amazon Cognito
* Tested Amazon Rekognition, Comprehend, and Amazon Bedrock foundation models
* Created visual serverless state machines using AWS Step Functions
* Automated file processing pipelines with S3 events, Lambda, and DynamoDB

AWS services used:

* Amazon Simple Notification Service (SNS)
* Amazon Simple Queue Service (SQS)
* Amazon Cognito
* Amazon Bedrock & AI Services
* AWS Step Functions
* AWS Lambda & Amazon DynamoDB

Skills gained:

* Decoupled asynchronous event messaging
* User authentication and authorization workflows
* Managed AI and generative AI model consumption
* Serverless workflow orchestration and error handling
