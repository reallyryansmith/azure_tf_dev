terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.30.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "055e4d31-9ec6-4c04-95e6-65c5171da4d6"
}

