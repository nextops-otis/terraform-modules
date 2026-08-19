# Storage Module

Creates an Azure Storage Account for application workloads.

## Usage

```hcl
module "storage" {
  source = "git::https://github.com/myorg/terraform-modules.git//storage"

  name                = "stcustomerdev"
  resource_group_name = module.rg.name
  location            = "eastus"
  environment         = "dev"
}
