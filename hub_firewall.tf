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

resource "azurerm_firewall_policy" "firewall_policy" {
  name                = "yb-firewall-policy"
  resource_group_name = azurerm_resource_group.hub_rg.name
  location            = azurerm_resource_group.hub_rg.location
  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_firewall_policy_rule_collection_group" "hub_firewall_policy_rule" {
  name               = "yb-firewall-policy-rule-collection-group"
  firewall_policy_id = azurerm_firewall_policy.firewall_policy.id
  priority           = 100
  network_rule_collection {
    name     = "network_rule_collection1"
    priority = 100
    action   = "Allow"
    rule {
      name = "allow-ssh-entry-to-spoke"
      protocols = ["TCP"]
      source_addresses = azurerm_subnet.entry_subnet.address_prefixes # Entry Windows VM subnet.
      destination_addresses = tolist(azurerm_virtual_network.spoke_vnet.address_space) # Spoke VNet address space.
      destination_ports = ["22"]
    }
    rule {
      name = "allow-icmp-entry-to-spoke" # For testing ping connections.
      protocols = ["ICMP"]
      source_addresses = azurerm_subnet.entry_subnet.address_prefixes # Entry Windows VM subnet.
      destination_addresses = tolist(azurerm_virtual_network.spoke_vnet.address_space) # Spoke VNet address space.
      destination_ports = ["*"]
    }
  }
}

resource "azurerm_firewall" "hub_firewall" {
  name                = "yb-hub-firewall"
  location            = azurerm_resource_group.hub_rg.location
  resource_group_name = azurerm_resource_group.hub_rg.name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"
  firewall_policy_id  = azurerm_firewall_policy.firewall_policy.id

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.hub_firewall_subnet.id
    public_ip_address_id = azurerm_public_ip.firewall_public_ip.id
  }
  lifecycle {
    ignore_changes = [tags]
  }
}
