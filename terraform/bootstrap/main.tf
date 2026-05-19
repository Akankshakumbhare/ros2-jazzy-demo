resource "azurerm_resource_group" "backend_rg" {
  name     = "rg-tf-backend"
  location = "East US"
}

resource "azurerm_storage_account" "backend_sa" {
  name                     = "tfstorageacc100"
  resource_group_name      = azurerm_resource_group.backend_rg.name
  location                 = azurerm_resource_group.backend_rg.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  min_tls_version                 = "TLS1_2"
  public_network_access_enabled   = true
  allow_nested_items_to_be_public = false
}

resource "azurerm_storage_container" "backend_container" {
  name                  = "tfstate"
  storage_account_id    = azurerm_storage_account.backend_sa.id
  container_access_type = "private"
}