# Angular Application Deployment Guide

This repository contains an Angular application with a complete CI/CD pipeline using Docker, GitHub Container Registry, Terraform, and Ansible with aws cloud platform

## Local Development

### Prerequisites
- Node.js 18.x or later
- npm 8.x or later
- Docker Desktop
- Git

### Local Setup
1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd angular-app
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Run the application locally:
   ```bash
   npm start
   ```
   The application will be available at `http://localhost:4200`

### Docker Local Build
1. Build the Docker image:
   ```bash
   docker build -t angular-app .
   ```

2. Run the container:
   ```bash
   docker run -p 80:80 angular-app
   ```
   Access the application at `http://localhost`

## CI/CD Pipeline Setup

### Prerequisites
- GitHub account with repository access
- AWS account with appropriate permissions
- Terraform installed
- Ansible installed
- SSH key pair for AWS

### GitHub Container Registry Setup
1. Enable GitHub Container Registry for your repository
2. Ensure GitHub Actions has necessary permissions

### AWS Infrastructure Deployment
1. Configure AWS credentials:
   ```bash
   aws configure
   ```

2. Initialize and apply Terraform configuration:
   ```bash
   cd terraform
   terraform init
   terraform apply
   ```
   When prompted, provide:
   - AWS region (default: us-west-2)
   - SSH key pair name
   - Confirm with 'yes'

### Application Deployment
1. Set up required GitHub secrets:
   - `GITHUB_TOKEN` (automatically provided)

2. The GitHub Actions workflow will automatically:
   - Build the Docker image
   - Push to GitHub Container Registry
   - Tag the image appropriately

3. Deploy to AWS using Ansible:
   ```bash
   cd ansible
   ansible-playbook -i <EC2-IP>, playbook.yml \
     -u ubuntu \
     --private-key <path-to-ssh-key> \
     -e "github_username=<your-github-username> github_token=<your-github-pat>"
   ```

## Infrastructure Components

### Docker
- Multi-stage build process
- Node.js build environment
- Nginx production server
- Optimized for production use

### GitHub Actions
- Automated builds on push/PR to main
- Container registry integration
- Automated tagging and versioning

### Terraform Resources
- VPC with public subnet
- Security group for web traffic
- EC2 instance (t2.micro)
- Necessary networking components

### Ansible Configuration
- Docker installation and setup
- Container registry authentication
- Application deployment
- Auto-restart configuration

## Security Notes
- The security group allows inbound traffic on ports 80 (HTTP) and 22 (SSH)
- Consider restricting SSH access to specific IP ranges
- Use environment variables for sensitive information
- Regularly update dependencies and AMI

## Troubleshooting
1. If the container fails to start:
   - Check Docker logs: `docker logs angular-app`
   - Verify port availability: `netstat -tuln`

2. If Terraform fails:
   - Verify AWS credentials
   - Check VPC limits in the region
   - Ensure unique resource names

3. If Ansible deployment fails:
   - Verify SSH key permissions
   - Check instance security group
   - Confirm GitHub token permissions
