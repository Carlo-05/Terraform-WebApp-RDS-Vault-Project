# VPC Module
output "MyVPC" {
  value = module.VPC.MyVPC
}

# EC2 Module
output "webpp_instance_id" {
    value = module.EC2.webapp_instance_id  
}

output "webapp_instance_public_ip" {
    value = module.EC2.webapp_instance_public_ip  
}

output "webapp_private_ip" {
  value = module.EC2.webapp_instance_private_ip
}

# Bastion Host
output "bastion_public_ip" {
  value = module.BASTION.bastion_ip  
}

# Vault
output "vault_private_ip" {
  value = module.VAULT.vault_private_ip
}
