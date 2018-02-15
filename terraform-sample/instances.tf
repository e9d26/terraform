### Launch configuration
resource "aws_launch_configuration" "dev_api" {
  name_prefix                 = "dev-api-"
  image_id                    = "${var.amis["ecs"]}"
  instance_type               = "t2.micro"
  iam_instance_profile        = "${aws_iam_instance_profile.ecs.id}"
  key_name                    = "${var.key_name}"
  security_groups             = ["${aws_security_group.ecs.id}"]
  associate_public_ip_address = 0
  user_data                   = "${file("user_data/nginx-ecs.sh")}"

  lifecycle {
    create_before_destroy = true
  }
}

### EC2 Auto Scaling Group
resource "aws_autoscaling_group" "dev_api" {
  availability_zones        = ["ap-northeast-1a", "ap-northeast-1c"]
  name                      = "dev-api"
  max_size                  = 2
  min_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "EC2"
  desired_capacity          = 2
  force_delete              = true
  launch_configuration      = "${aws_launch_configuration.dev_api.id}"
  vpc_zone_identifier       = ["${aws_subnet.private_1a.id}", "${aws_subnet.private_1c.id}"]

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupPendingInstances",
    "GroupStandbyInstances",
    "GroupTerminatingInstances",
    "GroupTotalInstances",
  ]

  tag = {
    key                 = "Name"
    value               = "ECS Instance"
    propagate_at_launch = true
  }

  tag = {
    key                 = "Environment"
    value               = "Development"
    propagate_at_launch = true
  }

  tag = {
    key                 = "Type"
    value               = "API"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

### EC2 AutoScaling Policy
resource "aws_autoscaling_policy" "scale_out" {
  name                   = "Instance-ScaleOut-CPU-High"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = "${aws_autoscaling_group.dev_api.name}"
}

resource "aws_autoscaling_policy" "scale_in" {
  name                   = "Instance-ScaleIn-CPU-Low"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = "${aws_autoscaling_group.dev_api.name}"
}

### EC2 AutoScaling Alarm
# resource "aws_cloudwatch_metric_alarm" "dev_api_cluster_high" {
#   alarm_name          = "dev-api-cluster-CPU-Utilization-High-30"
#   comparison_operator = "GreaterThanOrEqualToThreshold"
#   evaluation_periods  = "1"
#   metric_name         = "CPUUtilization"
#   namespace           = "AWS/ECS"
#   period              = "300"
#   statistic           = "Average"
#   threshold           = "30"

#   dimensions {
#     ClusterName = "${aws_ecs_cluster.api_cluster.name}"
#   }

#   alarm_actions = ["${aws_autoscaling_policy.scale_out.arn}"]
# }

# resource "aws_cloudwatch_metric_alarm" "dev_api_cluster_low" {
#   alarm_name          = "dev-api-cluster-CPU-Utilization-Low-5"
#   comparison_operator = "LessThanThreshold"
#   evaluation_periods  = "1"
#   metric_name         = "CPUUtilization"
#   namespace           = "AWS/ECS"
#   period              = "300"
#   statistic           = "Average"
#   threshold           = "5"

#   dimensions {
#     ClusterName = "${aws_ecs_cluster.api_cluster.name}"
#   }

#   alarm_actions = ["${aws_autoscaling_policy.scale_in.arn}"]
# }
