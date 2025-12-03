# Route Table (equivalent to AWS route table)
resource "azurerm_route_table" "public" {
  name                = "${var.vnet_name}-MAIN-RT"
  location            = var.location
  resource_group_name = var.resource_group_name

  route {
    name           = "default-route"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "Internet"   # Equivalent to IGW in AWS
  }

  tags = {
    Name              = "${var.vnet_name}-MAIN-RT"
    Terraform-Managed = "Yes"
    Env               = local.new_environment
    ProjectID         = local.projid
  }
}

# Associate route table with public subnets
resource "azurerm_subnet_route_table_association" "public" {
  count          = length(local.new_public_subnet_cidrs)
  subnet_id      = azurerm_subnet.public_subnets[count.index].id
  route_table_id = azurerm_route_table.public.id
}
