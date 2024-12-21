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
    source_address_prefix      = "10.0.1.0/24"  # Entry Vm subnet
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

resource "azurerm_network_interface" "spoke_vm_nic" {
  name                = "spoke-vm-nic"
  location            = azurerm_resource_group.spoke_rg.location
  resource_group_name = azurerm_resource_group.spoke_rg.name

  ip_configuration {
    name                          = "spoke_nic_configuration"
    subnet_id                     = azurerm_subnet.spoke_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
  lifecycle {
    ignore_changes = [tags]
  }
}


resource "azurerm_linux_virtual_machine" "spoke_linux_vm" {
  name                            = "linux-vm"
  location                        = azurerm_resource_group.spoke_rg.location
  resource_group_name             = azurerm_resource_group.spoke_rg.name
  network_interface_ids = [azurerm_network_interface.spoke_vm_nic.id]
  size                            = "Standard_B1s"
  admin_username                  = var.spoke_vm_username
  admin_password                  = var.spoke_vm_password
  disable_password_authentication = false

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  lifecycle {
    ignore_changes = [tags]
  }
}