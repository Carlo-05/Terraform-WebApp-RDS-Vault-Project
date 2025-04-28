variable "vpc_id" {
  description = "preferres vpc"
}
#Conditionals
variable "create_ASG-ALB_sg" {
  type = bool
  description = "create ASG sg and ALB sg"
  default = false
}
variable "create_webapp_sg" {
  type = bool
  description = "create webapp sg"
  default = false
}
#tags
variable "default_tags" {
  description = "local tags"
}
#RDS tags
variable "dbsg_tag" {
    description = "db sg name tag."
}
#bastion tags
variable "bastion_sg_tag" {
    description = "bastion sg name tag"  
}
# ALB tags
variable "ALB_sg_tag" {
  description = "ALB name tag"
}
#ASG tags
variable "ASG_sg_tag" {
  description = "ASG sg name tag"
}
#webapp tags
variable "webapp_sg_tag" {
  description = "webapp name tag"
}
#vault instance tags
variable "vault_sg_tag" {
    description = "vault sg name tag" 
}