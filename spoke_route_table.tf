resource "azurerm_route_table" "spoke_route_table" {
  name                = "spoke-route-table"
  location            = azurerm_resource_group.spoke_rg.location
  resource_group_name = azurerm_resource_group.spoke_rg.name
  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_route" "spoke_firewall_route" {
  name                   = "spoke-firewall-route"
  resource_group_name    = azurerm_resource_group.spoke_rg.name
  route_table_name       = azurerm_route_table.spoke_route_table.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = azurerm_firewall.hub_firewall.ip_configuration[0].private_ip_address
}


resource "azurerm_subnet_route_table_association" "spoke_route_association" {
  subnet_id      = azurerm_subnet.spoke_subnet.id
  route_table_id = azurerm_route_table.spoke_route_table.id
}
