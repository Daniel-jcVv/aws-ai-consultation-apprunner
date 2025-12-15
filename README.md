# AI Consultation App on AWS App Runner

AI-powered medical consultation SaaS that generates visit summaries and patient-friendly emails.  
Frontend built with Next.js, backend with FastAPI, deployed as a container to AWS App Runner using ECR and Terraform, with authentication via Clerk and OpenAI for text generation.

## Architecture

- **Frontend**: Next.js (Pages Router, TypeScript)
- **Backend**: FastAPI (Python)
- **Authentication**: Clerk
- **AI**: OpenAI Chat Completions
- **Infrastructure**: AWS App Runner + Amazon ECR
- **Infrastructure as Code**: Terraform
- **Containerization**: Docker

## Features

- **AI-generated visit summaries** for doctors
- **Patient-friendly email drafts** based on visit notes
- **Secure authentication** with Clerk
- **Single container deployment** serving static Next.js and FastAPI
- **Production-ready infra** on AWS App Runner with autoscaling

## Project Structure

```
saas/
├── api/                    # FastAPI backend (server.py)
├── pages/                  # Next.js pages (including product page)
├── public/                 # Static assets
├── styles/                 # Global styles
├── terraform/              # Terraform configuration for App Runner
│   ├── main.tf
│   ├── variables.tf
│   └── terraform.tfvars.example
├── Dockerfile              # Multi-stage build (Next.js + FastAPI)
├── deploy.py               # Legacy boto3 deploy script (optional)
├── requirements.txt        # Python dependencies
├── package.json            # Node.js dependencies
├── setup.sh                # Local setup script (venv + deps)
├── .env.example            # Environment variables template
└── .gitignore## Local Development
```

### Prerequisites

- Node.js 18+  
- Python 3.11+  
- Docker (optional but recommended)  

### 1. Setup environment

# Clone the repo
git clone https://github.com/your-username/your-repo-name.git
cd your-repo-name

# Run initial setup (creates venv and installs Python deps)
./setup.sh

# Activate virtual environment
source venv/bin/activate

# Install Node dependencies
npm install

# Copy env template and fill in your values
cp .env.example .envSet at least:

- `CLERK_SECRET_KEY`
- `CLERK_JWKS_URL`
- `NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY`
- `OPENAI_API_KEY`
- `AWS_REGION` (optional for local)

### 2. Run frontend and backend locally

# Terminal 1: frontend (Next.js)
npm run dev

# Terminal 2: backend (FastAPI)
source venv/bin/activate
uvicorn api.server:app --reload --host 0.0.0.0 --port 8000- Frontend: `http://localhost:3000`
- Backend health check: `http://localhost:8000/health`

## Docker Image

The app is packaged as a single container that serves:

- Next.js static export from `out/`
- FastAPI API from `api/server.py`

Build and test locally:

docker build --platform linux/amd64 -t consultation-app:latest .
docker run -p 8000:8000 consultation-app:latestThen visit `http://localhost:8000`.

## AWS Deployment

This project uses:

- **Amazon ECR** to store the Docker image
- **AWS App Runner** to run the container
- **Terraform** to define and create the infrastructure

### 1. Push image to ECR

Create an ECR repository named `consultation-app` and push the image:

# Login to ECR
aws ecr get-login-password --region us-east-1 | \
  docker login --username AWS --password-stdin 319029038975.dkr.ecr.us-east-1.amazonaws.com

# Tag and push
docker tag consultation-app:latest 319029038975.dkr.ecr.us-east-1.amazonaws.com/consultation-app:latest
docker push 319029038975.dkr.ecr.us-east-1.amazonaws.com/consultation-app:latest(Replace account ID and region with your own.)

### 2. Configure Terraform

cd terraform
cp terraform.tfvars.example terraform.tfvarsEdit `terraform.tfvars`:

- `project_name`
- `environment`
- `owner`
- `ecr_repository_name` (must match your ECR repo)
- Optionally override CPU, memory, autoscaling

Add sensitive values either as:

- Terraform variables in `terraform.tfvars`:
cl
clerk_secret_key = "sk_live_..."
clerk_jwks_url   = "https://..."
openai_api_key   = "sk-..."or as environment variables:

export TF_VAR_clerk_secret_key="sk_live_..."
export TF_VAR_clerk_jwks_url="https://..."
export TF_VAR_openai_api_key="sk-..."### 3. Create or reference IAM role for App Runner

An IAM role such as:

- `consultation-app-apprunner-ecr-role-dev`

is created by the root account and attached with:

- `AWSAppRunnerServicePolicyForECRAccess`

Terraform then uses this role ARN directly in `main.tf`.

### 4. Apply Terraform

terraform init
terraform plan
terraform applyTerraform will:

- Use the existing autoscaling configuration
- Create the App Runner service pointing at your ECR image
- Wire environment variables and health check

Get the service URL:

terraform output service_url## Security and Secrets

- **Do not commit** `.env` or real `terraform.tfvars`
- API keys (Clerk, OpenAI) should be stored in:
  - Local `.env` for development
  - Terraform variables or AWS Secrets Manager for production

## What This Project Demonstrates

- **Full-stack AI SaaS** on AWS (Next.js + FastAPI)
- **Infrastructure as Code** with Terraform
- **Secure IAM separation** between root and IAM user
- **Production-style deployment** on AWS App Runner with autoscaling

## License

This project is part of a personal portfolio. Use it as a reference or starting point for your own AI SaaS deployments.