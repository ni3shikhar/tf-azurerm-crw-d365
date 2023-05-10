# Terraform Block
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 2.0" 
    }
  } 
/*
# Terraform State Storage to Azure Storage Container
  backend "azurerm" {
    resource_group_name   = "rg-terraform-storage-state"
    storage_account_name  = "stgnmsterraformstate"
    container_name        = "tfstatefiles"
    key                   = "state-crw-d365-module.tfstate"
  }  */ 
}


# Provider Block
provider "azurerm" {
 features {}          
}



