#!/bin/bash

if [ "$(uname)" != "Darwin" ]; then
    echo "This script was designed for Docker Desktop on Mac OS."
    echo "Running it on Linux could be dangerous due with how it handles dealing with loop devices."
    exit 1
fi

echo "Deleting KinD cluster. This may take a few attempts."
while ! kind delete cluster; do
    echo "Sleeping 20 seconds before retrying."
    sleep 10s
done

echo "Detaching dangling loop devices in docker."
cat <<'EOF' | docker run --rm --privileged quay.io/ceph/ceph:v17.2 bash
losetup -d $(losetup -l -J | jq -r '.loopdevices[] | select(.["back-file"] == "/") | .name')
EOF
