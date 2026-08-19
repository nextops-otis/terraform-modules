resource "azurerm_log_analytics_workspace" "law" {
  name                = "${var.name}-law"
  location            = var.location
  resource_group_name = var.resource_group_name

  sku               = "PerGB2018"
  retention_in_days = 30

  tags = {
    environment = var.environment
    managed_by  = "platform-team"
    ticket      = var.ticket
  }
}

resource "azurerm_container_app_environment" "env" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id

  tags = {
    environment = var.environment
    managed_by  = "platform-team"
    ticket      = var.ticket
  }
}
