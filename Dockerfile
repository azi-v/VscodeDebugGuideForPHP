FROM php:7.4-fpm
RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd
RUN apt-get -y update \
    && apt-get install -y libicu-dev \ 
    && docker-php-ext-configure intl \
    && docker-php-ext-install intl
RUN pecl channel-update pecl.php.net
RUN pecl install xdebug-2.8.1 \
    && docker-php-ext-enable xdebug

RUN echo "xdebug.remote_enable=1\n\
xdebug.remote_autostart=1\n\
xdebug.remote_connect_back=0\n\
xdebug.remote_port=9001\n\
xdebug.remote_host=docker.for.mac.localhost\n\
xdebug.remote_handler=dbgp" >> /usr/local/etc/php/conf.d/xdebug.ini \
&& sed -i 's/request_terminate_timeout/;request_terminate_timeout/' /usr/local/etc/php-fpm.d/www.conf


WORKDIR /www

COPY . /www

CMD ["php-fpm","--allow-to-run-as-root"]