resource "azurerm_subnet" "spoke2_subnet" {
  name                 = "spoke2-subnet"
  resource_group_name  = azurerm_resource_group.spoke_rg.name
  virtual_network_name = azurerm_virtual_network.spoke_vnet.name
  address_prefixes = ["10.2.2.0/24"]
}

resource "azurerm_network_interface" "spoke2_vm_nic" {
  name                = "spoke2-vm-nic"
  location            = azurerm_resource_group.spoke_rg.location
  resource_group_name = azurerm_resource_group.spoke_rg.name

  ip_configuration {
    name                          = "spoke2_nic_configuration"
    subnet_id                     = azurerm_subnet.spoke2_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_linux_virtual_machine" "spoke2_linux_vm" {
  name                            = "linux-vm2"
  location                        = azurerm_resource_group.spoke_rg.location
  resource_group_name             = azurerm_resource_group.spoke_rg.name
  network_interface_ids = [azurerm_network_interface.spoke2_vm_nic.id]
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


resource "azurerm_subnet_route_table_association" "spoke2_route_association" {
  subnet_id      = azurerm_subnet.spoke2_subnet.id
  route_table_id = azurerm_route_table.spoke_route_table.id
}
