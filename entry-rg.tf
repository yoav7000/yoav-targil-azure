locals {
  resource_group_name = "yb-entry-rg"
}

resource "azurerm_resource_group" "entry_rg" {
  name     = local.resource_group_name
  location = "West Europe"
}
