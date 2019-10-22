FROM centos:centos7

# Install Apache and PHP.
RUN commonDeps=" \
      curl \
      git \
      unzip \
      vim \
      wget \
      zip \
    " \
    apacheDeps=" \
      httpd \
      mod_ssl \
    " \
    phpDeps=" \
      php \
      php-bcmath \
      php-gd \
      php-mbstring \
      php-mcrypt \
      php-mysqlnd \
      php-opcache \
      php-process \
      php-soap \
      php-xml \
      php-zip \
      php-pecl-xdebug \
    " \
 && yum update -y \
 && yum install -y $commonDeps \
 && yum install -y $apacheDeps \
 && yum install -y epel-release \
 && rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm \
 && yum --enablerepo=remi-php73 install -y $phpDeps \
 && yum clean all

# Install Composer.
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
 && ln -s $(composer config --global home) /root/composer
ENV PATH=$PATH:/root/composer/vendor/bin COMPOSER_ALLOW_SUPERUSER=1

# Install mkcert.
WORKDIR /usr/local/bin
RUN wget -O mkcert https://github.com/FiloSottile/mkcert/releases/download/v1.4.0/mkcert-v1.4.0-linux-amd64 \
 && chmod +x mkcert \
 && mkdir -m 755 /certs

# Copy config files.
COPY httpd.conf /etc/httpd/conf/
COPY ssl.conf security.conf welcome.conf /etc/httpd/conf.d/
COPY php.ini /etc/

# Declare default environment variables.
ENV APACHE_ACCESS_FILE '.htaccess.docker .htaccess'
ENV APACHE_LOG_DIR '/etc/httpd'
ENV APACHE_SERVER_NAME 'app.local'
ENV APP_HOME_DIR '/var/www/html'
ENV PUBLIC_DIR '/public'
ENV REMOTE_DEBUG 0

WORKDIR /

# 1. Rewrite Xdebug config in php.ini if necesarry.
# 2. Make locally trusted development certificates.
# 3. Start Apache.
CMD sh -c " \
      if [ "${REMOTE_DEBUG}" = "1" ]; then \
        sed -i 's/\;xdebug\.remote/xdebug\.remote/' /etc/php.ini; \
      fi \
      && mkcert -install \
      && mkcert -cert-file /certs/docker.pem -key-file /certs/docker-key.pem \
         '*.${APACHE_SERVER_NAME}' \
         ${APACHE_SERVER_NAME} \
         localhost \
         127.0.0.1 \
         192.168.99.100 \
      && /usr/sbin/httpd -DFOREGROUND \
    "
