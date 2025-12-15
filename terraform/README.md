# Terraform - Infrastructure as Code

Este directorio contiene la configuración de Terraform para desplegar la infraestructura en AWS de forma automatizada y profesional.

## 🎯 ¿Por qué Terraform?

**Terraform es la mejor opción para tu portfolio porque:**

1. ✅ **Infrastructure as Code (IaC)** - Tu infraestructura está versionada
2. ✅ **Reproducible** - Puedes crear/destruir entornos con un comando
3. ✅ **Profesional** - Es el estándar de la industria
4. ✅ **Escalable** - Fácil agregar más recursos (RDS, S3, etc.)
5. ✅ **Multi-entorno** - Dev, staging, prod con la misma configuración

## 📋 Prerequisitos

1. **Terraform instalado** (ver instrucciones abajo)
2. **AWS CLI configurado**: `aws configure`
3. **Permisos AWS**: Necesitas permisos para crear recursos de App Runner

## 🚀 Instalación de Terraform

### Ubuntu/Debian:

```bash
# Agregar clave GPG de HashiCorp
wget -O- https://apt.releases.hashicorp.com/gpg | \
  sudo gpg --dearmor | \
  sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg

# Agregar repositorio
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
  https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
  sudo tee /etc/apt/sources.list.d/hashicorp.list

# Instalar
sudo apt update && sudo apt install terraform
```

### Verificar instalación:

```bash
terraform version
```

## 📁 Estructura de Archivos

```
terraform/
├── main.tf              # Recursos principales (App Runner, Auto Scaling)
├── variables.tf         # Definición de variables
├── terraform.tfvars.example  # Ejemplo de valores
└── README.md           # Esta guía
```

## 🔧 Configuración Inicial

### 1. Copiar archivo de variables:

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
```

### 2. Editar `terraform.tfvars`:

Abre `terraform.tfvars` y completa con tus valores. **NUNCA commitees este archivo** (ya está en .gitignore).

### 3. Configurar variables sensibles:

Tienes dos opciones:

**Opción A: Variables de entorno (recomendado para desarrollo)**
```bash
export TF_VAR_clerk_secret_key="sk_live_..."
export TF_VAR_clerk_jwks_url="https://..."
export TF_VAR_openai_api_key="sk-..."
```

**Opción B: En terraform.tfvars (menos seguro)**
```hcl
clerk_secret_key = "sk_live_..."
clerk_jwks_url   = "https://..."
openai_api_key   = "sk-..."
```

## 🚀 Uso Básico

### Inicializar Terraform:

```bash
cd terraform
terraform init
```

### Ver qué va a crear (sin aplicar cambios):

```bash
terraform plan
```

### Crear la infraestructura:

```bash
terraform apply
```

Terraform te mostrará un plan y pedirá confirmación. Escribe `yes` para continuar.

### Ver outputs (URLs, ARNs):

```bash
terraform output
```

### Destruir todo (cuando ya no lo necesites):

```bash
terraform destroy
```

## 🌍 Múltiples Entornos

Para crear diferentes entornos (dev, staging, prod):

### Opción 1: Workspaces (recomendado)

```bash
# Crear workspace para dev
terraform workspace new dev
terraform workspace select dev

# Crear workspace para prod
terraform workspace new prod
terraform workspace select prod
```

Luego usa variables diferentes según el workspace.

### Opción 2: Directorios separados

```
terraform/
├── dev/
│   ├── main.tf
│   └── terraform.tfvars
└── prod/
    ├── main.tf
    └── terraform.tfvars
```

## 🔒 Seguridad

1. **NUNCA commitees**:
   - `terraform.tfvars` (con valores reales)
   - `.terraform/` (directorio de plugins)
   - `*.tfstate` (estado de Terraform)
   - Credenciales AWS

2. **Usa variables de entorno** para secretos:
   ```bash
   export TF_VAR_clerk_secret_key="..."
   ```

3. **Backend remoto** (para producción):
   Configura un backend S3 en `main.tf` para guardar el estado de forma segura.

## 📚 Recursos Adicionales

- [Documentación de Terraform](https://www.terraform.io/docs)
- [AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest)
- [App Runner Resource](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apprunner_service)

## 🆘 Troubleshooting

### Error: "No valid credential sources found"
```bash
aws configure
```

### Error: "Insufficient permissions"
Verifica que tu usuario AWS tenga permisos para App Runner.

### Error: "Resource already exists"
Alguien ya creó el recurso manualmente. Importa el recurso o destrúyelo primero.

