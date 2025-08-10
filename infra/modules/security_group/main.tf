# SSH Security Group
resource "aws_security_group" "ssh" {
  name        = "${var.name_prefix}-ssh-sg"
  description = "SSH access security group"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { 
    Name = "${var.name_prefix}-ssh-sg"
    Purpose = "SSH access"
  }
}

# HTTP Security Group
resource "aws_security_group" "http" {
  name        = "${var.name_prefix}-http-sg"
  description = "HTTP access security group"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.allowed_http_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { 
    Name = "${var.name_prefix}-http-sg"
    Purpose = "HTTP access"
  }
}

# HTTPS Security Group
resource "aws_security_group" "https" {
  name        = "${var.name_prefix}-https-sg"
  description = "HTTPS access security group"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.allowed_https_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { 
    Name = "${var.name_prefix}-https-sg"
    Purpose = "HTTPS access"
  }
}

# Jenkins Security Group
resource "aws_security_group" "jenkins" {
  name        = "${var.name_prefix}-jenkins-sg"
  description = "Jenkins web interface security group"
  vpc_id      = var.vpc_id

  ingress {
    description = "Jenkins web"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [var.allowed_jenkins_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { 
    Name = "${var.name_prefix}-jenkins-sg"
    Purpose = "Jenkins web interface"
  }
}

## Legacy combined SG removed to avoid over-permissive default