resource "azurerm_network_security_group" "entry_nsg" {
  name                = "entry-nsg"
  location            = azurerm_resource_group.entry_rg.location
  resource_group_name = azurerm_resource_group.entry_rg.name

  security_rule {
    name                       = "RDP"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  lifecycle {
    ignore_changes = [tags]
  }
}

# Connect the security group to the subnet
resource "azurerm_subnet_network_security_group_association" "connect_entry_nsg_to_subnet" {
  subnet_id                 = azurerm_subnet.entry_subnet.id
  network_security_group_id = azurerm_network_security_group.entry_nsg.id
}