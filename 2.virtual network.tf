# Virtual Network (equivalent to VPC)
resource "azurerm_virtual_network" "default" {
  name                = var.vnet_name
  address_space       = [var.vnet_cidr]   # same as cidr_block in AWS
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = {
    Name              = var.vnet_name
    Owner             = "Saikiran Pinapathruni"
    environment       = local.new_environment
    Terraform-Managed = "Yes"
    ProjectID         = local.projid
  }
}

# Subnet inside the VNet
resource "azurerm_subnet" "default" {
  name                 = "${var.vnet_name}-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.default.name
  address_prefixes     = [var.subnet_cidr]
}

# Public IP (used instead of Internet Gateway)
resource "azurerm_public_ip" "default" {
  name                = "${var.vnet_name}-pip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
    Name              = "${var.vnet_name}-PIP"
    Terraform-Managed = "Yes"
    Env               = local.new_environment
    ProjectID         = local.projid
  }
}

# (Optional) NAT Gateway for outbound internet
resource "azurerm_nat_gateway" "default" {
  name                = "${var.vnet_name}-natgw"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = "Standard"

  tags = {
    Name              = "${var.vnet_name}-NATGW"
    Terraform-Managed = "Yes"
    Env               = local.new_environment
    ProjectID         = local.projid
  }
}

resource "azurerm_nat_gateway_public_ip_association" "default" {
  nat_gateway_id       = azurerm_nat_gateway.default.id
  public_ip_address_id = azurerm_public_ip.default.id
}

resource "azurerm_subnet_nat_gateway_association" "default" {
  subnet_id      = azurerm_subnet.default.id
  nat_gateway_id = azurerm_nat_gateway.default.id
}
