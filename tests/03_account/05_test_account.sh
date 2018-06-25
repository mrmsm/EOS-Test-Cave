TEST_NAME="Create test account with non-eosio account and transfer liquid tokens to it"

if [[ ! $GLOBALPATH ]]; then
    GLOBALPATH="$(dirname $(realpath $0))/../.."
fi

config="$GLOBALPATH/config.json"
NAME="$( jq -r '.test_account_name' "$config" )"

failed(){
    echo "0:$TEST_NAME"
    echo "$TEST_NAME - Failed" >> $GLOBALPATH/log/log_error.log;
    echo "$1" >> $GLOBALPATH/log/log_error.log;
    echo "---------------------------------" >> $GLOBALPATH/log/log_error.log;
}

tpm_stderr="$GLOBALPATH/log/tmp_std_err.log"

#----------------------
PUB_KEY=$( cat $GLOBALPATH/log/wallet_name_testwallet_key.dat | cut -d' ' -f1)
CMD=$( $GLOBALPATH/bin/cleos.sh system newaccount eosio $NAME $PUB_KEY --stake-net "100.0000 EOS" --stake-cpu "100.0000 EOS" --buy-ram "10.0000 EOS" --transfer 2>$tpm_stderr)

ERR=$(cat $tpm_stderr)

if [[ $ERR != *"executed transaction"* ]]; then
    failed "$ERR"
    rm $tpm_stderr;
fi
CMD2=$( $GLOBALPATH/bin/cleos.sh transfer eosio $NAME "5000000.0000 EOS" "liquid tokens" 2>$tpm_stderr)
ERR=$(cat $tpm_stderr)
if [[ $ERR != *"executed transaction"* ]]; then
    failed "$ERR"
    rm $tpm_stderr;
else
    echo "1:$TEST_NAME"
fi
