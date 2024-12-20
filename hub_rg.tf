resource "azurerm_resource_group" "hub_rg" {
  name     = "yb-hub-rg"
  location = "West Europe"
  lifecycle {
    ignore_changes = [tags]
  }
}
