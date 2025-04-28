# db sg
output "db_sg" {
    value = aws_security_group.db_sg.id  
}
# bastion sg
output "bastion_sg" {
    value = aws_security_group.bastion-sg.id  
}
# ALB sg
output "ALB-sg" {
  value = var.create_ASG-ALB_sg ? aws_security_group.ALB-sg[0].id : null 
}
# ASG sg
output "ASG_template_sg" {
  value = var.create_ASG-ALB_sg ? aws_security_group.ASG_template_sg[0].id : null
}
# webapp sg
output "Web-app-sg" {
    value = var.create_webapp_sg ? aws_security_group.Web-app-sg[0].id : null  
}
#vault sg
output "Vault-SG" {
  value = aws_security_group.Vault-SG.id
}
