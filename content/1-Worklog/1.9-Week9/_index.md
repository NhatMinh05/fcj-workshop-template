---
title: "Week 9 Worklog"
date: 2026-09-14
weight: 9
chapter: false
pre: " <b> 1.9. </b> "
---

### Week 9 Objectives:

* Implement asynchronous messaging with Amazon SNS and Amazon SQS
* Add user authentication to web apps using Amazon Cognito
* Explore pre-trained AI services and Amazon Bedrock models
* Orchestrate multi-step workflows with AWS Step Functions
* Build event-driven data processing with S3, Lambda, and DynamoDB

### Tasks to be carried out this week:

| Day | Task | Start Date | Completion Date | Reference Material |
| --- | --- | --- | --- | --- |
| 2 | - Create Amazon SNS topic and Amazon SQS queues<br>- Subscribe SQS queues to SNS topic to build pub/sub messaging<br>- Send test messages and verify queue processing with Dead-Letter Queues | 09/11/2026 | 09/11/2026 | https://000054.awsfcaj.com/ |
| 3 | - Create Amazon Cognito User Pool with email sign-up and password policy<br>- Create an App Client and test user registration and login<br>- Verify user ID token and access token in sample web client | 10/11/2026 | 10/11/2026 | https://000055.awsfcaj.com/ |
| 4 | - Test Amazon Rekognition to detect objects and faces in images<br>- Test Amazon Comprehend to analyze sentiment in customer reviews<br>- Test Amazon Bedrock foundation models with prompt playground | 11/11/2026 | 11/11/2026 | https://000056.awsfcaj.com/ |
| 5 | - Create a visual state machine workflow in AWS Step Functions<br>- Add task states to call AWS Lambda functions sequentially<br>- Configure error handling and retry logic in Step Functions | 12/11/2026 | 12/11/2026 | https://000047.awsfcaj.com/ |
| 6 | - Configure S3 bucket event to trigger Lambda on file upload<br>- Process uploaded data and write summary records to DynamoDB<br>- Watch FCAJ YouTube Lessons 211 - 235 | 13/11/2026 | 13/11/2026 | https://000078.awsfcaj.com/ <br> https://www.youtube.com/@AWSStudyGroup |

### Week 9 Achievements:

* Built asynchronous pub/sub messaging pipelines with SNS and SQS
* Added secure user sign-up and authentication using Amazon Cognito
* Explored pre-trained AI services (Rekognition, Comprehend) and Bedrock
* Orchestrated multi-step serverless tasks using AWS Step Functions
* Built event-driven data processing with S3, Lambda, and DynamoDB

AWS services used:

* Amazon SNS
* Amazon SQS
* Amazon Cognito
* Amazon Bedrock & AI Services
* AWS Step Functions
* AWS Lambda & Amazon DynamoDB

Skills gained:

* Asynchronous messaging and queue-based decoupling
* User identity management and authentication
* AI and Generative AI service exploration on AWS
* Serverless state machine workflow design
