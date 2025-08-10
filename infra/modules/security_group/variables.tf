variable "vpc_id" {
  type = string
}

variable "name_prefix" {
  type        = string
  description = "Prefix for security group names"
  default     = "jenkins"
}

variable "allowed_ssh_cidr" {
  type        = string
  description = "CIDR block allowed for SSH access"
  default     = "0.0.0.0/0"
}

variable "allowed_http_cidr" {
  type        = string
  description = "CIDR block allowed for HTTP access"
  default     = "0.0.0.0/0"
}

variable "allowed_https_cidr" {
  type        = string
  description = "CIDR block allowed for HTTPS access"
  default     = "0.0.0.0/0"
}

variable "allowed_jenkins_cidr" {
  type        = string
  description = "CIDR block allowed for Jenkins web interface"
  default     = "0.0.0.0/0"
}

## All SGs are always created; creation flags removed for simplicity
