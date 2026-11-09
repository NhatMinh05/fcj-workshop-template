---
title: "Building Lambda Core Engine & API Gateway"
date: 2024-01-01
weight: 4
chapter: false
pre: " <b> 5.4. </b> "
---

# 5.4 Building Lambda Core Engine & API Gateway

With our RAG Knowledge Base online, we now build the **Serverless Compute Heart** of CloudGuard AI: the **AWS Lambda Core Audit Engine** exposed via a high-throughput **Amazon API Gateway (HTTP API)**.

---

### Step 1: Write Lambda Core Engine Logic (Python 3.12)

The Lambda handler executes an automated pipeline:
1. Ingests raw Terraform HCL from the HTTP POST payload (`POST /scan`).
2. Constructs a strict prompt with safety instructions and calls the `retrieve_and_generate` API in **Bedrock Agent Runtime**.
3. Bedrock automatically queries the Knowledge Base, extracts CIS rules, and prompts Claude 3.5 Sonnet to deduce violations.
4. Parses structured responses: Compliance Score (0-100), severity-graded finding objects, and remediated HCL code.
5. Persists the audit record into DynamoDB (`CloudGuard_ScanHistory`).
6. Emits a clean RESTful JSON response.

1. Create `lambda_function.py`:
```python
import json
import os
import uuid
import datetime
import boto3

bedrock_agent_runtime = boto3.client('bedrock-agent-runtime', region_name=os.environ.get('AWS_REGION', 'ap-southeast-1'))
dynamodb = boto3.resource('dynamodb', region_name=os.environ.get('AWS_REGION', 'ap-southeast-1'))

KNOWLEDGE_BASE_ID = os.environ.get('KNOWLEDGE_BASE_ID')
MODEL_ARN = os.environ.get('MODEL_ARN', 'arn:aws:bedrock:ap-southeast-1::foundation-model/anthropic.claude-3-5-sonnet-20240620-v1:0')
TABLE_NAME = os.environ.get('DYNAMODB_TABLE', 'CloudGuard_ScanHistory')
table = dynamodb.Table(TABLE_NAME)

def lambda_handler(event, context):
    try:
        body = event.get('body', {})
        if isinstance(body, str):
            body = json.loads(body)
        
        terraform_code = body.get('terraform_code', '')
        if not terraform_code.strip():
            return {
                "statusCode": 400,
                "headers": {"Content-Type": "application/json", "Access-Control-Allow-Origin": "*"},
                "body": json.dumps({"error": "Missing 'terraform_code' in request payload."})
            }

        scan_id = str(uuid.uuid4())
        scan_time = datetime.datetime.utcnow().isoformat() + "Z"

        query_prompt = f"""
You are CloudGuard AI, an elite DevSecOps & FinOps infrastructure security auditor.
Audit the following Terraform code strictly against the CIS AWS Foundations Benchmark v3.0 retrieved from the Knowledge Base:

```hcl
{terraform_code}
```

Instructions:
1. Identify all security misconfigurations (e.g. open ports 22/3389 to 0.0.0.0/0, unencrypted S3 buckets, public S3 access, wildcard IAM privileges).
2. Rate compliance score from 0 (extremely insecure) to 100 (flawless).
3. Return output strictly as a valid JSON object matching this structure:
{{
  "score": 65,
  "summary": "Short executive summary of findings",
  "findings": [
    {{
      "rule_id": "CIS-4.1",
      "severity": "CRITICAL",
      "resource": "aws_security_group.web_sg",
      "description": "Port 22 SSH open to 0.0.0.0/0",
      "recommendation": "Restrict to internal VPN CIDR."
    }}
  ],
  "remediated_code": "Full corrected Terraform code snippet"
}}
Return ONLY the raw JSON object, without any markdown backticks or preamble.
"""

        response = bedrock_agent_runtime.retrieve_and_generate(
            input={'text': query_prompt},
            retrieveAndGenerateConfiguration={
                'type': 'KNOWLEDGE_BASE',
                'knowledgeBaseConfiguration': {
                    'knowledgeBaseId': KNOWLEDGE_BASE_ID,
                    'modelArn': MODEL_ARN,
                    'generationConfiguration': {
                        'inferenceConfig': {
                            'textInferenceConfig': {
                                'maxTokens': 2500,
                                'temperature': 0.1,
                                'topP': 0.9
                            }
                        }
                    }
                }
            }
        )

        generated_text = response['output']['text'].strip()

        if generated_text.startswith("```json"):
            generated_text = generated_text[7:]
        if generated_text.startswith("```"):
            generated_text = generated_text[3:]
        if generated_text.endswith("```"):
            generated_text = generated_text[:-3]
        generated_text = generated_text.strip()

        audit_result = json.loads(generated_text)
        audit_result['scan_id'] = scan_id
        audit_result['scanned_at'] = scan_time

        table.put_item(
            Item={
                'scan_id': scan_id,
                'scanned_at': scan_time,
                'score': int(audit_result.get('score', 0)),
                'summary': audit_result.get('summary', ''),
                'findings_count': len(audit_result.get('findings', [])),
                'findings': json.dumps(audit_result.get('findings', [])),
                'remediated_code': audit_result.get('remediated_code', '')
            }
        )

        return {
            "statusCode": 200,
            "headers": {
                "Content-Type": "application/json",
                "Access-Control-Allow-Origin": "*",
                "Access-Control-Allow-Methods": "POST, OPTIONS",
                "Access-Control-Allow-Headers": "Content-Type"
            },
            "body": json.dumps(audit_result)
        }

    except Exception as e:
        print(f"Error during audit: {str(e)}")
        return {
            "statusCode": 500,
            "headers": {"Content-Type": "application/json", "Access-Control-Allow-Origin": "*"},
            "body": json.dumps({"error": str(e)})
        }
