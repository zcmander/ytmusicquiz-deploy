resource "aws_security_group" "db_access_sg" {
  vpc_id      = var.vpc_id
  name        = "db-access-sg"
  description = "Allow access to RDS"
}

resource "aws_security_group" "rds_sg" {
  name = "rds-sg"
  description = "DB Security Group"
  vpc_id = var.vpc_id

  // allows traffic from the SG itself
  ingress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      self = true
  }

  //allow traffic for TCP 5432
  ingress {
      from_port = 5432
      to_port   = 5432
      protocol  = "tcp"
      security_groups = [
          aws_security_group.db_access_sg.id
      ]
  }

  // outbound internet access
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_db_instance" "default" {
    allocated_storage    = 5
    engine               = "postgres"
    engine_version       = "11.5"
    instance_class       = "db.t2.micro"
    name                 = "ytmusicquiz"
    username             = "ytmusicquizadmin"
    password             = "adminpass"

    vpc_security_group_ids = [aws_security_group.rds_sg.id]

    skip_final_snapshot    = true
    deletion_protection = true
}
