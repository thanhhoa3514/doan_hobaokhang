# Sử dụng PHP 8.1 với Apache
FROM php:8.1-apache

# Cài đặt các extension PHP cần thiết
RUN docker-php-ext-install mysqli pdo pdo_mysql

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Copy toàn bộ source code vào container
COPY . /var/www/html/

# Set quyền cho thư mục
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Expose port 80
EXPOSE 80

# Start Apache
CMD ["apache2-foreground"]
