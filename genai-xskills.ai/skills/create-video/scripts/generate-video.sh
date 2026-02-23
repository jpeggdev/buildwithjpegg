#!/usr/bin/env bash
# generate-video.sh -- Create a video via xskills.ai API and poll for result
#
# Usage: bash generate-video.sh <model> <prompt> [ratio] [duration] [image_urls...]
#
# Arguments:
#   model       - Model ID (required, e.g., st-ai/super-seed2)
#   prompt      - Video generation prompt (required)
#   ratio       - Aspect ratio (default: 16:9)
#   duration    - Duration in seconds (default: 5)
#   image_urls  - Optional image URLs for reference (remaining args)
#
# Environment:
#   XSKILL_API_KEY - API key (required)
#
# Output: JSON result with video URLs on success, error message on failure

set -euo pipefail

API_BASE="https://api.sutui.cc/api/v3"
MODEL="${1:?Usage: generate-video.sh <model> <prompt> [ratio] [duration] [image_urls...]}"
PROMPT="${2:?Usage: generate-video.sh <model> <prompt> [ratio] [duration] [image_urls...]}"
RATIO="${3:-16:9}"
DURATION="${4:-5}"
shift 4 2>/dev/null || true
IMAGE_URLS=("$@")

if [ -z "${XSKILL_API_KEY:-}" ]; then
  echo "Error: XSKILL_API_KEY environment variable is not set" >&2
  exit 1
fi

# Build request payload with Python for reliable JSON construction
echo "Creating video task with model: $MODEL, duration: ${DURATION}s, ratio: $RATIO" >&2
if [ ${#IMAGE_URLS[@]} -gt 0 ]; then
  echo "Reference images: ${#IMAGE_URLS[@]}" >&2
fi

CREATE_RESPONSE=$(python3 -c "
import json, sys

model = sys.argv[1]
prompt = sys.argv[2]
ratio = sys.argv[3]
duration = int(sys.argv[4])
image_urls = sys.argv[5:]

params = {
    'prompt': prompt,
    'duration': duration
}

# Model-specific parameter mapping
if model == 'st-ai/super-seed2':
    params['model'] = 'seedance_2.0_fast'
    params['functionMode'] = 'omni_reference'
    params['ratio'] = ratio
    if image_urls:
        params['image_files'] = image_urls
elif model.startswith('fal-ai/sora-2'):
    params['aspect_ratio'] = ratio
    params['resolution'] = '720p'
    params['model'] = 'sora-2'
else:
    params['aspect_ratio'] = ratio

payload = {'model': model, 'params': params}
print(json.dumps(payload))
" "$MODEL" "$PROMPT" "$RATIO" "$DURATION" "${IMAGE_URLS[@]+"${IMAGE_URLS[@]}"}")

RESPONSE=$(curl -s -X POST "$API_BASE/tasks/create" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $XSKILL_API_KEY" \
  -d "$CREATE_RESPONSE")

# Extract task_id
TASK_ID=$(python3 -c "
import json, sys
data = json.loads(sys.argv[1])
if data.get('code') != 200:
    print('Error: ' + json.dumps(data), file=sys.stderr)
    sys.exit(1)
print(data['data']['task_id'])
" "$RESPONSE")

PRICE=$(python3 -c "
import json, sys
data = json.loads(sys.argv[1])
print(data['data'].get('price', 'unknown'))
" "$RESPONSE")

echo "Task created: $TASK_ID (cost: $PRICE credits)" >&2

# Poll for completion -- video takes longer than images
POLL_INTERVAL=5
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
      python3 -c "
import json, sys
data = json.loads(sys.argv[1])
print(json.dumps(data['data']['result'], indent=2))
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
      ELAPSED=$((i * POLL_INTERVAL))
      echo "Polling ($i/$MAX_POLLS, ${ELAPSED}s elapsed)... status: $STATUS" >&2
      ;;
  esac
done

echo "Error: Timed out waiting for task $TASK_ID after $((MAX_POLLS * POLL_INTERVAL))s" >&2
exit 1
