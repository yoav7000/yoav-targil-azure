resource "azurerm_public_ip" "entry_vm_public_ip" {
  name                = "entry-vm-public-ip"
  location            = azurerm_resource_group.entry_rg.location
  resource_group_name = azurerm_resource_group.entry_rg.name
  allocation_method   = "Static"
  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_network_interface" "entry_vm_nic" {
  name                = "entry-vm-nic"
  location            = azurerm_resource_group.entry_rg.location
  resource_group_name = azurerm_resource_group.entry_rg.name

  ip_configuration {
    name                          = "entry_nic_configuration"
    subnet_id                     = azurerm_subnet.entry_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.entry_vm_public_ip.id
  }
  lifecycle {
    ignore_changes = [tags]
  }
}


resource "azurerm_windows_virtual_machine" "entry_vm" {
  name                = "yb-entry-win"
  resource_group_name = azurerm_resource_group.entry_rg.name
  location            = azurerm_resource_group.entry_rg.location
  size                = "Standard_F2s_v2"
  admin_username      = var.entry_vm_username
  admin_password      = var.entry_vm_password
  network_interface_ids = [
    azurerm_network_interface.entry_vm_nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }
  lifecycle {
    ignore_changes = [tags]
  }
}