#!/bin/sh
#Hostname Mismatch

# Get ComputerName
COMPUTER_NAME="`scutil --get ComputerName`"

# Get HostName
HOST_NAME="`scutil --get HostName`"

if [ $COMPUTER_NAME == $HOST_NAME ]; then
echo "<result>MATCH</result>"
else
echo "<result>MISMATCH</result>"
fi
