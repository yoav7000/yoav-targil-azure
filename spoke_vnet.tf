resource "azurerm_virtual_network" "spoke_vnet" {
  name                = "yb-spoke-network"
  location            = azurerm_resource_group.spoke_rg.location
  resource_group_name = azurerm_resource_group.spoke_rg.name
  address_space = ["10.2.0.0/16"]
  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_subnet" "spoke_subnet" {
  name                 = "spoke-subnet"
  resource_group_name  = azurerm_resource_group.spoke_rg.name
  virtual_network_name = azurerm_virtual_network.spoke_vnet.name
  address_prefixes = ["10.2.1.0/24"]
}

