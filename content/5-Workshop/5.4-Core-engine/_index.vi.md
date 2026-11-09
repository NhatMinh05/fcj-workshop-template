---
title: "Xây dựng Lõi Kiểm toán Lambda & API Gateway"
date: 2024-01-01
weight: 4
chapter: false
pre: " <b> 5.4. </b> "
---

# 5.4 Xây dựng Lõi Kiểm toán Lambda & API Gateway

Sau khi đã có kho tri thức RAG trên Bedrock, bước quan trọng tiếp theo là xây dựng **Trái tim tính toán Serverless** của hệ thống: **AWS Lambda Core Audit Engine** và mở cổng giao tiếp **Amazon API Gateway (HTTP API)** để tiếp nhận yêu cầu kiểm toán từ bên ngoài.

---

### Bước 1: Viết Mã Nguồn Lambda Core Engine (Python 3.12)

Hàm Lambda sẽ thực hiện quy trình nghiệp vụ:
1. Nhận chuỗi mã nguồn Terraform HCL từ body của HTTP request (`POST /scan`).
2. Định dạng câu lệnh ngữ nghĩa (Prompt) kèm hướng dẫn Guardrails nghiêm ngặt, gọi API `retrieve_and_generate` của **Bedrock Agent Runtime**.
3. RAG Engine sẽ tự động trích xuất các điều khoản CIS tương ứng từ Knowledge Base và chuyển cho Claude 3.5 Sonnet suy luận.
4. Bóc tách kết quả phân tích: Điểm an ninh (0-100), danh sách lỗ hổng, mức độ nghiêm trọng và đoạn mã Terraform đã sửa lỗi.
5. Lưu bản ghi kiểm toán vào bảng DynamoDB `CloudGuard_ScanHistory`.
6. Trả về phản hồi JSON chuẩn RESTful API cho client.

1. Tạo tệp mã nguồn `lambda_function.py`:
```python
import json
import os
import uuid
import datetime
import boto3

# Khởi tạo các AWS SDK clients
bedrock_agent_runtime = boto3.client('bedrock-agent-runtime', region_name=os.environ.get('AWS_REGION', 'ap-southeast-1'))
dynamodb = boto3.resource('dynamodb', region_name=os.environ.get('AWS_REGION', 'ap-southeast-1'))

KNOWLEDGE_BASE_ID = os.environ.get('KNOWLEDGE_BASE_ID')
MODEL_ARN = os.environ.get('MODEL_ARN', 'arn:aws:bedrock:ap-southeast-1::foundation-model/anthropic.claude-3-5-sonnet-20240620-v1:0')
TABLE_NAME = os.environ.get('DYNAMODB_TABLE', 'CloudGuard_ScanHistory')
table = dynamodb.Table(TABLE_NAME)

def lambda_handler(event, context):
    try:
        # 1. Parse body từ API Gateway
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

        # 2. Xây dựng Prompt đối chiếu tri thức CIS Benchmark
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

        # 3. Gọi Bedrock Knowledge Base RAG
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

        # Làm sạch nếu AI vô tình bọc trong ```json
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

        # 4. Lưu kết quả vào DynamoDB
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

        # 5. Trả về kết quả
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

2. Nén tệp mã nguồn vào file `function.zip`:
```bash
zip function.zip lambda_function.py
```

---

### Bước 2: Khởi Tạo AWS Lambda Function

1. Triển khai hàm Lambda bằng AWS CLI:
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

*(Lưu ý: Thay thế `YOUR_KB_ID_HERE` bằng mã **Knowledge Base ID** bạn đã sao chép ở bài 5.3).*

2. Nếu cần cập nhật lại biến môi trường sau khi tạo:
```bash
aws lambda update-function-configuration \
    --function-name cloudguard-core-audit-engine \
    --environment "Variables={KNOWLEDGE_BASE_ID=${KNOWLEDGE_BASE_ID},DYNAMODB_TABLE=CloudGuard_ScanHistory,AWS_REGION=${AWS_REGION}}" \
    --region ${AWS_REGION}
```

---

### Bước 3: Tạo Amazon API Gateway (HTTP API)

Chúng ta cung cấp điểm cuối RESTful API cho phép giao diện web hoặc đường ống CI/CD gọi hàm Lambda:

1. Tạo một HTTP API mới có tên `CloudGuard-API`:
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

2. Tạo Integration liên kết API Gateway tới hàm Lambda vừa tạo:
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

3. Tạo Route `POST /scan` gắn với Integration:
```bash
aws apigatewayv2 create-route \
    --api-id ${API_ID} \
    --route-key "POST /scan" \
    --target "integrations/${INTEGRATION_ID}" \
    --region ${AWS_REGION}
```

4. Cấp quyền cho API Gateway invoke hàm Lambda:
```bash
aws lambda add-permission \
    --function-name cloudguard-core-audit-engine \
    --statement-id "apigateway-invoke-permission" \
    --action "lambda:InvokeFunction" \
    --principal "apigateway.amazonaws.com" \
    --source-arn "arn:aws:execute-api:${AWS_REGION}:${AWS_ACCOUNT_ID}:${API_ID}/*/*/scan" \
    --region ${AWS_REGION}
```

5. Tạo Stage `$default` tự động deploy các thay đổi:
```bash
aws apigatewayv2 create-stage \
    --api-id ${API_ID} \
    --stage-name '$default' \
    --auto-deploy \
    --region ${AWS_REGION}
```

Endpoint kiểm toán của bạn sẽ có dạng:
```
https://${API_ID}.execute-api.${AWS_REGION}.amazonaws.com/scan
```

---

### Bước 4: Kiểm Thử Gọi API Quét Mã Bằng cURL

Bây giờ chúng ta sẽ gửi một đoạn mã Terraform cố tình chứa 2 lỗ hổng an ninh nghiêm trọng:
1. `aws_security_group` mở cổng SSH 22 ra `0.0.0.0/0`.
2. `aws_s3_bucket` không bật mã hóa mặc định.

1. Chạy lệnh cURL:
```bash
curl -X POST "https://${API_ID}.execute-api.${AWS_REGION}.amazonaws.com/scan" \
  -H "Content-Type: application/json" \
  -d '{
    "terraform_code": "resource \"aws_security_group\" \"web\" { name = \"web-sg\" ingress { from_port = 22 to_port = 22 protocol = \"tcp\" cidr_blocks = [\"0.0.0.0/0\"] } }\nresource \"aws_s3_bucket\" \"data\" { bucket = \"my-company-confidential-bucket\" }"
  }'
```

2. Quan sát kết quả trả về trong tích tắc:
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

3. Kiểm tra xem dữ liệu đã được ghi vào bảng DynamoDB hay chưa:
```bash
aws dynamodb scan --table-name CloudGuard_ScanHistory --max-items 1 --region ${AWS_REGION}
```

Tuyệt vời! Hàm Lambda và API Gateway đã hoạt động ăn khớp 100%. Ở bài tiếp theo, chúng ta sẽ kết nối API này với **Web Dashboard trực quan và Lập lịch quét tự động EventBridge**!