# CMake generated Testfile for 
# Source directory: /home/eos/validation/eos_src/contracts/exchange
# Build directory: /home/eos/validation/eos_src/build/contracts/exchange
# 
# This file includes the relevant testing commands required for 
# testing this directory and lists subdirectories to be tested as well.
add_test(validate_exchange_abi "/home/eos/validation/eos_src/build/scripts/abi_is_json.py" "/home/eos/validation/eos_src/contracts/exchange/exchange.abi")
