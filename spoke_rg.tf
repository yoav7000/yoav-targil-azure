resource "azurerm_resource_group" "spoke_rg" {
  name     = "yb-spoke-rg"
  location = "West Europe"
  lifecycle {
    ignore_changes = [tags]
  }
}
