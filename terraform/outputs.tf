output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = coalesce(module.ec2_instance.public_ip, "")
  sensitive   = false
}

output "instance_public_dns" {
  description = "Public DNS of the EC2 instance"
  value       = coalesce(module.ec2_instance.public_dns, "")
  sensitive   = false
}

output "instance_state" {
  description = "State of the EC2 instance"
  value       = coalesce(module.ec2_instance.instance_state, "")
  sensitive   = false
}

output "instance_username" {
  description = "Username for SSH access"
  value       = "ec2-user"  # or "ubuntu" depending on your AMI
  sensitive   = false
}