terraform {
  backend "azurerm" {
    resource_group_name  = "rg_tfstate"
    storage_account_name = "rsmith"
    container_name       = "tfstate"
    key                  = "prod/networking.tfstate"
  }
}

