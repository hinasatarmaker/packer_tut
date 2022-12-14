packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "ami_prefix" {
  type    = string
  default = "packer-ubuntu-apache"
}

locals {
     timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}


source "amazon-ebs" "ubuntu" {
  #ami_name      = "new-packer-linux-aws"
  ami_name      = "${var.ami_prefix}-${local.timestamp}"
  instance_type = "t2.micro"
  region        = "ap-northeast-3"
  #vpc_id        = "vpc-0a034346d5abc0a81"
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-jammy-22.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
}

build {
  name = "new-packer"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]

   provisioner "ansible" {
    playbook_file = "./playbook.yml"
  }
}