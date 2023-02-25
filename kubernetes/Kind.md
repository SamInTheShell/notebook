[Kind](https://kind.sigs.k8s.io/) is a tool for running local Kubernetes clusters in docker, hence "Kubernetes in Docker". This tool is extremely useful for testing, development, and prototyping.

The [quick start](https://kind.sigs.k8s.io/docs/user/quick-start/) guide has information about installation.

Kubernetes is meant for building redundant systems that have many nodes and automatic failover. Using kind, you are able to create multi-node clusters locally. This is ideal for use cases where node affinity, taints, and tolerance rules need to be tests.

This is how to create a cluster with 3 worker nodes.
```yaml
cat <<EOF | kind create cluster --config /dev/stdin
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  ## You can define the image for each kind node
  # image: kindest/node:v1.24.7
  # image: kindest/node:v1.22.15
- role: worker
- role: worker
- role: worker
EOF
```

Listing kind cluster (or clusters if for some reason you're running multiple).
```
kind get clusters
```

Deleting your kind cluster.
```
kind delete cluster
```
