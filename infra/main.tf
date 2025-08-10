module "vpc" {
  source = "./modules/vpc"
  name   = var.vpc_name
  vpc_cidr = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
  az = var.availability_zone
}

module "sg" {
  source = "./modules/security_group"
  vpc_id = module.vpc.vpc_id
  name_prefix = var.sg_name_prefix
  # CIDR blocks for each security group
  allowed_ssh_cidr = var.allowed_ssh_cidr
  allowed_jenkins_cidr = var.allowed_jenkins_cidr
  allowed_http_cidr = var.allowed_http_cidr
  allowed_https_cidr = var.allowed_https_cidr
}

module "jenkins_master" {
  source = "./modules/ec2-instance"
  name = var.master_name
  ami  = var.master_ami
  instance_type = var.master_instance_type
  subnet_id = module.vpc.public_subnet_id
  key_name  = var.key_name
  volume_size        = var.jenkins_master_volume
  # Only attach SSH and Jenkins security groups to master
  security_group_ids = [
    module.sg.ssh_sg_id,
    module.sg.jenkins_sg_id
  ]
  user_data          = file("${path.module}/scripts/install_jenkins.sh")
}

module "jenkins_slave" {
  source = "./modules/ec2-instance"
  name = var.slave_name
  ami  = var.slave_ami
  instance_type = var.slave_instance_type
  subnet_id = module.vpc.public_subnet_id
  key_name  = var.key_name
  volume_size        = var.jenkins_slave_volume
  # Attach SSH, HTTP, and HTTPS security groups to slave
  security_group_ids = [
    module.sg.ssh_sg_id,
    module.sg.http_sg_id,
    module.sg.https_sg_id
  ]
  user_data          = file("${path.module}/scripts/setup_slave.sh")
}