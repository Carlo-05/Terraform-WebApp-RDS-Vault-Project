variable "region" {
    description = "Desire region."
    type = map(string)
    default = {
        "west-1" = "us-west-1"
        "west-2" = "us-west-2"
    }
    
  
}

variable "selected_region" {
    description = "Select between west-1 and west-2."
    type = string 
}

#VPC
variable "vpc_cidr_block" {
    description = "vpc cidr block" 
}

variable "subnet-public-1-az" {
    description = "public subnet 1 az"
}

variable "subnet-public-2-az" {
    description = "public subnet 2 az" 
}

variable "subnet-private-1-az" {
    description = "private subnet 1 az"  
}

variable "subnet-private-2-az" {
    description = "private subnet 2 az"
}

#Security Group
variable "create_ASG-ALB_sg" {
  type = bool
  description = "Create ASG-ALB sg. For prod!"
}

variable "create_webapp_sg" {
  type = bool
  description = "Create WebApp sg. For dev!"
}

#SSM parameter store
variable "ssm_db_name" {
  description = "your db name"
}
variable "ssm_db_username" {
  description = "your db username"
}
variable "ssm_db_password" {
  description = "your db password"
}

#RDS
variable "db_identifier" {
  description = "db identifier"
}
variable "db_engine" {
  description = "db engine"
}

variable "db_engine_version" {
  description = "db engine version"
}
variable "db_instance_class" {
  description = "db instance class"
}
variable "db_allocated_storage" {
  description = "db allocated storage"
}
variable "db_AZ" {
    description = "preferred AZ for your db"  
}
variable "db_multi_az" {
  description = "multi-az or single instance"
  type = bool
}
variable "ssm_db_endpoint" {
  description = "db module output endpoint"
}

#WebApp
variable "ami" {
    type = map(string)
    default = {
      "linux2" = "ami-0520f976ad2e6300c"
      "ubuntu" = "ami-0606dd43116f5ed57"
    } 
}
variable "select_ami" {
    description = "select ami"
    type = string
  
}
variable "user" {
    type = map(string)
    default = {
      "linux2" = "ec2-user"
      "ubuntu" = "ubuntu"
    }  
}
variable "instance_type" {
  description = "EC2 instance type"
}

#TAGS
# Local Tagging
variable "env" {
    description = "Enviroment"  
}
variable "projectname" {
    description = "project name"
  
}
# VPC tagging
variable "vpc_tag" {
    description = "vpc name tag"  
}
variable "igw_tag" {
    description = "igw name tag"  
}
variable "public1_subnet_tag" {
    description = "public subnet 1 name tag"  
}
variable "public2_subnet_tag" {
    description = "public subnet 2 name tag"  
}
variable "private1_subnet_tag" {
    description = "private subnet 1 name tag"  
}
variable "private2_subnet_tag" {
    description = "private subnet 2 name tag"  
}
variable "public_RT_tag" {
    description = "public rt name tag"  
}
variable "private_RT_tag" {
    description = "private rt name tag"  
}

# NAT Tagging
variable "NatGateway_tag" {
  description = "NAT Gateway name tag"
  
}
variable "EIP_tag" {
  description = "Elastic ip name tag"
}

# RDS tagging
variable "db_subnetgroup_tag" {
    description = "db subnet name tag"  
}
variable "dbsg_tag" {
  description = "db sg name tag"
}


# IAM role tag
variable "iam_role_tag" {
    description = "iam role name tag"
  
}

#Keypair tag
variable "keypair_tag" {
  description = "keypair name tag"
}

#ALB tags
variable "webapp_target_group_tag" {
  description = "webapp target group name tag"
}
variable "webapp_ALB_tag" {
  description = "ALB name tag"
}
variable "ALB_listener_tag" {
  description = "ALB listener name tag"
}
variable "ALB_sg_tag" {
  description = "ALB sg name tag"
}

#ASG tags
variable "WebApp_ASG_template_tag" {
  description = "ASG template name tag"
}
variable "Webapp_ASG_tag" {
  description = "ASG name"
}
variable "ASG_sg_tag" {
  description = "ASG sg name tag"
}

# EC2 WebApp tag
variable "webapp_sg_tag" {
    description = "webapp sg name tag"
}

variable "EC2_webapp_tag" {
    description = "EC2 webapp name tag"
}

# Bastion Host tag
variable "bastion_tag" {
    description = "Bastion name tag"
}

variable "bastion_sg_tag" {
    description = "Bastion SG name tag"
}

# Vault tag
variable "vault_sg_tag" {
  description = "vault sg instance name tag"
}
variable "vault_tag" {
  description = "vault instance name tag"
}