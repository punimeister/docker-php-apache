FROM php:5.6-apache

# PHP extension etc.
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    libicu-dev \
    libjpeg-dev \
    libpng-dev \
 && rm -rf /var/lib/apt/lists/* \
 && docker-php-ext-configure gd --with-jpeg-dir=/usr --with-png-dir=/usr \
 && docker-php-ext-configure pdo_mysql --with-pdo-mysql=mysqlnd \
 && docker-php-ext-install \
    intl \
    gd \
    mysqli \
    opcache \
    pdo_mysql \
    zip \
 && docker-php-ext-enable mysqli \
 && apt-get purge --auto-remove -y

COPY default.conf /etc/apache2/sites-enabled/000-default.conf

COPY php.ini overwrite-php.ini.sh /usr/local/etc/php/

# Apache Configuration
RUN a2enmod rewrite expires ssl

ENV ERROR_LOG='0'

CMD sh -c "sh /usr/local/etc/php/overwrite-php.ini.sh && apache2-foreground"
