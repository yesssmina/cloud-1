# All configurable parameters for the infrastructure

variable "zone" {
  description = "Scaleway availability zone"
  type        = string
  default     = "fr-par-1"
}

variable "region" {
  description = "Scaleway region"
  type        = string
  default     = "fr-par"
}

variable "instance_name" {
  description = "Name of the VM instance"
  type        = string
  default     = "cloud1-server"
}

variable "instance_type" {
  description = "Scaleway instance type"
  type        = string
  default     = "DEV1-S"
}

variable "instance_image" {
  description = "OS image for the instance"
  type        = string
  default     = "ubuntu_jammy"
}

variable "volume_size" {
  description = "Root volume size in GB"
  type        = number
  default     = 20
}

variable "ssh_key_name" {
  description = "Name of the SSH key on Scaleway"
  type        = string
  default     = "Cloud1"
}
