#!/bin/bash
yum install -y docker 

docker pull ${ecr_image}

docker run -d \
  -e DB_HOST=${db_host} \
  -e DB_NAME="ecommerce"
  -e DB_USER="admin"
  -e DB_PASSWORD="admin1234"
  -p 80:80 \
  ${ecr_image}