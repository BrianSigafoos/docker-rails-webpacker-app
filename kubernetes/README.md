# Kubernetes

## Pre-requisites

This README assumes the following are already set up in an EKS cluster running in AWS.

- deploy user in EKS
- [cluster autoscaler](https://github.com/kubernetes/autoscaler)
- [AWS load balancer controller](https://github.com/kubernetes-sigs/aws-load-balancer-controller)
- [external DNS](https://github.com/kubernetes-sigs/aws-load-balancer-controller)
- [image_pull_secrets](https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/#create-a-pod-that-uses-your-secret)
- [reflector](https://github.com/emberstack/kubernetes-reflector)
- [metrics server](https://github.com/kubernetes-sigs/metrics-server/)
- [Grafana](https://github.com/grafana/grafana)
- [Loki](https://github.com/grafana/loki)
- [Promtail](https://grafana.com/docs/loki/latest/clients/promtail/)

Install [Oh My Zsh](https://ohmyz.sh/) and add the `kubernetes` plugin
to benefit from all the shortcuts below like `k ...` and `kgp`, etc.

## Setup

### Create the configuration secrets for this app

Store in your password manager, and look for "demoapp k8s .env.production.local".
Copy and paste the contents to a .env.production.local file

Next, create a secret using this file:

```shell
# Create namespace
kubectl create namespace demoapp

# Add secret named "demoapp-secrets" as a generic type of secret from file
# with many entries.
# https://kubernetes.io/docs/concepts/configuration/secret/
kubectl -n demoapp create secret generic demoapp-secrets --from-env-file='.env.production.local'

# Show this secret
kubectl -n demoapp describe secret demoapp-secrets

# Clean up prod secrets from local machine
rm .env.production.local
```

## Usage

- Make changes to a folder in /overlays or to the /base and then check the output manually:

```shell
KUSTOMIZE_OVERLAY=kubernetes/overlays/canary
# View output after kustomize applies overlays
k kustomize $KUSTOMIZE_OVERLAY

# Update newTag like the "deploy" action does
# With SHA_SHORT from a recently built image:
# https://github.com/BrianSigafoos/docker-rails-webpacker-app/pkgs/container/docker-rails-webpacker-app
#
# IMAGE=ghcr.io/briansigafoos/docker-rails-webpacker-app
# SHA_SHORT=c702fa6
# cd kubernetes/overlays/canary
# kustomize edit set image "$IMAGE=:$SHA_SHORT"
#
# OR just manually paste into overlays `kustomization.yaml`

# Current state
k get -k $KUSTOMIZE_OVERLAY
k describe -k $KUSTOMIZE_OVERLAY

# Manually Apply!
# Check diff (dry-run server side) or run dry-run client
# kubectl apply -k kubernetes/overlays/canary --validate --dry-run='client'
k diff -k $KUSTOMIZE_OVERLAY
k apply -k $KUSTOMIZE_OVERLAY --validate; kgp -w

# Restart
k rollout restart deployment demoapp-app

# Get pods
# kubectl get pod
kgp
# Use jsonpath to get name of first pod
# kubectl get pod
POD_NAME=$(kgp -o=jsonpath='{.items[0].metadata.name}')
# kubectl describe pod
kdp $POD_NAME

# Quick debugging if the pod is running + available
# kubectl exec --stdin --tty $POD_NAME -- /bin/bash
keti $POD_NAME -- /bin/bash

# Or
k attach $POD_NAME -c $CONTAINER_NAME -it


# Install vim for troubleshooting
apt-get update -qq && apt-get install vim
# Force puma to restart (from pod)
bundle exec pumactl restart

# Teardown canary
# Change to ONLY remove deployment not ingress, etc !!!
# kubectl kustomize kubernetes/overlays/canary | yq e 'select(.kind != "Namespace")' - | kubectl delete -f -
```

## Debugging

- https://kubernetes.io/docs/tasks/debug-application-cluster/debug-application/
- https://kubernetes.io/docs/tasks/debug-application-cluster/debug-running-pod/

```shell
# Get pod name
# kubectl get pod
kgp

# Set env vars
POD_NAME=$(kgp -o=jsonpath='{.items[0].metadata.name}')
CONTAINER_NAME=demoapp-container

# Describe the pod to target. Shows Events on that pod
# kubectl describe pod $POD_NAME
kdp $POD_NAME

# View logs
# kubectl logs
# kl $POD_NAME $CONTAINER_NAME
kl $POD_NAME
# If failed
# kl $POD_NAME $CONTAINER_NAME --previous
kl $POD_NAME --previous

# Get interactive shell into the pod for debugging
# kubectl exec --stdin --tty $POD_NAME -- /bin/bash
keti $POD_NAME -- /bin/bash

# Create temporary debug pod copied from running pod
# k debug $POD_NAME -it --image=ubuntu --share-processes --copy-to=app-debug

# Debug a container that fails to start
# https://kubernetes.io/docs/tasks/debug-application-cluster/debug-running-pod/#copying-a-pod-while-changing-its-command
k debug $POD_NAME -it --copy-to=app-debug --container=$CONTAINER_NAME -- sh

k attach app-debug -c $CONTAINER_NAME -it

# Try running commands on container
# kubectl exec ${POD_NAME} -c ${CONTAINER_NAME} -- ${CMD} ${ARG1} ${ARG2} ... ${ARGN}
k exec $POD_NAME -c $CONTAINER_NAME --

# Clean up the debug pod
k delete pod app-debug
```

### Editing secrets

```shell
# Check secrets
kubectl get secret
# List all secrets
kubectl describe secret
# Show this secret
kubectl describe secret demoapp-secrets

# Delete secret
kubectl delete secrets demoapp-secrets

# Edit secrets to change/update
kubectl edit secrets demoapp-secrets
```

## References

- [kubectl cheatsheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)
- [Deploying a Rails App to a Kubernetes Cluster](https://www.civo.com/learn/deploying-a-rails-app-to-a-kubernetes-cluster)
- [Reddit: webserver for Kubernetes on Rails](https://www.reddit.com/r/rails/comments/ibhhij/which_web_server_is_best_to_run_kubernetes_for/)
- [Debugging - Restart pods](https://linuxhandbook.com/restart-pod-kubernetes/)

### Web servers for Rails / K8s

- [Rails on Kubernetes - NGINX setup](https://dev.lambdacu.be/blog/rails-on-kubernetes/)
  - [JakubOboza/RailsOnKubernetes](https://github.com/JakubOboza/RailsOnKubernetes)
- [PUMA in production for Rails](https://dev.to/anilmaurya/why-to-use-puma-in-production-for-your-rails-app-44ga)
  - [anilmaurya/puma-benchmark - determine Puma config](https://github.com/anilmaurya/puma-benchmark)
- [Gitlab migrate to Puma from Unicorn](https://about.gitlab.com/blog/2020/07/08/migrating-to-puma-on-gitlab/)
- [Puma docs: Kubernetes on Puma](https://github.com/puma/puma/blob/master/docs/kubernetes.md)

### Tips

- [Add namespace to context for kubectl](https://www.kubernet.dev/set-a-default-namespace-for-kubectl/)
- [Add container limits for AppSignal](https://docs.appsignal.com/metrics/host-metrics/containers.html#container-limits)
