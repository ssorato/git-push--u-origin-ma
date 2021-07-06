output "alb_dns" {
  description = "The DNS name of the load balancer"
  value = aws_alb.alb.dns_name
}


