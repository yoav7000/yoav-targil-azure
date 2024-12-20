locals {
  entry_vm_name = "yb-entry-win"
}

resource "azurerm_network_security_group" "entry-nsg" {
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
}

resource "azurerm_public_ip" "entry_vm_public_ip" {
  name                = "entry-vm-public-ip"
  location            = azurerm_resource_group.entry_rg.location
  resource_group_name = azurerm_resource_group.entry_rg.name
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "entry-vm-nic" {
  name                = "entry-vm-nic"
  location            = azurerm_resource_group.entry_rg.location
  resource_group_name = azurerm_resource_group.entry_rg.name

  ip_configuration {
    name                          = "entry_nic_configuration"
    subnet_id                     = azurerm_subnet.entry-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.entry_vm_public_ip.id
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "connect-entry-nsg-to-nic" {
  network_interface_id      = azurerm_network_interface.entry-vm-nic.id
  network_security_group_id = azurerm_network_security_group.entry-nsg.id
}

resource "azurerm_windows_virtual_machine" "entry-vm" {
  name                = local.entry_vm_name
  resource_group_name = azurerm_resource_group.entry_rg.name
  location            = azurerm_resource_group.entry_rg.location
  size                = "Standard_F2s_v2"
  admin_username      = var.entry_vm_username
  admin_password      = var.entry_vm_password
  network_interface_ids = [
    azurerm_network_interface.entry-vm-nic.id,
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
}