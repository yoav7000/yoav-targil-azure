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
  name                            = "yb-spoke-linux-vm"
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