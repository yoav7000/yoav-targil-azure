resource "azurerm_subnet" "no_entry_subnet" {
  name                 = "no-entry-subnet"
  resource_group_name  = azurerm_resource_group.entry_rg.name
  virtual_network_name = azurerm_virtual_network.entry_vnet.name
  address_prefixes = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "no_entry_vm_public_ip" {
  name                = "no-entry-vm-public-ip"
  location            = azurerm_resource_group.entry_rg.location
  resource_group_name = azurerm_resource_group.entry_rg.name
  allocation_method   = "Static"
  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_network_interface" "no_entry_vm_nic" {
  name                = "no-entry-vm-nic"
  location            = azurerm_resource_group.entry_rg.location
  resource_group_name = azurerm_resource_group.entry_rg.name
  lifecycle {
    ignore_changes = [tags]
  }

  ip_configuration {
    name                          = "no_entry_nic_configuration"
    subnet_id                     = azurerm_subnet.no_entry_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.no_entry_vm_public_ip.id
  }
}

# Connect the security group to the subnet
resource "azurerm_subnet_network_security_group_association" "connect_no_entry_nsg_to_subnet" {
  subnet_id                 = azurerm_subnet.no_entry_subnet.id
  network_security_group_id = azurerm_network_security_group.entry_nsg.id
}

# Vm in different subnet for testing no traffic to spoke vm.
resource "azurerm_windows_virtual_machine" "no_entry_vm" {
  name                = "yb-no-entry-win"
  resource_group_name = azurerm_resource_group.entry_rg.name
  location            = azurerm_resource_group.entry_rg.location
  size                = "Standard_F2s_v2"
  admin_username      = var.entry_vm_username
  admin_password      = var.entry_vm_password
  network_interface_ids = [
    azurerm_network_interface.no_entry_vm_nic.id,
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