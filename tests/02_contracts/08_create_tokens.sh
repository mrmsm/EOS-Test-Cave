TEST_NAME="Create tokens"

if [[ ! $GLOBALPATH ]]; then
    GLOBALPATH="$(dirname $(realpath $0))/../.."
fi

config="$GLOBALPATH/config.json"
KEY="$( jq -r '.eosio_pub_key' "$config" )"

failed(){
    echo "0:$TEST_NAME"
    echo "$TEST_NAME - Failed" >> $GLOBALPATH/log/log_error.log;
    echo "$1" >> $GLOBALPATH/log/log_error.log;
    echo "---------------------------------" >> $GLOBALPATH/log/log_error.log;
}

tpm_stderr="$GLOBALPATH/log/tmp_std_err.log"

#----------------------

CMD=$( $GLOBALPATH/bin/cleos.sh push action eosio.token create '["eosio", "10000000000.0000 EOS"]' -p eosio.token 2>$tpm_stderr)

ERR=$(cat $tpm_stderr)

VALUE="$($GLOBALPATH/bin/cleos.sh get currency stats eosio.token EOS | /bin/grep max_supply | /bin/sed 's/[^0-9]*//g')"

if [[ $ERR != *"executed transaction"* ]]; then
    failed "$ERR"
    rm $tpm_stderr;
elif [[ $VALUE != "100000000000000" ]]; then
    failed "Wrong max supply"
    rm $tpm_stderr;
else
    echo "1:$TEST_NAME"
fi
