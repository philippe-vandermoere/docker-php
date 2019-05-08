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

## Installation

```
composer require --dev symfony/dotenv
```

## Usage

php 7.3.4 with xdebug, gd

```
./vendor/bin/docker-php --version 7.3.4 --extensions 'gd xdebug' --alpine-version 3.9.3 -t php_custom:7.3.4-dev
```

php 7.3.4 with gd

```
./vendor/bin/docker-php --version 7.3.4 --extensions gd --alpine-version 3.9.3 -t php_custom:7.3.4
```

php 7.2.17

```
./vendor/bin/docker-php --version 7.2.17 -t php_custom:7.2.17
```
