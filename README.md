# Please use only during development

# Supported tags and respective `Dockerfile` links

- [`7.3`, `latest` (7.3/Dockerfile)](https://github.com/punimeister/docker-php-apache/blob/master/7.3/Dockerfile)
- [`7.2` (7.2/Dockerfile)](https://github.com/punimeister/docker-php-apache/blob/master/7.2/Dockerfile)
- [`7.1` (7.1/Dockerfile)](https://github.com/punimeister/docker-php-apache/blob/master/7.1/Dockerfile)
- [`5.6` (5.6/Dockerfile)](https://github.com/punimeister/docker-php-apache/blob/master/5.6/Dockerfile)

## Environment Variables

### `APACHE_ACCESS_FILE` (default = '.htaccess.docker .htaccess')

`AccessFileName ${APACHE_ACCESS_FILE}` in default.conf

### `APP_HOME_DIR` (default = '/var/www/html')

`DocumentRoot ${APP_HOME_DIR}${PUBLIC_DIR}` in default.conf

### `PUBLIC_DIR` (default = '/public')

`DocumentRoot ${APP_HOME_DIR}${PUBLIC_DIR}` in default.conf

### `REMOTE_DEBUG` (default = 0)

When set to 1 enable to remote debug (Xdebug)

## Configuration files (in docker container)

- Apache config ... `/etc/httpd/conf.d/default.conf`
- Apache security config ... `/etc/httpd/conf.d/security.conf`
- php.ini ... `/etc/php.ini`
- rootCA.pem ... `/root/.local/share/mkcert/rootCA.pem`
- rootCA-key.pem ... `/root/.local/share/mkcert/rootCA-key.pem`

## Example

### Directory structure

```
.
├── certs
├── docker-compose.yml
└── web
    └── public
        └── index.php
```

### docker-compose.yml

```
version: '3'

services:

  php-apache:
    image: 'punimeister/php-apache:latest'
    restart: 'on-failure'
    environment:
      APACHE_ACCESS_FILE: '.htaccess.docker .htaccess'
      APP_HOME_DIR: '/var/www/html'
      PUBLIC_DIR: '/public'
      REMOTE_DEBUG: '0'
    ports:
      - '80:80'
      - '443:443'
    volumes:
      - './certs:/root/.local/share/mkcert'
      - './web:/var/www/html'
    working_dir: '/var/www/html'
```
