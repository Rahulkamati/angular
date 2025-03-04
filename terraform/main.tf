terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket = "04032025-terraform-state-bucket-name"
    key    = "terraform.tfstate"
    region = "ap-south-1"
    encrypt = true
  }
}

provider "aws" {
  region     = var.aws_region
  # access_key = var.aws_access_key_id
  # secret_key = var.aws_secret_access_key
}

variable "ssh_public_key" {
  description = "SSH public key for EC2 instance access (passed from GitHub Actions)"
  type        = string
}

# Create a new EC2 key pair
resource "aws_key_pair" "angular_app_key" {
  key_name   = "angular-key"
  public_key = var.ssh_public_key
}

resource "aws_security_group" "allow_web" {
  name        = "allow_web_traffic"
  description = "Allow web inbound traffic"
  vpc_id      = "vpc-0e4e7b5eb0ac04145"

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ICMP"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_web"
  }
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 5.0"

  name = "angular-app-instance"

  instance_type          = "t2.micro"
  ami                    = var.ami_id
  key_name               = aws_key_pair.angular_app_key.key_name
  subnet_id              = "subnet-089dfade2607c702e" # Default Subnet used for mapping purpose
  vpc_security_group_ids = [aws_security_group.allow_web.id]

  # Add user data to ensure SSH is running
  user_data = <<-EOF
              #!/bin/bash
              sudo systemctl start sshd
              sudo systemctl enable sshd
              EOF

  tags = {
    Name        = "angular-app-instance"
    Environment = "dev"
    Terraform   = "true"
  }
}
