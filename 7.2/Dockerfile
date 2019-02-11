FROM php:7.2-apache

# Install PHP extensions and PECL modules.
RUN buildDeps=" \
      default-libmysqlclient-dev \
      libbz2-dev \
      libmemcached-dev \
      libsasl2-dev \
    " \
    runtimeDeps=" \
      curl \
      git \
      libfreetype6-dev \
      libicu-dev \
      libjpeg-dev \
      libldap2-dev \
      libmemcachedutil2 \
      libnss3-tools \
      libpng-dev \
      libpq-dev \
      libxml2-dev \
      wget \
    " \
 && apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y $buildDeps $runtimeDeps \
 && docker-php-ext-install bcmath bz2 calendar iconv intl mbstring mysqli opcache pdo_mysql pdo_pgsql pgsql soap zip \
 && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
 && docker-php-ext-install gd \
 && docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ \
 && docker-php-ext-install ldap \
 && docker-php-ext-install exif \
 && pecl install memcached redis \
 && docker-php-ext-enable memcached.so redis.so \
 && apt-get purge -y --auto-remove $buildDeps \
 && rm -r /var/lib/apt/lists/* \
 && a2enmod rewrite expires ssl

# Install mkcert.
WORKDIR /usr/local/bin
RUN wget -O mkcert https://github.com/FiloSottile/mkcert/releases/download/v1.3.0/mkcert-v1.3.0-linux-amd64 \
 && chmod +x mkcert

# Install Composer.
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
 && ln -s $(composer config --global home) /root/composer
ENV PATH=$PATH:/root/composer/vendor/bin COMPOSER_ALLOW_SUPERUSER=1

# Install xdebug.
RUN pecl install xdebug-2.6.1

# Copy config files.
COPY default.conf /etc/apache2/sites-enabled/000-default.conf
COPY ssl.conf /etc/apache2/sites-enabled/000-ssl.conf
COPY php.ini /usr/local/etc/php/
COPY xdebug.ini /usr/local/etc/php/conf.d/

# Initial settings.
ENV REMOTE_DEBUG='0'
RUN mkdir -m 755 /certs
WORKDIR /var/www/html

# 1. Rewrite xdebug.ini if needed.
# 2. Make locally trusted development certificates.
# 3. Starting Apache.
CMD sh -c " \
      if [ "${REMOTE_DEBUG}" = "1" ]; then \
        sed -i s/\;xdebug\.remote/xdebug\.remote/ /usr/local/etc/php/conf.d/xdebug.ini; \
      fi \
      && mkcert -install \
      && mkcert -cert-file /certs/docker.pem -key-file /certs/docker-key.pem \
         '*.app.local' \
         app.local \
         localhost \
         127.0.0.1 \
         192.168.99.100 \
      && apache2-foreground \
    "