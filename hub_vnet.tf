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

resource "azurerm_virtual_network_peering" "entry_hub_vnet_peering" {
  name                         = "peer_entry_to_hub"
  resource_group_name          = azurerm_resource_group.entry_rg.name
  virtual_network_name         = azurerm_virtual_network.entry_vnet.name
  remote_virtual_network_id    = azurerm_virtual_network.hub_vnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

resource "azurerm_virtual_network_peering" "hub_entry_vnet_peering" {
  name                         = "peer_hub_to_entry"
  resource_group_name          = azurerm_resource_group.hub_rg.name
  virtual_network_name         = azurerm_virtual_network.hub_vnet.name
  remote_virtual_network_id    = azurerm_virtual_network.entry_vnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}
# #TODO: DELETE LATER!!!!!!!!!!
# resource "azurerm_virtual_network_peering" "entry_spoke_vnet_peering" {
#   name                         = "peer_entry_to_spoke"
#   resource_group_name          = azurerm_resource_group.entry_rg.name
#   virtual_network_name         = azurerm_virtual_network.entry_vnet.name
#   remote_virtual_network_id    = azurerm_virtual_network.spoke_vnet.id
#   allow_virtual_network_access = true
#   allow_forwarded_traffic      = true
# }
#
# #TODO: DELETE LATER!!!!!!!!!!
# resource "azurerm_virtual_network_peering" "spoke_entry_vnet_peering" {
#   name                         = "peer_spoke_to_entry"
#   resource_group_name          = azurerm_resource_group.spoke_rg.name
#   virtual_network_name         = azurerm_virtual_network.spoke_vnet.name
#   remote_virtual_network_id    = azurerm_virtual_network.entry_vnet.id
#   allow_virtual_network_access = true
#   allow_forwarded_traffic      = true
# }