module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.6.1"

  vpc_tags = { Name = "${local.name}-vpc" }
  igw_tags = { Name = "${local.name}-igw" }

  name = "${local.name}-vpc"
  cidr = var.cidr

  azs = local.azs

  public_subnets       = var.public_subnets
  public_subnet_names  = local.public_subnet_names
  public_subnet_suffix = local.public_subnet_suffix

  enable_nat_gateway = false

  manage_default_route_table = var.manage_default_route_table
  default_route_table_tags = {
    Name   = "${local.name}-default-rt"
    Status = "unused"
  }

  manage_default_network_acl = var.manage_default_network_acl
  default_network_acl_tags = {
    Name   = "${local.name}-default-nacl"
    Status = "locked"
  }

  default_network_acl_ingress = [
    {
      rule_no    = 100
      protocol   = "-1"
      action     = "deny"
      cidr_block = "0.0.0.0/0"
      from_port  = 0
      to_port    = 0
    }
  ]

  default_network_acl_egress = [
    {
      rule_no    = 100
      protocol   = "-1"
      action     = "deny"
      cidr_block = "0.0.0.0/0"
      from_port  = 0
      to_port    = 0
    }
  ]

  public_dedicated_network_acl = var.public_dedicated_network_acl
  public_acl_tags = {
    Name = "${local.name}-public-nacl"
    Type = "public"
  }

  tags = local.tags
}
