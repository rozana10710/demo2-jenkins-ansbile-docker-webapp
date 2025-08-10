variable "name" {
  type = string
}

variable "ami" {
  type = string
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}
variable "volume_size" {
  description = "Size of the root EBS volume in GB"
  type        = number
  default     = 20
}
variable "subnet_id" {
  type = string
}

variable "key_name" {
  type = string
}

variable "security_group_ids" {
  type = list(string)
}

variable "associate_public_ip" {
  type    = bool
  default = true
}

variable "user_data" {
  type    = string
  default = ""
}