```

2. Package the code into a deployment archive:
```bash
zip function.zip lambda_function.py
```

---

### Step 2: Provision the AWS Lambda Function

1. Deploy the serverless function using the AWS CLI:
```bash
aws lambda create-function \
    --function-name cloudguard-core-audit-engine \
    --runtime python3.12 \
    --role arn:aws:iam::${AWS_ACCOUNT_ID}:role/CloudGuard_Lambda_ExecutionRole \
    --handler lambda_function.lambda_handler \
    --zip-file fileb://function.zip \
    --timeout 60 \
    --memory-size 512 \
    --environment "Variables={KNOWLEDGE_BASE_ID=YOUR_KB_ID_HERE,DYNAMODB_TABLE=CloudGuard_ScanHistory}" \
    --region ${AWS_REGION}
```

*(Note: Replace `YOUR_KB_ID_HERE` with your actual Knowledge Base ID from step 5.3).*

---

### Step 3: Create Amazon API Gateway (HTTP API)

1. Provision the HTTP API:
```bash
API_ID=$(aws apigatewayv2 create-api \
    --name CloudGuard-API \
    --protocol-type HTTP \
    --cors-configuration "AllowOrigins=*,AllowMethods=POST,OPTIONS,AllowHeaders=Content-Type" \
    --query "ApiId" \
    --output text \
    --region ${AWS_REGION})

echo "Created API with ID: ${API_ID}"
```

2. Bind the integration proxy to our Lambda ARN:
```bash
LAMBDA_ARN=$(aws lambda get-function --function-name cloudguard-core-audit-engine --query "Configuration.FunctionArn" --output text --region ${AWS_REGION})

INTEGRATION_ID=$(aws apigatewayv2 create-integration \
    --api-id ${API_ID} \
    --integration-type AWS_PROXY \
    --integration-uri ${LAMBDA_ARN} \
    --payload-format-version "2.0" \
    --query "IntegrationId" \
    --output text \
    --region ${AWS_REGION})
