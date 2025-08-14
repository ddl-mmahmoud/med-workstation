provider "aws" {
  region = var.region
}

resource "aws_eip" "workstation-eip" {
  instance = aws_instance.workstation-instance.id
  vpc = true
}

output "public_ip" {
  description = "Public IP address"
  value = aws_eip.workstation-eip.public_ip
}

resource "aws_instance" "workstation-instance" {
  ami = var.ami-id
  instance_type = var.instance_type
  key_name = aws_key_pair.workstation-keypair.key_name
  tags = {
    Name = "Workstation ${var.name}"
    Owner = var.email
    longTerm = true
    deploy_type = "manual"
    duration = "91+"
  }
  vpc_security_group_ids = [
    aws_security_group.workstation-sg.id,
  ]

  connection {
    host = "${self.public_ip}"
    type = "ssh"
    user = "ubuntu"
    private_key = "${file(var.private_ssh_key_path)}"
  }

  provisioner "remote-exec" {
    script = "modules/workstation/bootstrap.sh"
  }

  provisioner "remote-exec" {
    script = "modules/workstation/bootstrap_med.sh"
  }
}

resource "aws_key_pair" "workstation-keypair" {
  key_name = "${var.name}-workstation-keypair"
  public_key = var.workstation_ssh_key
}

resource "aws_security_group" "workstation-sg" {
  name        = "${var.name}-workstation-sg"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.cidrs_with_access
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Owner = var.name
  }
}
