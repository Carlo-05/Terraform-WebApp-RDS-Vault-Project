# VPC
selected_region = "west-2"
vpc_cidr_block = "10.0.0.0/16"
subnet-public-1-az = "us-west-2a"
subnet-public-2-az = "us-west-2b"
subnet-private-1-az = "us-west-2a"
subnet-private-2-az = "us-west-2b"

# Security Group
create_ASG-ALB_sg = false
create_webapp_sg = true

#Parameter store
ssm_db_name = "/projectdb/database" 
ssm_db_username = "/projectdb/username"
ssm_db_password = "/projectdb/password"
ssm_db_endpoint = "/projectdb/endpoint"

#RDS 
db_identifier = "projectdb"
db_engine = "mysql"
db_engine_version = "8.0"
db_instance_class ="db.t3.micro" #change to db.t3.medium for multi-az
db_allocated_storage = 20
db_AZ = "us-west-2a"
db_multi_az = false

#EC2 webapp/bastion/vault/ASG 
select_ami = "linux2" # choose between linux2(ec2-user) and ubuntu(ubuntu)
instance_type = "t2.micro"



# TAGS

#local tags
env = "dev"
projectname = "Webapp-RDS-Vault Project"

# Vpc tagging
vpc_tag = "MyVPC-WRVP"
igw_tag = "MyIGW-WRVP"
public1_subnet_tag = "public-subnet-1-WRVP"
public2_subnet_tag = "public-subnet-2-WRVP"
private1_subnet_tag = "private-subnet-1-WRVP"
private2_subnet_tag = "private-subnet-2-WRVP"
public_RT_tag = "public-RT-WRVP"
private_RT_tag = "privavte-RT-WRVP"

#RDS tags
db_subnetgroup_tag ="db-subnet-group-WRVP"
dbsg_tag = "db-SG-WRVP"
#NAT tags
NatGateway_tag = "NAT-WRVP"
EIP_tag = "EIP-WRVP"
# Iam role tag
iam_role_tag = "WRVP_role"
# Keypair tag
keypair_tag = "keypair-WRVP"
# ALB tags
webapp_ALB_tag = "MyALB-WRVP"
webapp_target_group_tag = "MyALB-TargetGroup-WRVP" 
ALB_listener_tag = "MyALB-Listener-WRVP"
ALB_sg_tag = "MyALB-SG-WRVP"
# ASG tags
WebApp_ASG_template_tag ="Webapp-ASG-Template-WRVP"
Webapp_ASG_tag = "Webapp-ASG-WRVP"
ASG_sg_tag = "Webapp-SG-WRVP"
# EC2 WebApp Tags
webapp_sg_tag = "webapp-sg-WRVP"
EC2_webapp_tag = "webapp-WRVP"

# Bastion Host tags
bastion_tag = "Bastion-Host-WRVP"
bastion_sg_tag = "Bastion-SG-WRVP"
#Vault tags
vault_sg_tag = "vault-sg-WRVP"
vault_tag = "vault-instance-WRVP"





