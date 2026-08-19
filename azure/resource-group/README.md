# Azure Resource Group Module

## Purpose
Creates a standardized Azure Resource Group for enterprise workloads.

## Usage

```hcl
module "rg" {
  source = "git::https://github.com/myorg/terraform-modules.git//resource-group?ref=v1.0.0"

  name        = "rg-customer-api-dev"
  location    = "eastus"
  environment = "dev"
}
