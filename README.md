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

## Example build and deploy

```
❯ make build python-echo-server
build with subcommand: python-echo-server
/Library/Developer/CommandLineTools/usr/bin/make build-python-echo-server
Running build for python-echo-server...

./scripts/build_image.sh applications/python-echo-server
[+] Building 0.9s (13/13) FINISHED                                                                                                                 docker:desktop-linux
 => [internal] load build definition from Dockerfile                                                                                                               0.0s
 => => transferring dockerfile: 1.39kB                                                                                                                             0.0s
 => resolve image config for docker-image://docker.io/docker/dockerfile:1                                                                                          0.5s
 => CACHED docker-image://docker.io/docker/dockerfile:1@sha256:a57df69d0ea827fb7266491f2813635de6f17269be881f696fbfdf2d83dda33e                                    0.0s
 => [internal] load metadata for docker.io/library/python:3.12.4-slim                                                                                              0.3s
 => [internal] load .dockerignore                                                                                                                                  0.0s
 => => transferring context: 671B                                                                                                                                  0.0s
 => [base 1/6] FROM docker.io/library/python:3.12.4-slim@sha256:2fba8e70a87bcc9f6edd20dda0a1d4adb32046d2acbca7361bc61da5a106a914                                   0.0s
 => [internal] load build context                                                                                                                                  0.0s
 => => transferring context: 218B                                                                                                                                  0.0s
 => CACHED [base 2/6] WORKDIR /app                                                                                                                                 0.0s
 => CACHED [base 3/6] RUN adduser     --disabled-password     --gecos ""     --home "/nonexistent"     --shell "/sbin/nologin"     --no-create-home     --uid "10  0.0s
 => CACHED [base 4/6] RUN --mount=type=cache,target=/root/.cache/pip     --mount=type=bind,source=requirements.txt,target=requirements.txt     python -m pip inst  0.0s
 => CACHED [base 5/6] COPY . .                                                                                                                                     0.0s
 => CACHED [base 6/6] RUN chmod +x /app/main.py                                                                                                                    0.0s
 => exporting to image                                                                                                                                             0.0s
 => => exporting layers                                                                                                                                            0.0s
 => => writing image sha256:4d8a5727c4a92772802c8f52bb8e9df052fd81e5dc790545c223894fb0a46b48                                                                       0.0s
 => => naming to docker.io/library/python-echo-server:v1.0                                                                                                         0.0s
 => => naming to docker.io/library/python-echo-server:latest                                                                                                       0.0s

What's next:
    View a summary of image vulnerabilities and recommendations → docker scout quickview

❯ make deploy python-echo-server
deploy with subcommand: python-echo-server
/Library/Developer/CommandLineTools/usr/bin/make deploy-python-echo-server
Running deploy for python-echo-server...

./scripts/deploy.sh -n python-echo-server -d applications/python-echo-server/deploy
[INFO][2024-06-19 21:57:04 -0400]
[INFO][2024-06-19 21:57:04 -0400]	------------------------------------Phase 1: Initializing deploy------------------------------------
[INFO][2024-06-19 21:57:05 -0400]	All required parameters and files are present
[INFO][2024-06-19 21:57:05 -0400]	Discovering resources:
[INFO][2024-06-19 21:57:05 -0400]	  - Deployment/python-echo-server
[INFO][2024-06-19 21:57:05 -0400]	  - Service/python-echo-server-svc
[INFO][2024-06-19 21:57:05 -0400]
[INFO][2024-06-19 21:57:05 -0400]	----------------------------Phase 2: Checking initial resource statuses-----------------------------
[INFO][2024-06-19 21:57:06 -0400]	Deployment/python-echo-server                     1 replica, 1 updatedReplica, 1 availableReplica
[INFO][2024-06-19 21:57:06 -0400]	Service/python-echo-server-svc                    Selects at least 1 pod
[INFO][2024-06-19 21:57:06 -0400]
[INFO][2024-06-19 21:57:06 -0400]	----------------------------------Phase 3: Deploying all resources----------------------------------
[INFO][2024-06-19 21:57:06 -0400]	Deploying resources:
[INFO][2024-06-19 21:57:06 -0400]	- Deployment/python-echo-server (progress deadline: 600s)
[INFO][2024-06-19 21:57:06 -0400]	- Service/python-echo-server-svc (timeout: 420s)
[INFO][2024-06-19 21:57:10 -0400]	Successfully deployed in 3.6s: Deployment/python-echo-server, Service/python-echo-server-svc
[INFO][2024-06-19 21:57:10 -0400]
[INFO][2024-06-19 21:57:10 -0400]	------------------------------------------Result: SUCCESS-------------------------------------------
[INFO][2024-06-19 21:57:10 -0400]	Successfully deployed 2 resources
[INFO][2024-06-19 21:57:10 -0400]
[INFO][2024-06-19 21:57:10 -0400]	Successful resources
[INFO][2024-06-19 21:57:10 -0400]	Deployment/python-echo-server                     1 replica, 1 updatedReplica, 1 availableReplica
[INFO][2024-06-19 21:57:10 -0400]	Service/python-echo-server-svc                    Selects at least 1 pod

❯ kcl --context minikube -n python-echo-server get all
NAME                                     READY   STATUS    RESTARTS   AGE
pod/python-echo-server-d84844957-zl2wb   1/1     Running   0          3h24m

NAME                             TYPE       CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
service/python-echo-server-svc   NodePort   10.107.121.68   <none>        80:31016/TCP   3h24m

NAME                                 READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/python-echo-server   1/1     1            1           3h24m

NAME                                           DESIRED   CURRENT   READY   AGE
replicaset.apps/python-echo-server-d84844957   1         1         1       3h24m
```
