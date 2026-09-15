# Displayed after terraform apply — used by Ansible

output "server_ip" {
  description = "Public IP of the Cloud-1 server"
  value       = scaleway_instance_ip.cloud1.address
}

output "server_id" {
  description = "Instance ID"
  value       = scaleway_instance_server.cloud1.id
}
