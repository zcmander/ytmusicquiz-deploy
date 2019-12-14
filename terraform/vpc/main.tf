resource "aws_vpc" "default" {
    cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "az1" {
    vpc_id = aws_vpc.default.id

    availability_zone = "eu-west-1a"
    cidr_block = "10.0.2.0/24"
    map_public_ip_on_launch = true
}

resource "aws_subnet" "az2" {
    vpc_id = aws_vpc.default.id

    availability_zone = "eu-west-1b"
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.default.id
}

resource "aws_route_table" "r" {
  vpc_id = aws_vpc.default.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.az1.id
  route_table_id = aws_route_table.r.id
}