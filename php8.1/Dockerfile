FROM php:8.1-fpm
RUN apt update \
    # 相关依赖必须手动安装
    && apt install -y wget cron vim libfreetype6-dev libjpeg62-turbo-dev libpng-dev libwebp-dev zlib1g-dev libzip-dev \
    # 创建并初始化 `/usr/src/php`目录
    && docker-php-source extract \
    # 如果安装的扩展需要自定义配置时
    && docker-php-ext-configure gd \
     --enable-gd \
     --with-freetype \
     --with-jpeg \
     --with-webp \
    # 安装扩展
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install pdo_mysql mysqli zip bcmath pcntl \
    && wget https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_$uname_f.tar.gz \
    && tar xvf ioncube_loaders_lin_$uname_f.tar.gz \
    && cp ioncube/ioncube_loader_lin_8.1.so /usr/local/lib/php/extensions/no-debug-non-zts-20210902/ioncube.so \
    && rm -rf ioncube ioncube_loaders_lin_$uname_f.tar.gz \
    && pecl install redis && docker-php-ext-enable redis opcache ioncube \
    # 删除临时文件
    && docker-php-source delete && apt clean all \
    # 安装composer
    && wget https://getcomposer.org/download/latest-stable/composer.phar -O /usr/local/bin/composer && chmod +x /usr/local/bin/composer
