output "hub_firewall_private_ip" {
  value = azurerm_firewall.hub_firewall.ip_configuration[0].private_ip_address
}
