# flux2
A toolkit for managing deployments in Kubernetes.

## Installation
```
helm --namespace flux-system upgrade flux2 flux2 --install --create-namespace --version '~2.2.0' --repo https://fluxcd-community.github.io/helm-charts
```

## Resources
- HelmRespositories
- HelmReleases
- Kustomizations
- GitRepositories

# Weave GitOps and Dex
Dex is an OICD provider that can auth with various different providers.
Weave GitOps is the web GUI for Flux 2.

The examples for Dex and Weave GitOps demonstrate how auth and impersonatio can work.
It was tested locally in a KIND cluster.

The contents of `/etc/hosts` included these hostname mappings.
```
127.0.0.1 dex.auth-system.svc.cluster.local
127.0.0.1 weave-gitops.flux-system.svc.cluster.local
```

These two port-forwards were left running in separate terminals.
```sh
kubectl -n flux-system port-forward svc/weave-gitops 9001:9001
kubectl -n auth-system port-forward svc/dex 5556:5556

# Consider wrapping them in a loop
while true; do kubectl -n auth-system port-forward <...>; sleep 4; done
```

Dex is configured to use Github for authentication. Weave GitOps impersonates the user based on their team.

RBAC for the team is configured in `weave-gitops-dex-rbac.yaml`. 
