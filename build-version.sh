#!/usr/bin/env bash
# Injeta versao nos placeholders __VERSION_FRIENDLY__ e __VERSION_DETAIL__
# nos arquivos HTML antes do deploy no Vercel.
set -e

SHA="${VERCEL_GIT_COMMIT_SHA:-local}"
SHORT_SHA="${SHA:0:7}"
BRANCH="${VERCEL_GIT_COMMIT_REF:-local}"
ENV_NAME="${VERCEL_ENV:-development}"

PT_MONTHS=(jan fev mar abr mai jun jul ago set out nov dez)
MONTH_NUM=$(TZ='America/Sao_Paulo' date +%-m)
MONTH_NAME="${PT_MONTHS[$((MONTH_NUM - 1))]}"
DAY=$(TZ='America/Sao_Paulo' date +%-d)
TIME=$(TZ='America/Sao_Paulo' date +%H:%M)
FRIENDLY="${DAY} ${MONTH_NAME} ${TIME}"

DETAIL="${SHORT_SHA} | ${BRANCH} | ${ENV_NAME}"

echo "Versao amigavel : ${FRIENDLY}"
echo "Detalhe tecnico : ${DETAIL}"

python3 - <<PYEOF
import sys

friendly = """${FRIENDLY}"""
detail   = """${DETAIL}"""

files = ["index.html", "como-aplicar-no-gmail.html"]
for fname in files:
    try:
        with open(fname, "r", encoding="utf-8") as fh:
            content = fh.read()
        content = content.replace("__VERSION_FRIENDLY__", friendly)
        content = content.replace("__VERSION_DETAIL__", detail)
        with open(fname, "w", encoding="utf-8") as fh:
            fh.write(content)
        print(f"  -> {fname} atualizado")
    except FileNotFoundError:
        print(f"  -> {fname} nao encontrado, pulando")
PYEOF
