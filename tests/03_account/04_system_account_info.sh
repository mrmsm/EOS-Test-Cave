TEST_NAME="Get system accounts info"

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

accounts=( eosio.bpay eosio.msig eosio.names eosio.ram eosio.ramfee eosio.saving eosio.stake eosio.token eosio.vpay );

for account in "${accounts[@]}"
do
  CMD=$( $GLOBALPATH/bin/cleos.sh get account $account 2>$tpm_stderr)
  ERR=$(cat $tpm_stderr)
  if [[ $ERR != "" ]]; then
    failed "$ERR"
    rm $tpm_stderr;
    exit 1;
  fi
done

echo "1:$TEST_NAME"

