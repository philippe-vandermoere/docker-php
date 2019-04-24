# Docker-php

## Description
Build une image docker PHP basée sur alpine contenant:
- La version de php passée en argument
- Les extensions PHP de base:
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
- Les extensions PHP passées en argument:
- composer
- bash (avec auto-complete + alias)
- git
- user: www-data

## Exemples:

php 7.2.17

```
docker build . \
    --build-arg ALPINE_VERSION=3.9.3 \
    --build-arg PHP_VERSION=7.2.17 \
    --build-arg PHP_EXTENSIONS='curl intl gd opcache'
```

php 7.3.4

```
docker build . \
    --build-arg ALPINE_VERSION=3.9.3 \
    --build-arg PHP_VERSION=7.3.4 \
    --build-arg PHP_EXTENSIONS=''
```
