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
  allowed_ssh_cidr = var.allowed_ssh_cidr
  allowed_jenkins_cidr = var.allowed_jenkins_cidr
  name = var.sg_name
}

module "jenkins_master" {
  source = "./modules/ec2-instance"
  name = var.master_name
  ami  = var.master_ami
  instance_type = var.master_instance_type
  subnet_id = module.vpc.public_subnet_id
  key_name  = var.key_name
  volume_size        = var.jenkins_master_volume
  security_group_ids = [module.sg.sg_id]
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
  security_group_ids = [module.sg.sg_id]
  user_data          = file("${path.module}/scripts/setup_slave.sh")
}