FROM php:8.2-apache

# Habilitar mod_rewrite
RUN a2enmod rewrite

# Permitir uso de .htaccess (AllowOverride All)
RUN sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf

# Dependencias para GD
RUN apt-get update && apt-get install -y \
    zlib1g-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libfreetype6-dev

# GD para cargar imagenes de productos
RUN docker-php-ext-configure gd --with-jpeg --with-freetype
RUN docker-php-ext-install gd pdo pdo_mysql

# Copiar código de la app
COPY . /var/www/html/

# Renombrar archivo htaccess (sin punto) a .htaccess dentro del contenedor
# (ajustá "htaccess" si en tu repo tiene otro nombre)
RUN if [ -f /var/www/html/htaccess ]; then mv /var/www/html/htaccess /var/www/html/.htaccess; fi

# Permisos recomendados
RUN chown -R www-data:www-data /var/www/html

EXPOSE 80
