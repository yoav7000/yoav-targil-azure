resource "azurerm_network_security_group" "spoke_vm_nsg" {
  name                = "spoke-vm-nsg"
  location            = azurerm_resource_group.spoke_rg.location
  resource_group_name = azurerm_resource_group.spoke_rg.name

  security_rule {
    name                       = "EntryToSpoke"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = azurerm_subnet.entry_subnet.address_prefixes[0]  # Entry Vm subnet
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Deny-All-Other-Traffic"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_address_prefix      = "*"
    source_port_range          = "*"
    destination_address_prefix = "*"
    destination_port_range     = "*"
  }

  lifecycle {
    ignore_changes = [tags]
  }
}

# Connect the security group to the subnet
resource "azurerm_subnet_network_security_group_association" "connect_spoke_vm_nsg_to_subnet" {
  subnet_id                 = azurerm_subnet.spoke_subnet.id
  network_security_group_id = azurerm_network_security_group.spoke_vm_nsg.id
}