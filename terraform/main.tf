terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
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
  vpc_id      = "vpc-09480bdec71136196"

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
  key_name              = aws_key_pair.angular_app_key.key_name
  subnet_id             = "subnet-0002c0f9833c778a0"
  vpc_security_group_ids = [aws_security_group.allow_web.id]

  tags = {
    Name        = "angular-app-instance"
    Environment = "dev"
    Terraform   = "true"
  }
}