#!/bin/bash

if [ "$(uname)" != "Darwin" ]; then
    echo "This script was designed for Docker Desktop on Mac OS."
    echo "Running it on Linux could be dangerous due with how it handles dealing with loop devices."
    exit 1
fi

echo "Deleting KinD cluster. This may take a few attempts."
while ! kind delete cluster; do
    echo "Sleeping 20 seconds before retrying."
    sleep 10
done

echo "Detaching dangling loop devices in docker."
cat <<'EOF' | docker run --rm -i --privileged quay.io/ceph/ceph:v17.2 bash < /dev/stdin
echo "Installing qemu-img in container."
dnf install -q -y qemu-img
echo "Detaching dangling loop devices."
for i in /dev/nbd*; do
    qemu-nbd --disconnect $i
done
losetup -D

for i in $(cat /sys/class/block/nbd*/size); do
    if [ "${i}" -ne "0" ]; then
        echo ERROR: Failed to disconnect a network block device;
        echo You might need to restart docker desktop to resolve this;
        exit 1
    fi
done
EOF

echo Done
