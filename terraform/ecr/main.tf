resource "aws_ecr_repository" "ytmusicquiz" {
  name                 = "ytmusicquiz"
  image_tag_mutability = "MUTABLE"
}

resource "aws_ecr_repository" "ytmusicquiz-static" {
  name                 = "ytmusicquiz-static"
  image_tag_mutability = "MUTABLE"
}

resource "aws_ecr_repository" "ytmusicquiz-proxy" {
  name                 = "ytmusicquiz-proxy"
  image_tag_mutability = "MUTABLE"
}

resource "aws_ecr_repository" "ytmusicquiz-dashboard" {
  name                 = "ytmusicquiz-dashboard"
  image_tag_mutability = "MUTABLE"
}
