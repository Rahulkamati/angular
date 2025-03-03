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
  description = "AMI ID for the EC2 instance"  # Used t2 micro as arch resembeles the same
  type        = string
  default     = "ami-06374a9fe05107fb9"  # ubuntu-miminal images-ami-amd-hvm-2.0.20240503.0-x86_64-gp2
} 
