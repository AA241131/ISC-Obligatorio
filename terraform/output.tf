output "alb_url" {
  value = "http://${module.vpc-module.lb_dns_name}"
}