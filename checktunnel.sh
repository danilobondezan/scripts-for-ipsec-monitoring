#!/bin/bash
set -x

CLIENT_NAME=John
IP_SERVICE=10.1.12.115
PORT_SERVICE=1433
CHECK_PORTS=$(nmap -p $PORT_SERVICE -PN $IP_SERVICE | grep open | wc -l)
LOG=/var/log/vpn-check/ipsec-$CLIENT_NAME.log
DATE=$(date +%Y_%m_%d_%H%M)

if [ $CHECK_PORTS -lt 1 ]
 then
    sudo iptables -F && ipsec restart
fi

if [ $? -ne 0 ]; then
  echo "$DATE The VPN was not sucessfully restarted" >> $LOG
else
  echo "$DATE VPN OK" >> $LOG
fi

echo "Done"

#echo $CHECK_PORTS
