variable "resourcePrefix" {
  type = string
  description = "Lab name"
}

variable "azs" {
  type = list(string)
  description = "Availability Zone 1"
}

variable "vpc_cidr" {
  type = string
  description = "The VPC CIDR"
}

variable "public_subnets" {
type = list(string)
description = "Public subnets"
}

variable "private_subnets" {
  type = list(string)
  description = "Public subnet 2"
}

variable "instance_type" {
  type = string
  description = "The ec2 instance type"
}

variable "ami" {
  type = string
  description = "The Amazon Machine Image"
}

variable "boot_disk_size" {
  type = string
  description = "Instance boot disk size in GB"
}

variable "ssh_key_name" {
  type = string
  description = "The key pair name used to access to the instance"
}

variable "common_tag" {
  type = map(string)
  description = "Common resource tags"
}

variable "route53_hosted_zone" {
  type = string
  description = "The Route53 hosted zone"
}

