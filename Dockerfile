# Use image which contains apache with php
FROM php:7.4.27-apache
RUN apt-get update && apt-get upgrade -y
# Install packages needed to install php extensions
RUN apt-get install git zlib1g-dev libxml2-dev libzip-dev zip unzip -y
# Install PHP extensions
RUN docker-php-ext-install zip intl mysqli pdo pdo_mysql opcache
# Install composer command
RUN curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer

ADD src/ /var/www/html/src/
RUN chown $USER:www-data -R /var/www/html/src/
RUN chmod u=rwX,g=srX,o=rX -R /var/www/html/src/
RUN find /var/www/html/src/ -type d -exec chmod g=rwxs "{}" \;
RUN find /var/www/html/src/ -type f -exec chmod g=rws "{}" \;

EXPOSE 80

ENTRYPOINT ["apache2ctl", "-D", "FOREGROUND"]