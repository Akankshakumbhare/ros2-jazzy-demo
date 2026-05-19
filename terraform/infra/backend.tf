terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tf-backend"
    storage_account_name = "tfstorageacc100"
    container_name       = "tfstate"
    key                  = "aks-prod.tfstate"
  }
}