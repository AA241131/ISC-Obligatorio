#!/bin/bash

# Archivo de configuración para el contenedor Docker del e-commerce

docker run -d \
  --name ecommerce \
  -p 80:80 \
  -e DB_HOST="${db_host}" \
  -e DB_NAME="ecommerce" \
  -e DB_USER="admin" \
  -e DB_PASSWORD="supersecret" \
  ecommerce:latest