resource "azurerm_network_security_group" "example" {
  name                = "example-security-group"
  location            = azurerm_resource_group.entry_rg.location
  resource_group_name = azurerm_resource_group.entry_rg.name
}

resource "azurerm_virtual_network" "example" {
  name                = "yb-entry-network"
  location            = azurerm_resource_group.entry_rg.location
  resource_group_name = azurerm_resource_group.entry_rg.name
  address_space = ["10.0.0.0/16"]

  subnet {
    name = "subnet1"
    address_prefixes = ["10.0.1.0/24"]
  }

}