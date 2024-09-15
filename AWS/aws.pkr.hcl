# packer puglin for AWS 
# https://www.packer.io/plugins/builders/amazon 

// variable "aws_access_key_id" {
//   type = string
// }

// variable "aws_secret_access_key" {
//   type = string
// }

packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = ">= 1.3.2"
    }
    ansible = {
      version = "~> 1"
      source = "github.com/hashicorp/ansible"
    }
  }
}

# which ami to use as the base and where to save it
source "amazon-ebs" "amazon-linux" {
  // access_key      = var.aws_access_key_id
  // secret_key      = var.aws_secret_access_key
  region          = "us-east-1"
  ami_name        = "ami-version-1.0.1-{{timestamp}}"
  instance_type   = "t2.micro"
  source_ami      = "ami-0182f373e66f89c85" #Amazon Linux 2023 AMI
  ssh_username    = "ec2-user"
  #ami_users       = ["AWS Account ID"]
  ami_regions     = [
                      "us-east-1"
                    ]
}

build {
  name    = "amazon-linux-build"
  sources = [
    "source.amazon-ebs.amazon-linux"
  ]

  provisioner "ansible" {
    playbook_file           = "ami-playbook.yml"
    user = "ec2-user"
    use_proxy = false
  }
}