terraform {
  required_version = ">= 0.13.1"

  required_providers {
    azurerm = {
      version = ">= 3.18.0"
      source  = "hashicorp/azurerm"
    }
    azurecaf = {
      source  = "aztfmod/azurecaf"
      version = ">= 1.2.15"
    }
    /*
    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 2.15.0"
    }
    */
  }
  backend "azurerm" {
    resource_group_name  = "rg-tfstate"
    storage_account_name = "tfstate-production"
    container_name       = "tfstate"
    key                  = "container-apps/terraform.tfstate"
    use_oidc             = true
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = false
    }
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  use_oidc = true
}

/*
# Configure the Azure Active Directory Provider
provider "azuread" {
  tenant_id = "00000000-0000-0000-0000-000000000000"
}
*/

# Make client_id, tenant_id, subscription_id and object_id variables
data "azurerm_client_config" "current" {}

# data "azuread_client_config" "current" {}
