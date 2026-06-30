#!/usr/bin/env bash
# Injeta a versão amigável (data BRT em pt-BR) + detalhe técnico
# (SHA · branch · env · timestamp UTC) nos arquivos HTML antes do deploy.
set -e

SHA="${VERCEL_GIT_COMMIT_SHA:-local}"
SHORT_SHA="${SHA:0:7}"
BRANCH="${VERCEL_GIT_COMMIT_REF:-local}"
ENV_NAME="${VERCEL_ENV:-development}"

# Data amigável em BRT, formato pt-BR (ex.: "28/mai · 09:35")
PT_MONTHS=(jan fev mar abr mai jun jul ago set out nov dez)
MONTH_NUM=$(TZ='America/Sao_Paulo' date +%m)
IDX=$((10#${MONTH_NUM} - 1))
DAY=$(TZ='America/Sao_Paulo' date +%-d)
TIME=$(TZ='America/Sao_Paulo' date +%H:%M)
FRIENDLY="${DAY}/${PT_MONTHS[${IDX}]} · ${TIME}"

# Em preview, anexa o ambiente no fim ("preview")
if [ "${ENV_NAME}" != "production" ]; then
  FRIENDLY="${FRIENDLY} · ${ENV_NAME}"
fi

# Detalhe técnico (vai pro title attribute / hover)
BUILT_UTC="$(date -u '+%Y-%m-%d %H:%M')"
DETAIL="${SHORT_SHA} · ${BRANCH} · ${ENV_NAME} · ${BUILT_UTC} UTC"

echo "Friendly: ${FRIENDLY}"
echo "Detail:   ${DETAIL}"

for f in index.html como-aplicar-no-gmail.html; do
  if [ -f "$f" ]; then
    sed -i "s|__VERSION_FRIENDLY__|${FRIENDLY}|g; s|__VERSION_DETAIL__|${DETAIL}|g" "$f"
    echo "  ✓ $f"
  fi
done
