# VPC

resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags {
    Name = "Terraform VPC"
  }
}

# Internet Gateway

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "igw"
  }
}

# Public Subnets

resource "aws_subnet" "public_1a" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "10.0.10.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = "1"

  tags {
    Name = "public-1a"
  }
}

resource "aws_subnet" "public_1c" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "10.0.11.0/24"
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = "1"

  tags {
    Name = "public-1c"
  }
}

# Private Subnets

resource "aws_subnet" "private_1a" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "10.0.100.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = "0"

  tags {
    Name = "private-1a"
  }
}

resource "aws_subnet" "private_1c" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "10.0.101.0/24"
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = "0"

  tags {
    Name = "private-1c"
  }
}

# Routes Table

resource "aws_route_table" "public_rt" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }

  tags {
    Name = "public-rt"
  }
}

resource "aws_route_table" "nat_rt" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block  = "0.0.0.0/0"
    instance_id = "${aws_instance.nat.id}"
  }

  tags {
    Name = "nat-rt"
  }
}

# Public Subnet Association

resource "aws_route_table_association" "public_1a" {
  subnet_id      = "${aws_subnet.public_1a.id}"
  route_table_id = "${aws_route_table.public_rt.id}"
}

resource "aws_route_table_association" "public_1c" {
  subnet_id      = "${aws_subnet.public_1c.id}"
  route_table_id = "${aws_route_table.public_rt.id}"
}

# Private Subnet Association

resource "aws_route_table_association" "private_1a" {
  subnet_id      = "${aws_subnet.private_1a.id}"
  route_table_id = "${aws_route_table.nat_rt.id}"
}

resource "aws_route_table_association" "private_1c" {
  subnet_id      = "${aws_subnet.private_1c.id}"
  route_table_id = "${aws_route_table.nat_rt.id}"
}

# NAT Server
resource "aws_instance" "nat" {
  ami                         = "${var.amis["nat"]}"
  instance_type               = "t2.micro"
  key_name                    = "${var.key_name}"
  vpc_security_group_ids      = ["${aws_security_group.nat.id}"]
  subnet_id                   = "${aws_subnet.public_1a.id}"
  associate_public_ip_address = true
  source_dest_check           = false
  user_data                   = "${file("user_data/nat-setup.sh")}"

  tags {
    Name        = "NAT Instance"
    Environment = "Common"
    Role        = "NAT"
  }
}
