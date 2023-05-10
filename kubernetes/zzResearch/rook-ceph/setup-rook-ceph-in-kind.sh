#!/bin/bash

set -e

if [ "$(uname)" != "Darwin" ]; then
    echo "This script was designed for Docker Desktop on Mac OS."
    echo "Running it on Linux could be dangerous due to working with host level block devices."
    exit 1
fi

function require(){
    if ! command -v "${1}" &> /dev/null; then
        echo "Command not found: ${1}"
        exit 1
    fi
}

require kind
require helm

## change directory to where this script is
cd "$(dirname "${0}")"

## Setup a kind cluster with labels pointing at nodes that have local LVM pools
cat <<'EOF' | kind create cluster --config /dev/stdin --wait 300s
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
- role: worker
  labels:
    settings.cluster.local/lvm-storage-pool: "enabled"
- role: worker
  labels:
    settings.cluster.local/lvm-storage-pool: "enabled"
- role: worker
  labels:
    settings.cluster.local/lvm-storage-pool: "enabled"
- role: worker
EOF

## Install lvm-localpv to allocate
helm upgrade --install lvm-localpv lvm-localpv --namespace openebs-lvm-localpv --create-namespace --repo https://openebs.github.io/lvm-localpv --wait

## Install rook-ceph for ceph cluster management and csi tools
helm upgrade --install rook-ceph rook-ceph --create-namespace --namespace rook-ceph --repo https://charts.rook.io/release --wait

## Install metrics-server for resource usage details
helm --namespace kube-system upgrade --install metrics-server metrics-server --create-namespace --set 'args={--kubelet-insecure-tls}' --repo https://kubernetes-sigs.github.io/metrics-server --wait

## Setup lvm plug for kind and wait for it to be ready
kubectl apply -f ./manifests/kind-lvm-plug.yaml
kubectl wait pods -n kube-system -l name=kind-lvm-plug --for condition=Ready --timeout=90s

## Add storage class for volumegroup in lvm
kubectl apply -f ./manifests/kind-lvm-storageclass.yaml

## Setup kind cluster with rook-ceph
kubectl apply -f ./manifests/kind-cephcluster-on-local-lvm.yaml

echo "Waiting for ceph cluster to become ready..."
kubectl -n rook-ceph wait cephclusters rook-ceph --for condition=Ready --timeout=900s

echo "Done setting up Ceph cluster in KinD"
