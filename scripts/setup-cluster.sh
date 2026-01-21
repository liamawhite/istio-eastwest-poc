#!/bin/bash

set -e

CLUSTER_NAME="istio-cluster"
CONFIG_FILE="kind-config.yaml"

echo "Setting up kind cluster: ${CLUSTER_NAME}"

# Check if kind is installed
if ! command -v kind &> /dev/null; then
    echo "Error: kind is not installed. Please install kind first."
    echo "Visit: https://kind.sigs.k8s.io/docs/user/quick-start/#installation"
    exit 1
fi

# Check if kubectl is installed
if ! command -v kubectl &> /dev/null; then
    echo "Error: kubectl is not installed. Please install kubectl first."
    exit 1
fi

# Check if cluster already exists
if kind get clusters 2>/dev/null | grep -q "^${CLUSTER_NAME}$"; then
    echo "Cluster ${CLUSTER_NAME} already exists. Deleting it first..."
    kind delete cluster --name "${CLUSTER_NAME}"
fi

# Create the cluster
echo "Creating kind cluster with config from ${CONFIG_FILE}..."
kind create cluster --config="${CONFIG_FILE}"

# Wait for cluster to be ready
echo "Waiting for cluster to be ready..."
kubectl wait --for=condition=Ready nodes --all --timeout=300s

echo "Kind cluster ${CLUSTER_NAME} is ready!"
kubectl cluster-info --context "kind-${CLUSTER_NAME}"
