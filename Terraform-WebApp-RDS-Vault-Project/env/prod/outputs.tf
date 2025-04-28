# VPC Module
output "MyVPC" {
  value = module.VPC.MyVPC
}

# ALB
output "alb-dns" {
  value = module.ALB.ALB_dns
}

# Bastion Host
output "bastion_public_ip" {
  value = module.BASTION.bastion_ip
  
}

# Vault
output "vault_private_ip" {
  value = module.VAULT.vault_private_ip
}
