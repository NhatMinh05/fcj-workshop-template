#!/usr/bin/env bash
# ==============================================================================
# ImageGuard v2.0 — Nang cap he thong AWS tu Pham-Nhut-An/fcj-workshop (v1.0)
# len NhutTan-May/AWS_product (v2.0: 8 man hinh Dark Mode + 5 Lambdas + GSI Feed)
# Chay truc tiep trong AWS CloudShell (region us-east-1)
# ==============================================================================
set -euo pipefail
export AWS_REGION=us-east-1 AWS_DEFAULT_REGION=us-east-1 AWS_PAGER=""

rm -rf /tmp/AWS_product
git clone https://github.com/NhutTan-May/AWS_product.git /tmp/AWS_product
cd /tmp/AWS_product

# Chay bo script deploy-all.sh cua AWS_product:
# - Tu dong them GSI PublicFeedIndex vao bang DynamoDB imageguard-images
# - Tu dong cap nhat 3 Lambda cu & tao them 2 Lambda moi (publish-image, get-feed)
# - Tu dong them route POST /images/{imageId}/publish va GET /feed vao API Gateway y0bn5zqopj
# - Tu dong ghi config.js that va upload frontend v2.0 len s3://imageguard-web-125022369745
# - Tu dong Invalidate CloudFront https://d2tm9q0ah83pvf.cloudfront.net/
bash scripts/deploy-all.sh

# Mo them CORS & Cognito Callback cho ca domain Vercel (neu muon dung song song)
ACC=$(aws sts get-caller-identity --query Account --output text)
CF_DOMAIN="d2tm9q0ah83pvf.cloudfront.net"
VERCEL_ORIGIN="https://imageguard-web.vercel.app"
API_ID="y0bn5zqopj"
CLIENT_ID="1romckrtso1lsfkpsfnj6i4a4k"
IMG_BUCKET="imageguard-images-${ACC}"
WEB_BUCKET="imageguard-web-${ACC}"

aws apigatewayv2 update-api --api-id "${API_ID}" \
  --cors-configuration "{\"AllowOrigins\":[\"https://${CF_DOMAIN}\",\"${VERCEL_ORIGIN}\"],\"AllowHeaders\":[\"authorization\",\"content-type\"],\"AllowMethods\":[\"GET\",\"POST\",\"OPTIONS\"],\"MaxAge\":300}" >/dev/null

aws s3api put-bucket-cors --bucket "${IMG_BUCKET}" --cors-configuration \
  "{\"CORSRules\":[{\"AllowedOrigins\":[\"https://${CF_DOMAIN}\",\"${VERCEL_ORIGIN}\"],\"AllowedMethods\":[\"PUT\",\"GET\"],\"AllowedHeaders\":[\"content-type\"],\"MaxAgeSeconds\":3000}]}"

POOL_ID=$(aws cognito-idp list-user-pools --max-results 60 --query "UserPools[?Name=='imageguard-users'].Id | [0]" --output text)
aws cognito-idp update-user-pool-client --user-pool-id "${POOL_ID}" --client-id "${CLIENT_ID}" \
  --client-name imageguard-web \
  --allowed-o-auth-flows code --allowed-o-auth-scopes openid email --allowed-o-auth-flows-user-pool-client \
  --supported-identity-providers COGNITO \
  --callback-urls "https://${CF_DOMAIN}/" "${VERCEL_ORIGIN}/" \
  --logout-urls "https://${CF_DOMAIN}/" "${VERCEL_ORIGIN}/" \
  --explicit-auth-flows ALLOW_REFRESH_TOKEN_AUTH \
  --prevent-user-existence-errors ENABLED >/dev/null

# Dung window.location.origin + "/" trong config.js de chay duoc tren ca CloudFront va Vercel
cat > /tmp/config.js <<EOF
window.IMAGEGUARD_CONFIG = {
  cognitoDomain: "https://imageguard-${ACC}.auth.us-east-1.amazoncognito.com",
  clientId: "${CLIENT_ID}",
  redirectUri: window.location.origin + "/",
  apiUrl: "https://${API_ID}.execute-api.us-east-1.amazonaws.com",
};
EOF
aws s3 cp /tmp/config.js "s3://${WEB_BUCKET}/config.js" --content-type "application/javascript; charset=utf-8" --cache-control "no-cache"

DIST_ID=$(aws cloudfront list-distributions --query "DistributionList.Items[?DomainName=='${CF_DOMAIN}'].Id | [0]" --output text)
aws cloudfront create-invalidation --distribution-id "${DIST_ID}" --paths "/*" >/dev/null

echo "=================================================================="
echo "HOAN TAT NANG CAP LEN IMAGEGUARD V2.0 TREN AWS CLOUDFRONT:"
echo "  👉 https://${CF_DOMAIN}/"
echo "=================================================================="
