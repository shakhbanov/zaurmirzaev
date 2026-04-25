#!/usr/bin/env bash
# Submit all URLs from sitemap.xml to IndexNow.
# IndexNow notifies Bing, Yandex, Seznam, Naver and (via the shared endpoint)
# any other participating search engine of fresh / changed URLs in one call.
#
# Usage: bash scripts/indexnow.sh

set -euo pipefail

HOST="zaurmirzaev.ru"
KEY="fbc4eda62d524852a55863f04f6af06a"
KEY_LOCATION="https://${HOST}/${KEY}.txt"
SITEMAP_URL="https://${HOST}/sitemap.xml"
ENDPOINT="https://api.indexnow.org/IndexNow"

echo "Fetching ${SITEMAP_URL} ..."
URLS=$(curl -fsSL "${SITEMAP_URL}" | grep -oE '<loc>[^<]+</loc>' | sed -E 's|</?loc>||g')

if [ -z "${URLS}" ]; then
  echo "No URLs in sitemap." >&2
  exit 1
fi

# Build JSON body
URL_LIST=$(echo "${URLS}" | awk '{ printf "\"%s\",", $0 }' | sed 's/,$//')
BODY=$(cat <<EOF
{
  "host": "${HOST}",
  "key": "${KEY}",
  "keyLocation": "${KEY_LOCATION}",
  "urlList": [${URL_LIST}]
}
EOF
)

echo "Submitting $(echo "${URLS}" | wc -l | tr -d ' ') URL(s) to IndexNow ..."
HTTP_CODE=$(curl -fsS -o /tmp/indexnow.out -w "%{http_code}" \
  -X POST "${ENDPOINT}" \
  -H "Content-Type: application/json; charset=utf-8" \
  -d "${BODY}" || echo "fail")

echo "HTTP ${HTTP_CODE}"
[ -s /tmp/indexnow.out ] && cat /tmp/indexnow.out || true

# 200 — accepted, 202 — accepted (will validate), 422/400/403 — error.
case "${HTTP_CODE}" in
  200|202) echo "OK"; exit 0 ;;
  *)       echo "IndexNow rejected the request" >&2; exit 1 ;;
esac
