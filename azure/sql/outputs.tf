output "sql_server_id" {
  value = azurerm_mssql_server.server.id
}

output "sql_database_name" {
  value = azurerm_mssql_database.db.name
}
