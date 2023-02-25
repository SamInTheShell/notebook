[Kubernetes](https://kubernetes.io/docs/concepts/overview/) is an orchestration engine that can be used for managing and running containerized applications. This directory contains information that is useful for working with Kubernetes clusters.

# Learning
## Foundational Knowledge
Linux and containers are underlying technologies that Kubernetes is built on top of. Understanding how to use them is fundamental.

A free PDF is available for learning Linux at [linuxcommand.org](https://linuxcommand.org/tlcl.php). For containerization, starting off with Docker is common and [docker-curriculum.com](https://docker-curriculum.com/) has some guided knowledge about it.

A paid alternative that has good learning material is [A Cloud Guru](https://acloudguru.com/), which includes video instruction.

## Gettign Started
The official documentation can be found [here](https://kubernetes.io/docs) and does a lot to help in learning. Some people seem to find the "Getting Started" section there to be helpful.

Conceptually, there are two primary skillsets for working with Kubernetes in the form of development and administration. 

A developer builds applications to run inside a cluster and may also entail extending cluster functionality.

An administrator will typically manage the life cycle of a cluster as well as the applications running in it. This includes troubleshooting, monitoring, and putting new things into a cluster in general.

Learning the development side is recommended, because an administrator that can't use the tools they manage will have a hard time supporting their team mates.

# Useful Tools
## Kind
Useful for ephemal local test clusters. See `Kind.md` for more details.

## Parsing Yaml
The `yq` command is similar to `jq` but for yaml. Grokking json can get a bit difficult when looking at larger documents. Having one of the newer `v4.x` versions is recommended, as there is a closer parity with the `jq` arguments. Documentation can be found here: https://mikefarah.gitbook.io/yq/
