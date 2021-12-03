#!/bin/bash
set -euo pipefail 

DEV_PUBLIC_KEY="$(jq -r .dev.public < eosio-wallet/secrets.json)"
DEV_PRIVATE_KEY="$(jq -r .dev.private < eosio-wallet/secrets.json)"

nodeos \
    --genesis-json "./genesis.json" \
    --signature-provider "${DEV_PUBLIC_KEY}=KEY:${DEV_PRIVATE_KEY}" \
    --plugin eosio::producer_plugin \
    --plugin eosio::producer_api_plugin \
    --plugin eosio::chain_plugin \
    --plugin eosio::chain_api_plugin \
    --plugin eosio::http_plugin \
    --plugin eosio::history_api_plugin \
    --plugin eosio::history_plugin \
    --producer-name eosio \
    --enable-stale-production \
    --access-control-allow-origin='*' \
    --trace-history \
    --chain-state-history \
    --disable-replay-opts \
    --contracts-console \
    --http-validate-host=false \
    --verbose-http-errors \
    --http-server-address=0.0.0.0:8888 \
    --state-history-endpoint=0.0.0.0:8080