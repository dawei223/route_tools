rm /etc/config/chinaip.sh
wget -c http://ftp.apnic.net/stats/apnic/delegated-apnic-latest
cat delegated-apnic-latest | awk -F '|' '/CN/&&/ipv4/ {print $4 "/" 32-log($5)/log(2)}' | tee /etc/config/chinaip.sh
#sed -i "/./{s/^/&route /;s/$/& net_gateway/}" chinaiplist.txt
sed -i "s/^/&ipset add chinaip /" /etc/config/chinaip.sh
sed -i "1 i\ipset create chinaip hash:net hashsize 10240" /etc/config/chinaip.sh
chmod 777 /etc/config/chinaip.sh
rm /etc/config/delegated-apnic-latest
