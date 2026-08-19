# SQL Module

Creates Azure SQL Server and Database.

## Usage

```hcl
module "sql" {
  source = "git::https://github.com/myorg/terraform-modules.git//sql"

  server_name            = "sql-customer-dev"
  database_name          = "customerdb"
  resource_group_name    = module.rg.name
  location               = "eastus"

  administrator_password = var.sql_admin_password
  environment            = "dev"
}
