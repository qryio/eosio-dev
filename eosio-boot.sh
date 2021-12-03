#!/bin/bash
set -euo pipefail
set +x

while ! nc -z localhost 8888; do
    sleep 1;
done;

WALLET_PASSWD="$(jq -r .password < eosio-wallet/secrets.json)"
TEST_PUBLIC_KEY="$(jq -r .test.public < eosio-wallet/secrets.json)"
TEST_PRIVATE_KEY="$(jq -r .test.private < eosio-wallet/secrets.json)"

cleos wallet open
cleos wallet unlock --password "${WALLET_PASSWD}"

SYSTEM_ACCOUNTS=(saving cpay vpay bpay stake rexpay ramfee token ram forum wrap bios msig system rex)
for sys_act in "${SYSTEM_ACCOUNTS[@]}"; do
    priv_key=$(cleos create key --to-console | awk '{print $3}' | head -n1)
    pub_key=$(cleos wallet import --private-key "${priv_key}" | awk '{print $5}')
    cleos create account eosio "eosio.${sys_act}" "${pub_key}"
done

sleep 2

cleos set contract eosio.token eosio.contracts/build/contracts/eosio.token && sleep 2
cleos set contract eosio.msig eosio.contracts/build/contracts/eosio.msig && sleep 2

cleos push action eosio.token create '[ "eosio", "10000000000.0000 EOS" ]' -p eosio.token@active && sleep 2
cleos push action eosio.token issue '[ "eosio", "1000000000.0000 EOS", "memo" ]' -p eosio@active && sleep 2

curl -XPOST http://127.0.0.1:8888/v1/producer/schedule_protocol_feature_activations \
    -d '{"protocol_features_to_activate": ["0ec7e080177b2c02b278d5088611686b49d739925a92d9bfcacd7fc6b74053bd"]}' && sleep 2

cleos set contract eosio eos/contracts/contracts/eosio.boot/bin eosio.boot.wasm eosio.boot.abi && sleep 2

cleos push action eosio activate '["825ee6288fb1373eab1b5187ec2f04f6eacb39cb3a97f356a07c91622dd61d16"]' -p eosio
cleos push action eosio activate '["c3a6138c5061cf291310887c0b5c71fcaffeab90d5deb50d3b9e687cead45071"]' -p eosio
cleos push action eosio activate '["bf61537fd21c61a60e542a5d66c3f6a78da0589336868307f94a82bccea84e88"]' -p eosio
cleos push action eosio activate '["5443fcf88330c586bc0e5f3dee10e7f63c76c00249c87fe4fbf7f38c082006b4"]' -p eosio
cleos push action eosio activate '["f0af56d2c5a48d60a4a5b5c903edfb7db3a736a94ed589d0b797df33ff9d3e1d"]' -p eosio
cleos push action eosio activate '["2652f5f96006294109b3dd0bbde63693f55324af452b799ee137a81a905eed25"]' -p eosio
cleos push action eosio activate '["8ba52fe7a3956c5cd3a656a3174b931d3bb2abb45578befc59f283ecd816a405"]' -p eosio
cleos push action eosio activate '["ad9e3d8f650687709fd68f4b90b41f7d825a365b02c23a636cef88ac2ac00c43"]' -p eosio
cleos push action eosio activate '["68dcaa34c0517d19666e6b33add67351d8c5f69e999ca1e37931bc410a297428"]' -p eosio
cleos push action eosio activate '["e0fb64b1085cc5538970158d05a009c24e276fb94e1a0bf6a528b48fbc4ff526"]' -p eosio
cleos push action eosio activate '["ef43112c6543b88db2283a2e077278c315ae2c84719a8b25f25cc88565fbea99"]' -p eosio
cleos push action eosio activate '["4a90c00d55454dc5b059055ca213579c6ea856967712a56017487886a4d4cc0f"]' -p eosio
cleos push action eosio activate '["1a99a59d87e06e09ec5b028a9cbb7749b4a5ad8819004365d02dc4379a8b7241"]' -p eosio
cleos push action eosio activate '["4e7bf348da00a945489b2a681749eb56f5de00b900014e137ddae39f48f69d67"]' -p eosio
cleos push action eosio activate '["4fca8bd82bbd181e714e283f83e1b45d95ca5af40fb89ad3977b653c448f78c2"]' -p eosio
cleos push action eosio activate '["299dcb6af692324b899b39f16d5a530a33062804e41f09dc97e9f156b4476707"]' -p eosio
sleep 2

cleos set contract eosio eosio.contracts/build/contracts/eosio.system && sleep 2

cleos push action eosio setpriv '["eosio.msig", 1]' -p eosio@active && sleep 2
cleos push action eosio init '["0", "4,EOS"]' -p eosio@active && sleep 2

cleos wallet import --private-key "${TEST_PRIVATE_KEY}"

cleos system newaccount eosio \
    --transfer accountnum11 "${TEST_PUBLIC_KEY}" \
    --stake-net "100000000.0000 EOS" \
    --stake-cpu "100000000.0000 EOS" \
    --buy-ram-kbytes 8192 && sleep 2

echo EOSIO_BOOT_COMPLETE
exit 0