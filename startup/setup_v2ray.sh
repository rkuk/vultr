#! /bin/bash

if [[ -z "$VULTR_SS_PASSWORD" ]]; then
    VULTR_SS_PASSWORD=$(echo "$RANDOM$RANDOM"|sha1sum|head -c10)
fi

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
$VULTR_SS_PASSWORD
${VULTR_SS_PROTOCOL:-2}
EOF

cd .. && mkdir -p root/$VULTR_INFO_URL
cd root/$VULTR_INFO_URL
v2ray info|sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g" >v2ray.html
v2ray url|sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g" >vmess.html
v2ray ssinfo|sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g" >ss.html

cd .. && echo "<h3>403 Forbidden</h3>" > index.html
nohup python3 -m http.server 80 &>/dev/null &
