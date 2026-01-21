# Istio East-West POC

A reproducible setup for a Kind cluster with Istio 1.28.0 for testing east-west traffic patterns.

## Prerequisites

Before running the setup, ensure you have the following tools installed:

- [Docker](https://docs.docker.com/get-docker/) - Required for Kind
- [kind](https://kind.sigs.k8s.io/docs/user/quick-start/#installation) - Kubernetes in Docker
- [kubectl](https://kubernetes.io/docs/tasks/tools/) - Kubernetes CLI

## Quick Start

Run the complete setup with a single command:

```bash
./setup.sh
```

This will:
1. Create a Kind cluster with 1 control-plane and 2 worker nodes
2. Download and install Istio 1.28.0
3. Configure the cluster with appropriate port mappings for Istio

## Manual Setup

You can also run the setup steps individually:

### 1. Create the Kind Cluster

```bash
./scripts/setup-cluster.sh
```

This creates a cluster using the configuration in `kind-config.yaml`.

### 2. Install Istio

```bash
./scripts/install-istio.sh
```

This downloads Istio 1.28.0 (if needed) and installs it with the default profile.

## Cluster Configuration

The Kind cluster is configured with:
- 1 control-plane node with ingress capabilities
- 2 worker nodes
- Port mappings for HTTP (80), HTTPS (443), and Istio health checks (15021)

See `kind-config.yaml` for the full configuration.

## Verify Installation

After setup, verify your installation:

```bash
# Check cluster info
kubectl cluster-info

# View Istio components
kubectl get pods -n istio-system

# Check Istio version
istioctl version
```

## Enable Sidecar Injection

To enable automatic sidecar injection for a namespace:

```bash
kubectl label namespace default istio-injection=enabled
```

## Cleanup

To delete the cluster and clean up resources:

```bash
./scripts/cleanup.sh
```

## Project Structure

```
.
├── README.md
├── setup.sh                    # Main setup script
├── kind-config.yaml            # Kind cluster configuration
└── scripts/
    ├── setup-cluster.sh        # Creates the Kind cluster
    ├── install-istio.sh        # Installs Istio 1.28.0
    └── cleanup.sh              # Cleanup script
```