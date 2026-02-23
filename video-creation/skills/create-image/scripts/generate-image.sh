#!/usr/bin/env bash
# generate-image.sh -- Create an image via xskills.ai API and poll for result
#
# Usage: bash generate-image.sh <prompt> [model] [image_size] [num_images]
#
# Arguments:
#   prompt      - Image generation prompt (required)
#   model       - Model ID (default: fal-ai/flux-2/flash)
#   image_size  - Size preset (default: landscape_4_3)
#   num_images  - Number of images (default: 1)
#
# Environment:
#   XSKILL_API_KEY - API key (required)
#
# Output: JSON result with image URLs on success, error message on failure

set -euo pipefail

API_BASE="https://api.xskill.ai/api/v3"
PROMPT="${1:?Usage: generate-image.sh <prompt> [model] [image_size] [num_images]}"
MODEL="${2:-fal-ai/flux-2/flash}"
IMAGE_SIZE="${3:-landscape_4_3}"
NUM_IMAGES="${4:-1}"

if [ -z "${XSKILL_API_KEY:-}" ]; then
  echo "Error: XSKILL_API_KEY environment variable is not set" >&2
  exit 1
fi

# Create task
echo "Creating image task with model: $MODEL" >&2
CREATE_RESPONSE=$(curl -s -X POST "$API_BASE/tasks/create" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $XSKILL_API_KEY" \
  -d "$(python3 -c "
import json, sys
print(json.dumps({
    'model': '$MODEL',
    'params': {
        'prompt': sys.argv[1],
        'image_size': '$IMAGE_SIZE',
        'num_images': int('$NUM_IMAGES')
    }
}))
" "$PROMPT")")

# Extract task_id
TASK_ID=$(python3 -c "
import json, sys
data = json.loads(sys.argv[1])
if data.get('code') != 200:
    print('Error: ' + json.dumps(data), file=sys.stderr)
    sys.exit(1)
print(data['data']['task_id'])
" "$CREATE_RESPONSE")

PRICE=$(python3 -c "
import json, sys
data = json.loads(sys.argv[1])
print(data['data'].get('price', 'unknown'))
" "$CREATE_RESPONSE")

echo "Task created: $TASK_ID (cost: $PRICE credits)" >&2

# Poll for completion
POLL_INTERVAL=3
MAX_POLLS=60

for i in $(seq 1 $MAX_POLLS); do
  sleep $POLL_INTERVAL

  QUERY_RESPONSE=$(curl -s -X POST "$API_BASE/tasks/query" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $XSKILL_API_KEY" \
    -d "{\"task_id\": \"$TASK_ID\"}")

  STATUS=$(python3 -c "
import json, sys
data = json.loads(sys.argv[1])
print(data.get('data', {}).get('status', 'unknown'))
" "$QUERY_RESPONSE")

  case "$STATUS" in
    completed|success)
      echo "Task completed." >&2
      # Output the full result JSON
      python3 -c "
import json, sys
data = json.loads(sys.argv[1])
print(json.dumps(data['data']['output'], indent=2))
" "$QUERY_RESPONSE"
      exit 0
      ;;
    failed|error)
      echo "Task failed." >&2
      python3 -c "
import json, sys
data = json.loads(sys.argv[1])
print(json.dumps(data.get('data', {}), indent=2))
" "$QUERY_RESPONSE" >&2
      exit 1
      ;;
    *)
      echo "Polling ($i/$MAX_POLLS)... status: $STATUS" >&2
      ;;
  esac
done

echo "Error: Timed out waiting for task $TASK_ID" >&2
exit 1
