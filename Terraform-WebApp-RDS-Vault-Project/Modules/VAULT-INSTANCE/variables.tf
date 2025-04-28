# Vault instance
variable "subnet_id" {
  description = "vault instance subnet id"
}
variable "Vault-SG" {
  description = "vault instance security group"
}
variable "ami" {
    description = "Vault instance ami"  
}
variable "instance_type" {
  description = "vault instance type"
}
variable "key_name" {
  description = "vault instance key pair"
}
variable "user" {
  description = "user to login into vault instance"
}

variable "bastion_public_ip" {
  description = "bastion host public ip"
}

#tagging
variable "default_tags" {
  description = "local tags"
}
variable "vault_tag" {
  description = "vault name tag"
}