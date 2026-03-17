#!/bin/bash
set -e

# Load .env if exists
if [ -f .env ]; then
  export $(grep -v '^#' .env | xargs)
fi

API_KEY="${PROMPTRAILS_API_KEY:?Set PROMPTRAILS_API_KEY in .env}"
GF_PASS="${GF_SECURITY_ADMIN_PASSWORD:-admin}"
GF_URL="${GF_URL:-http://localhost:3333}"

echo "Waiting for Grafana to start..."
until curl -sf -u "admin:${GF_PASS}" "${GF_URL}/api/health" > /dev/null 2>&1; do
  sleep 2
done
echo "Grafana is ready."

echo "Configuring PromptRails datasource..."
curl -sf -X PUT -u "admin:${GF_PASS}" \
  -H "Content-Type: application/json" \
  "${GF_URL}/api/datasources/uid/promptrails" \
  -d "{
    \"name\": \"PromptRails\",
    \"uid\": \"promptrails\",
    \"type\": \"yesoreyeram-infinity-datasource\",
    \"access\": \"proxy\",
    \"url\": \"https://api.promptrails.ai\",
    \"isDefault\": true,
    \"jsonData\": {
      \"allowedHosts\": [\"api.promptrails.ai\"],
      \"httpHeaderName1\": \"X-API-Key\"
    },
    \"secureJsonData\": {
      \"httpHeaderValue1\": \"${API_KEY}\"
    }
  }" > /dev/null

echo ""
echo "Done! Open ${GF_URL}"
echo "Login: admin / ${GF_PASS}"
echo ""
echo "If dashboards show 'URL not allowed', go to:"
echo "  Connections > Data Sources > PromptRails > Security"
echo "  Verify 'api.promptrails.ai' is in Allowed Hosts"
