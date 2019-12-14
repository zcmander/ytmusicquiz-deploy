resource "aws_default_vpc" "default" {
}

resource "aws_default_subnet" "default_az1" {
    availability_zone = "eu-west-1a"
    map_public_ip_on_launch = true
}

resource "aws_default_subnet" "default_az2" {
    availability_zone = "eu-west-1b"
    map_public_ip_on_launch = true
}

resource "aws_eip" "lb" {
    vpc      = true
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_default_vpc.default.id
}

resource "aws_route_table" "r" {
  vpc_id = aws_default_vpc.default.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_default_subnet.default_az1.id
  route_table_id = aws_route_table.r.id
}

resource "aws_default_security_group" "default" {
  vpc_id = aws_default_vpc.default.id

  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
    description = ""
  }

  ingress {
    protocol        = "tcp"
    cidr_blocks = [
        "0.0.0.0/0"
    ]
    from_port = 80
    to_port   = 80
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}