# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.1.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}





# # PowerShell
# > $env:ARM_CLIENT_ID = "00000000-0000-0000-0000-000000000000"
# > $env:ARM_CLIENT_SECRET = "12345678-0000-0000-0000-000000000000"
# > $env:ARM_TENANT_ID = "10000000-0000-0000-0000-000000000000"
# > $env:ARM_SUBSCRIPTION_ID = "20000000-0000-0000-0000-000000000000"

# # sh
# export ARM_CLIENT_ID="00000000-0000-0000-0000-000000000000"
# export ARM_CLIENT_SECRET="12345678-0000-0000-0000-000000000000"
# export ARM_TENANT_ID="10000000-0000-0000-0000-000000000000"
# export ARM_SUBSCRIPTION_ID="20000000-0000-0000-0000-000000000000"

