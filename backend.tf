terraform {
  backend "azurerm" {
    resource_group_name  = "storage" 
    storage_account_name = "azterra1379"                      
    container_name       = "tfstate"                      
    key                  = "petApp.terraform.tfstate"        
  }
}