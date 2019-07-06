# Please use only during development

# Supported tags and respective `Dockerfile` links

- [`7.3`, `latest` (7.3/Dockerfile)](https://github.com/punimeister/docker-php-apache/blob/master/7.3/Dockerfile)
- [`7.2` (7.2/Dockerfile)](https://github.com/punimeister/docker-php-apache/blob/master/7.2/Dockerfile)
- [`7.1` (7.1/Dockerfile)](https://github.com/punimeister/docker-php-apache/blob/master/7.1/Dockerfile)
- [`5.6` (5.6/Dockerfile)](https://github.com/punimeister/docker-php-apache/blob/master/5.6/Dockerfile)

## Environment Variables

### `REMOTE_DEBUG`

When set to 1 enable to remote debug (Xdebug)

## Configuration files (in docker container)

- Apache HTTP config ... `/etc/apache2/sites-enabled/000-default.conf`
- Apache HTTPS config ... `/etc/apache2/sites-enabled/000-ssl.conf`
- php.ini ... `/usr/local/etc/php/php.ini`
- xdebug.ini ... `/usr/local/etc/php/conf.d/xdebug.ini`
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
      REMOTE_DEBUG: '0'
    ports:
      - '80:80'
      - '443:443'
    volumes:
      - './certs:/root/.local/share/mkcert'
      - './web:/var/www/html'
```
