provider "aws" {
    region = lookup(var.region, var.selected_region, "us-west-2")
  
}
# Add local tag (eg. Environment)
locals {
  default_tags = {
        Environment = var.env
        Project = var.projectname
    }
}


module "VPC" {
    source = "../../Modules/VPC"
    vpc_cidr_block = var.vpc_cidr_block
    subnet-public-1-az = var.subnet-public-1-az
    subnet-public-2-az = var.subnet-public-2-az
    subnet-private-1-az = var.subnet-private-1-az
    subnet-private-2-az = var.subnet-private-2-az


    #tags
    default_tags = local.default_tags
    vpc_tag = var.vpc_tag
    igw_tag = var.igw_tag
    public1_subnet_tag = var.public1_subnet_tag
    public2_subnet_tag = var.public2_subnet_tag
    private1_subnet_tag = var.private1_subnet_tag
    private2_subnet_tag = var.private2_subnet_tag
    public_RT_tag = var.public_RT_tag
    private_RT_tag = var.private_RT_tag  
}
# Security Groups
module "SG" {
  source = "../../Modules/SECURITYGROUPS"
  vpc_id = module.VPC.MyVPC
  create_ASG-ALB_sg = var.create_ASG-ALB_sg
  create_webapp_sg = var.create_webapp_sg
  #tags
  default_tags = local.default_tags
  dbsg_tag = var.dbsg_tag
  bastion_sg_tag = var.bastion_sg_tag
  ALB_sg_tag = var.ALB_sg_tag
  ASG_sg_tag = var.ASG_sg_tag
  webapp_sg_tag = var.webapp_sg_tag
  vault_sg_tag = var.vault_sg_tag

}
# Attached a NAT Gateway
module "NAT" {
  source = "../../Modules/NAT"
  NAT-Subnet = module.VPC.public-subnet-2
  Private-RT = module.VPC.private-route-table
  #tags
  default_tags = local.default_tags
  NatGateway_tag = var.NatGateway_tag
  EIP_tag = var.EIP_tag
}

#create data that fetch db name, password, and username.
data "aws_ssm_parameter" "db_name" {
  name = var.ssm_db_name
}
data "aws_ssm_parameter" "db_username" {
  name = var.ssm_db_username
}

data "aws_ssm_parameter" "db_password" {
  name = var.ssm_db_password
  with_decryption = true
}

#RDS
module "RDS" {
  source = "../../Modules/RDS-MYSQL"
  #subnet group
  db_subnet_private1 = module.VPC.private-subnet-1
  db_subnet_private2 = module.VPC.private-subnet-2 
  #Security group
  vpc_id = module.VPC.MyVPC
  db_sg = module.SG.db_sg  
  #databse config
  db_identifier = var.db_identifier
  db_engine = var.db_engine
  db_engine_version = var.db_engine_version
  db_instance_class = var.db_instance_class #change to db.t3.medium for multi-az
  db_allocated_storage = var.db_allocated_storage
  db_name = data.aws_ssm_parameter.db_name.value
  db_username = data.aws_ssm_parameter.db_username.value
  db_password = data.aws_ssm_parameter.db_password.value
  db_AZ = var.db_multi_az ? null : var.db_AZ
  db_multi_az = var.db_multi_az
  #tags
  default_tags = local.default_tags
  db_subnetgroup_tag = var.db_subnetgroup_tag
  db_tag = format("%s-WRVP", data.aws_ssm_parameter.db_name.value)
}

#Create a resource that export rds enpoint to ssm parameter
resource "aws_ssm_parameter" "db_host" {
  name = var.ssm_db_endpoint
  type = "String"
  value = split(":", module.RDS.db_endpoint)[0]

}
#Key pair 
module "KEYPAIR" {
  source = "../../Modules/KEYPAIR"
  #tags
  default_tags = local.default_tags
  keypair_tag = var.keypair_tag
}
#Bastion Host
module "BASTION" {
  source = "../../Modules/BASTION"
  bastion_sg = module.SG.bastion_sg
  ami = lookup(var.ami, var.select_ami, "ami-0606dd43116f5ed57") # AMI id is account specific. Change your values in variable AMI.
  instance_type = var.instance_type
  subnet_id = module.VPC.public-subnet-2
  key_name = module.KEYPAIR.key_name
  #tags
  default_tags = local.default_tags
  bastion_tag = var.bastion_tag  
}

# IAM role
module "IAM_role" {
  source = "../../Modules/IAM-ROLE"
  #tagging
  default_tags = local.default_tags
  iam_role_tag = var.iam_role_tag
  
}

# WebApp
module "EC2" {
  source = "../../Modules/EC2"
  depends_on = [ module.RDS ]
  Web-app-sg = module.SG.Web-app-sg
  ami = lookup(var.ami, var.select_ami, "ami-0606dd43116f5ed57") # AMI id is account specific. Change your values in variable AMI.
  instance_type = var.instance_type
  webapp_subnet = module.VPC.public-subnet-1
  iam_instance_profile = module.IAM_role.iam_instance_profile
  user = lookup(var.user, var.select_ami)
  key_name = module.KEYPAIR.key_name
  bastion_ip = module.BASTION.bastion_ip
  
  #tags
  default_tags = local.default_tags
  keypair_tag = var.keypair_tag
  EC2_webapp_tag = var.EC2_webapp_tag

}

#Vault
module "VAULT" {
  source = "../../Modules/VAULT-INSTANCE"
  depends_on = [ module.NAT, module.BASTION ]
  ami = lookup(var.ami, var.select_ami, "ami-0606dd43116f5ed57") # AMI id is account specific. Change your values in variable AMI.
  instance_type = var.instance_type
  Vault-SG = module.SG.Vault-SG
  subnet_id = module.VPC.private-subnet-2
  user = lookup(var.user, var.select_ami)
  key_name = module.KEYPAIR.key_name
  bastion_public_ip = module.BASTION.bastion_ip
  # tags
  default_tags = local.default_tags
  vault_tag = var.vault_tag
}
