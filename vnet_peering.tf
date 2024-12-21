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

resource "azurerm_virtual_network_peering" "hub_spoke_vnet_peering" {
  name                         = "peer_hub_to_spoke"
  resource_group_name          = azurerm_resource_group.hub_rg.name
  virtual_network_name         = azurerm_virtual_network.hub_vnet.name
  remote_virtual_network_id    = azurerm_virtual_network.spoke_vnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

resource "azurerm_virtual_network_peering" "spoke_hub_vnet_peering" {
  name                         = "peer_spoke_to_hub"
  resource_group_name          = azurerm_resource_group.spoke_rg.name
  virtual_network_name         = azurerm_virtual_network.spoke_vnet.name
  remote_virtual_network_id    = azurerm_virtual_network.hub_vnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}