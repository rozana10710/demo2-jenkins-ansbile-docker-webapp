# Individual security group outputs (always created)
output "ssh_sg_id" {
  description = "ID of SSH security group"
  value       = aws_security_group.ssh.id
}

output "http_sg_id" {
  description = "ID of HTTP security group"
  value       = aws_security_group.http.id
}

output "https_sg_id" {
  description = "ID of HTTPS security group"
  value       = aws_security_group.https.id
}

output "jenkins_sg_id" {
  description = "ID of Jenkins security group"
  value       = aws_security_group.jenkins.id
}

output "all_sg_ids" {
  description = "List of all created security group IDs"
  value       = [
    aws_security_group.ssh.id,
    aws_security_group.http.id,
    aws_security_group.https.id,
    aws_security_group.jenkins.id
  ]
}
