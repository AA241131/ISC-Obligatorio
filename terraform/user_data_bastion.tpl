#!/bin/bash

yum install -y docker 

systemctl enable docker
systemctl start docker
sudo usermod -a -G docker ec2-user

sudo dnf install -y git

git clone https://github.com/AA241131/ISC-Obligatorio /home/ec2-user/repo/ISC-Obligatorio
cd /home/ec2-user/repo/ISC-Obligatorio/e-commerce

docker build -t php-apache:ver1 .

#Lo siguiente depende de la creacion del ECR

aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${ecr_url}

docker tag php-apache:ver1  ${ecr_url}

docker push "${ecr_url}"

sudo dnf install mariadb105 -y

mysql \
  -h "${db_host}" \
  -u "${db_user}" \
  -p"${db_password}" \
  "${db_name}" < /home/ec2-user/repo/ISC-Obligatorio/e-commerce/db-settings.sql
