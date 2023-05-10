# Resource-1: Azure Resource Group
resource "azurerm_resource_group" "rg-d365" {
  #name = "${var.business_unit}-${var.environment}-${var.resoure_group_name}"
  #name = local.rg_name
  name = "rg-${var.business_unit}-${var.environment}"
  location = var.resoure_group_location
  #tags = var.common_tags
}

# Create Virtual Network
resource "azurerm_virtual_network" "vnet-d365" {
  name                = "vnet-${var.business_unit}-${var.environment}"
  address_space       = var.vnet_address_space_d365
  location            = azurerm_resource_group.rg-d365.location
  resource_group_name = azurerm_resource_group.rg-d365.name
  #tags = var.common_tags 
}

/*resource "azurerm_subnet" "snet-bastion" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.rg-d365.name
  virtual_network_name = azurerm_virtual_network.vnet-d365.name
  address_prefixes     = var.bastion_host_address_prefix
}*/

resource "azurerm_subnet" "snet-core-d365" {
  name                 = "snet-${var.environment}"
  resource_group_name  = azurerm_resource_group.rg-d365.name
  virtual_network_name = azurerm_virtual_network.vnet-d365.name
  address_prefixes     = var.d365_subent_address_prefix
}

resource "azurerm_network_security_group" "nsg-d365" {
  name                = "nsg-${var.environment}-${var.resoure_group_location}"
  location            = var.resoure_group_location
  resource_group_name = azurerm_resource_group.rg-d365.name

  security_rule {
    name                       = "AllowRDPInboundFromBastion"
    priority                   = 900
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "3389"
    destination_port_range     = "3389"
    source_address_prefixes     = var.bastion_host_address_prefix
    destination_address_prefix = azurerm_subnet.snet-core-d365.address_prefixes[0]
  }

  security_rule {
    name                       = "AllowLCSOnly"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "5986"
    destination_port_range     = "5986"
    source_address_prefixes = var.address_prefixes_lcs_only
    destination_address_prefix = azurerm_subnet.snet-core-d365.address_prefixes[0]
  }

  security_rule {
    name                       = "AllowHTTPSFromLCSVMs"
    priority                   = 1020
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_ranges          = ["443","50000-65535"]
    destination_port_ranges     = ["443","50000-65535"]
    source_address_prefixes = var.lcs_vm_ip_addresses
    destination_address_prefix = azurerm_subnet.snet-core-d365.address_prefixes[0]
  }  

  security_rule {
    name                       = "AllowHTTPSFromCrowe"
    priority                   = 1030
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_ranges          = ["443"]
    destination_port_ranges     = ["443"]
    source_address_prefixes = var.crowe_ip_addresses
    destination_address_prefix = azurerm_subnet.snet-core-d365.address_prefixes[0]
  }  

  security_rule {
    name                       = "AllowHTTPSFromClient"
    priority                   = 1040
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_ranges          = ["443"]
    destination_port_ranges     = ["443"]
    source_address_prefixes = var.client_ip_addresses #update these ip addresses to client specific
    destination_address_prefix = azurerm_subnet.snet-core-d365.address_prefixes[0]
  }  
  #tags = var.common_tags
}

resource "azurerm_subnet_network_security_group_association" "nsgassoc" {
  subnet_id                 = azurerm_subnet.snet-core-d365.id
  network_security_group_id = azurerm_network_security_group.nsg-d365.id
}

# Public IP
resource "azurerm_public_ip" "pip-bastion" {
  name                = "pip-bastion"
  location            = azurerm_resource_group.rg-d365.location
  resource_group_name = azurerm_resource_group.rg-d365.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

/*resource "azurerm_bastion_host" "bh-d365" {
  name                = "bh-${var.business_unit}-d365"
  location            = azurerm_resource_group.rg-d365.location
  resource_group_name = azurerm_resource_group.rg-d365.name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.snet-bastion.id
    public_ip_address_id = azurerm_public_ip.pip-bastion.id
  }
}*/