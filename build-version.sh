#!/usr/bin/env bash
set -e
SHA="${VERCEL_GIT_COMMIT_SHA:-local}"
SHORT_SHA="${SHA:0:7}"
BRANCH="${VERCEL_GIT_COMMIT_REF:-local}"
ENV_NAME="${VERCEL_ENV:-development}"
BUILT_AT="$(date -u +%Y-%m-%d\ %H:%M)"
VERSION="${SHORT_SHA} · ${BRANCH} · ${ENV_NAME} · ${BUILT_AT} UTC"

echo "Injecting version: ${VERSION}"
for f in index.html como-aplicar-no-gmail.html; do
  if [ -f "$f" ]; then
    sed -i "s|__VERSION__|${VERSION}|g" "$f"
    echo "  ✓ $f"
  fi
done
