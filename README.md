# Cloud-1 — Automated Deployment of Inception

Automated deployment of a WordPress infrastructure on Scaleway
using Ansible and Terraform.

## Architecture

- **WordPress** — CMS application
- **MySQL 8.0** — Database (isolated on backend network)
- **phpMyAdmin** — Database admin (accessible at /pma/)
- **Nginx** — Reverse proxy with TLS (Let's Encrypt)
- **Certbot** — TLS certificate (auto-renewed daily)

## Prerequisites

- Ansible >= 2.17
- Terraform >= 1.0 (optional, for VM provisioning)
- SSH key configured on Scaleway
- DuckDNS domain pointing to server IP

## Quick Start

1. Install Ansible dependencies:

   ansible-galaxy collection install -r requirements.yml

2. Configure vault password:

   echo "your_vault_password" > ~/.vault_pass
   chmod 600 ~/.vault_pass

3. (Optional) Create VM with Terraform:

   cd terraform && terraform init && terraform apply && cd ..

4. Update inventory.ini with the server IP

5. Deploy:

   ansible-playbook playbook.yml

## docker-compose.yml

The docker-compose file is a Jinja2 template (docker-compose.yml.j2)
rendered by Ansible on the server with secrets from the vault.
To view the rendered file on the server:

   ssh root@<server_ip> "cat /opt/wordpress/docker-compose.yml"

## Project Structure

   ansible.cfg              Ansible configuration
   inventory.ini            Target servers
   playbook.yml             Main playbook (calls all roles)
   vault.yml                Encrypted secrets (Ansible Vault)
   group_vars/all.yml       Public variables
   requirements.yml         Ansible collection dependencies
   terraform/               VM provisioning (optional)
      main.tf
      variables.tf
      outputs.tf
   roles/
      base/                 System update + prerequisites
      docker/               Docker + Compose V2
      firewall/             UFW (ports 22/80/443 only)
      wordpress/            Docker-compose stack deployment
      nginx/                Reverse proxy + TLS + cert auto-renewal

## Multi-Server Deployment

To deploy on additional servers:

1. Add the server IP to inventory.ini:

   [webservers]
   51.15.216.227  ansible_user=root  ansible_ssh_private_key_file=~/.ssh/id_ed25519
   NEW.IP.HERE    ansible_user=root  ansible_ssh_private_key_file=~/.ssh/id_ed25519

2. Create a host_vars file for the new server:

   host_vars/NEW.IP.HERE.yml

   With content:

   domain_name: your-domain.duckdns.org
   certbot_email: your-email@example.com

3. Point the new DuckDNS domain to the new server IP

4. Deploy:

   ansible-playbook playbook.yml

Ansible deploys on all servers in parallel. Each server gets its own
domain and TLS certificate. Database credentials are shared via group_vars.

## Security

- Only ports 22, 80, 443 exposed (UFW + Scaleway security group)
- Database isolated on backend Docker network (no internet access)
- All secrets encrypted with Ansible Vault
- TLS certificates auto-renewed via daily cron job
- No hard-coded secrets in the codebase
