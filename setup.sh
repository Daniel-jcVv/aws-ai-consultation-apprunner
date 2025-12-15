#!/bin/bash
# Script de configuración inicial del proyecto
# Este script configura el entorno virtual y las dependencias

set -e  # Detener si hay errores

echo "🚀 Configurando proyecto SaaS..."

# Colores para output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 1. Crear entorno virtual si no existe
if [ ! -d "venv" ]; then
    echo -e "${BLUE}📦 Creando entorno virtual (venv)...${NC}"
    python3 -m venv venv
    echo -e "${GREEN}✅ Entorno virtual creado${NC}"
else
    echo -e "${YELLOW}⚠️  El entorno virtual ya existe${NC}"
fi

# 2. Activar entorno virtual
echo -e "${BLUE}🔌 Activando entorno virtual...${NC}"
source venv/bin/activate

# 3. Actualizar pip
echo -e "${BLUE}⬆️  Actualizando pip...${NC}"
pip install --upgrade pip

# 4. Instalar dependencias de Python
echo -e "${BLUE}📥 Instalando dependencias de Python...${NC}"
pip install -r requirements.txt

# 5. Verificar instalación
echo -e "${BLUE}🔍 Verificando instalación...${NC}"
python -c "import boto3; import dotenv; print('✅ boto3 y dotenv instalados correctamente')"

echo ""
echo -e "${GREEN}✨ ¡Configuración completada!${NC}"
echo ""
echo -e "${YELLOW}📝 Próximos pasos:${NC}"
echo "1. Activa el entorno virtual: source venv/bin/activate"
echo "2. Crea un archivo .env con tus variables de entorno"
echo "3. Configura AWS CLI: aws configure"
echo ""
echo -e "${BLUE}💡 Para usar el proyecto:${NC}"
echo "   source venv/bin/activate  # Activar venv"
echo "   python deploy.py          # Ejecutar script de deploy (si usas boto3)"
echo "   terraform init             # Inicializar Terraform (recomendado)"
echo ""

