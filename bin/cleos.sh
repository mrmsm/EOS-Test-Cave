#!/bin/bash
################################################################################
#
#  EOS Testing Cave
#
#  Made by Cryptolions.io (2018)
#  Modify EOS BP Developer Team (https://github.com/EOS-BP-Developers)
#
#  for automated testing EOS Software
#
#  Github : https://github.com/EOS-BP-Developers/EOS-Test-Cave
#
################################################################################

SCRIPTPATH=$(/usr/bin/dirname $(realpath $0))""
conf_file="$SCRIPTPATH/../config.conf"

[ -f $conf_file ] && . $conf_file

$BIN_DIR/cleos -u http://$BOOT_HOST:$BOOT_HTTP --wallet-url http://$WALLET_HOST "$@"
