# XAI Sentry Node Docker Image and Helm Chart

This repos produces the Docker image and Helm Chart for the XAI Sentry Node.

The source for the XAI Sentry Node is located at:
https://github.com/xai-foundation/sentry

The repo will automatically detect new releases of the XAI node each evening and produce a matching release of the Docker Image that is then pushed to Docker Hub.

If you are deploying the XAI Sentry Node to Kubernetes, you can references :latest of the image tag to automatically get the latest version of the XAI Sentry Node.
