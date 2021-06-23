wget -c http://ftp.apnic.net/stats/apnic/delegated-apnic-latest -O /tmp/delegated-apnic-latest
rm /etc/config/chinaip.sh
cat /tmp/delegated-apnic-latest | awk -F '|' '/CN/&&/ipv4/ {print $4 "/" 32-log($5)/log(2)}' | tee /etc/config/chinaip.sh
#sed -i "/./{s/^/&route /;s/$/& net_gateway/}" chinaiplist.txt
sed -i "s/^/&ipset add chinaip /" /etc/config/chinaip.sh
sed -i "1 i\ipset create chinaip hash:net hashsize 10240" /etc/config/chinaip.sh
chmod 775 /etc/config/chinaip.sh
