resource "aws_alb" "dev_api" {
  name = "dev-api"

  subnets = [
    "${aws_subnet.public_1a.id}",
    "${aws_subnet.public_1c.id}"
  ]

  security_groups = ["${aws_security_group.alb.id}"]

  internal                   = false
  enable_deletion_protection = false

  tags {
    Name        = "dev-alb"
    Environment = "Development"
    Type        = "ALB"
  }
}

### ALB target group for custom php
resource "aws_alb_target_group" "dev_api" {
  name                 = "dev-api"
  port                 = 80
  protocol             = "HTTP"
  vpc_id               = "${aws_vpc.vpc.id}"
  deregistration_delay = 30

  health_check {
    interval            = 30
    path                = "/index.php"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 4
    matcher             = 200
  }

  tags {
    Name        = "dev-alb"
    Environment = "Development"
    Type        = "ALB"
  }
}

### ALB Listener for custom php
resource "aws_alb_listener" "dev_api" {
  load_balancer_arn = "${aws_alb.dev_api.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.dev_api.arn}"
    type             = "forward"
  }
}

### ALB target group for kong
resource "aws_alb_target_group" "kong_api" {
  name                 = "kong-api"
  port                 = 8000
  protocol             = "HTTP"
  vpc_id               = "${aws_vpc.vpc.id}"
  deregistration_delay = 30

  health_check {
    interval            = 30
    path                = "/mockbin"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 4
    matcher             = "200-499"
  }

  tags {
    Name        = "dev-alb"
    Environment = "Development"
    Type        = "ALB"
  }
}

### ALB Listener for kong
resource "aws_alb_listener" "kong_api" {
  load_balancer_arn = "${aws_alb.dev_api.arn}"
  port              = "8000"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.kong_api.arn}"
    type             = "forward"
  }
}

##########
# Output
##########

output "alb_id" {
  value = "${aws_alb.dev_api.id}"
}

output "alb_dns_name" {
  value = "${aws_alb.dev_api.dns_name}"
}

output "alb_zone_id" {
  value = "${aws_alb.dev_api.zone_id}"
}