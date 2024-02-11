#!/bin/sh

echo "Lookup email input parameter: $LOOKUP_EMAIL"

OUT_FILE=slack-response-output.json
RETRIES=3
MAX_TIME=20
http_response_code=$(curl -s \
  --retry $RETRIES \
  --max-time $MAX_TIME \
  -H "Authorization: Bearer $SLACK_TOKEN" \
  -H 'Accept: application/json' \
  --data-urlencode "email=$LOOKUP_EMAIL" \
  "https://slack.com/api/users.lookupByEmail" \
  -o $OUT_FILE \
  -w "%{http_code}" \
)

echo "HTTP response code from curl is $http_response_code"
if [ $http_response_code -eq 200 ]; then
  # check anyway if we the output file
  if [ ! -f "$OUT_FILE" ]; then
      echo "::error::No response generated but request was 200"
      exit 1
  fi
  # Check if the response contains {"ok":true...
  is_ok=$(jq '.ok' "$OUT_FILE")
  if [ "$is_ok" = "true" ]; then
      profile=$(jq '.user' "$OUT_FILE")
      echo "slack-profile-info=$profile" >> $GITHUB_OUTPUT
      exit 0
  else
      slack_error=$(jq '.error' "$OUT_FILE")
      echo "::error::Slack API returned an error: $slack_error"
      exit 2
  fi
else # 000 if any other kind of error
  echo "::error::curl unsuccesful or non-200 HTTP response code from Slack ($http_response_code)"
  exit 3
fi
