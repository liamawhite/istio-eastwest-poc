#!/bin/bash

set -e

echo "========================================="
echo "Istio on Kind - Complete Setup"
echo "========================================="
echo ""

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Step 1: Setup kind cluster
echo "Step 1/2: Setting up kind cluster..."
"${SCRIPT_DIR}/scripts/setup-cluster.sh"
echo ""

# Step 2: Install Istio
echo "Step 2/2: Installing Istio..."
"${SCRIPT_DIR}/scripts/install-istio.sh"
echo ""

echo "========================================="
echo "Setup Complete!"
echo "========================================="
echo ""
echo "Your kind cluster with Istio 1.28.0 is ready to use."
echo ""
echo "Useful commands:"
echo "  - View cluster info:    kubectl cluster-info"
echo "  - View Istio pods:      kubectl get pods -n istio-system"
echo "  - Enable injection:     kubectl label namespace default istio-injection=enabled"
echo "  - Cleanup everything:   ./scripts/cleanup.sh"
echo ""
