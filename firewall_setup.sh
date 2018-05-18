#!/bin/bash

if [[ $EUID -ne 0 ]]; then
	echo "Please run as root.";
	exit;
fi

ufw default deny incoming;

# SSH.
ufw allow 22/tcp;

# Dashboard.
ufw allow 80/tcp;
ufw allow 443/tcp;

# Backend admin.
ufw allow 8080/tcp;
#iptables -A INPUT -p tcp --dport 8080 -s 127.0.0.1 -d 127.0.0.1 -j ACCEPT; # TODO: Decide if only local host can access.

#SNMP.
ufw allow 161/tcp;
ufw allow 162/tcp;

#Database (only allow localhost).
ufw allow 3306/tcp;
iptables -A INPUT -p tcp --dport 3306 -s 127.0.0.1 -d 127.0.0.1 -j ACCEPT;