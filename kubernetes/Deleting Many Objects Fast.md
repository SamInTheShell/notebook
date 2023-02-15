# Deleting Many Objects Fast
When the need to delete 100k or more objects, kubectl is very slow. A single `kubectl delete ...` comand performs multiple calls to the API and performs validations. If for some reason you have a million objects that need to be deleted, this would potentially take weeks to delete.

By making requests only to delete every object, the time taken for bulk deletion can be reduced significantly. Roughly 600k secrets can be deleted in less than an hour with 1000's of parallel requests.

Using an admin service account is recommended to avoid rate limiting that may happen.

The commands below were used to identify calico service account tokens to be deleted. 
```
# get all the secrets in the namespace
kubectl -n kube-system get secrets -oyaml > /tmp/kube-system-secrets.yaml

# find the secrets you want to delete
yq '.items[]|select(.metadata.name | match("^calico-(node|kube)")) | ["/api/v1/namespaces/kube-system/secrets", .metadata.name] | join("/")' /tmp/kube-system-secrets.yaml > /tmp/kube-system-secrets-delete-list.txt

# purge unused tokens
cat /tmp/kube-system-secrets-delete-list.txt | xargs -n 1 -P 1000 kubectl delete --raw
```
