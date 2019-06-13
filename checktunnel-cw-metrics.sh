#!/bin/bash

export PATH=$PATH:/usr/local/bin/:/usr/bin
instanceid=$(curl http://169.254.169.254/latest/meta-data/instance-id 2>/dev/null)

ports=$( ( nmap -p 1535,7000 -PN 192.168.8.149 192.168.8.150 ; nmap -p 8094,8095 -PN 172.16.110.90 ) | grep open | wc -l)

# need install aws-cli "pip install awscli"
aws cloudwatch put-metric-data --metric-name vpn.ports.connect --namespace "VPN connections" --unit Count --value ${ports} --dimensions InstanceID=${instanceid}

# check if result of ports are < 4 and restart
if [ $ports < 4 ]
       then
   sudo iptables -F && sudo ipsec restart
fi
