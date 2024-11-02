# Dockerfile for LimeSurvey

# Use the official PHP image as a base
FROM php:8.1-apache

# Install dependencies
RUN apt-get update && \
    apt-get install -y software-properties-common && \
    apt-get update && \
    apt-get install -y \
        unzip \
        wget \
        libpng-dev \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libzip-dev \
        zip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd zip pdo pdo_mysql \
    && a2enmod rewrite \
    && rm -rf /var/lib/apt/lists/*

# Copy LimeSurvey source code to Apache directory
COPY . /var/www/html

# Set permissions
RUN chown -R www-data:www-data /var/www/html && \
    chmod -R 755 /var/www/html

# Change Apache to listen on port 8080
RUN sed -i 's/Listen 80/Listen 8080/' /etc/apache2/ports.conf && \
    sed -i 's/:80/:8080/g' /etc/apache2/sites-available/000-default.conf

# Expose port 8080
EXPOSE 8080

# Start Apache
CMD ["apache2-foreground"]
