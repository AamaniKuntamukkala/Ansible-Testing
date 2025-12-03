provider "azurerm" {
  features {}
}

terraform {
  required_version = "<= 1.8.5" # Force Terraform version

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "<= 4.0.0" # Force provider version (adjust as needed)
    }
  }

  backend "azurerm" {
    resource_group_name  = "tfstate-rg"          # RG where storage account lives
    storage_account_name = "tfstateaccount01"    # Storage account name
    container_name       = "tfstate"             # Blob container name
    key                  = "Ansible.tfstate"     # State file name
  }
}
