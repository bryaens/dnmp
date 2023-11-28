FROM debian:11

RUN apt update -y \
    && apt install -y init locales git wget curl vim cron sudo gnupg2 tzdata ca-certificates apt-transport-https software-properties-common -y \
    && echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/sury-php.list \
    && wget -qO - https://packages.sury.org/php/apt.gpg | sudo apt-key add - \
    && apt update -y \
    && apt install -y php8.1-fpm php8.1-curl php8.1-gd php8.1-mbstring php8.1-redis php8.1-sqlite3 php8.1-xml php8.1-zip php8.1-yaml php8.1-mysql \
    && wget https://getcomposer.org/download/latest-stable/composer.phar -O /usr/local/bin/composer && chmod +x /usr/local/bin/composer \
    && sed -i "s/^#\?listen =.*/listen = 0.0.0.0:9000/g" /etc/php/8.1/fpm/pool.d/www.conf \
    && sed -i "s/^#\?upload_max_filesize =.*/upload_max_filesize = 1024M/g" /etc/php/8.1/cli/php.ini \
    && sed -i "s/^#\?post_max_size =.*/post_max_size = 1024M/g" /etc/php/8.1/cli/php.ini \
    && localedef -i zh_CN -c -f UTF-8 -A /usr/share/locale/locale.alias zh_CN.UTF-8 \
    && ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && dpkg-reconfigure -f noninteractive tzdata \
    && apt clean all && rm -rf /var/lib/apt/lists/*

ENV LANG zh_CN.UTF-8

CMD ["/sbin/init"]
