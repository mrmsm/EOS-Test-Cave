TEST_NAME="Setprods on eosio"

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
CMD=$( $GLOBALPATH/bin/cleos.sh push action eosio setprods '{"schedule":[{"producer_name":"eosio","block_signing_key":"'$KEY'"}]}' -p eosio 2>$tpm_stderr)

ERR=$(cat $tpm_stderr)

if [[ $ERR != *"executed transaction"* ]]; then
    failed "$ERR"
    rm $tpm_stderr;
else
    echo "1:$TEST_NAME"
fi
