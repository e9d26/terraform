#!/bin/bash
sudo yum update -y
echo ECS_CLUSTER=api-cluster >> /etc/ecs/ecs.config
