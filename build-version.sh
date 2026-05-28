#!/usr/bin/env bash
# Injeta versao nos placeholders __VERSION_FRIENDLY__ e __VERSION_DETAIL__
# nos arquivos HTML antes do deploy no Vercel.
set -e

SHA="${VERCEL_GIT_COMMIT_SHA:-local}"
SHORT_SHA="${SHA:0:7}"
BRANCH="${VERCEL_GIT_COMMIT_REF:-local}"
ENV_NAME="${VERCEL_ENV:-development}"

# Data amigavel em BRT, formato pt-BR (ex.: "28/mai - 09:35")
PT_MONTHS=(jan fev mar abr mai jun jul ago set out nov dez)
MONTH_NUM=$(TZ='America/Sao_Paulo' date +%-m)
MONTH_NAME="${PT_MONTHS[$((MONTH_NUM - 1))]}"
FRIENDLY=$(TZ='America/Sao_Paulo' date +"%-d/${MONTH_NAME} - %H:%M")

DETAIL="${SHORT_SHA} | ${BRANCH} | ${ENV_NAME}"

echo "Versao amigavel : ${FRIENDLY}"
echo "Detalhe tecnico : ${DETAIL}"

for f in index.html como-aplicar-no-gmail.html; do
  if [ -f "$f" ]; then
    sed -i "s|__VERSION_FRIENDLY__|${FRIENDLY}|g" "$f"
    sed -i "s|__VERSION_DETAIL__|${DETAIL}|g" "$f"
    echo "  -> $f atualizado"
  fi
done
