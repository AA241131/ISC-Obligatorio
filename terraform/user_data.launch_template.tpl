#!/bin/bash
dnf install -y amazon-efs-utils
mkdir -p /mnt/uploads
#montar efs
mount -t efs ${efs_id}:/ /mnt/uploads

yum install -y docker 

systemctl enable docker
systemctl start docker

aws ecr get-login-password --region us-east-1 \
  | docker login \
  --username AWS \
  --password-stdin ${ecr_url}

#probar bajar la imagen hasta que se pueda bajar correctamente
until aws ecr describe-images \
    --repository-name ecommerce \
    --image-ids imageTag=ver1 >/dev/null 2>&1
do
    echo "Esperando imagen..."
    sleep 15
done

docker pull ${ecr_url}

SECRET=$(aws secretsmanager get-secret-value \
    --secret-id ${secret_arn} \
    --query SecretString \
    --output text)

DB_USER=$(echo "$SECRET" | jq -r '.username')
DB_PASSWORD=$(echo "$SECRET" | jq -r '.password')

docker run -d \
  -v /mnt/uploads:/var/www/html/uploads \
  -e DB_HOST=${db_host} \
  -e DB_NAME="ecommerce" \
  -e DB_USER="$DB_USER" \
  -e DB_PASSWORD="$DB_PASSWORD" \
  -p 80:80 \
  ${ecr_url}

sudo usermod -aG docker ec2-user