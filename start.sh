#!/bin/bash

GLOBALPATH=$(/usr/bin/dirname $(/usr/bin/realpath $0))

/bin/echo "Preparing and clearing..."
# Restart chain
config="$GLOBALPATH/config.json"
NODE_DIR="$( /usr/bin/jq -r '.node_data_dir' "$config" )"
WALLET_DIR="$( /usr/bin/jq -r '.wallet_data_dir' "$config" )"
#Remove default wallets files in ~/eosio-wallet folder (to clean test)
/bin/rm -r $WALLET_DIR/*

# Remove logs from last testing
/bin/rm -r $GLOBALPATH/log/*.dat
/bin/rm -r $GLOBALPATH/log/*.log

# Restart chain
config="$GLOBALPATH/config.json"
NODE_DIR="$( /usr/bin/jq -r '.node_data_dir' "$config" )"

$NODE_DIR/start.sh --delete-all-blocks --genesis-json $NODE_DIR/genesis.json

print_test_result() {
    T_=$1
    T1=$(/bin/echo $T_ | /usr/bin/cut -d ":" -f 1)
    T2=$(/bin/echo $T_ | /usr/bin/cut -d ":" -f 2)
    if [[ $T1 -eq 1 ]]; then
	#echo -e "$T2 - \e[32m[OK]\e[39m" | column -t -s- 

	/usr/bin/printf '\e[1;39m%-75s\e[m \e[1;32m%-25s\e[m\n' " $T2" "[OK]"
	TEST_OK_WALLET=$(($TEST_OK_WALLET+1))
	TEST_OK=$(($TEST_OK+1))
    else
	#echo -e "$T2 \t \e[31m[FAILED]\e[39m"
	/usr/bin/printf '\e[1;39m%-75s\e[m \e[1;31m%-25s\e[m\n' " $T2" "[FAILED]"
	TEST_FAILED_WALLET=$(($TEST_FAILED_WALLET+1))
	TEST_FAILED=$(($TEST_FAILED+1))
    fi

}

startCategoryTest(){
    DIR=$1;

    /bin/echo "";
    /bin/echo -e "\e[1;39m╔════════════════════╣ \e[1;32m Tests $1 \e[m ╠═══════════════════════════════╗\e[m \n";

    mydir=$(/bin/pwd)
    STARTTIME_GROUP=$(/bin/date +%s.%N)
    TEST_FAILED_WALLET=0
    TEST_OK_WALLET=0

    cd $1
    for f in *.sh; do
	print_test_result "$(./$f)"
    done
    cd $mydir

    ENDTIME_GROUP=$(/bin/date +%s.%N)
    DIFF_GROUP=$(/bin/echo "$ENDTIME_GROUP - $STARTTIME_GROUP" | /usr/bin/bc)

    /bin/echo ""
    /bin/echo -e "\e[1;39m┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫\e[m"
    /bin/echo " Tests: $1"
    /bin/echo " Time: $DIFF_GROUP sec"
    /bin/echo -e " Group Total \e[32mOK\e[39m/\e[31mFailed\e[39m/\e[1;39mTotal\e[m tests: \e[32m$TEST_OK_WALLET\e[m/\e[31m$TEST_FAILED_WALLET\e[m/\e[1;39m"$((TEST_OK_WALLET+TEST_FAILED_WALLET))"\e[m"

    /bin/echo -e "\e[1;39m╚══════════════════════════════════════════════════════════════════════════════╝\e[m \n";
}


#========================================================================================================================================

/bin/echo "START TESTING..."
TEST_FAILED=0
TEST_OK=0

STARTTIME=$(/bin/date +%s.%N)

#########################################################################################################################
#########################################################################################################################

startCategoryTest "tests/01_wallet"
startCategoryTest "tests/02_account"
startCategoryTest "tests/03_contracts"

#########################################################################################################################
#########################################################################################################################


ENDTIME=$(/bin/date +%s.%N)
DIFF=$(/bin/echo "$ENDTIME - $STARTTIME" | /usr/bin/bc)

/bin/echo ""
/bin/echo ""
/bin/echo -e "\e[92m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\e[m"
/bin/echo -e "\e[92m▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒\e[m"
/bin/echo -e "\e[92m▒\e[m"
/bin/echo -e "\e[92m▒\e[m  Time: $DIFF sec"
/bin/echo -e "\e[92m▒\e[m  Total \e[32mOK\e[39m/\e[31mFailed\e[39m/\e[1;39mTotal\e[m for all tests: \e[32m$TEST_OK\e[m/\e[31m$TEST_FAILED\e[m/\e[1;39m"$((TEST_OK+TEST_FAILED))"\e[m"
/bin/echo -e "\e[92m▒\e[m"
/bin/echo -e "\e[92m▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒\e[m"
/bin/echo ""
read -n 1 -s -r -p "Press any key to continue"
/bin/echo ""
