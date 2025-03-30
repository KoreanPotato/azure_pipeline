# === VARIABLES ===

variable "public_key" {
  description = "SSH public key for VM access"
  type        = string
}

variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
}

variable "client_id" {
  description = "Azure client ID"
  type        = string
}

variable "client_secret" {
  description = "Azure client secret"
  type        = string
}

variable "tenant_id" {
  description = "Azure tenant ID"
  type        = string
}

# === PROVIDER ===

provider "azurerm" {
  features {}
  subscription_id                = var.subscription_id
  client_id                      = var.client_id
  client_secret                  = var.client_secret
  tenant_id                      = var.tenant_id
  resource_provider_registrations = "none"
}

# === EXISTING RESOURCE GROUP ===

data "azurerm_resource_group" "rg" {
  name = "myResourceGroup"
}

# === EXISTING RESOURCES === 

data "azurerm_virtual_network" "vnet" {
  name                = "myVNet"
  resource_group_name = data.azurerm_resource_group.rg.name
}

data "azurerm_public_ip" "public_ip" {
  name                = "myPublicIP"
  resource_group_name = data.azurerm_resource_group.rg.name
}

data "azurerm_network_security_group" "nsg" {
  name                = "ssh-nsg"
  resource_group_name = data.azurerm_resource_group.rg.name
}

data "azurerm_subnet" "subnet" {
  name                 = "mySubnet"
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_resource_group.rg.name
}

# === CREATE NIC ===

resource "azurerm_network_interface" "nic" {
  name                = "myNIC"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "myNICConfig"
    subnet_id                     = data.azurerm_subnet.subnet.id
    private_ip_address_allocation = "Static"
    public_ip_address_id          = data.azurerm_public_ip.public_ip.id
  }
}

# === ASSOCIATE NIC WITH NSG ===

resource "azurerm_network_interface_security_group_association" "nic_nsg" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = data.azurerm_network_security_group.nsg.id
}

# === CREATE VIRTUAL MACHINE ===

resource "azurerm_linux_virtual_machine" "vm" {
  name                = "UbuntuVM"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  size                = "Standard_B1s"
  admin_username      = "sergey"

  network_interface_ids = [azurerm_network_interface.nic.id]

  admin_ssh_key {
    username   = "sergey"
    public_key = var.public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
}

# === OUTPUT IP ===

output "public_ip_address" {
  value       = data.azurerm_public_ip.public_ip.ip_address
  description = "Public IP for SSH"
}
