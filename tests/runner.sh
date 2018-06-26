#!/bin/bash

######################################################################
#
# Runner for all test parent methods
#
# Made with <3 by the team @ EOS-BP-Developers
#
# Find the code @ https://github.com/EOS-BP-Developers/EOS-Test-Cave
#
######################################################################

if [[ ! $GLOBALPATH ]]; then
	GLOBALPATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/../.."
fi

config="$GLOBALPATH/config.json"

failed(){
    echo "0:$TEST_NAME"
    echo "$TEST_NAME - Failed" >> $GLOBALPATH/log/log_error.log;
    echo "$1" >> $GLOBALPATH/log/log_error.log;
    echo "---------------------------------" >> $GLOBALPATH/log/log_error.log;
}

tpm_stderr="$GLOBALPATH/log/tmp_std_err.log"