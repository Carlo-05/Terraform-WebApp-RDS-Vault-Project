# EC2
resource "aws_instance" "WebApp" {
    ami = var.ami
    instance_type = var.instance_type
    vpc_security_group_ids = [var.Web-app-sg]
    subnet_id = var.webapp_subnet
    key_name = var.key_name
    iam_instance_profile = var.iam_instance_profile
    tags = merge(var.default_tags , { Name = var.EC2_webapp_tag })
    
    connection {
      type = "ssh"
      user = var.user
      #private_key = file("~/.ssh/id_rsa")
      host = self.private_ip
      agent = true
      bastion_host = var.bastion_ip
    }

    provisioner "remote-exec" {
      inline = [ 
        "curl -L -o project.sh https://raw.githubusercontent.com/Carlo-05/WebApp_RDS_Vault_Project/refs/heads/main/project.sh",
        "curl -L -o employees.sql https://raw.githubusercontent.com/Carlo-05/WebApp_RDS_Vault_Project/refs/heads/main/employees.sql",
        "sudo chmod 755 project.sh",
        "sudo ./project.sh",
       ]
      
    }
}