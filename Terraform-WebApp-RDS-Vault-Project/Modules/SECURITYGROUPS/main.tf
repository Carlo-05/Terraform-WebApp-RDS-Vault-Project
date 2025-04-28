# RDS security group
resource "aws_security_group" "db_sg" {
    vpc_id = var.vpc_id
    name = var.dbsg_tag
    description = "allow ssh from bastion host and webapp"
    #tags
    tags = merge(var.default_tags, { Name = var.dbsg_tag })
}

#RDS add rule
# allow bastion traffic to rds
resource "aws_security_group_rule" "allow_bastion_to_RDS" {
    type = "ingress"
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    source_security_group_id = aws_security_group.bastion-sg.id
    security_group_id = aws_security_group.db_sg.id
}
# allow webapp traffic to rds
resource "aws_security_group_rule" "allow_ec2_to_RDS" {
    count = var.create_webapp_sg ? 1 : 0
    type = "ingress"
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    source_security_group_id = aws_security_group.Web-app-sg[0].id
    security_group_id = aws_security_group.db_sg.id
}
# allow ASG traffic to rds
resource "aws_security_group_rule" "allow_ASG_to_RDS" {
    count = var.create_ASG-ALB_sg ? 1 : 0
    type = "ingress"
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    source_security_group_id = aws_security_group.ASG_template_sg[0].id
    security_group_id = aws_security_group.db_sg.id
}
resource "aws_security_group_rule" "allow_all_rds_egress" {
    type = "egress"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = aws_security_group.db_sg.id
}

# Bastion Host Security Group
resource "aws_security_group" "bastion-sg" {
    vpc_id = var.vpc_id
    name = var.bastion_sg_tag
    description = "allow ssh connection"
    tags = merge(var.default_tags, { Name = var.bastion_sg_tag })
    
    # allow ssh
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }  
}

# ALB security group
resource "aws_security_group" "ALB-sg" {
    vpc_id = var.vpc_id
    count = var.create_ASG-ALB_sg ? 1 : 0
    name = var.ALB_sg_tag
    description = "allow http traffic"
    tags = merge(var.default_tags, { Name = var.ALB_sg_tag})

  # http
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# webapp security group
resource "aws_security_group" "Web-app-sg" {
    vpc_id = var.vpc_id
    count = var.create_webapp_sg ? 1 : 0
    name = var.webapp_sg_tag
    description = "allow http"
    # tags
    tags = merge(var.default_tags , { Name = var.webapp_sg_tag })
}
# WebApp SG Rules
# allow traffic from bastion to webapp
resource "aws_security_group_rule" "allow_bastion_to_ec2" {
    count = var.create_webapp_sg ? 1 : 0
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    source_security_group_id = aws_security_group.bastion-sg.id
    security_group_id = aws_security_group.Web-app-sg[0].id
}
# allow http traffic
resource "aws_security_group_rule" "allow_http_to_ec2" {
    count = var.create_webapp_sg ? 1 : 0
    type = "ingress"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = aws_security_group.Web-app-sg[0].id
}
# allow all outbound traffic
resource "aws_security_group_rule" "allow_all_ec2_egress" {
    count = var.create_webapp_sg ? 1 : 0
    type = "egress"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = aws_security_group.Web-app-sg[0].id
}



# ASG security group
resource "aws_security_group" "ASG_template_sg" {
  count = var.create_ASG-ALB_sg ? 1 : 0
  name = var.ASG_sg_tag
  description = "allow http to ASG"
  vpc_id = var.vpc_id
    
  tags = merge(var.default_tags, { Name = var.ASG_sg_tag })
  
}
# ASG sg rules
#allow traffic from bastion to ASG
resource "aws_security_group_rule" "allow_bastion_to_ASG" {
    count = var.create_ASG-ALB_sg ? 1 : 0
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    source_security_group_id = aws_security_group.bastion-sg.id
    security_group_id = aws_security_group.ASG_template_sg[0].id
}
# Allow ALB traffic to ASG
resource "aws_security_group_rule" "allow_ALB_to_ASG" {
    count = var.create_ASG-ALB_sg ? 1 : 0
    type = "ingress"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    source_security_group_id = aws_security_group.ALB-sg[0].id
    security_group_id = aws_security_group.ASG_template_sg[0].id
}
# allow all outbound traffic
resource "aws_security_group_rule" "allow_all_ASG_egress" {
    count = var.create_ASG-ALB_sg ? 1 : 0
    type = "egress"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = aws_security_group.ASG_template_sg[0].id
}




# Vault security group
resource "aws_security_group" "Vault-SG" {
    vpc_id = var.vpc_id
    name = var.vault_sg_tag
    tags = merge(var.default_tags, { Name = var.vault_sg_tag })
  }
# Vault sg rules
# allow traffic from bastion to vault  
resource "aws_security_group_rule" "allow_bastion_to_Vault" {
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    source_security_group_id = aws_security_group.bastion-sg.id
    security_group_id = aws_security_group.Vault-SG.id
  }
# allow traffic to flow in port 8200
resource "aws_security_group_rule" "allow_bastion_to_Vaultport8200" {
    type = "ingress"
    from_port = 8200
    to_port = 8200
    protocol = "tcp"
    source_security_group_id = aws_security_group.bastion-sg.id
    security_group_id = aws_security_group.Vault-SG.id
  }
# allow all outbound traffic
resource "aws_security_group_rule" "allow_all_egress" {
    type = "egress"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = aws_security_group.Vault-SG.id
}