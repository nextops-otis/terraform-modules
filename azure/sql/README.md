# SQL Module

Creates an Azure SQL Server and Database, with a firewall rule allowing Azure
services and resources (including AKS) to connect. Does not create its own
Key Vault - the admin password is a plain input variable with a default.

## Usage

```hcl
module "sql" {
  source = "git::https://github.com/myorg/terraform-modules.git//sql"

  server_name            = "sql-customer-dev"
  database_name          = "customerdb"
  resource_group_name    = module.rg.name
  location               = "eastus"

  sql_admin_password     = "NexTOps@312" # optional - this is the default
  environment            = "dev"
}
