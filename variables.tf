# Input Variables

# 1. Business Unit Name
variable "business_unit" {
  description = "Business Unit Name"
  type = string
  default = "crw"
}
# 2. Environment Name
variable "environment" {
  description = "Environment Name"
  type = string
  default = "d365"
}
# 3. Resource Group Name
variable "resoure_group_name" {
  description = "Resource Group Name"
  type = string
  default = "d365"
}
# 4. Resource Group Location
variable "resoure_group_location" {
  description = "Resource Group Location"
  type = string
  default = "eastus"
}
# 5. Virtual Network Name
variable "virtual_network_name" {
  description = "Virtual Network Name"
  type = string 
  default = "myvnet"
}

# 6. Virtual Network Address - Dev
variable "vnet_address_space_d365" {
  description = "Virtual Network Address Space for Dev Environment"
  type = list(string)
  default = ["10.0.0.0/16"]
}

# 7. Virtual Network Address - 
variable "vnet_address_space_all" {
  description = "Virtual Network Address Space for All Environment except Dev"
  type = list(string)
  default = ["10.0.0.0/16"]
}

# 8. Address prefixes - LCS Only
variable "address_prefixes_lcs_only" {
  description = "LCS Only address prefixes"
  type = list(string)
  default = ["191.239.20.104/32", "40.76.5.241/32", "40.112.209.123/32","40.121.208.21/32","40.118.145.241/32"]
}

# 9. LCS One Box VM ip addresses
variable "lcs_vm_ip_addresses" {
  description = "IP addresses of the LCS On Box VMs"
  type = list(string)
  default = ["0.0.0.0/0"] #update it once LCS one-box VMs are provisioned or in tfvar file
}

# 10. Crowe IP addresses
variable "crowe_ip_addresses" {
  description = "Crowe IP Addresses"
  type = list(string)
  default = ["159.246.20.2","159.246.40.2"] #update it once LCS one-box VMs are provisioned or in tfvar file
}

# 11. Client IP addresses
variable "client_ip_addresses" {
  description = "Client IP Addresses"
  type = list(string)
  default = ["1.2.3.4","5.6.7.8"] #update it once LCS one-box VMs are provisioned or in tfvar file
}

# 12. Bastion subnet address prefix
variable "bastion_host_address_prefix" {
  description = "Address prefix of the bastion host"
  type = list(string)
  default = ["10.0.3.0/27"] 
}

# 13. D365 core subnet
variable "d365_subent_address_prefix" {
  description = "D365 subnet address prefix"
  type = list(string)
  default = ["10.0.1.0/24"] 
}

# 13. Common Tags
/*variable "common_tags" {
  type = list(string({
    Service = string
    Owner = string
    Client = string
  }))
  default = [
    {
      Service = "Crowe D365 Services"
      Owner = "System Engineering"
      Client = "Client"
    }
  ]
}*/