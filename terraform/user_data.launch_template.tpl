#!/bin/bash
yum install -y docker 

systemctl enable docker
systemctl start docker

docker pull ${ecr_url}

aws ecr get-login-password --region us-east-1 \
| docker login \
--username AWS \
--password-stdin ${ecr_url}

docker run -d \
  -e DB_HOST=${db_host} \
  -e DB_NAME="ecommerce" \
  -e DB_USER="admin" \
  -e DB_PASSWORD="admin1234" \
  -p 80:80 \
  ${ecr_url}