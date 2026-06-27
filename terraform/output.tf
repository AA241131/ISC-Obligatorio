output "alb_url" {
  value = "http://${module.alb-module.lb_dns_name}"
}

output "ecr_repository_url" {
  value = aws_ecr_repository.repo.repository_url
}