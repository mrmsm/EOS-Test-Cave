
### Defualt config 
blocks-dir = "blocks"
genesis-json = ./genesis.json
chain-state-db-size-mb = 1024
reversible-blocks-db-size-mb = 340
contracts-console = false
access-control-allow-credentials = false
sync-fetch-span = 100
max-implicit-request = 1500
#wasm-runtime=wavm

# actor-whitelist =
# actor-blacklist =
# contract-whitelist =
# contract-blacklist =
# filter-on =
# https-client-root-cert =

https-client-validate-peers = 1
http-server-address = 127.0.0.1:__BOOT_HTTP__
p2p-listen-endpoint = 0.0.0.0:__BOOT_P2P__
p2p-server-address = __BOOT_HOST__:__BOOT_P2P__
p2p-max-nodes-per-host = 1
#__BOOT_PEER__
#__P2P_PEER_LIST__

# peer-key =
# peer-private-key =

agent-name = "EOS BOOT NODE"
allowed-connection = any
max-clients = 120
connection-cleanup-period = 30
network-version-match = 1

enable-stale-production = true
#pause-on-startup = false
max-transaction-time = 100000
max-irreversible-block-age = -1

# Enable block production with the testnet producers
producer-name = eosio
signature-provider = __PUBKEY__=KEY:__PRIVKEY__
private-key = ["__PUBKEY__","__PRIVKEY__"]
# Appointment Producer
producer-name = genesisnodea
producer-name = genesisnodeb
producer-name = genesisnodec
producer-name = genesisnoded
producer-name = genesisnodee
producer-name = genesisnodef
producer-name = genesisnodeg
producer-name = genesisnodeh
producer-name = genesisnodei
producer-name = genesisnodej
producer-name = genesisnodek
producer-name = genesisnodel
producer-name = genesisnodem
producer-name = genesisnoden
producer-name = genesisnodeo
producer-name = genesisnodep
producer-name = genesisnodeq
producer-name = genesisnoder
producer-name = genesisnodes
producer-name = genesisnodet
producer-name = genesisnodeu

# Wallet config
keosd-provider-timeout = 5
txn-reference-block-lag = 0
wallet-dir = "."
unlock-timeout = 900

# BNET Config
#__BNET_PLUGIN__

# eosio-key =
# plugin =
plugin = eosio::chain_api_plugin
plugin = eosio::history_api_plugin
plugin = eosio::http_plugin
