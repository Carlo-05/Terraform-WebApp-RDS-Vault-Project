terraform {
  backend "s3" {
    bucket = "<your s3 bucket>"
    key = "dev/terrafor.tfstate"
    encrypt = true
    region = "us-west-2"
  }
}