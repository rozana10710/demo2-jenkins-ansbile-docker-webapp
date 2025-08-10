variable "vpc_id" {
  type = string
}

variable "allowed_ssh_cidr" {
  type    = string
  default = "0.0.0.0/0"
}

variable "allowed_jenkins_cidr" {
  type    = string
  default = "0.0.0.0/0"
}

variable "name" {
  type    = string
  default = "jenkins-sg"
}
