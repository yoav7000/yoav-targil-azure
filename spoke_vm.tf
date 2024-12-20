# resource "azurerm_network_security_group" "entry_nsg" {
#   name                = "entry-nsg"
#   location            = azurerm_resource_group.entry_rg.location
#   resource_group_name = azurerm_resource_group.entry_rg.name
#
#   security_rule {
#     name                       = "RDP"
#     priority                   = 1000
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "*"
#     source_port_range          = "*"
#     destination_port_range     = "3389"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#   }
# }

resource "azurerm_network_interface" "spoke_vm_nic" {
  name                = "spoke-vm-nic"
  location            = azurerm_resource_group.spoke_rg.location
  resource_group_name = azurerm_resource_group.spoke_rg.name

  ip_configuration {
    name                          = "spoke_nic_configuration"
    subnet_id                     = azurerm_subnet.spoke_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

# # Connect the security group to the subnet
# resource "azurerm_subnet_network_security_group_association" "connect_entry_nsg_to_subnet" {
#   subnet_id                 = azurerm_subnet.entry_subnet.id
#   network_security_group_id = azurerm_network_security_group.entry_nsg.id
# }


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
}