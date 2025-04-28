variable "NAT-Subnet" {
    description = "Desired public subnet"
  
}

variable "Private-RT" {
    description = "Attached this subnet to NAT"
  
}

#tagging

variable "default_tags" {
    description = "local tags"
  
}

variable "EIP_tag" {
    description = "EIP name tag"
  
}

variable "NatGateway_tag" {
    description = "NatGateway name tag"
  
}