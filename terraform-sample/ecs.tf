resource "aws_ecs_cluster" "api_cluster" {
  name = "api-cluster"
}

################################
# ECS Service for custom php ★
################################

# resource "aws_ecs_service" "api_service" {
#   name                               = "api-service"
#   cluster                            = "${aws_ecs_cluster.api_cluster.id}"
#   task_definition                    = "${aws_ecs_task_definition.api.arn}"
#   desired_count                      = 2
#   deployment_minimum_healthy_percent = 50
#   deployment_maximum_percent         = 100
#   iam_role                           = "${aws_iam_role.ecs_service_role.arn}"

#   load_balancer {
#     target_group_arn = "${aws_alb_target_group.dev_api.arn}"
#     container_name   = "custom-nginx-php-fpm"
#     container_port   = 80
#   }
# }


#########################
# ECS Service for kong ★
#########################

# resource "aws_ecs_service" "kong-api_service" {
#   name                               = "kong-api-service"
#   cluster                            = "${aws_ecs_cluster.api_cluster.id}"
#   task_definition                    = "${aws_ecs_task_definition.kong-api.arn}"
#   desired_count                      = 2
#   deployment_minimum_healthy_percent = 50
#   deployment_maximum_percent         = 100
#   iam_role                           = "${aws_iam_role.ecs_service_role.arn}"

#   load_balancer {
#     target_group_arn = "${aws_alb_target_group.kong_api.arn}"
#     container_name   = "kong"
#     container_port   = 8000
#   }
# }

### ECS Task Definition for custom kong
resource "aws_ecs_task_definition" "kong-api" {
  family                = "kong-api"
  container_definitions = "${file("task-definitions/kong.json")}"
}

### ECS Task Definition for custom php
resource "aws_ecs_task_definition" "api" {
  family                = "api"
  container_definitions = "${file("task-definitions/api.json")}"
}


##########################
# ECS AutoScaling Alarm ★
##########################

# resource "aws_cloudwatch_metric_alarm" "dev_api_service_high" {
#   alarm_name          = "dev-api-service-CPU-Utilization-High-30"
#   comparison_operator = "GreaterThanOrEqualToThreshold"
#   evaluation_periods  = "1"
#   metric_name         = "CPUUtilization"
#   namespace           = "AWS/ECS"
#   period              = "300"
#   statistic           = "Average"
#   threshold           = "30"

#   dimensions {
#     ClusterName = "${aws_ecs_cluster.api_cluster.name}"
#     ServiceName = "${aws_ecs_service.api_service.name}"
#   }

#   alarm_actions = ["${aws_appautoscaling_policy.scale_out.arn}"]
# }

# resource "aws_cloudwatch_metric_alarm" "dev_api_service_low" {
#   alarm_name          = "dev-api-service-CPU-Utilization-Low-15"
#   comparison_operator = "LessThanThreshold"
#   evaluation_periods  = "1"
#   metric_name         = "CPUUtilization"
#   namespace           = "AWS/ECS"
#   period              = "180"
#   statistic           = "Average"
#   threshold           = "15"

#   dimensions {
#     ClusterName = "${aws_ecs_cluster.api_cluster.name}"
#     ServiceName = "${aws_ecs_service.api_service.name}"
#   }

#   alarm_actions = ["${aws_appautoscaling_policy.scale_in.arn}"]
# }


###############################
# ECS App AutoScaling Policy ★
###############################

# resource "aws_appautoscaling_target" "target" {
#   service_namespace  = "ecs"
#   resource_id        = "service/${aws_ecs_cluster.api_cluster.name}/${aws_ecs_service.api_service.name}"
#   scalable_dimension = "ecs:service:DesiredCount"
#   role_arn           = "${aws_iam_role.ecs_autoscale_role.arn}"
#   min_capacity       = 2
#   max_capacity       = 4
# }

# resource "aws_appautoscaling_policy" "scale_out" {
#   name                    = "scale-out"
#   resource_id             = "service/${aws_ecs_cluster.api_cluster.name}/${aws_ecs_service.api_service.name}"
#   scalable_dimension = "${aws_appautoscaling_target.target.scalable_dimension}"
#   service_namespace  = "${aws_appautoscaling_target.target.service_namespace}"

#   step_scaling_policy_configuration {
#     adjustment_type         = "ChangeInCapacity"
#     cooldown                = 30
#     metric_aggregation_type = "Average"

#     step_adjustment {
#       metric_interval_lower_bound = 0
#       scaling_adjustment          = 2
#     }
#   }

#   depends_on = ["aws_appautoscaling_target.target"]
# }

# resource "aws_appautoscaling_policy" "scale_in" {
#   name                    = "scale-in"
#   resource_id             = "service/${aws_ecs_cluster.api_cluster.name}/${aws_ecs_service.api_service.name}"
#   scalable_dimension = "${aws_appautoscaling_target.target.scalable_dimension}"
#   service_namespace  = "${aws_appautoscaling_target.target.service_namespace}"

#   step_scaling_policy_configuration {
#     adjustment_type         = "ChangeInCapacity"
#     cooldown                = 30
#     metric_aggregation_type = "Average"

#     step_adjustment {
#       metric_interval_upper_bound = 0
#       scaling_adjustment          = -1
#     }
#   }

#   depends_on = ["aws_appautoscaling_target.target"]
# }