```

3. Expose the `POST /scan` route:
```bash
aws apigatewayv2 create-route \
    --api-id ${API_ID} \
    --route-key "POST /scan" \
    --target "integrations/${INTEGRATION_ID}" \
    --region ${AWS_REGION}
```

4. Grant invocation permissions to API Gateway:
```bash
aws lambda add-permission \
    --function-name cloudguard-core-audit-engine \
    --statement-id "apigateway-invoke-permission" \
    --action "lambda:InvokeFunction" \
    --principal "apigateway.amazonaws.com" \
    --source-arn "arn:aws:execute-api:${AWS_REGION}:${AWS_ACCOUNT_ID}:${API_ID}/*/*/scan" \
    --region ${AWS_REGION}
```

5. Deploy the `$default` auto-deployment stage:
```bash
aws apigatewayv2 create-stage \
    --api-id ${API_ID} \
    --stage-name '$default' \
    --auto-deploy \
    --region ${AWS_REGION}
```

Your live RESTful endpoint is:
```
https://${API_ID}.execute-api.${AWS_REGION}.amazonaws.com/scan
```

---

### Step 4: Validate the API with cURL

We test the endpoint with a snippet containing 2 severe misconfigurations:
1. Public SSH port 22 open to `0.0.0.0/0`.
2. Unencrypted S3 bucket.

1. Execute the curl request:
```bash
curl -X POST "https://${API_ID}.execute-api.${AWS_REGION}.amazonaws.com/scan" \
  -H "Content-Type: application/json" \
  -d '{
    "terraform_code": "resource \"aws_security_group\" \"web\" { name = \"web-sg\" ingress { from_port = 22 to_port = 22 protocol = \"tcp\" cidr_blocks = [\"0.0.0.0/0\"] } }\nresource \"aws_s3_bucket\" \"data\" { bucket = \"my-company-confidential-bucket\" }"
  }'
```

2. Inspect the synthesized compliance report:
```json
{
  "scan_id": "c71a39f2-b892-48f5-961d-72fb68912803",
  "scanned_at": "2026-11-09T09:45:00Z",
  "score": 45,
  "summary": "Discovered 2 high-severity violations against CIS AWS Foundations Benchmark v3.0.",
  "findings": [
    {
      "rule_id": "CIS-4.1",
      "severity": "CRITICAL",
      "resource": "aws_security_group.web",
      "description": "Port 22 SSH is open to 0.0.0.0/0, allowing unauthorized remote brute-force attacks.",
      "recommendation": "Restrict inbound traffic to designated corporate CIDR blocks or migrate to AWS Systems Manager Session Manager."
    },
    {
      "rule_id": "CIS-2.1.1",
      "severity": "HIGH",
      "resource": "aws_s3_bucket.data",
      "description": "Default server-side encryption is absent on S3 bucket.",
      "recommendation": "Attach aws_s3_bucket_server_side_encryption_configuration with SSE-S3 or KMS."
    }
  ],
  "remediated_code": "resource \"aws_security_group\" \"web\" {\n  name = \"web-sg\"\n  ingress {\n    from_port   = 22\n    to_port     = 22\n    protocol    = \"tcp\"\n    cidr_blocks = [\"10.0.0.0/16\"]\n  }\n}\n\nresource \"aws_s3_bucket\" \"data\" {\n  bucket = \"my-company-confidential-bucket\"\n}\n\nresource \"aws_s3_bucket_server_side_encryption_configuration\" \"data_enc\" {\n  bucket = aws_s3_bucket.data.id\n  rule {\n    apply_server_side_encryption_by_default {\n      sse_algorithm = \"AES256\"\n    }\n  }\n}"
}
```

3. Confirm persistence in DynamoDB:
```bash
aws dynamodb scan --table-name CloudGuard_ScanHistory --max-items 1 --region ${AWS_REGION}
```

The core serverless engine is operating with 100% precision. Next, we build the **Interactive Web Dashboard and EventBridge Automated Scheduler**!