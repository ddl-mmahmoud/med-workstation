variable "public_key_path" {
  type = string
}

variable "private_key_path" {
  type = string
}

variable "prefix" {
  type = string
}

variable "email" {
  type = string
}

variable "cidrs" {
  type = list(string)
}


module "workstation_instance" {
  source = "./modules/workstation"

  name = "${var.prefix}-workstation"
  email = var.email
  workstation_ssh_key = "${file(var.public_key_path)}"
  private_ssh_key_path = var.private_key_path
  cidrs_with_access = var.cidrs
}


output "workstation_public_ip" {
  description = "Public IP"
  value = module.workstation_instance.public_ip
}
