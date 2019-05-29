# Docker-php 

[![CircleCI](https://circleci.com/gh/philippe-vandermoere/docker-php/tree/master.svg?style=svg)](https://circleci.com/gh/philippe-vandermoere/docker-php/tree/master)

Build a alpine php docker image with: 
- php
- The default php extensions:
    - ctype
    - curl
    - date
    - dom
    - fileinfo
    - filter
    - ftp
    - hash
    - iconv
    - json
    - libxml
    - mbstring
    - mysqlnd
    - openssl
    - pcre
    - PDO
    - pdo_sqlite
    - Phar
    - posix
    - readline
    - Reflection
    - session
    - SimpleXML
    - sockets
    - SPL
    - sqlite3
    - standard
    - tokenizer
    - xml
    - xmlreader
    - xmlwriter
    - zlib
- composer
- bash
- git
- user: www-data

## Usage

php 7.3.5 with xdebug, gd

```
./bin/docker-php --version 7.3.5 --extensions 'gd xdebug' -t php_custom:7.3.5-dev
```

php 7.3.5 with gd

```
./bin/docker-php --version 7.3.5 --extensions gd -t php_custom:7.3.5
```

php 7.2.17

```
./bin/docker-php --version 7.2.17 -t php_custom:7.2.17
```
