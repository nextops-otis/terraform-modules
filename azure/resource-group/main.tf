resource "azurerm_resource_group" "rg" {

  name     = var.name
  location = var.location

  tags = merge(
    {
      environment = var.environment
      managed_by  = "platform-team"
      ticket      = var.ticket
    },
    var.tags
  )
}
