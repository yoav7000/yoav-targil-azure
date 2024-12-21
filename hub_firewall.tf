resource "azurerm_subnet" "hub_firewall_subnet" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.hub_rg.name
  virtual_network_name = azurerm_virtual_network.hub_vnet.name
  address_prefixes = ["10.1.2.0/24"]
}

resource "azurerm_public_ip" "firewall_public_ip" {
  name                = "firewall-public-ip"
  location            = azurerm_resource_group.hub_rg.location
  resource_group_name = azurerm_resource_group.hub_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  lifecycle {
    ignore_changes = [tags]
  }
}


resource "azurerm_firewall" "hub_firewall" {
  name                = "hub-firewall"
  location            = azurerm_resource_group.hub_rg.location
  resource_group_name = azurerm_resource_group.hub_rg.name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.hub_firewall_subnet.id
    public_ip_address_id = azurerm_public_ip.firewall_public_ip.id
  }
  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_firewall_network_rule_collection" "hub_firewall_rules" {
  name                = "allow-entry-to-spoke"
  azure_firewall_name = azurerm_firewall.hub_firewall.name
  resource_group_name = azurerm_resource_group.hub_rg.name
  priority            = 100
  action              = "Allow"

  rule {
    name = "entry-to-spoke"
    source_addresses = ["10.0.1.0/24"] # Entry Windows VM subnet.
    destination_addresses = ["10.2.0.0/16"] # Spoke VNet
    destination_ports = ["*"]
    protocols = ["Any"]
  }
}

