# CMake generated Testfile for 
# Source directory: /home/eos/validation/eos_src/contracts/hello
# Build directory: /home/eos/validation/eos_src/build/contracts/hello
# 
# This file includes the relevant testing commands required for 
# testing this directory and lists subdirectories to be tested as well.
add_test(validate_hello_abi "/home/eos/validation/eos_src/build/scripts/abi_is_json.py" "/home/eos/validation/eos_src/contracts/hello/hello.abi")
