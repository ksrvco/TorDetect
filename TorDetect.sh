#!/bin/bash
# Project name: TorDetect - Detect Tor Traffic in Network
# Written by: KsrvcO
# Version: 1.0
# Compatible with: Linux Operation Systems
# Tested on: WiFi networks , LAN networks
# Contact: flower.k2000[at]gmail.com

if ! [ $(id -u) = 0 ]; then
	   echo "Run this tool as root privilege."
	   exit 1
else
    mkdir -p /tmp/torpath
    tpath="/tmp/torpath"
    reset
    echo -e "

    ▄▄▄█████▓ ▒█████   ██▀███  ▓█████▄ ▓█████▄▄▄█████▓▓█████  ▄████▄  ▄▄▄█████▓
    ▓  ██▒ ▓▒▒██▒  ██▒▓██ ▒ ██▒▒██▀ ██▌▓█   ▀▓  ██▒ ▓▒▓█   ▀ ▒██▀ ▀█  ▓  ██▒ ▓▒
    ▒ ▓██░ ▒░▒██░  ██▒▓██ ░▄█ ▒░██   █▌▒███  ▒ ▓██░ ▒░▒███   ▒▓█    ▄ ▒ ▓██░ ▒░
    ░ ▓██▓ ░ ▒██   ██░▒██▀▀█▄  ░▓█▄   ▌▒▓█  ▄░ ▓██▓ ░ ▒▓█  ▄ ▒▓▓▄ ▄██▒░ ▓██▓ ░ 
      ▒██▒ ░ ░ ████▓▒░░██▓ ▒██▒░▒████▓ ░▒████▒ ▒██▒ ░ ░▒████▒▒ ▓███▀ ░  ▒██▒ ░ 
      ▒ ░░   ░ ▒░▒░▒░ ░ ▒▓ ░▒▓░ ▒▒▓  ▒ ░░ ▒░ ░ ▒ ░░   ░░ ▒░ ░░ ░▒ ▒  ░  ▒ ░░   
        ░      ░ ▒ ▒░   ░▒ ░ ▒░ ░ ▒  ▒  ░ ░  ░   ░     ░ ░  ░  ░  ▒       ░    
      ░      ░ ░ ░ ▒    ░░   ░  ░ ░  ░    ░    ░         ░   ░          ░      
                ░ ░     ░        ░       ░  ░           ░  ░░ ░               
                                ░                            ░                 
                                                                    by KsrvcO

    Project name: TorDetect - Detect Tor Traffic in Network
    Written by: KsrvcO
    Version: 1.0
    Contact: flower.k2000[at]gmail.com

    "
    sleep 5
    read -p "[+] Enter your network interface: " netinterface
    ifconfig $netinterface promisc
    if [ $(cat /sys/class/net/$netinterface/operstate) == "up" ]
      then
      ifconfig $netinterface promisc
      sleep 1
      echo "[+] Monitoring mode enabled on $netinterface"
    fi
    echo "[+] Started monitoring..."
    sleep 2
      tshark -i $netinterface -a duration:60  >> $tpath/captured.txt 2>/dev/null
      cat $tpath/captured.txt | grep "Application Data" | awk '/→ / {print $3}' | sort -u > $tpath/ip_nodes.txt
      echo "[+] Getting information..."
      wget "https://raw.githubusercontent.com/SecOps-Institute/Tor-IP-Addresses/master/tor-exit-nodes.lst" -O $tpath/1.txt 2>/dev/null
      wget "https://raw.githubusercontent.com/SecOps-Institute/Tor-IP-Addresses/master/tor-nodes.lst" -O $tpath/2.txt 2>/dev/null
      echo "[+] Getting information Done."
      cat $tpath/1.txt $tpath/2.txt | sort -u  > $tpath/tornodes.txt
      torip=$(for i in $(cat $tpath/ip_nodes.txt); do cat $tpath/tornodes.txt | grep "$i"; done)
      clientip=$(cat $tpath/captured.txt | grep "Application Data" | grep "$torip" | awk '/→ / {print $3,$5}' | sort -u | head -n 1 | cut -d " " -f2)
      date >> $tpath/result.txt
      echo "Tor Traffic Detected in Network" >> $tpath/tempresult.txt
      echo "ClientIP: $clientip" >> $tpath/tempresult.txt
      echo "TorNodeIP: $torip" >> $tpath/tempresult.txt
      echo -e "\n" >> $tpath/tempresult.txt
      sed -e '/ClientIP:$/,+3d' $tpath/tempresult.txt >> $tpath/result.txt
      rm -rf $tpath/1.txt
      rm -rf $tpath/2.txt
      rm -rf $tpath/ip_nodes.txt
      rm -rf $tpath/tempresult.txt
      rm -rf $tpath/tornodes.txt
      rm -rf $tpath/captured.txt
      echo "[+] Results saved in $tpath/result.txt"
    exit
fi