###########
# IAM Role
###########
resource "aws_iam_role" "ecs_instance_role" {
  name               = "ecs_instance_role"
  assume_role_policy = "${file("policies/ec2-assume-role.json")}"
}

resource "aws_iam_role" "ecs_service_role" {
  name               = "ecs_service_role"
  assume_role_policy = "${file("policies/ecs-assume-role.json")}"
}

resource "aws_iam_role" "ecs_autoscale_role" {
  name               = "ecs_autoscale_role"
  assume_role_policy = "${file("policies/autoscale-assume-role.json")}"
}


########################
# IAM Policy Attachment
########################
resource "aws_iam_role_policy_attachment" "ecs_instance_role_attach" {
  role      = "${aws_iam_role.ecs_instance_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "ecs_service_role_attach" {
  role      = "${aws_iam_role.ecs_service_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}

resource "aws_iam_role_policy_attachment" "ecs_autoscale_role_attach" {
  role      = "${aws_iam_role.ecs_autoscale_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceAutoscaleRole"
}

#######################
# IAM Instance Profile
#######################
resource "aws_iam_instance_profile" "ecs" {
  name = "ecs-instance-profile"
  path  = "/"
  role = "${aws_iam_role.ecs_instance_role.name}"
}