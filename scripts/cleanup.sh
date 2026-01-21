#!/bin/bash

set -e

CLUSTER_NAME="istio-cluster"

echo "Cleaning up resources..."

# Check if kind is installed
if ! command -v kind &> /dev/null; then
    echo "Error: kind is not installed."
    exit 1
fi

# Check if cluster exists
if kind get clusters 2>/dev/null | grep -q "^${CLUSTER_NAME}$"; then
    echo "Deleting kind cluster: ${CLUSTER_NAME}..."
    kind delete cluster --name "${CLUSTER_NAME}"
    echo "Cluster ${CLUSTER_NAME} deleted successfully!"
else
    echo "Cluster ${CLUSTER_NAME} does not exist. Nothing to clean up."
fi

# Optionally clean up downloaded Istio directory
if [ -d "istio-1.28.0" ]; then
    read -p "Do you want to delete the downloaded Istio directory (istio-1.28.0)? [y/N] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -rf istio-1.28.0
        echo "Istio directory removed."
    fi
fi

echo "Cleanup complete!"
