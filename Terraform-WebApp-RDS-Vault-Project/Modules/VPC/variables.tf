variable "vpc_cidr_block" {
    description = "Desired VPC cidr bloc"  
}


# Subnet Availability Zone
variable "subnet-public-1-az" {
   description = "Desired availability zone"  
}

variable "subnet-public-2-az" {
    description = "Desired availability zone"  
}

variable "subnet-private-1-az" {
    description = "Desired availability zone"  
}

variable "subnet-private-2-az" {
    description = "Desired availability zone"
} 


# Resources Tags
variable "default_tags" {
    type = map(string)
    description = "local tags in your root main.tf"
}

variable "vpc_tag" {
    description = "Name tag."
  
}

variable "igw_tag" {
    description = "Name Tag"
  
}
variable "public1_subnet_tag" {
    description = "Name tag."
  
}

variable "public2_subnet_tag" {
    description = "Name tag."
  
}

variable "private1_subnet_tag" {
    description = "Name tag."
  
}

variable "private2_subnet_tag" {
    description = "Name tag."
  
}

variable "public_RT_tag" {
    description = "Name tag."
  
}

variable "private_RT_tag" {
    description = "Name tag."
  
}

