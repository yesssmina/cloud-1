# Cloud-1 — Terraform configuration
# Creates a Scaleway VM instance for WordPress deployment

terraform {
  required_providers {
    scaleway = {
      source = "scaleway/scaleway"
    }
  }
  required_version = ">= 1.0"
}

# Scaleway provider — credentials come from environment variables
# SCW_ACCESS_KEY, SCW_SECRET_KEY, SCW_DEFAULT_PROJECT_ID
provider "scaleway" {
  zone   = var.zone
  region = var.region
}

# SSH key — references your existing key on Scaleway
data "scaleway_iam_ssh_key" "cloud1" {
  name = var.ssh_key_name
}

# Security group — only allow ports 22, 80, 443 (mirrors UFW config)
resource "scaleway_instance_security_group" "cloud1" {
  name                    = "cloud1-sg"
  inbound_default_policy  = "drop"
  outbound_default_policy = "accept"

  inbound_rule {
    action = "accept"
    port   = 22
  }

  inbound_rule {
    action = "accept"
    port   = 80
  }

  inbound_rule {
    action = "accept"
    port   = 443
  }
}

# The VM instance
resource "scaleway_instance_server" "cloud1" {
  name  = var.instance_name
  type  = var.instance_type
  image = var.instance_image

  ip_id             = scaleway_instance_ip.cloud1.id
  security_group_id = scaleway_instance_security_group.cloud1.id

  root_volume {
    size_in_gb = var.volume_size
  }
}

# Static public IP
resource "scaleway_instance_ip" "cloud1" {}
