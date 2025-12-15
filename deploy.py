import boto3
import os
from dotenv import load_dotenv

load_dotenv()

apprunner = boto3.client('apprunner', region_name='us-east-1')
account_id = boto3.client('sts').get_caller_identity()['Account']

# 1. Crear auto-scaling
autoscaling_response = apprunner.create_auto_scaling_configuration(
    AutoScalingConfigurationName='custom-1-1-10',
    MaxConcurrency=10,
    MinSize=1,
    MaxSize=1
)

autoscaling_arn = autoscaling_response['AutoScalingConfiguration']['AutoScalingConfigurationArn']

# 2. Crear servicio
service_response = apprunner.create_service(
    ServiceName='consultation-app-service',
    SourceConfiguration={
        'ImageRepository': {
            'ImageIdentifier': f'{account_id}.dkr.ecr.us-east-1.amazonaws.com/consultation-app:latest',
            'ImageRepositoryType': 'ECR',
            'ImageConfiguration': {
                'Port': '8000',
                'RuntimeEnvironmentVariables': {
                    'CLERK_SECRET_KEY': os.getenv('CLERK_SECRET_KEY'),
                    'CLERK_JWKS_URL': os.getenv('CLERK_JWKS_URL'),
                    'OPENAI_API_KEY': os.getenv('OPENAI_API_KEY')
                }
            }
        },
        'AutoDeploymentsEnabled': False
    },
    InstanceConfiguration={
        'Cpu': '256',
        'Memory': '512'
    },
    HealthCheckConfiguration={
        'Protocol': 'HTTP',
        'Path': '/health',
        'Interval': 20,
        'Timeout': 5,
        'HealthyThreshold': 2,
        'UnhealthyThreshold': 5
    },
    AutoScalingConfigurationArn=autoscaling_arn
)

print(f"Service URL: {service_response['Service']['ServiceUrl']}")