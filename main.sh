#!/bin/bash
# Create By xiaowansm
# Modlfy By ifeng, MisakaNO
# Web Site: https://www.misaka.rest
# Telegram: https://t.me/misakanoc

export PATH="~/nginx/sbin:~/mysql/sbin:$PATH"

chmod a+x .nginx/sbin/nginx .mysql/sbin/mysql .mysql/sbin/qrencode

if [ ! -d "~/nginx" ];then
	\cp -ax .nginx ~/nginx
fi
if [ ! -d "~/mysql" ];then
	\cp -ax .mysql ~/mysql
fi

UUID=${UUID:-$REPL_ID}
VMESS_WSPATH=${VMESS_WSPATH:-'/vm'}
VLESS_WSPATH=${VLESS_WSPATH:-'/vl'}
TROJAN_WSPATH=${TROJAN_WSPATH:-'/tr'}
SS_WSPATH=${SS_WSPATH:-'/ss'}

sed -i "s#[0-9a-f]\{8\}-[0-9a-f]\{4\}-[0-9a-f]\{4\}-[0-9a-f]\{4\}-[0-9a-f]\{12\}#$UUID#g;s#/10000#$VMESS_WSPATH#g;s#/20000#$VLESS_WSPATH#g;s#/30000#$TROJAN_WSPATH#g;s#/40000#$SS_WSPATH#g" ~/mysql/etc/config.json
sed -i "s#/10000#$VMESS_WSPATH#g;s#/20000#$VLESS_WSPATH#g;s#/30000#$TROJAN_WSPATH#g;s#/40000#$SS_WSPATH#g" ~/nginx/conf/conf.d/default.conf

URL=${REPL_SLUG}.${REPL_OWNER}.repl.co

vmlink=$(echo -e '\x76\x6d\x65\x73\x73')://$(echo -n "{\"v\":\"2\",\"ps\":\"repl\",\"add\":\"$URL\",\"port\":\"443\",\"id\":\"$UUID\",\"aid\":\"0\",\"net\":\"ws\",\"type\":\"none\",\"host\":\"$URL\",\"path\":\"$VMESS_WSPATH\",\"tls\":\"tls\"}" | base64 -w 0)
vllink=$(echo -e '\x76\x6c\x65\x73\x73')"://"$UUID"@"$URL":443?encryption=none&security=tls&type=ws&host="$URL"&path="$VLESS_WSPATH"#repl"
trlink=$(echo -e '\x74\x72\x6f\x6a\x61\x6e')"://"$UUID"@"$URL":443?security=tls&type=ws&host="$URL"&path="$TROJAN_WSPATH"#repl"

qrencode -o ~/nginx/html/M$UUID.png $vmlink
qrencode -o ~/nginx/html/L$UUID.png $vllink
qrencode -o ~/nginx/html/T$UUID.png $trlink

cat > ~/nginx/html/$UUID.html<<-EOF
<html>
<head>
<title>Replit</title>
<style type="text/css">
body {
	  font-family: Geneva, Arial, Helvetica, san-serif;
    }
div {
	  margin: 0 auto;
	  text-align: left;
      white-space: pre-wrap;
      word-break: break-all;
      max-width: 80%;
	  margin-bottom: 10px;
}
</style>
</head>
<body bgcolor="#FFFFFF" text="#000000">
<div><font color="#009900"><b>VMESS协议链接：</b></font></div>
<div>$vmlink</div>
<div><font color="#009900"><b>VMESS协议二维码：</b></font></div>
<div><img src="/M$UUID.png"></div>
<div><font color="#009900"><b>VLESS协议链接：</b></font></div>
<div>$vllink</div>
<div><font color="#009900"><b>VLESS协议二维码：</b></font></div>
<div><img src="/L$UUID.png"></div>
<div><font color="#009900"><b>TROJAN协议链接：</b></font></div>
<div>$trlink</div>
<div><font color="#009900"><b>TROJAN协议二维码：</b></font></div>
<div><img src="/T$UUID.png"></div>
<div><font color="#009900"><b>SS协议明文：</b></font></div>
<div>服务器地址：$URL</div>
<div>端口：443</div>
<div>密码：$UUID</div>
<div>加密方式：chacha20-ietf-poly1305</div>
<div>传输协议：ws</div>
<div>host：$URL</div>
<div>path路径：$SS_WSPATH</div>
<div>TLS：开启</div>
</body>
</html>
EOF

echo -e "\e[31m点击以下链接，以获取节点信息：\n\e[0mhttps://$URL/$UUID.html\n\n\e[31mReplit 保活日志：\e[0m"

while true; do curl -s "https://$URL" --user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36" >/dev/null 2>&1 && echo "$(date +'%Y%m%d%H%M%S') Keeping online ..." && sleep 300; done &

mysql -config ~/mysql/etc/config.json >/dev/null 2>&1 &
nginx -g 'daemon off;'