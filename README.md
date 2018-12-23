# punimeister/php-apache

[![Docker Stars](https://img.shields.io/docker/stars/punimeister/php-apache.svg)](https://hub.docker.com/r/punimeister/php-apache/)
[![Docker Pulls](https://img.shields.io/docker/pulls/punimeister/php-apache.svg)](https://hub.docker.com/r/punimeister/php-apache/)
[![Docker Automated](https://img.shields.io/docker/automated/punimeister/php-apache.svg)](https://hub.docker.com/r/punimeister/php-apache/)
[![Docker Build](https://img.shields.io/docker/build/punimeister/php-apache.svg)](https://hub.docker.com/r/punimeister/php-apache/)

## Source Code

### [php-apache:7.3](https://github.com/punimeister/docker-php-apache/tree/master/7.3)
### [php-apache:7.2](https://github.com/punimeister/docker-php-apache/tree/master/7.2)
### [php-apache:7.0](https://github.com/punimeister/docker-php-apache/tree/master/7.0)
### [php-apache:5.6](https://github.com/punimeister/docker-php-apache/tree/master/5.6)

## Environment Variables

### `ERROR_LOG`

When set to 1 enable to error log

### `REMOTE_DEBUG`

When set to 1 enable to remote debug (xdebug)

## Example

### Directory structure

```
.
├── conf
│   ├── certificate
│   ├── default.conf
│   └── ssl.conf
├── docker-compose.yml
└── web
    └── public
        └── index.php
```

### default.conf

```
<VirtualHost *:80>
  ServerAdmin webmaster@localhost
  DocumentRoot /var/www/html/public

  <Directory "/var/www/html">
    Options -Indexes +FollowSymLinks
    AllowOverride All
    Require all granted
  </Directory>

  ErrorLog ${APACHE_LOG_DIR}/error.log
  CustomLog ${APACHE_LOG_DIR}/access.log combined

  Alias /log/ "/var/log/"
  <Directory "/var/log/">
    Options Indexes MultiViews FollowSymLinks
    AllowOverride None
    Order deny,allow
    Deny from all
    Allow from all
    Require all granted
  </Directory>
</VirtualHost>
```

### ssl.conf

```
<VirtualHost *:443>
  ServerAdmin webmaster@localhost
  DocumentRoot /var/www/html/public

  SSLEngine on
  SSLCertificateFile "/certificate/docker.crt"
  SSLCertificateKeyFile "/certificate/docker.key"

  <Directory "/var/www/html">
    Options -Indexes +FollowSymLinks
    AllowOverride All
    Require all granted
  </Directory>

  ErrorLog ${APACHE_LOG_DIR}/error.log
  CustomLog ${APACHE_LOG_DIR}/access.log combined

  Alias /log/ "/var/log/"
  <Directory "/var/log/">
    Options Indexes MultiViews FollowSymLinks
    AllowOverride None
    Order deny,allow
    Deny from all
    Allow from all
    Require all granted
  </Directory>
</VirtualHost>
```

### docker-compose.yml

```
version: '3'

services:

  php-apache:
    image: 'punimeister/php-apache:7.3'
    restart: 'on-failure'
    environment:
      ERROR_LOG: '0'
      REMOTE_DEBUG: '0'
    ports:
      - '80:80'
      - '443:443'
    volumes:
      - './web:/var/www/html'
      - './conf/default.conf:/etc/apache2/sites-enabled/000-default.conf:ro'
      - './conf/ssl.conf:/etc/apache2/sites-enabled/000-ssl.conf:ro'
      - './conf/certificate:/certificate:ro'
    depends_on:
      - 'create-certificate'

  create-certificate:
    image: 'punimeister/create-certificate'
    environment:
      CERTS: 'docker'
    volumes:
      - './conf/certificate:/app/certificate'
```
