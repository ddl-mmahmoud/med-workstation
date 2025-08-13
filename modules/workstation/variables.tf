variable "name" {
  type = string
}

variable "email" {
  type = string
}

variable "workstation_ssh_key" {
  type = string
}

variable "private_ssh_key_path" {
  type = string
}

variable "cidrs_with_access" {
  type = list(string)
}

variable "ami-id" {
  type = string
  # These Ubuntu images are trusted
  # https://cloud-images.ubuntu.com/locator/ec2/
  default = "ami-075686beab831bb7f"
}

variable "instance_type" {
  type = string
  default = "t2.medium"
}

variable "region" {
  type = string
  default = "us-west-2"
}
