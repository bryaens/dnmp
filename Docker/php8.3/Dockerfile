FROM debian:11

SHELL ["/bin/bash", "-c"]
RUN apt update -y \
    && apt install -y init locales wget vim cron sudo gnupg2 tzdata ca-certificates apt-transport-https software-properties-common \
    && echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/sury-php.list \
    && wget -qO - https://packages.sury.org/php/apt.gpg | apt-key add - \
    && apt update -y \
    && apt install -y php8.3-{bcmath,curl,dev,fpm,gd,inotify,mbstring,mysql,redis,sqlite3,xml,yaml,zip} \
    && wget -q https://getcomposer.org/download/latest-stable/composer.phar -O /usr/local/bin/composer && chmod +x /usr/local/bin/composer
RUN arch="$(uname -m)" \
    && if [[ "$arch" == "i386" || "$arch" == "i686" ]]; then arch="x86"; \
    elif [[ "$arch" == "armv6l" || "$arch" == "armv7l" ]]; then arch="armv7l"; \
    elif [[ "$arch" == "armv8l" || "$arch" == "aarch64" ]]; then arch="aarch64"; \
    else arch="x86-64"; fi \
    && wget -q https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_"$arch".tar.gz \
    && tar xf ioncube_loaders_lin_"$arch".tar.gz \
    && cp ioncube/ioncube_loader_lin_8.3.so $(php-config --extension-dir)/ioncube.so \
    && echo "zend_extension=$(php-config --extension-dir)/ioncube.so" >> $(php-config --ini-dir)/00-ioncube.ini \
    && sed -i "s/^#\?listen =.*/listen = 0.0.0.0:9000/g" /etc/php/8.3/fpm/pool.d/www.conf \
    && sed -i "s/^#\?upload_max_filesize =.*/upload_max_filesize = 1024M/g" $(php-config --ini-path)/php.ini \
    && sed -i "s/^#\?post_max_size =.*/post_max_size = 1024M/g" $(php-config --ini-path)/php.ini \
    && localedef -i zh_CN -c -f UTF-8 -A /usr/share/locale/locale.alias zh_CN.UTF-8 \
    && ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && dpkg-reconfigure -f noninteractive tzdata \
    && apt remove -y gnupg2 ca-certificates apt-transport-https software-properties-common && apt autoremove -y \
    && apt clean all && rm -rf /var/lib/apt/lists/* /ioncube /ioncube_loaders_lin_"$arch".tar.gz
ENV LANG=zh_CN.UTF-8
WORKDIR /var/www
COPY Docker/php8.3/docker-entrypoint /usr/bin
RUN chmod +x /usr/bin/docker-entrypoint
CMD ["docker-entrypoint"]
