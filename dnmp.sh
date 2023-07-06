#!/bin/bash

# 检测是否已安装 Docker
if ! command -v docker &> /dev/null; then
    echo "未安装 Docker，正在安装..."

    # 执行 Docker 安装命令
    if curl -fsSL https://get.docker.com | bash -s docker; then
        echo "Docker 安装成功。"
    else
        echo "Docker 安装失败，请检查安装脚本或手动安装 Docker。"
        exit 1
    fi
else
    echo "Docker已安装，开始安装Docker-Compose..."

    # 执行 Docker-Compose 安装命令
    if curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && chmod +x /usr/local/bin/docker-compose; then
        echo "Docker-Compose 安装成功。"
    else
        echo "Docker-Compose 安装失败，请检查安装命令或手动安装 Docker-Compose。"
        exit 1
    fi
fi

echo "开始从仓库拉取Dnmp..."
if git clone https://github.com/RyanY610/Dnmp.git /var/dnmp; then
    echo "Dnmp 仓库拉取成功。"
else
    echo "Dnmp 仓库拉取失败，请检查/var下是否存在dnmp目录。"
    exit 1
fi

# 启动容器
cd /var/dnmp/ && docker-compose up -d

# 检查容器是否启动成功
if docker-compose ps | grep "Up" &> /dev/null; then
    echo "Dnmp 启动成功。"
else
    echo "Dnmp 启动失败，请检查是否存在相同的容器和网络。"
fi
