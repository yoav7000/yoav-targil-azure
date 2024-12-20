resource "azurerm_public_ip" "firewall_public_ip" {
  name                = "firewall-public-ip"
  location            = azurerm_resource_group.hub_rg.location
  resource_group_name = azurerm_resource_group.hub_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}


resource "azurerm_firewall" "hub_firewall" {
  name                = "hub-firewall"
  location            = azurerm_resource_group.hub_rg.location
  resource_group_name = azurerm_resource_group.hub_rg.name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.hub_subnet.id
    public_ip_address_id = azurerm_public_ip.firewall_public_ip.id
  }
}


resource "azurerm_route_table" "hub_route_table" {
  name                = "hub-route-table"
  location            = azurerm_resource_group.hub_rg.location
  resource_group_name = azurerm_resource_group.hub_rg.name
}

resource "azurerm_route" "firewall_route" {
  name                   = "firewall-route"
  resource_group_name    = azurerm_resource_group.hub_rg.name
  route_table_name       = azurerm_route_table.hub_route_table.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = azurerm_firewall.hub_firewall.ip_configuration[0].private_ip_address
}


resource "azurerm_subnet_route_table_association" "hub_route_association" {
  subnet_id      = azurerm_subnet.hub_subnet.id
  route_table_id = azurerm_route_table.hub_route_table.id
}
