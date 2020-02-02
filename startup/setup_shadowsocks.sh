#!/bin/sh

if [[ -z VULTR_SS_PORT ]]; then
    VULTR_SS_PORT=8388
fi
if [[ -z VULTR_SS_PASSWORD ]]; then
    VULTR_SS_PASSWORD=$(cat /dev/urandom|tr -dc "[:alnum:]"|fold -w 10|head -n1)
fi

apt-get update -y
apt -y install shadowsocks-libev

echo -n > /etc/shadowsocks-libev/config.json
echo "{" >> /etc/shadowsocks-libev/config.json
echo "\"server\":\"$(hostname -I)\"," >> /etc/shadowsocks-libev/config.json
echo "\"server_port\":$VULTR_SS_PORT," >> /etc/shadowsocks-libev/config.json
echo "\"local_port\":1080," >> /etc/shadowsocks-libev/config.json
echo "\"password\":\"$VULTR_SS_PASSWORD\"," >> /etc/shadowsocks-libev/config.json
echo "\"timeout\":60," >> /etc/shadowsocks-libev/config.json
echo "\"method\":\"aes-256-cfb\"" >> /etc/shadowsocks-libev/config.json
echo "}" >> /etc/shadowsocks-libev/config.json

cat /etc/shadowsocks-libev/config.json
/etc/init.d/shadowsocks-libev start
/etc/init.d/shadowsocks-libev stop

echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
sysctl -p
sysctl net.ipv4.tcp_available_congestion_control
lsmod | grep bbr

/etc/init.d/shadowsocks-libev start
