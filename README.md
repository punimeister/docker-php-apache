# Supported tags and respective `Dockerfile` links

- [`7.3`, `latest` (7.3/Dockerfile)](https://github.com/punimeister/docker-php-apache/blob/7.3/Dockerfile)
- [`7.2` (7.2/Dockerfile)](https://github.com/punimeister/docker-php-apache/blob/7.2/Dockerfile)
- [`7.0` (7.0/Dockerfile)](https://github.com/punimeister/docker-php-apache/blob/7.0/Dockerfile)
- [`5.6` (5.6/Dockerfile)](https://github.com/punimeister/docker-php-apache/blob/5.6/Dockerfile)

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
    image: 'punimeister/php-apache:latest'
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
