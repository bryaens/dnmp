FROM debian:12

RUN apt update -y \
    && apt install -y init locales git wget curl vim cron sudo gnupg2 tzdata php-fpm php-bcmath php-curl php-gd php-mbstring php-redis php-sqlite3 php-xml php-zip php-yaml php-mysql \
    && wget https://getcomposer.org/download/latest-stable/composer.phar -O /usr/local/bin/composer && chmod +x /usr/local/bin/composer \
    && sed -i "s/^#\?listen =.*/listen = 0.0.0.0:9000/g" /etc/php/8.2/fpm/pool.d/www.conf \
    && sed -i "s/^#\?upload_max_filesize =.*/upload_max_filesize = 1024M/g" /etc/php/8.2/cli/php.ini \
    && sed -i "s/^#\?post_max_size =.*/post_max_size = 1024M/g" /etc/php/8.2/cli/php.ini \
    && localedef -i zh_CN -c -f UTF-8 -A /usr/share/locale/locale.alias zh_CN.UTF-8 \
    && ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && dpkg-reconfigure -f noninteractive tzdata \
    && apt clean all && rm -rf /var/lib/apt/lists/*

ENV LANG zh_CN.UTF-8

CMD ["/sbin/init"]
