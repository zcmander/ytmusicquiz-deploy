output "repository_ytmuiscquiz" {
  value = aws_ecr_repository.ytmusicquiz.repository_url
}

output "repository_ytmuiscquiz_static" {
  value = aws_ecr_repository.ytmusicquiz-static.repository_url
}

output "repository_ytmuiscquiz_proxy" {
  value = aws_ecr_repository.ytmusicquiz-proxy.repository_url
}

output "repository_ytmuiscquiz_dashboard" {
  value = aws_ecr_repository.ytmusicquiz-dashboard.repository_url
}
