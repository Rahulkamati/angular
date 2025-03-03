variable "aws_region" {
  description = "AWS region"
  type        = string
}

# variable "aws_access_key_id" {
#   description = "AWS access key ID"
#   type        = string
#   sensitive   = true
# }

# variable "aws_secret_access_key" {
#   description = "AWS secret access key"
#   type        = string
#   sensitive   = true
# }

# variable "key_name" {
#   description = "Name of the SSH key pair"
#   type        = string
# }

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
  default     = "ami-0019ea9b7352899c2"  # amzn2-ami-amd-hvm-2.0.20240503.0-x86_64-gp2
} 