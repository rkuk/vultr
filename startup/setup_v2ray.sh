#! /bin/bash

if [[ -d vultr ]]; then
    exit 0
fi

git clone https://github.com/rkuk/vultr && cd vultr
chmod u+x bin/* && mv -f bin/* /usr/bin
chmod u+x script/* && script/v2ray.sh <<EOF
1
22
EOF

cd .. && mkdir -p root/$VULTR_V2RAY_URL
cd root/$VULTR_V2RAY_URL
v2ray <<EOF >v2ray.html
1
EOF
v2ray url >vess.html
# v2ray url >vess.html

cd .. && echo "<h3>403 Forbidden</h3>" > index.html
nohup python3 -m http.server 80 &
