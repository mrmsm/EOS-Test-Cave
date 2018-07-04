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
CLEOS="$( /usr/bin/jq -r '.cleos_bin' "$config" )"

$CLEOS -u http://$NODEHOST --wallet-url http://$WALLETHOST "$@"
