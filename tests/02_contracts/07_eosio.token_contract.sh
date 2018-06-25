TEST_NAME="Deploy eosio.token contract"

if [[ ! $GLOBALPATH ]]; then
    GLOBALPATH="$(dirname $(realpath $0))/../.."
fi

config="$GLOBALPATH/config.json"
#KEY="$( jq -r '.eosio_pub_key' "$config" )"

failed(){
    echo "0:$TEST_NAME"
    echo "$TEST_NAME - Failed" >> $GLOBALPATH/log/log_error.log;
    echo "$1" >> $GLOBALPATH/log/log_error.log;
    echo "---------------------------------" >> $GLOBALPATH/log/log_error.log;
}

tpm_stderr="$GLOBALPATH/log/tmp_std_err.log"

#----------------------
ACCOUNT="eosio.token"

CMD=$( $GLOBALPATH/bin/cleos.sh set contract $ACCOUNT $GLOBALPATH/contracts/eosio.token 2>$tpm_stderr)

ERR=$(cat $tpm_stderr)

if [[ $ERR != *"executed transaction"* ]]; then
    failed "$ERR"
    rm $tpm_stderr;
fi

CMD2=$( $GLOBALPATH/bin/cleos.sh get code $ACCOUNT 1>$tpm_stderr)
ERR=$(cat $tpm_stderr)
if [[ $ERR != *"0000000000000000000000000000000000000000000000000000000000000000"* ]]; then
	echo "1:$TEST_NAME"
else
    failed "$ERR"
    rm $tpm_stderr;
fi

