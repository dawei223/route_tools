#!/bin/sh
wget -c http://ftp.apnic.net/stats/apnic/delegated-apnic-latest.md5 -O /tmp/delegated-apnic-latest.md5.online
if
 onlinedalm=`cat /tmp/delegated-apnic-latest.md5.online | awk '{print $4}'`
 olddalm=`cat /etc/config/delegated-apnic-latest.md5.old`
 [ "$onlinedalm" = "$olddalm" ]; then
 rm /tmp/delegated-apnic-latest.md5.online
 echo "same md5 "
else
 wget -c http://ftp.apnic.net/stats/apnic/delegated-apnic-latest -O /tmp/delegated-apnic-latest
 md5sum /tmp/delegated-apnic-latest > /tmp/delegated-apnic-latest.md5.local
 localdalm=`cat /tmp/delegated-apnic-latest.md5.local | awk '{print $1}'`
 onlinedalm=`cat /tmp/delegated-apnic-latest.md5.online | awk '{print $4}'`
fi
if
 [ "$localdalm" = "$onlinedalm" ]; then
 rm /etc/config/chinaip.sh
 cat /tmp/delegated-apnic-latest | awk -F '|' '/CN/&&/ipv4/ {print $4 "/" 32-log($5)/log(2)}' | tee /etc/config/chinaip.sh
# sed -i "/./{s/^/&route /;s/$/& net_gateway/}" chinaiplist.txt
 sed -i "s/^/&ipset add chinaip /" /etc/config/chinaip.sh
 sed -i "1 i\ipset create chinaip hash:net hashsize 10240" /etc/config/chinaip.sh
 chmod 775 /etc/config/chinaip.sh
 cat /tmp/delegated-apnic-latest.md5.online | awk '{print $4}' > /etc/config/delegated-apnic-latest.md5.old
 rm /tmp/delegated-apnic-latest.md5.online
 rm /tmp/delegated-apnic-latest.md5.local
 rm /tmp/delegated-apnic-latest
 echo "same md5 update"
# reboot
 ipset flush chinaip
 /etc/config/chinaip.sh
fi
exit 0


0 3 * * 1 root /etc/config/cnip.sh > /tmp/cnip.log

0 3 * * * . /etc/profile; /etc/config/cnip.sh
