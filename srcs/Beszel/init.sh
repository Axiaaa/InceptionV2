AGENT_NAME=$(hostname)
AGENT_HOST=$(ip route get 8.8.8.8 | awk -F"src " 'NR==1{split($2,a," ");print a[1]}')
AGENT_PORT=45876

AUTH_USER=$(curl -s -X POST "$HUB_URL/api/collections/users/auth-with-password" \
  -H "Content-Type: application/json" \
  -d "{\"identity\": \"$ADMIN_EMAIL\", \"password\": \"$ADMIN_PASSWORD\"}")


TOKEN=$(echo "$AUTH_USER" | jq -r '.token')
ID=$(echo "$AUTH_USER" | jq -r '.record.id')

echo $AUTH_USER $TOKEN $ID
AGENT_KEY=$(curl -s GET "$HUB_URL/api/beszel/getkey" \
  -H "Authorization: $TOKEN")
RESPONSE=$(curl -s -X POST "$HUB_URL/api/collections/systems/records" \
  -H "Authorization: $TOKEN" \
  -H "Content-Type: application/json" \
  -d "{
    \"name\": \"$AGENT_NAME\",
    \"host\": \"$AGENT_HOST\",
    \"port\": \"$AGENT_PORT\",
    \"users\": [\"$ID\"]
  }")

AGENT_KEY=$(echo "$AGENT_KEY" | jq -r '.key')
echo $AGENT_KEY $TOKEN
echo "Token and key sucessfuly created!"

./beszel-agent -key "$AGENT_KEY" -token "$TOKEN" -url "$HUB_URL"
