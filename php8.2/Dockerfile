FROM php:8.2-fpm

RUN apt update \
    # 相关依赖必须手动安装
    && apt install -y wget libfreetype6-dev libjpeg62-turbo-dev libpng-dev libwebp-dev zlib1g-dev libzip-dev libbz2-dev libyaml-dev \
    # 设置环境变量
    && uname -m > /tmp/arch.txt \
    && if [ "$(cat /tmp/arch.txt)" = "x86_64" ] ; then \
        uname_f="x86-64" ; \
       elif [ "$(cat /tmp/arch.txt)" = "aarch64" ] ; then \
        uname_f="aarch64" ; \
       fi \
    # 创建并初始化 /usr/src/php目录
    && docker-php-source extract \
    # 如果安装的扩展需要自定义配置时
    && docker-php-ext-configure gd \
     --enable-gd \
     --with-freetype \
     --with-jpeg \
     --with-webp \
    # 安装扩展
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install pdo_mysql mysqli zip bz2 bcmath pcntl \
    && pecl install redis yaml && docker-php-ext-enable redis yaml opcache \
    # 删除临时文件
    && docker-php-source delete && apt clean all && rm -rf /var/lib/apt/lists/* \
    # 安装composer
    && wget https://getcomposer.org/download/latest-stable/composer.phar -O /usr/local/bin/composer && chmod +x /usr/local/bin/composer
