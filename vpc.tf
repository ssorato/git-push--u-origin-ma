data "http" "myip"{
  url = "https://ifconfig.me"
}

locals {
  ssh_ingress = [
    {
      protocol    = "tcp"
      from_port   = 22
      to_port     = 22
      cidr_blocks = "${chomp(data.http.myip.body)}/32"
      description = "Enable ssh incoming traffic from my public ip"
    },
    {
      protocol    = "tcp"
      from_port   = 0
      to_port     = 0
      cidr_blocks = var.vpc_cidr
      description = "Enable all incoming traffic from the VPC"
    },
    {
      protocol    = "icmp"
      from_port   = 8
      to_port     = 0
      cidr_blocks = var.vpc_cidr
      description = "Enable ping incoming traffic from the VPC"
    }
  ]
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.resourcePrefix}-vpc"
  cidr = var.vpc_cidr

  manage_default_security_group   = true
  default_security_group_egress   = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "all"
      cidr_blocks = "0.0.0.0/0"
      description = "Enable all output traffic"
    }
  ]
  default_security_group_ingress  = local.ssh_ingress
  default_security_group_name     = "${var.resourcePrefix}-sg"
  default_security_group_tags     = var.common_tag

  azs             = var.azs
  public_subnets  = var.public_subnets
  # private subnets without Internet routing when enable_nat_gateway is false
  private_subnets = var.private_subnets

  enable_nat_gateway = true
  single_nat_gateway = false
  enable_vpn_gateway = false

  tags = var.common_tag

}