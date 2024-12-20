resource "azurerm_resource_group" "entry_rg" {
  name     = "yb-entry-rg"
  location = "West Europe"
  lifecycle {
    ignore_changes = [tags]
  }
}
