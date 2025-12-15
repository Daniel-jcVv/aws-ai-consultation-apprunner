# Main Terraform configuration for AWS App Runner
# This file defines Infrastructure as Code (IaC)

terraform {
  required_version = ">= 1.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  
  # Optional: Remote backend for state (recommended for production)
  # backend "s3" {
  #   bucket = "your-bucket-terraform-state"
  #   key    = "saas-app/terraform.tfstate"
  #   region = "us-east-1"
  # }
}

provider "aws" {
  region = var.aws_region
  
  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "terraform"
      Owner       = var.owner
    }
  }
}

# Get current AWS Account ID
data "aws_caller_identity" "current" {}

# Auto Scaling configuration for App Runner
resource "aws_apprunner_auto_scaling_configuration_version" "main" {
  auto_scaling_configuration_name = "${var.project_name}-autoscaling-${var.environment}"
  
  max_concurrency = var.max_concurrency
  min_size        = var.min_size
  max_size        = var.max_size

  tags = {
    Name = "${var.project_name}-autoscaling-${var.environment}"
  }
}

# Use existing IAM role (created by root) instead of creating it

#data "aws_iam_role" "apprunner_ecr_access" {
#  name = "consultation-app-apprunner-ecr-role-dev"
#}

# COMENTADO: El rol se crea manualmente como root, no con Terraform
# resource "aws_iam_role" "apprunner_ecr_access" {
#   name = "${var.project_name}-apprunner-ecr-role-${var.environment}"
#
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [{
#       Action = "sts:AssumeRole"
#       Effect = "Allow"
#       Principal = {
#         Service = "build.apprunner.amazonaws.com"
#       }
#     }]
#   })
#
#   tags = {
#     Name = "${var.project_name}-apprunner-ecr-role-${var.environment}"
#   }
# }
#
# # Attach ECR access policy to the role
# resource "aws_iam_role_policy_attachment" "apprunner_ecr_access" {
#   role       = aws_iam_role.apprunner_ecr_access.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AWSAppRunnerServicePolicyForECRAccess"
# }

# App Runner Service
resource "aws_apprunner_service" "main" {
  service_name = "${var.project_name}-service-${var.environment}"

  source_configuration {
    authentication_configuration {
      access_role_arn = "arn:aws:iam::319029038975:role/consultation-app-apprunner-ecr-role-dev"
    }

    image_repository {
      image_identifier      = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/${var.ecr_repository_name}:${var.image_tag}"
      image_repository_type = "ECR"
      
      image_configuration {
        port = var.app_port
        runtime_environment_variables = {
          CLERK_SECRET_KEY = var.clerk_secret_key
          CLERK_JWKS_URL   = var.clerk_jwks_url
          OPENAI_API_KEY   = var.openai_api_key
        }
      }
    }
    
    auto_deployments_enabled = var.auto_deploy_enabled
  }

  instance_configuration {
    cpu    = var.cpu_units
    memory = var.memory_units
  }

  health_check_configuration {
    protocol            = "HTTP"
    path                = var.health_check_path
    interval            = var.health_check_interval
    timeout             = var.health_check_timeout
    healthy_threshold   = var.health_check_healthy_threshold
    unhealthy_threshold = var.health_check_unhealthy_threshold
  }

  auto_scaling_configuration_arn = aws_apprunner_auto_scaling_configuration_version.main.arn

  tags = {
    Name = "${var.project_name}-service-${var.environment}"
  }
}

# Outputs - Important URLs and ARNs
output "service_url" {
  description = "App Runner service URL"
  value       = aws_apprunner_service.main.service_url
}

output "service_arn" {
  description = "App Runner service ARN"
  value       = aws_apprunner_service.main.arn
}

output "autoscaling_arn" {
  description = "Auto-scaling configuration ARN"
  value       = aws_apprunner_auto_scaling_configuration_version.main.arn
}