#!/bin/expect -f

# Create OpenSIPS database and enter password
set timeout 10
spawn opensips-cli -x database create
expect "Password for admin MySQL user (root):"
send "root\r"
expect eof