resource "azurerm_mssql_server" "server" {
  name                = var.server_name
  resource_group_name = var.resource_group_name
  location            = var.location

  version                      = "12.0"
  administrator_login          = "sqladmin"
  administrator_login_password = var.sql_admin_password

  minimum_tls_version = "1.2"
}

# Azure SQL denies every connection by default until a firewall rule allows it.
# 0.0.0.0/0.0.0.0 is Azure's documented special case for "Allow Azure services
# and resources to access this server" - firewall rules can't be scoped to a
# resource group, so this is the closest equivalent and also covers AKS.
resource "azurerm_mssql_firewall_rule" "allow_azure_services" {
  name             = "AllowAzureServicesAndResources"
  server_id        = azurerm_mssql_server.server.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
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
