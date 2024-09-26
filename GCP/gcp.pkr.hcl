packer {
  required_plugins {
    googlecompute = {
      version = "1.1.3"
      source  = "github.com/hashicorp/googlecompute"
    }

    ansible = {
      version = "~> 1"
      source  = "github.com/hashicorp/ansible"
    }
  }
}


variable "project_id" {
  type = string
}

variable "zone" {
  type = string
}

variable "builder_sa" {
  type = string
}

source "googlecompute" "gcp-image" {
  project_id                  = var.project_id
  machine_type                = "e2-medium"
  source_image_family         = "debian-12"
  zone                        = var.zone
  image_name                  = "gcp-image-{{timestamp}}"
  image_description           = "Created with HashiCorp Packer from Jenkins"
  disk_size       = 10
  ssh_username                = "debian"
  tags                        = ["packer"]
  impersonate_service_account = var.builder_sa
}

build {
  sources = ["sources.googlecompute.gcp-image"]

  provisioner "ansible" {
    playbook_file           = "ami-playbook.yml"
    user = "debian"
    use_proxy = false
  }
}