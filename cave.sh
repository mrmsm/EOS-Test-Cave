#!/bin/bash
SCRIPTPATH=$(/usr/bin/dirname $(realpath $0))""
conf_file="$SCRIPTPATH/config.conf"

[ -f $conf_file ] && . $conf_file
if [ -z $BASE_DIR ]
then
  echo "  >> Not found $conf_file in $(pwd) directory. please set to $conf_file file."
  exit 0;
fi

# Load function
for f in $(ls $BASE_DIR/function/*.func);do
  source $f
done

node_svc_check () {
  if [ $1 == "wallet" ]
  then
    CHK_SVC=$(curl -Is http://${WALLET_HOST}/v1/wallet/list_wallets | head -n 1 | grep HTTP | wc -l)
  else
    CHK_SVC=$(curl -Is http://$1/v1/chain/get_info | head -n 1 | grep HTTP | wc -l)
  fi
  /bin/echo $CHK_SVC
  [ $CHK_SVC -eq 1 ] && return 1 || return 0
}

check_os () {
  OS_NAME=$(cat /etc/os-release | grep "^NAME" | awk -F"=" '{print $2}' | sed "s/\"//g")
  if [ $OS_NAME != "Ubuntu" ]
  then
    echo_f "This script support only Ubuntu OS"
    exit 1
  fi
}

check_requirement() { 
  DPKG="jq"
  for pkg in $DPKG; do
    if [ -z $( dpkg -s jq 2>/dev/null | grep "Status" | awk '{print $4}') ]; then
      echo_f "JQ is not installed. We will install JQ on here at now"
      sudo apt-get -y install $pkg
    fi
  done
}

clear_all_data () { 
  /bin/echo "";
  /bin/echo -e "\e[1;39m╔════════════════════╣ \e[1;32m old data clear \e[m ╠═══════════════════════════════╗\e[m \n";
  /bin/echo "START TESTING..."

  # Stop All node
  stop_all_nodes 

  # Remove test data
  [ -d $WALLET_DIR ] && rm -rf $WALLET_DIR;
  [ -d $LOG_DIR ] && rm -f $LOG_DIR/*;
  [ -d $DATA_DIR ] && rm -rf $DATA_DIR;
}

stop_all_nodes () { 
  if [ -d $WALLET_DIR ]; then 
    $WALLET_DIR/run.sh stop
  fi
  if [ -d $DATA_DIR ]; then
    for INF in $(ls $DATA_DIR);do
      [ -f $DATA_DIR/$INF/nodeos.pid ] && $DATA_DIR/$INF/run.sh stop
    done
  fi
}

test_data_prepare() { 
  /bin/echo "";
  /bin/echo -e "\e[1;39m╔════════════════════╣ \e[1;32m Tests Prepare \e[m ╠═══════════════════════════════╗\e[m \n";
  /bin/echo "START TESTING..."

  STARTTIME=$(/bin/date +%s.%N)
  TEST_FAILED=0
  TEST_OK=0
}

start_wallet_node() {
  # is keosd running?
  if [ $(node_svc_check wallet) -eq 1 ];
  then
    stop_wallet_node
  else
    # Check Wallet Directory
    [ ! -d $WALLET_DIR ] && mkdir $WALLET_DIR
    sed -e "s/__WALLET_HOST__/${WALLET_HOST}/g" \
        -e "s+__WALLET_DIR__+${WALLET_DIR}+g"  < $BASE_DIR/template/wallet.config > $WALLET_DIR/config.ini
    sed -e "s+__DATA__+${WALLET_DIR}+g" \
        -e "s+__BIN__+${BIN_DIR}+g" \
        -e "s/__PROG__/keosd/g" < $BASE_DIR/template/run.sh > $WALLET_DIR/run.sh
  
    chmod +x $WALLET_DIR/run.sh
    # Start keosd(wallet) 
    $WALLET_DIR/run.sh start
    print_out $? "Wallet Start"
  fi
}

stop_wallet_node() {
  $WALLET_DIR/run.sh stop
  if [ $(node_svc_check wllet) -eq 1 ];
  then
    $CLE wallet stop
  fi
}

startCategoryTest(){
    if [ ! -d $1 ]; then
      echo " $1 test script directory is not exists"
      return 1
    fi
    DIR=$1;

    /bin/echo "";
    /bin/echo -e "\e[1;39m╔════════════════════╣ \e[1;32m Tests $1 \e[m ╠═══════════════════════════════╗\e[m \n";

    mydir=$(/bin/pwd)
    STARTTIME_GROUP=$(/bin/date +%s.%N)
    TEST_FAIL_GROUP=0
    TEST_OK_GROUP=0

    if [ $(find ${1} -name "*.sh" | wc -l) -ne 0 ]; then
      for f in $(ls ${1}/*.sh); do
        if [ -x $f ]; then
          print_test_result "$(./$f)"
        fi
      done
    else
      echo "     Script empty!"
    fi

    ENDTIME_GROUP=$(/bin/date +%s.%N)
    DIFF_GROUP=$(/bin/echo "$ENDTIME_GROUP - $STARTTIME_GROUP" | /usr/bin/bc)

    /bin/echo ""
    /bin/echo -e "\e[1;39m┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫\e[m"
    /bin/echo " Tests: $1"
    /bin/echo " Time: $DIFF_GROUP sec"
    /bin/echo -e " Group Total \e[32mOK\e[39m/\e[31mFailed\e[39m/\e[1;39mTotal\e[m tests: \e[32m$TEST_OK_GROUP\e[m/\e[31m$TEST_FAILED_GROUP\e[m/\e[1;39m"$((TEST_OK_GROUP+TEST_FAILED_GROUP))"\e[m"

    /bin/echo -e "\e[1;39m╚══════════════════════════════════════════════════════════════════════════════╝\e[m \n";
}

test_end_print() { 
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
}

print_usage() { 
echo -e '
################################################################################
#                                                                              #
#        EOS Test cave                                                         #
#        Made by EOS BP Developers Team @ 2018                                 #
#                                                                              #
#        Github : https://github.com/EOS-BP-Developers/EOS-Test-Cave           #
#                                                                              #
################################################################################
'
echo " 
Usage : $0 [ Subcommand ]

  - clear            : Remove tested old data
  - boot             : Init start boot node for tests
  - wallet           : Init start wallet for tests
  - all              : Run all tests
  - test [test name] : Runs only the specified Test.

  [Test List]"
for list in $(ls $BASE_DIR/tests/);do
  echo "    - $list"
done

echo ""
}

# Main start
check_os
check_requirement

case "$1" in 
  clear)
    stop_wallet_node
    clear_all_data
    RETVAL=0
    ;;
  boot)
    clear_all_data
    test_data_prepare
    start_wallet_node
    init_boot_node
    stop_all_nodes
    test_end_print
    RETVAL=0
    ;;
  all)
    clear_all_data
    test_data_prepare
    start_wallet_node
    init_boot_node
    init_bp_node
    bp_validation
    for list in $(ls $BASE_DIR/tests/);do
      startCategoryTest "tests/$list"
    done
    stop_all_nodes
    test_end_print
    RETVAL=0
    ;;
  wallet)
    clear_all_data
    start_wallet_node
    ;;
  test)
    clear_all_data
    test_data_prepare
    start_wallet_node
    init_boot_node
    init_bp_node
    bp_validation
    startCategoryTest "tests/$2"
    stop_all_nodes
    test_end_print
    ;;
    *)
    print_usage
    RETVAL=2
    ;;
esac

exit $RETVAL
