ARG ALPINE_VERSION
FROM alpine:${ALPINE_VERSION} as php

ARG PHP_VERSION

ENV PHP_VERSION=${PHP_VERSION}
ENV PHP_SRC_DIR=/usr/src/php
ENV PHP_INI_DIR=/usr/local/etc/php
ENV PHP_INI_CONFIG_DIR=${PHP_INI_DIR}/conf.d

# Apply stack smash protection to functions using local buffers and alloca()
# Make PHP's main executable position-independent (improves ASLR security mechanism, and has no performance impact on x86_64)
# Enable optimization (-O2)
# Enable linker optimization (this sorts the hash buckets to improve cache locality, and is non-default)
# Adds GNU HASH segments to generated executables (this is used if present, and is much faster than sysv hash; in this configuration, sysv hash is also generated)
# https://github.com/docker-library/php/issues/272
ENV CFLAGS="-fstack-protector-strong -fpic -fpie -O2"
ENV CPPFLAGS=${CFLAGS}
ENV LDFLAGS="-Wl,-O1 -Wl,--hash-style=both -pie"

COPY scripts/* /usr/local/bin/

# Download php source, compile and install
RUN set -xe; \
    docker-php-download ${PHP_VERSION} ${PHP_SRC_DIR}; \
    mkdir -p ${PHP_INI_DIR}; \
    mkdir -p ${PHP_INI_CONFIG_DIR}; \
    apk add --no-cache --virtual .build-deps \
        autoconf \
        argon2-dev \
        coreutils \
        curl-dev \
        dpkg \
        dpkg-dev \
        file \
        g++ \
        gcc \
        libc-dev \
        libedit-dev \
        libxml2-dev \
        make \
        openssl-dev \
        pkgconf \
        re2c \
    ; \
    cd ${PHP_SRC_DIR}; \
    ./configure \
        --build=$(dpkg-architecture --query DEB_BUILD_GNU_TYPE) \
        --prefix /usr/local \
        --with-config-file-path=${PHP_INI_DIR} \
        --with-config-file-scan-dir="${PHP_INI_CONFIG_DIR}" \
        --enable-option-checking=fatal \
        --with-mhash \
        --enable-ftp \
        --enable-mbstring \
        --enable-mysqlnd \
        --with-password-argon2 \
        --with-curl \
        --with-libedit \
        --with-openssl \
        --enable-sockets \
        --with-zlib \
        --enable-fpm \
        --with-fpm-user=www-data \
        --with-fpm-group=www-data \
        --disable-cgi \
    ; \
    make -j $(nproc); \
    find -type f -name '*.a' -delete; \
    make install; \
    cp /usr/local/etc/php-fpm.conf.default /usr/local/etc/php-fpm.conf; \
    make clean; \
    apk del --no-network .build-deps; \
    apk add --update --no-cache \
        $(scanelf --needed --nobanner --format '%n#p' --recursive /usr/local | tr ',' '\n' | sort -u | awk '{ print "so:" $1 }') \
    ;

ARG PHP_EXTENSIONS
# Install PHP extensions
RUN set -xe; \
    docker-php-extension-install ${PHP_EXTENSIONS}; \
    docker-php-extension-enable ${PHP_EXTENSIONS};

# Install composer
COPY --from=composer /usr/bin/composer /usr/local/bin/composer

FROM alpine:${ALPINE_VERSION}

ARG ALPINE_VERSION
ARG PHP_VERSION

LABEL maintainer="Philippe VANDERMOERE <philippe@wizaplace.com>"

ENV ALPINE_VERSION=${ALPINE_VERSION} \
    PHP_VERSION=${PHP_VERSION} \
    PHP_INI_CONFIG_DIR=/usr/local/etc/php/conf.d \
    PHP_FPM_CONFIG_DIR=/usr/local/etc/php-fpm.d \
    TIMEZONE=UTC \
    PHP_FPM_PORT=9000 \
    PHP_FPM_PM_LOG_LEVEL=notice \
    PHP_FPM_PM_MAX_CHILDREN=5 \
    PHP_FPM_PM_START_SERVER=2 \
    PHP_FPM_PM_MIN_SPARE_SERVER=1 \
    PHP_FPM_PM_MAX_SPARE_SERVER=3 \
    PHP_FPM_PM_STATUS_PATH=/status \
    PHP_FPM_PM_PING_PATH=/ping

# Copy PHP source
COPY --from=php /usr/local /usr/local

# Install dependency library for extension
RUN set -xe; \
    apk add --update --no-cache \
        bash \
        bash-completion \
        ca-certificates \
        curl \
        openssl \
        git \
        $(scanelf --needed --nobanner --format '%n#p' --recursive /usr/local | tr ',' '\n' | sort -u | awk '{ print "so:" $1 }') \
    ;

# ensure www-data user exists
# 82 is the standard uid/gid for "www-data" in Alpine
RUN set -xe; \
    addgroup -g 82 -S www-data; \
    adduser -u 82 -h /var/www -D -S -G www-data www-data; \
    mkdir -p /var/www/html; \
    chown -R www-data:www-data /var/www/html;

# Config php
COPY configs/php/*.ini ${PHP_INI_CONFIG_DIR}/

# Config php-fpm
COPY configs/php-fpm/*.conf ${PHP_FPM_CONFIG_DIR}/

# configure bash
COPY --chown=www-data:www-data configs/.bashrc /var/www/.bashrc 

USER www-data

WORKDIR /var/www/html

CMD ["php-fpm"]

EXPOSE ${PHP_FPM_PORT}
