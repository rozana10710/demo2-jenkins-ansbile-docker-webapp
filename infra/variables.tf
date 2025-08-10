variable "aws_region" {
  type        = string
  default     = "us-east-1"
}

#___________VPC___________
variable "vpc_name" {
  type        = string
  default     = "jenkins-vpc"
}
variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
}
variable "public_subnet_cidr" {
  type        = string
  default     = "10.0.1.0/24"
}
variable "availability_zone" {
  type        = string
  default     = ""
}
#___________SECURITY GROUP___________
variable "allowed_ssh_cidr" {
  type        = string
  default     = "0.0.0.0/0"
}
variable "allowed_jenkins_cidr" {
  type        = string
  default     = "0.0.0.0/0"
}
variable "sg_name" {
  type        = string
  default     = "jenkins-sg"
}
#___________KEY PAIR___________
variable "key_name" {
  type        = string
}
#___________JENKINS MASTER___________
variable "master_name" {
  type        = string
  default     = "jenkins-master"
}


variable "master_instance_type" {
  type        = string
  default     = "m7i-flex.xlarge"
}

variable "jenkins_master_volume" {
  description = "Root volume size (GB) for Jenkins master"
  type        = number
  default     = 50
}

variable "master_ami" {
  type        = string
}

#___________JENKINS SLAVE___________    

variable "slave_name" {
  type        = string
  default     = "jenkins-slave"
}

variable "slave_ami" {
  type        = string
}
variable "slave_instance_type" {
  type        = string
  default     = "m7i-flex.xlarge"
}

variable "jenkins_slave_volume" {
  description = "Root volume size (GB) for Jenkins slave"
  type        = number
  default     = 50
}
