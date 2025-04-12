#!/bin/bash

REGION="${REGION}"
SECRET_NAME="${SECRET_NAME}"

echo "Getting DB password from Secrets Manager..."
SECRET_JSON=$(aws secretsmanager get-secret-value \
  --region $REGION \
  --secret-id $SECRET_NAME \
  --query SecretString \
  --output text)

DB_PASSWORD=$(echo $SECRET_JSON | jq -r .password)

echo "Setting up environment variables..."
echo "DB_NAME=${DB_NAME}" | sudo tee -a /etc/environment
echo "DB_USERNAME=${DB_USERNAME}" | sudo tee -a /etc/environment
echo "DB_PASSWORD=$${DB_PASSWORD}" | sudo tee -a /etc/environment
echo "DB_HOST=${DB_HOST}" | sudo tee -a /etc/environment
echo "BUCKET_NAME=${BUCKET_NAME}" | sudo tee -a /etc/environment

echo "Reloading environment variables..."
source /etc/environment

echo "Restarting Spring Boot service..."
sudo systemctl restart springboot.service

sudo mkdir -p /opt/aws/amazon-cloudwatch-agent/bin/

INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)

echo "Creating CloudWatch Agent config..."
cat <<EOC > /opt/aws/amazon-cloudwatch-agent/bin/config.json
{
  "metrics": {
    "metrics_collected": {
      "statsd": {
        "service_address": ":8125"
      }
    },
    "namespace": "MySpringApp2"
  },
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/opt/csye6225/my-app.log",
            "log_group_name": "my-springboot-app-logs",
            "log_stream_name": "$INSTANCE_ID"
          }
        ]
      }
    }
  }
}
EOC

echo "Starting CloudWatch Agent..."
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
  -a fetch-config \
  -m ec2 \
  -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json \
  -s