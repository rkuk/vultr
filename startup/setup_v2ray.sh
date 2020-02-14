#! /bin/bash

if [[ -z "$VULTR_SS_PASSWORD" ]]; then
    VULTR_SS_PASSWORD=$(date +%s%N|sha1sum|head -c10)
fi

git clone https://github.com/rkuk/vultr && cd vultr
chmod u+x bin/* && mv -f bin/* /usr/bin
chmod u+x script/*

# define VULTR_SS to enable ss
if [[ -n "$VULTR_SS" ]]; then
    script/v2ray.sh <<EOF
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
else
    script/v2ray.sh <<EOF
1
${VULTR_V2RAY_PROTOCOL:-22}
$VULTR_V2RAY_PORT
$VULTR_V2RAY_PORT_START
$VULTR_V2RAY_PORT_END
EOF
fi

cd .. && mkdir -p root/$VULTR_INFO_URL
cd root/$VULTR_INFO_URL
reformat="s/\x1B\[([0-9]{1,2}(;[0-9]{1,2}){0,2})?[m|K]//g;s/$/<br>/"
v2ray url|sed -r $reformat >v2ray.html
v2ray info|sed -r $reformat >>v2ray.html
if [[ -n "$VULTR_SS" ]]; then
    v2ray ssinfo|sed -r $reformat >ss.html
fi

cd .. && echo "<h3>403 Forbidden</h3>" > index.html
nohup python3 -m http.server 80 &>/dev/null &
