#! /bin/bash

git clone https://github.com/rkuk/vultr && cd vultr
chmod u+x bin/* && mv -f bin/* /usr/bin
chmod u+x script/* && script/v2ray.sh <<EOF
1
${VULTR_V2RAY_PROTOCOL:-22}
$VULTR_V2RAY_PORT
$VULTR_V2RAY_PORT_START
$VULTR_V2RAY_PORT_END
n
y
$VULTR_SS_PORT
${VULTR_SS_PASSWORD:-$(cat /dev/urandom|tr -dc "[:alnum:]"|fold -w 10|head -n1)}
${VULTR_SS_PROTOCOL:-2}
EOF

cd .. && mkdir -p root/$VULTR_INFO_URL
cd root/$VULTR_INFO_URL
v2ray info >v2ray.html
v2ray url >vmess.html
v2ray ssinfo >ss.html

cd .. && echo "<h3>403 Forbidden</h3>" > index.html
nohup python3 -m http.server 80 &>/dev/null &
