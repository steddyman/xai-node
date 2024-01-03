# XAI Sentry Node Docker Image and Helm Chart

## Introduction

This repos produces the Docker image and Helm Chart for the XAI Sentry Node.

The source for the XAI Sentry Node is located at:
https://github.com/xai-foundation/sentry

## Docker Image

The repo will automatically detect new releases of the XAI node each evening and produce a matching release of the Docker Image that is then pushed to Docker Hub with the image steddyman/xai-node:version_tag.

## Deployment

### Docker Deployment

The image takes a single environment variable, `PRIVATE_KEY`, which is the private key for the node operator wallet.

To run the docker image from the command line, run:

```bash
docker run --name xai-node-container --pull=always -e PRIVATE_KEY=PRIVATE_KEY_VALUE steddyman/xai-node:latest
```

This will download the latest version of the image and run it within docker.  

To view the logs of the running container, run:

```bash
docker logs -f xai-node-container
```

To stop the running container, run:

```bash
docker stop xai-node-container
```

To remove the container, run:

```bash
docker rm xai-node-container
```

### Kubernetes Deployment

The **manifests** folder contains the Kubernetes deployment manifest for the XAI Sentry Node.  In order to deploy the XAI Sentry Node to a Kubernetes cluster, perform the following steps:

1. Create a Kubernetes namespace for the XAI Sentry Node

```bash
kubectl apply -f manifests/namespace.yaml
```

2. Create a Kubernetes secret for the XAI Sentry Node private key in the xai-node namespace, created in step 1.

```bash
kubectl create secret -n xai-node generic xai-node-key --from-literal=PRIVATE_KEY='your_private_key_here'
```

3. Deploy the XAI Sentry Node to the xai-node namespace, created in step 1.

```bash
kubectl apply -f manifests/deployment.yaml
```

The deployment contains a Kubernetes Liveness Probe that will restart the container if the XAI Sentry Node becomes unresponsive or crashes.

If you wish to deploy multiple nodes with different keys, just create additional namespaces and deploy the new secret and deployment manifests to the new namespace.
