# Deploy with K8s

This repo will contain a collection small apps with docker configurations kubernetes manifests to be used as templates and example. The goal of this project is to make it easier for anyone to understand deployments with kubernetes.

## Development requirements for this repo

Note that the below requirements are only required to run the examples defined in this repository in your own local environment. The example are not meant for production environments and should be used in development / testing / homelab environments.

1. [Docker](https://docs.docker.com/engine/install/)
2. [Minikube](https://minikube.sigs.k8s.io/docs/start/?arch=%2Fmacos%2Fx86-64%2Fstable%2Fbinary+download)
3. [kubectl](https://kubernetes.io/docs/tasks/tools/)
4. [Helm](https://helm.sh/docs/intro/install/)
5. [Krane](https://github.com/Shopify/krane)
6. `golang / python / nodejs / etc... (see ./src/*/README.md)`


## Building and deploying

All examples will use `docker` for containerization. Most application templating will be done using `helm` and deployments will use `krane` for easy to understand live results.

## Examples

```

```
