# Terraform variables
# All configurable variables  

variable "aws_region" {
  description = "Región de AWS donde se desplegará la infraestructura"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name used for resource naming" # "Nombre del proyecto (usado para naming de recursos)"
  type        = string
  default     = "consultation-app"
}

variable "environment" {
  description = "Ambiente de despliegue (dev, staging, prod)"
  type        = string
  default     = "dev"
  
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "El ambiente debe ser: dev, staging o prod"
  }
}

variable "owner" {
  description = "Owner of the project (email or name)"
  type        = string
  default     = "portfolio"
}

# ECR configuration
variable "ecr_repository_name" {
  description = "ECR repository name"
  type        = string
  default     = "consultation-app"
}

variable "image_tag" {
  description = "Tag de la imagen Docker a desplegar"
  type        = string
  default     = "latest"
}

# Auto Scaling configuration
variable "min_size" {
  description = "Número mínimo de instancias"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Número máximo de instancias"
  type        = number
  default     = 1
}

variable "max_concurrency" {
  description = "Máximo de requests concurrentes por instancia"
  type        = number
  default     = 10
}

# Configuración de recursos
variable "cpu_units" {
  description = "Unidades de CPU (256, 512, 1024, etc.)"
  type        = string
  default     = "256"
}

variable "memory_units" {
  description = "Unidades de memoria en MB (512, 1024, 2048, etc.)"
  type        = string
  default     = "512"
}

variable "app_port" {
  description = "Puerto de la aplicación"
  type        = number
  default     = 8000
}

# Health Check
variable "health_check_path" {
  description = "Ruta del health check endpoint"
  type        = string
  default     = "/health"
}

variable "health_check_interval" {
  description = "Intervalo del health check en segundos"
  type        = number
  default     = 20
}

variable "health_check_timeout" {
  description = "Timeout del health check en segundos"
  type        = number
  default     = 5
}

variable "health_check_healthy_threshold" {
  description = "Número de checks saludables para considerar healthy"
  type        = number
  default     = 2
}

variable "health_check_unhealthy_threshold" {
  description = "Número de checks fallidos para considerar unhealthy"
  type        = number
  default     = 5
}

# Auto Deploy
variable "auto_deploy_enabled" {
  description = "Habilitar auto-deploy cuando hay cambios en ECR"
  type        = bool
  default     = false
}

# Variables sensibles (se pasan via terraform.tfvars o variables de entorno)
variable "clerk_secret_key" {
  description = "Clave secreta de Clerk (autenticación)"
  type        = string
  sensitive   = true
}

variable "clerk_jwks_url" {
  description = "URL del JWKS de Clerk"
  type        = string
  sensitive   = true
}

variable "openai_api_key" {
  description = "API Key de OpenAI"
  type        = string
  sensitive   = true
}

