output "master_public_ip" {
  value = module.jenkins_master.public_ip
}

output "slave_public_ip" {
  value = module.jenkins_slave.public_ip
}

output "master_id" {
  value = module.jenkins_master.instance_id
}

output "slave_id" {
  value = module.jenkins_slave.instance_id
}