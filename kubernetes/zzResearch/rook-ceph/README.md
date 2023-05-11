# Rook Ceph
This script prepares a KinD cluster with some network block storage to test a rook-ceph cluster with OpenEBS lvm-localpv.
```
bash kubernetes/zzResearch/rook-ceph/setup-rook-ceph-in-kind.sh
```

Cleanup can be done with this script, to ensure that all unused loop devices are purged.
```
bash kubernetes/zzResearch/rook-ceph/cleanup-rook-ceph-in-kind.sh
```

## Implementing this on Hardware
An LVM volume group is expected to be setup on relevant cluster nodes, eliminating the need for `manifests/kind-lvm-plug.yaml`. Everything else done in the demo is pretty much the same.

## Shared File System
Create a `CephFilesystem` object and a `StorageClass` referencing it.
```
kubectl apply -f kubernetes/zzResearch/rook-ceph/manifests/cephfs.yaml
```

The status can be checked with this command.
```
kubectl -n rook-ceph get cephfilesystem myfs
```

Setup multiple nginx nodes relying on the new storage class.
```
kubectl apply -f kubernetes/zzResearch/rook-ceph/manifests/cephfs-nginx.yaml
```

These were all deployed in the default namespace.
```
kubectl get pv,pvc,pods
```

Once all the nginx pods are `Running`, this shell block will get all the nginx pod names, create a file on one of them, and show the file on all of them.
```
for nginxpod in $(kubectl get pods -oname); do
  kubectl exec -it ${nginxpod} -- bash -c '
    echo;echo;
    hostname;
    [ -f "/usr/share/nginx/html/hello.txt" ] || echo hello world > /usr/share/nginx/html/hello.txt; ls -lah /usr/share/nginx/html;
    echo;
    cat /usr/share/nginx/html/hello.txt';
done
```

## Further Reading
- Ceph Architecture (Video): https://www.youtube.com/watch?v=PmLPbrf-x9g
- Setting up consumable storage: https://rook.io/docs/rook/v1.11/Getting-Started/example-configurations/#setting-up-consumable-storage
- Filesystem Storage: https://rook.io/docs/rook/v1.11/CRDs/Shared-Filesystem/ceph-filesystem-crd/
- CephFilesystems across namespaces: https://github.com/rook/rook/blob/master/Documentation/Storage-Configuration/Shared-Filesystem-CephFS/filesystem-storage.md#consume-the-shared-filesystem-across-namespaces
- Block storage pool: https://rook.io/docs/rook/v1.11/CRDs/Block-Storage/ceph-block-pool-crd/
- Object storage: https://rook.io/docs/rook/v1.11/CRDs/Object-Storage/ceph-object-store-crd/
