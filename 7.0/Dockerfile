FROM php:7.0-apache

# PHP extension etc.
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    default-libmysqlclient-dev \
    libbz2-dev \
    libmemcached-dev \
    libsasl2-dev \
    curl \
    libfreetype6-dev \
    libicu-dev \
    libjpeg-dev \
    libldap2-dev \
    libmcrypt-dev \
    libmemcachedutil2 \
    libpng-dev \
    libpq-dev \
    libxml2-dev \
 && docker-php-ext-configure gd --with-jpeg-dir=/usr --with-png-dir=/usr \
 && docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ \
 && docker-php-ext-configure pdo_mysql --with-pdo-mysql=mysqlnd \
 && docker-php-ext-install \
    bcmath \
    bz2 \
    calendar \
    exif \
    gd \
    iconv \
    intl \
    ldap \
    mbstring \
    mcrypt \
    mysqli \
    opcache \
    pdo_mysql \
    pdo_pgsql \
    pgsql \
    soap \
    zip \
 && docker-php-ext-enable mysqli \
 && apt-get purge --auto-remove -y \
 && rm -rf /var/lib/apt/lists/*

COPY conf/default.conf /etc/apache2/sites-enabled/000-default.conf

COPY conf/php.ini conf/overwrite-php.ini.sh /usr/local/etc/php/

# Apache Configuration
RUN a2enmod rewrite expires ssl

# Install xdebug
RUN pecl install xdebug-2.6.1

ENV ERROR_LOG='0' \
    REMOTE_DEBUG='0'

CMD sh -c "sh /usr/local/etc/php/overwrite-php.ini.sh && apache2-foreground"
