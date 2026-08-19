# Azure Kubernetes Service (AKS) Module

This module creates an Azure Kubernetes Service (AKS) cluster with configurable node pools, networking, and security settings.

## Features

- Creates AKS cluster with customizable Kubernetes version
- Supports multiple node pools with auto-scaling
- Configurable network settings (Azure CNI or Kubenet)
- Azure AD integration support
- Role-Based Access Control (RBAC)
- Network policies support
- Azure Monitor integration
- Managed identity support
- Private cluster option
- HTTP application routing (optional)

## Usage

```hcl
module "aks_cluster" {
  source = "git::https://github.com/nextops-otis/terraform-modules.git//azure/aks?ref=develop"

  # Required variables
  cluster_name        = "my-aks-cluster"
  resource_group_name = "my-rg"
  location            = "eastus"
  dns_prefix          = "myaks"

  # Node pool configuration
  default_node_pool = {
    name                = "default"
    node_count          = 3
    vm_size             = "Standard_D2s_v3"
    enable_auto_scaling = true
    min_count           = 2
    max_count           = 5
  }

  # Networking
  network_plugin     = "azure"
  network_policy     = "azure"
  service_cidr       = "10.0.0.0/16"
  dns_service_ip     = "10.0.0.10"
  docker_bridge_cidr = "172.17.0.1/16"

  tags = {
    Environment = "Production"
    ManagedBy   = "Terraform"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| azurerm | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| azurerm | >= 3.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cluster_name | Name of the AKS cluster | `string` | n/a | yes |
| resource_group_name | Name of the resource group | `string` | n/a | yes |
| location | Azure region | `string` | n/a | yes |
| dns_prefix | DNS prefix for the cluster | `string` | n/a | yes |
| kubernetes_version | Kubernetes version | `string` | `null` | no |
| default_node_pool | Default node pool configuration | `object` | See below | yes |
| network_plugin | Network plugin (azure or kubenet) | `string` | `"azure"` | no |
| network_policy | Network policy (azure or calico) | `string` | `"azure"` | no |
| service_cidr | Service CIDR | `string` | `"10.0.0.0/16"` | no |
| dns_service_ip | DNS service IP | `string` | `"10.0.0.10"` | no |
| docker_bridge_cidr | Docker bridge CIDR | `string` | `"172.17.0.1/16"` | no |
| enable_rbac | Enable RBAC | `bool` | `true` | no |
| enable_azure_policy | Enable Azure Policy | `bool` | `false` | no |
| enable_http_application_routing | Enable HTTP application routing | `bool` | `false` | no |
| enable_private_cluster | Enable private cluster | `bool` | `false` | no |
| enable_auto_scaling | Enable cluster auto-scaling | `bool` | `true` | no |
| sku_tier | SKU tier (Free or Standard) | `string` | `"Free"` | no |
| additional_node_pools | Additional node pools | `list(object)` | `[]` | no |
| tags | Tags to apply to resources | `map(string)` | `{}` | no |

### Default Node Pool Object

```hcl
default_node_pool = {
  name                = string
  node_count          = number
  vm_size             = string
  enable_auto_scaling = bool
  min_count           = number (optional)
  max_count           = number (optional)
  max_pods            = number (optional)
  os_disk_size_gb     = number (optional)
  availability_zones  = list(string) (optional)
}
```

## Outputs

| Name | Description |
|------|-------------|
| cluster_id | ID of the AKS cluster |
| cluster_name | Name of the AKS cluster |
| kube_config | Kubernetes configuration (sensitive) |
| kube_config_raw | Raw Kubernetes configuration (sensitive) |
| cluster_fqdn | FQDN of the AKS cluster |
| node_resource_group | Resource group for AKS nodes |
| principal_id | Principal ID of the system-assigned identity |
| kubelet_identity | Kubelet identity details |

## Examples

See the [examples](./examples/) directory for complete usage examples.

## Important Notes

- AKS cluster creation can take 10-15 minutes
- Consider using Standard SKU for production workloads
- Use private clusters for enhanced security
- Enable Azure Monitor for cluster monitoring
- Plan your network CIDR ranges carefully to avoid conflicts
