#!/bin/sh
#读取上一次查询的IP地址
odnsunlock=`cat /etc/config/old.dnsunlock.com`
echo "$odnsunlock"
#写入本次次查询的IP地址
#ping -c 1 hk1.dnsunlock.com | head -2 | tail -1 | awk '{print $4}' | sed 's/[(:)]//g' > /tmp/new.dnsunlock.com
#ping -c 1 tw1.dnsunlock.com | head -2 | tail -1 | awk '{print $4}' | sed 's/[(:)]//g' > /tmp/new.dnsunlock.com
ping -c 1 tw2.dnsunlock.com | head -2 | tail -1 | awk '{print $4}' | sed 's/[(:)]//g' > /tmp/new.dnsunlock.com
ndnsunlock=`cat /tmp/new.dnsunlock.com`
echo "$ndnsunlock"
#确认IP是否为空.
if [ -z "$ndnsunlock" ];then
    echo "can't connect"
    rm /tmp/new.dnsunlock.com
    /etc/init.d/dnsmasq restart
#两次获取IP对比.
elif
    [ "$odnsunlock" = "$ndnsunlock" ]; then
    echo "same ip"
    rm /tmp/new.dnsunlock.com
#判断IP更新后.
else
    echo "ip different"
    rm /etc/config/old.dnsunlock.com
    mv /tmp/new.dnsunlock.com /etc/config/old.dnsunlock.com
    sed -i "s/$odnsunlock/$ndnsunlock/g" /www/dnsmasq/dns_user.conf
    /etc/init.d/dnsmasq restart
fi
exit 0

计划任务中添加
*/10 * * * * /etc/config/steamsv.sh > /tmp/steamsv.log
