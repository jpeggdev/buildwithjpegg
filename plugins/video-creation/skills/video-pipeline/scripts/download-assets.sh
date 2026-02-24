#!/usr/bin/env bash
# download-assets.sh -- Download a file from a URL to a local path
#
# Usage: bash download-assets.sh <url> <output_path>
#
# Arguments:
#   url          - URL to download (required)
#   output_path  - Local file path to save to (required)
#
# Creates parent directories if they don't exist.
# Output: The local file path on success, error message on failure.

set -euo pipefail

URL="${1:?Usage: download-assets.sh <url> <output_path>}"
OUTPUT="${2:?Usage: download-assets.sh <url> <output_path>}"

# Create parent directory
mkdir -p "$(dirname "$OUTPUT")"

echo "Downloading: $URL" >&2
echo "       To: $OUTPUT" >&2

HTTP_CODE=$(curl -s -w "%{http_code}" -L -o "$OUTPUT" "$URL")

if [ "$HTTP_CODE" -ge 200 ] && [ "$HTTP_CODE" -lt 300 ]; then
  FILE_SIZE=$(wc -c < "$OUTPUT" | tr -d ' ')
  echo "Downloaded: $OUTPUT ($FILE_SIZE bytes)" >&2
  echo "$OUTPUT"
else
  rm -f "$OUTPUT"
  echo "Error: HTTP $HTTP_CODE downloading $URL" >&2
  exit 1
fi
