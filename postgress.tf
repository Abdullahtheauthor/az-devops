resource "azurerm_postgresql_server" "db" {
  count               = var.vm_count
  name                = "postgress-${element(var.envs, count.index)}-${count.index + 1}"
  location            = azurerm_resource_group.petGroup.location
  resource_group_name = azurerm_resource_group.petGroup.name

  administrator_login          = var.username
  administrator_login_password = var.password

  sku_name   = element(var.sku, count.index)
  version    = "11"
  storage_mb = 640000

  backup_retention_days        = 7
  geo_redundant_backup_enabled = false
  auto_grow_enabled            = true

  public_network_access_enabled    = false
  ssl_enforcement_enabled          = true
  ssl_minimal_tls_version_enforced = "TLS1_2"
}

# PostgreSQL Firewall Rules
resource "azurerm_postgresql_firewall_rule" "allowed_ips" {
  count               = length(azurerm_public_ip.pip)
  name                = "allow_ip_${count.index}"
  resource_group_name = azurerm_resource_group.petGroup.name
  server_name         = azurerm_postgresql_server.db[count.index].name

  start_ip_address = azurerm_public_ip.pip[count.index].ip_address

  end_ip_address = azurerm_public_ip.pip[count.index].ip_address
}
