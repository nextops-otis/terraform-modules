resource "azurerm_storage_account" "sa" {
  name                     = substr(replace(var.name, "-", ""), 0, 24)
  resource_group_name     = var.resource_group_name
  location                 = var.location

  account_tier            = var.account_tier
  account_replication_type = var.replication_type

  min_tls_version = "TLS1_2"

  allow_nested_items_to_be_public = false

  tags = {
    environment = var.environment
    managed_by  = "platform-team"
    ticket      = var.ticket
  }
}
