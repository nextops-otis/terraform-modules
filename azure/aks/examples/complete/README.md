# Example: Azure Kubernetes Service (AKS) Cluster

This example demonstrates how to use the AKS module from another repository.

## Usage

```hcl
terraform {
  required_version = ">= 1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Create Resource Group
resource "azurerm_resource_group" "example" {
  name     = "rg-example-aks"
  location = "eastus"
}

# Use the AKS module from this repository
module "aks_cluster" {
  source = "git::https://github.com/nextops-otis/terraform-modules.git//azure/aks?ref=develop"

  # Cluster Configuration
  cluster_name        = "example-aks-cluster"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  dns_prefix          = "exampleaks"
  kubernetes_version  = "1.28"
  sku_tier            = "Standard"

  # Default Node Pool
  default_node_pool = {
    name                = "system"
    node_count          = 3
    vm_size             = "Standard_D2s_v3"
    enable_auto_scaling = true
    min_count           = 2
    max_count           = 5
    max_pods            = 110
    os_disk_size_gb     = 128
    availability_zones  = ["1", "2", "3"]
  }

  # Network Configuration
  network_plugin     = "azure"
  network_policy     = "azure"
  service_cidr       = "10.0.0.0/16"
  dns_service_ip     = "10.0.0.10"
  docker_bridge_cidr = "172.17.0.1/16"

  # Security and Features
  enable_rbac                     = true
  enable_azure_policy             = true
  enable_http_application_routing = false
  enable_private_cluster          = false

  # Additional Node Pools
  additional_node_pools = [
    {
      name                = "workload"
      node_count          = 2
      vm_size             = "Standard_D4s_v3"
      enable_auto_scaling = true
      min_count           = 1
      max_count           = 4
      max_pods            = 110
      os_disk_size_gb     = 256
      availability_zones  = ["1", "2", "3"]
      node_labels = {
        workload-type = "application"
      }
      node_taints = []
    }
  ]

  # SSH Access (generate key pair first: ssh-keygen -t rsa -b 4096)
  admin_username = "azureuser"
  ssh_public_key = file("~/.ssh/id_rsa.pub")  # Replace with your SSH public key path

  # Tags
  tags = {
    Environment = "Development"
    Project     = "Example"
    ManagedBy   = "Terraform"
  }
}

# Outputs
output "cluster_id" {
  description = "AKS cluster ID"
  value       = module.aks_cluster.cluster_id
}

output "cluster_fqdn" {
  description = "AKS cluster FQDN"
  value       = module.aks_cluster.cluster_fqdn
}

output "kube_config_raw" {
  description = "Raw kubeconfig for kubectl access"
  value       = module.aks_cluster.kube_config_raw
  sensitive   = true
}

output "principal_id" {
  description = "Principal ID for managed identity"
  value       = module.aks_cluster.principal_id
}

output "node_resource_group" {
  description = "Resource group for AKS nodes"
  value       = module.aks_cluster.node_resource_group
}
```

## Steps to Run

1. Generate SSH key pair (if not already done):
   ```bash
   ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa
   ```

2. Initialize Terraform:
   ```bash
   terraform init
   ```

3. Review the execution plan:
   ```bash
   terraform plan
   ```

4. Apply the configuration (this will take 10-15 minutes):
   ```bash
   terraform apply
   ```

5. Get kubeconfig and connect to the cluster:
   ```bash
   # Save kubeconfig
   terraform output -raw kube_config_raw > ~/.kube/config
   
   # Or use Azure CLI
   az aks get-credentials --resource-group rg-example-aks --name example-aks-cluster
   
   # Verify connection
   kubectl get nodes
   ```

## Testing the Cluster

After the cluster is created, you can test it:

```bash
# View cluster information
kubectl cluster-info

# View nodes
kubectl get nodes

# Deploy a test application
kubectl create deployment nginx --image=nginx
kubectl expose deployment nginx --port=80 --type=LoadBalancer

# Get service details
kubectl get services
```

## Clean Up

To destroy the resources:
```bash
terraform destroy
```

**Note:** AKS cluster deletion can take several minutes.

## Important Notes

- AKS cluster creation typically takes 10-15 minutes
- The Standard SKU provides an SLA for production workloads
- Multiple availability zones provide high availability
- Consider using private clusters for enhanced security
- Node pools can be scaled independently
- Use Azure Policy for governance and compliance
- Monitor cluster health using Azure Monitor
- Plan network CIDR ranges to avoid conflicts with existing infrastructure
- SSH keys are recommended for secure node access
- Use managed identities for Azure resource access
