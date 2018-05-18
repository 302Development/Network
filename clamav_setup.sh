#!/bin/bash

if [[ $EUID -ne 0 ]]; then
	echo "Please run as root.";
	exit;
fi

if which freshclam >/dev/null; then
	killall freshclam > /dev/null;
fi

echo "[*] Installing clam AV..."
apt-get update && apt-get install -y clamav clamav-freshclam;

echo "[*] Enabling clam AV / auto-updates...";
service ClamAV-freshclam start;

if which freshclam >/dev/null; then
    echo "[*] clam AV installed...";
else
    echo "[!] clam AV failed to install...";
    exit;
fi

echo "[*] Pulling latest updates for clam AV...";
freshclam -v;

echo "[*] Creating daily scan script...";
echo "IyEvYmluL2Jhc2gKCmlmIFsgIiRFVUlEIiAtbmUgMCBdCiAgdGhlbiBlY2hvICJQbGVhc2UgcnVuIGFzIHJvb3QuIgogIGV4aXQKZmkKCkxPR0ZJTEU9Ii92YXIvbG9nL2NsYW1hdi9jbGFtYXYtJChkYXRlICsnJVktJW0tJWQnKS5sb2ciOwpESVJUT1NDQU49Ii92YXIvd3d3IC92YXIvdm1haWwiOwoKZm9yIFMgaW4gJHtESVJUT1NDQU59OyBkbwogRElSU0laRT0kKGR1IC1zaCAiJFMiIDI+L2Rldi9udWxsIHwgY3V0IC1mMSk7CgogZWNobyAiU3RhcnRpbmcgYSBkYWlseSBzY2FuIG9mICIkUyIgZGlyZWN0b3J5LgogQW1vdW50IG9mIGRhdGEgdG8gYmUgc2Nhbm5lZCBpcyAiJERJUlNJWkUiLiI7CgogY2xhbXNjYW4gLXJpICIkUyIgPj4gIiRMT0dGSUxFIjsKCiAjIEdldCB0aGUgdmFsdWUgb2YgaW5mZWN0ZWQgZmlsZS4KIE1BTFdBUkU9JCh0YWlsICIkTE9HRklMRSJ8Z3JlcCBJbmZlY3RlZHxjdXQgLWQiICIgLWYzKTsKCiAjIFdlIGNhbiBub3cgZG8gc29tZXRoaW5nIHdpdGggTUFMV0FSRSwgZS5nIHNlbmQgYW4gZW1haWwgd2l0aCBhIG5vdGlmaWNhdGlvbi4KCmRvbmUKZXhpdCAwCg==" | base64 -d > ~/daily_scan.sh;

if [ ! -f ~/daily_scan.sh ]; then
    echo "[!] Failed to write daily scan script to disk...";
    exit;
fi

chmod +x ~/daily_scan.sh;

echo "[*] Adding daily scan script to cronjob...";
ln -f ~/daily_scan.sh /etc/cron.daily/daily_scan;

echo "[*] Done!";