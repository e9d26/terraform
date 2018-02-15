##########
# ECS SG
##########

resource "aws_security_group" "ecs" {
  vpc_id      = "${aws_vpc.vpc.id}"
  name        = "ecs"
  description = "Allow ecs traffic"

  ingress {
    from_port = 0
    to_port   = 65535
    protocol  = "tcp"
    self      = true
  }

  ingress {
    from_port = 0
    to_port   = 65535
    protocol  = "tcp"
    security_groups = ["${aws_security_group.alb.id}"]
  }

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    security_groups = ["${aws_security_group.nat.id}"]
  }

# for Kong admin port
  ingress {
    from_port = 8000
    to_port   = 8001
    protocol  = "tcp"
    security_groups = ["${aws_security_group.nat.id}"]
  }

# for Prometheus
  ingress {
    from_port = 9100
    to_port   = 9100
    protocol  = "tcp"
    security_groups = ["${aws_security_group.nat.id}"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "ecs"
  }
}


#########
# NAT SG
#########
resource "aws_security_group" "nat" {
  vpc_id      = "${aws_vpc.vpc.id}"
  name        = "nat"
  description = "Allow internal inbound traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

# for Swagegr Docker container
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

# for c3vis
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

# for Kong Docker container
  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

# for Apache Docker container
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

# for Nginx Docker container
  ingress {
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["${aws_vpc.vpc.cidr_block}"]
  }

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "udp"
    cidr_blocks = ["${aws_vpc.vpc.cidr_block}"]
  }

# for Prometheus
  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "nat"
  }
}


##########
# ALB SG
##########
resource "aws_security_group" "alb" {
  vpc_id      = "${aws_vpc.vpc.id}"
  name        = "alb"
  description = "Allow http inbound traffic"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

# for Kong
  ingress {
    from_port   = 8000
    to_port     = 8001
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "alb"
  }
}
