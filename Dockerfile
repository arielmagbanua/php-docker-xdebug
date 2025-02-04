# Use the official PHP image from Docker Hub
FROM php:8.4-apache

# Install required PHP extensions and dependencies
RUN apt-get update && apt-get install -y unzip git libpng-dev libjpeg-dev libfreetype6-dev \
    && docker-php-ext-install pdo pdo_mysql gd

# Install Xdebug
RUN pecl install xdebug \
    && docker-php-ext-enable xdebug

# Copy xdebug.ini configuration file to PHP's conf.d directory
COPY xdebug.ini /usr/local/etc/php/conf.d/

# Install Composer globally
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

COPY composer.lock composer.json /var/www/html/

# Set the working directory
WORKDIR /var/www/html/

# Install dependencies
RUN composer install --no-scripts --no-autoloader

# Copy the application files to the container
COPY . /var/www/html

# Set correct permissions
RUN chown -R www-data:www-data /var/www/html && chmod -R 755 /var/www/html

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Expose port 80
EXPOSE 80

# Start Apache in the foreground
CMD ["apache2-foreground"]
