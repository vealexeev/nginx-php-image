FROM php:7.1-fpm

WORKDIR /var/www

RUN apt-get update && apt-get install --no-install-recommends -y \
        libfreetype6-dev libjpeg62-turbo-dev libpng12-dev \
        libcurl4-gnutls-dev \
		supervisor sendmail nginx \
		git unzip \
	&& rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install curl pdo_mysql mbstring gd \
    && sed -i 's/\[\:\:\]\:9000/\/var\/run\/php7-fpm.sock/g' /usr/local/etc/php-fpm.conf \
    && php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
	&& php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
	&& php -r "unlink('composer-setup.php');" \
	&& ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log

EXPOSE 80

ADD supervisord.conf /etc/supervisor/supervisord.conf
ADD nginx.conf /etc/nginx/nginx.conf
ADD nginx-vhost.conf /etc/nginx/sites-available/default
ADD php-extra.ini /usr/local/etc/php/conf.d/extra.ini
ADD fpm-extra.conf /usr/local/etc/php-fpm.d/zzz-extra.conf

CMD ["supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf"]
