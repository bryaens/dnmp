#!/bin/bash

# 设置字体输出颜色
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# 检测操作系统类型
if [ -f /etc/os-release ]; then
    # CentOS
    if grep -qiE "centos" /etc/os-release; then
        echo -e "${GREEN}CentOS 操作系统，开始安装 Git...${NC}"
        yum install -y git
    fi

    # Debian 或 Ubuntu
    if grep -qiE "debian" /etc/os-release; then
        # Debian
        if grep -qiE "debian" /etc/os-release; then
            echo -e "${GREEN}Debian 操作系统，开始安装 Git...${NC}"
            apt install -y git
        fi

        # Ubuntu
        if grep -qiE "ubuntu" /etc/os-release; then
            echo -e "${GREEN}Ubuntu 操作系统，开始安装 Git...${NC}"
            apt install -y git
        fi
    fi
else
    echo -e "${RED}无法确定操作系统类型，无法自动安装 Git。${NC}"
    exit 1
fi

# 检查是否安装成功
if command -v git &> /dev/null; then
    echo -e "${GREEN}Git 安装成功。${NC}"
else
    echo -e "${RED}Git 安装失败，请检查安装命令或尝试手动安装 Git。${NC}"
    exit 1
fi

# 检测是否已安装 Docker
if ! command -v docker &> /dev/null; then
    echo -e "${GREEN}未安装 Docker，正在安装...${NC}"

    # 执行 Docker 安装命令
    if curl -fsSL https://get.docker.com | bash -s docker; then
        echo -e "${GREEN}Docker 安装成功。${NC}"
    else
        echo -e "${RED}Docker 安装失败，请检查安装脚本或手动安装 Docker。${NC}"
        exit 1
    fi
fi
systemctl restart docker
echo -e "${GREEN}Docker已安装，开始安装Docker-Compose...${NC}"
# 执行 Docker-Compose 安装命令
if curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && chmod +x /usr/local/bin/docker-compose; then
    echo -e "${GREEN}Docker-Compose 安装成功。${NC}"
    else
    echo -e "${RED}Docker-Compose 安装失败，请检查安装命令或手动安装 Docker-Compose。${NC}"
    exit 1
fi

echo -e "${GREEN}开始从仓库拉取Dnmp...${NC}"
if git clone https://github.com/RyanY610/Dnmp.git /var/dnmp; then
    echo -e "${GREEN}Dnmp 仓库拉取成功。${NC}"
else
    echo -e "${RED}Dnmp 仓库拉取失败，请检查/var下是否存在dnmp目录。${NC}"
    exit 1
fi

# 启动容器
cd /var/dnmp/ && docker-compose up -d

# 检查容器是否启动成功
if docker-compose ps | grep "Up" &> /dev/null; then
    echo -e "${GREEN}Dnmp 启动成功。${NC}"
else
    echo -e "${RED}Dnmp 启动失败，请检查是否存在相同的容器和网络。${NC}"
fi
