#!/bin/bash

curl -fsSL https://get.docker.com | bash -s docker # 安装docker
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && chmod +x /usr/local/bin/docker-compose && docker-compose --version # 安装docker-compose
git clone https://github.com/RyanY610/Dnmp.git /var/dnmp # 拉取项目到本地

# 设置环境变量
uname_m=$(uname -m)
case $uname_m in
    x86_64)
        uname_f="x86-64"
        ;;
    aarch64)
        uname_f="aarch64"
        ;;
    *)
        uname_f="unknown"
        ;;
esac

# 启动容器
cd /var/dnmp/ && docker-compose up -d
cd /var/dnmp/ && docker-compose restart

# 安装ioncube
wget https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_$uname_f.tar.gz
tar xvf ioncube_loaders_lin_$uname_f.tar.gz
docker cp ioncube/ioncube_loader_lin_8.1.so php8.1:/usr/local/lib/php/extensions/no-debug-non-zts-20210902/ioncube.so
docker cp ioncube/ioncube_loader_lin_7.4.so php7.4:/usr/local/lib/php/extensions/no-debug-non-zts-20190902/ioncube.so
rm -rf ioncube_loaders_lin_$uname_f.tar.gz ioncube

# 启动phpCron
cd /var/dnmp/ && cp php7.4_cron.service /etc/systemd/system/
cd /var/dnmp/ && cp php8.1_cron.service /etc/systemd/system/
systemctl start php7.4_cron php8.1_cron

rm -rf /var/dnmp/dnmp.sh
