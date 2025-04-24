#Add to maint.tf (dev or prod) after doing all of the vault configuration
provider "vault" { 
  address = "http://127.0.0.1:8200" #Local vault address
  skip_child_token = true

  auth_login {
    path = "auth/approle/login"

    parameters = {
      role_id = "<role-id>"
      secret_id = "<secret-id>"
    }
  }
  
}

data "vault_kv_secret_v2" "example" {
  mount = "employees"
  name  = "secrets"
}

resource "aws_s3_object" "text-file" {
    bucket = "<your-s3-bucket>"
    key = "Vault/SecretV2.txt"
    content = data.vault_kv_secret_v2.example.data_json
    content_type = "text/plain"  
}