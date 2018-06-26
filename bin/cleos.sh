#!/bin/bash
################################################################################
#
# EOS Cleos wrapper
#
# Created by http://CryptoLions.io
#
# Git Hub: https://github.com/CryptoLions
# Eos Network Monitor: http://eosnetworkmonitor.io/
#
###############################################################################

SCRIPTPATH=$(/usr/bin/dirname $(realpath $0))""
config="$SCRIPTPATH/../config.json"
WALLETHOST="$( /usr/bin/jq -r '.walletAddr' "$config" )"
NODEHOST="$( /usr/bin/jq -r '.nodeos' "$config" )"


docker-compose exec keosd /opt/eosio/bin/cleos -u http://nodeosd:8888 --wallet-url http://localhost:8900 "$@"
