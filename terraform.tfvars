resourcePrefix      = "ecs-lab"

azs                 = ["us-east-1a","us-east-1b"]

vpc_cidr            = "192.168.235.0/24"
public_subnets      = ["192.168.235.0/26","192.168.235.64/26"]
private_subnets     = ["192.168.235.128/26","192.168.235.192/26"]

instance_type       = "t2.micro"
ami                 = "ami-09e67e426f25ce0d7" # Ubuntu Server 20.04 LTS (HVM), SSD Volume Type ( us-east-1 )
boot_disk_size      = 8
ssh_key_name        = "new2-aws-simone"
route53_hosted_zone = "afakedomain.com"

common_tag          = {
    Terraform = "terraform-ecs-fargate-cluster"
    Environment = "ecs-lab"
}


