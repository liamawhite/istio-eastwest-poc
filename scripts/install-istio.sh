#!/bin/bash

set -e

ISTIO_VERSION="1.28.0"
CLUSTER_NAME="istio-cluster"

echo "Installing Istio ${ISTIO_VERSION}"

# Check if istioctl is installed
if ! command -v istioctl &> /dev/null; then
    echo "istioctl not found. Downloading Istio ${ISTIO_VERSION}..."

    # Download Istio
    curl -L https://istio.io/downloadIstio | ISTIO_VERSION=${ISTIO_VERSION} sh -

    # Add istioctl to PATH for this session
    export PATH="$PWD/istio-${ISTIO_VERSION}/bin:$PATH"

    echo "Downloaded Istio to istio-${ISTIO_VERSION}/"
    echo "Add istioctl to your PATH permanently by running:"
    echo "  export PATH=\"\$PWD/istio-${ISTIO_VERSION}/bin:\$PATH\""
else
    # Check if the installed version matches
    INSTALLED_VERSION=$(istioctl version --remote=false 2>/dev/null | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1)
    if [ "$INSTALLED_VERSION" != "$ISTIO_VERSION" ]; then
        echo "Warning: istioctl version ${INSTALLED_VERSION} is installed, but ${ISTIO_VERSION} is required."
        echo "Downloading Istio ${ISTIO_VERSION}..."
        curl -L https://istio.io/downloadIstio | ISTIO_VERSION=${ISTIO_VERSION} sh -
        export PATH="$PWD/istio-${ISTIO_VERSION}/bin:$PATH"
    fi
fi

# Verify kubectl context
CURRENT_CONTEXT=$(kubectl config current-context)
if [ "$CURRENT_CONTEXT" != "kind-${CLUSTER_NAME}" ]; then
    echo "Warning: Current kubectl context is ${CURRENT_CONTEXT}, expected kind-${CLUSTER_NAME}"
    echo "Switching to kind-${CLUSTER_NAME}..."
    kubectl config use-context "kind-${CLUSTER_NAME}"
fi

# Install Istio with the default profile
echo "Installing Istio with default profile..."
istioctl install --set profile=default -y

# Wait for Istio to be ready
echo "Waiting for Istio components to be ready..."
kubectl wait --for=condition=available --timeout=300s deployment/istiod -n istio-system
kubectl wait --for=condition=available --timeout=300s deployment/istio-ingressgateway -n istio-system

echo "Istio ${ISTIO_VERSION} installation complete!"
echo ""
echo "Istio components:"
kubectl get pods -n istio-system
echo ""
echo "To enable automatic sidecar injection for a namespace, run:"
echo "  kubectl label namespace <namespace> istio-injection=enabled"
