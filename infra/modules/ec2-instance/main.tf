resource "aws_instance" "this" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  key_name      = var.key_name
  vpc_security_group_ids = var.security_group_ids
  associate_public_ip_address = var.associate_public_ip

    root_block_device {
    volume_size = var.volume_size
    volume_type = "gp3"
  }


  tags = { Name = var.name }

  user_data = var.user_data
}
