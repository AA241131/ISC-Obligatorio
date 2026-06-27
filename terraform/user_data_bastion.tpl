#!/bin/bash
dnf install -y amazon-efs-utils
mkdir -p /mnt/uploads
#montar efs y dar permisos de escritura
mount -t efs ${efs_id}:/ /mnt/uploads
chmod 777 /mnt/uploads

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

#pusheo de la imagen al ECR
docker push "${ecr_url}"

echo "Imagen subida."

sudo dnf install mariadb105 -y

mysql \
  -h "${db_host}" \
  -u "${db_user}" \
  -p"${db_password}" \
  "${db_name}" < /home/ec2-user/repo/ISC-Obligatorio/e-commerce/db-settings.sql

echo "Base de datos configurada."

#testear que la tabla products este vacía y subir datos de prueba si es así
product_count=$(mysql -h "${db_host}" -u "${db_user}" -p"${db_password}" -D "${db_name}" -se "SELECT COUNT(*) FROM products;")
if [ "$product_count" -eq 0 ]; then
    echo "La tabla products está vacía. Subiendo datos de prueba..."
    mysql -h "${db_host}" -u "${db_user}" -p"${db_password}" "${db_name}" < /home/ec2-user/repo/ISC-Obligatorio/testdata/feed.sql
    cp /home/ec2-user/repo/ISC-Obligatorio/testdata/imagenes/* /mnt/uploads/
    echo "Datos de prueba subidos correctamente."
else
    echo "La tabla products ya contiene datos. No se subirán datos de prueba."
fi  
