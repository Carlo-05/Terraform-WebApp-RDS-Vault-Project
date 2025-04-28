locals {
  name_tag = {
    Name = var.Webapp_ASG_tag
  }
  all_tags = merge(var.default_tags, local.name_tag)
  asg_tags = [
    for key, value in local.all_tags : {
      key                 = key
      value               = value
      propagate_at_launch = true
    }
  ]
}


# ASG launch template
resource "aws_launch_template" "WebApp_ASG_template" {
    name = var.WebApp_ASG_template_tag
    image_id = var.ami
    instance_type = var.instance_type
    key_name = var.key_name
    vpc_security_group_ids = [ var.ASG_template_sg ]
    iam_instance_profile {
      name = var.iam_instance_profile
    }
    #user data, get sh file from github
    user_data = base64encode(<<-EOF
      #!/bin/bash

      # Log everything for debugging
      exec > >(tee -a /var/log/user_data.log | logger -t user_data -s 2>/dev/console) 2>&1
      set -x

      # Wait for the network and IAM
      sleep 10

      # Download the script with retries
      for i in {1..5}; do
        curl -fSL -o project.sh https://raw.githubusercontent.com/Carlo-05/WebApp_RDS_Vault_Project/refs/heads/main/project.sh && break
        echo "Retrying download of test.sh..."
        sleep 3
      done

      for i in {1..5}; do
        curl -fSL -o employees.sql https://raw.githubusercontent.com/Carlo-05/WebApp_RDS_Vault_Project/refs/heads/main/employees.sql && break
        echo "Retrying download of test.sql..."
        sleep 3
      done

      chmod 755 project.sh

      # Run test.sh in background-safe way
      bash project.sh || echo "test.sh failed"
    EOF
    )
    tags = merge(var.default_tags, {Name = var.WebApp_ASG_template_tag })
}

# ASG policy
resource "aws_autoscaling_policy" "cpu_target_tracking" {
  name                   = "cpu-target-scaling-policy"
  autoscaling_group_name = aws_autoscaling_group.WebApp_ASG.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value       = 50.0 # Target average CPU usage %
    disable_scale_in   = false
  }
}

# ASG
resource "aws_autoscaling_group" "WebApp_ASG" {
    depends_on = [ aws_launch_template.WebApp_ASG_template ]
    name = var.Webapp_ASG_tag
    desired_capacity = 2
    max_size = 4
    min_size = 2
    vpc_zone_identifier = [var.public-subnet-1, var.public-subnet-2]
    target_group_arns = var.webapp_target_group

    launch_template {
      id = aws_launch_template.WebApp_ASG_template.id
      version = "$Latest"
    }
    
    dynamic "tag" {
    for_each = local.asg_tags
    content {
      key                 = tag.value.key
      value               = tag.value.value
      propagate_at_launch = tag.value.propagate_at_launch
    }
    }
}
