resource "azurerm_route_table" "entry_route_table" {
  name                = "entry-route-table"
  location            = azurerm_resource_group.entry_rg.location
  resource_group_name = azurerm_resource_group.entry_rg.name
  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_route" "entry_firewall_route" {
  name                   = "entry-firewall-route"
  resource_group_name    = azurerm_resource_group.entry_rg.name
  route_table_name       = azurerm_route_table.entry_route_table.name
  address_prefix         = tolist(azurerm_virtual_network.spoke_vnet.address_space)[0]
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = azurerm_firewall.hub_firewall.ip_configuration[0].private_ip_address
}

#TODO: CHECK IF NEEDED!!!!
resource "azurerm_route" "default_internet_route" {
  name                = "default-internet-route"
  resource_group_name = azurerm_resource_group.entry_rg.name
  route_table_name    = azurerm_route_table.entry_route_table.name
  address_prefix      = "0.0.0.0/0"
  next_hop_type       = "Internet"
}


resource "azurerm_subnet_route_table_association" "entry_route_association" {
  subnet_id      = azurerm_subnet.entry_subnet.id
  route_table_id = azurerm_route_table.entry_route_table.id
}


