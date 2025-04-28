
# Vault Instance
resource "aws_instance" "Vault-Instance" {
    subnet_id = var.subnet_id
    vpc_security_group_ids = [var.Vault-SG]
    ami = var.ami
    instance_type = var.instance_type
    key_name = var.key_name
   
    connection {
    type          = "ssh"
    user          = var.user
    host          = self.private_ip
    agent         = true
    bastion_host  = var.bastion_public_ip

  }
    
    provisioner "remote-exec" {
      inline = [
        "curl -L -o vault-installer.sh https://raw.githubusercontent.com/Carlo-05/WebApp_RDS_Vault_Project/refs/heads/main/vault-installer.sh",
        "sudo chmod 755 vault-installer.sh",
        "./vault-installer.sh",
      ]
      
    }

    tags = merge(var.default_tags, { Name = var.vault_tag })
  
}
