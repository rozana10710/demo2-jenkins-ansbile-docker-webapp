## Infrastructure (Terraform)

This folder provisions AWS infrastructure for the demo Jenkins + Ansible + Docker web app.

### What it creates
- VPC, public subnet, and related networking
- Modular security groups:
  - SSH (22), HTTP (80), HTTPS (443), Jenkins (8080)
- EC2 instances:
  - Jenkins master
  - Jenkins slave (agent)
- User data scripts to configure master and slave

### Files
- `main.tf`: Composes modules (`vpc`, `security_group`, `ec2-instance`)
- `variables.tf`: Input variables (VPC, AMIs, instance sizes, SG CIDRs)
- `terraform.tfvars` (example): Region/AMI overrides
- `modules/*`: Reusable Terraform modules
- `scripts/install_jenkins.sh`: Installs Jenkins on master
- `scripts/setup_slave.sh`: Installs JDK, Ansible, Docker on slave

### Usage
1) Set values in `infra/terraform.tfvars` (region, key pair, AMIs, CIDRs)
2) Init + review + apply:
```
cd infra
terraform init
terraform plan
terraform apply -auto-approve
```
3) Outputs/notes
- Master gets SGs: SSH + Jenkins (8080)
- Slave gets SGs: SSH + HTTP + HTTPS
- User data runs on first boot; instances will recreate if user_data changes

### Access
- Jenkins (master): `http://<master-public-ip>:8080`
- Web app (slave): `http://<slave-public-ip>`

### Clean up
```
cd infra
terraform destroy -auto-approve
```