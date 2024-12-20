resource "azurerm_virtual_network" "entry-vnet" {
  name                = "yb-entry-network"
  location            = azurerm_resource_group.entry_rg.location
  resource_group_name = azurerm_resource_group.entry_rg.name
  address_space = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "entry-subnet" {
  name                 = "entry-subnet"
  resource_group_name  = azurerm_resource_group.entry_rg.name
  virtual_network_name = azurerm_virtual_network.entry-vnet.name
  address_prefixes = ["10.0.1.0/24"]
}