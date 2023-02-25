Helm is a package management solution for Kubernetes. The packages are called "charts" and they are made with Go Templates. The Helm command will read a chart, render Kubernetes manifests, and apply the resulting manifests to a cluster. This tool tracks the objects it applies to a cluster and can be used to perform rollbacks, upgrades, or uninstalls. An installed package is called a "release".

Refer to `Kind.md` if you need a test cluster.

# Release Management
TODO: Make notes about using helm to manage releases.

# Templating
Some template examples are provided in `helm-templating/` for handing common problems that might come up.

## Creating Helm Charts
```
% helm create chart-name
% mv chart-name chart
% rm -rf chart/templates/*
```

## Rendering
Viewing rendered templates can be done with the `helm template` command. Here is a fleshed out example that is handy to keep a note of.

```yaml
cat <<EOF | helm template --release-name RELEASE-NAME chart/ --values -
# values go here
EOF
```
