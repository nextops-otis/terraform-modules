module "kv" {
  source = "git::https://github.com/nextops-otis/terraform-modules.git//azure/key-vault?ref=develop"

  name                = "${var.server_name}-${var.environment}-kv"
  resource_group_name = var.resource_group_name
  location            = var.location
  environment         = var.environment
}

resource "random_password" "sql_admin" {
  length  = 24
  special = true
}

resource "azurerm_key_vault_secret" "sql_password" {
  name         = "sql-admin-password"
  value        = random_password.sql_admin.result
  key_vault_id = module.kv.key_vault_id
}

resource "azurerm_mssql_server" "server" {
  name                         = var.server_name
  resource_group_name         = var.resource_group_name
  location                     = var.location

  version                      = "12.0"
  administrator_login         = "sqladmin"
  administrator_login_password = random_password.sql_admin.result

  minimum_tls_version = "1.2"
}

resource "azurerm_mssql_database" "db" {

  name      = var.database_name
  server_id = azurerm_mssql_server.server.id

  sku_name = "Basic"

  tags = {
    environment = var.environment
    managed_by  = "platform-team"
    ticket      = var.ticket
  }
}
