terraform {
  backend "s3" {
    bucket = "<your s3 bucket>"
    key = "prod/terraform.tfstate"
    dynamodb_table = "lock-table-WRVP"
    encrypt = true
    region = "us-west-2"
  }
}