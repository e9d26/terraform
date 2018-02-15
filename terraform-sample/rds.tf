##################
# DB Subnet Group
##################
resource "aws_db_subnet_group" "postgres_db_subnet_group" {
  name       = "postgres_db_subnet_group"
  subnet_ids = ["${aws_subnet.private_1a.id}", "${aws_subnet.private_1c.id}"]

  tags {
    Name = "Postgres DB subnet group"
  }
}

#####################
# DB Parameter Group
#####################
resource "aws_db_parameter_group" "postgres_db_parameter_group" {
  name   = "rds-parameter-group"
  family = "postgres9.6"
}

###################
# RDS for Postgres
###################
resource "aws_db_instance" "rds" {
  allocated_storage    = 10
  storage_type         = "gp2"
  engine               = "postgres"
  engine_version       = "9.6.5"
  instance_class       = "db.t2.micro"
  name                 = "kong"
  username             = "kong"
  password             = "kongkong"
  db_subnet_group_name = "postgres_db_subnet_group"
  parameter_group_name = "rds-parameter-group"
  vpc_security_group_ids      = ["${aws_security_group.rds_sg.id}"]
  skip_final_snapshot = true
  snapshot_identifier = ""
}

################
# SecurityGroup
################
resource "aws_security_group" "rds_sg" {
  vpc_id      = "${aws_vpc.vpc.id}"
  name        = "rds"
  description = "Allow rds inbound traffic"

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    security_groups = ["${aws_security_group.ecs.id}"]
  }

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    security_groups = ["${aws_security_group.nat.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "rds"
  }
}

############
# Variables
############
variable "common" { type = "map" default = {} }
variable "rds"    { type = "map" default = {} }
variable "vpc"    { type = "map" default = {} }

#########
# Output
#########
output "rds" {
  value = "${
    map(
      "address",  "${aws_db_instance.rds.address}",
      "port",     "${aws_db_instance.rds.port}",
      "name",     "${aws_db_instance.rds.name}",
      "username", "${aws_db_instance.rds.username}"
    )
  }"
}