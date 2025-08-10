# Demo: Jenkins + Ansible + Docker Web App on AWS

End-to-end demo that provisions AWS infra for Jenkins master/agent, builds a Docker image via Ansible from Jenkins, pushes to Docker Hub, and runs a simple web app.

## Architecture
- Terraform (`infra/`): VPC, subnet, modular security groups, EC2 master + slave
- Jenkins (`jenkins/`): Declarative pipeline to checkout and invoke Ansible
- Ansible (`ansbile/`): Builds, tags, pushes image, and runs container on the agent
- Docker (`docker/`): Dockerfile + static `index.html`

## Flow
1. Terraform creates infra; user data installs Jenkins (master) and agent deps (slave)
2. Jenkins pipeline (on slave) checks out this repo
3. Pipeline runs Ansible playbook to build and push image, then start container
4. Web app becomes available on the slave’s public IP (port 80)

## Prerequisites
- AWS account + credentials for Terraform
- Terraform >= 1.5
- A key pair in AWS (used by instances)
- Valid Ubuntu AMIs for master/slave
- Docker Hub account

## Quickstart
1) Provision AWS:
```
cd infra
terraform init
terraform apply -auto-approve
```
2) Get public IPs from AWS console or Terraform outputs
3) Access Jenkins: `http://<master-public-ip>:8080` (admin/admin123 by default; change it)
4) In Jenkins, create a Pipeline job pointing to this repo (Jenkinsfile in `jenkins/`)
5) Configure job parameters:
   - DOCKERHUB_USERNAME (string)
   - DOCKERHUB_PASSWORD (password/token)
6) Run the pipeline
7) Access the app: `http://<slave-public-ip>`

## Folder Overview
- `infra/`: Terraform modules, variables, and scripts
- `jenkins/`: Jenkins pipeline definition
- `ansbile/`: Playbook and docs for build/push/run
- `docker/`: Dockerfile and static site content

## Clean Up
```
cd infra
terraform destroy -auto-approve
```

## Notes
- Security groups are modular; attach only what’s needed per instance
- The agent must allow inbound HTTP (80) to expose the demo site
- The `jenkins` user must be in the `docker` group on the agent