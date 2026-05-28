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
MONTH_NUM=$(TZ='America/S