resource "azurerm_virtual_network" "hub_vnet" {
  name                = "yb-hub-network"
  location            = azurerm_resource_group.hub_rg.location
  resource_group_name = azurerm_resource_group.hub_rg.name
  address_space = ["10.1.0.0/16"]
}

resource "azurerm_subnet" "hub_subnet" {
  name                 = "hub-subnet"
  resource_group_name  = azurerm_resource_group.hub_rg.name
  virtual_network_name = azurerm_virtual_network.hub_vnet.name
  address_prefixes = ["10.1.1.0/24"]
}