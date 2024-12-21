output "hub_firewall_private_ip" {
  value = azurerm_firewall.hub_firewall.ip_configuration[0].private_ip_address
}

output "entry_subnet" {
  value = azurerm_subnet.entry_subnet.address_prefixes[0]
}

output "entry_vnet_address_space" {
  value = azurerm_virtual_network.entry_vnet.address_space
}