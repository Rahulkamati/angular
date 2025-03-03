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

resource "aws_instance" "angular_app" {
  ami           = var.ami_id
  instance_type = "t2.micro"
  subnet_id     = "subnet-0ed9673b297aa9c4b"

  vpc_security_group_ids = [aws_security_group.allow_web.id]
  key_name              = aws_key_pair.angular_app_key.key_name

  tags = {
    Name = "angular-app-instance"
  }
} 