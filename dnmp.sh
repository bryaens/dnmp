#!/bin/bash

RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
NC="\033[0m"

back2menu() {
	echo ""
	echo -e "${GREEN}所选命令操作执行完成${NC}"
	read -rp "请输入“y”退出, 或按任意键回到主菜单：" back2menuInput
	case "$back2menuInput" in
		y) exit 1 ;;
		*) menu ;;
	esac
}

back3menu() {
	echo ""
	echo -e "${GREEN}所选命令操作执行完成${NC}"
	read -rp "请输入“y”返回主菜单, 或按任意键回到当前菜单：" back3menuInput
	case "$back3menuInput" in
		y) menu ;;
		*) run_dnmp ;;
	esac
}
back4menu() {
	echo ""
	echo -e "${GREEN}所选命令操作执行完成${NC}"
	read -rp "请输入“y”返回主菜单, 或按任意键回到当前菜单：" back4menuInput
	case "$back4menuInput" in
		y) menu ;;
		*) stop_dnmp ;;
	esac
}


install_base(){
	# 检测是否已安装 Docker
	if ! command -v docker &> /dev/null; then
		echo -e "${GREEN}未安装 Docker，正在安装...${NC}"

	# 执行 Docker 安装命令
	if curl -fsSL https://get.docker.com | bash -s docker; then
		systemctl restart docker
		echo -e "${GREEN}Docker 安装成功。${NC}"
	else
		echo -e "${RED}Docker 安装失败，请检查安装脚本或手动安装 Docker。${NC}"
		exit 1
	fi
	fi
	echo -e "${GREEN}Docker已安装，开始安装Docker-Compose...${NC}"
	# 执行 Docker-Compose 安装命令
	if curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && chmod +x /usr/local/bin/docker-compose; then
		echo -e "${GREEN}Docker-Compose 安装成功。${NC}"
	else
		echo -e "${RED}Docker-Compose 安装失败，请检查安装命令或手动安装 Docker-Compose。${NC}"
		exit 1
	fi

	# 检测操作系统类型
	if [ -f /etc/os-release ]; then
		# CentOS
		if grep -qiE "centos" /etc/os-release; then
			echo -e "${GREEN}CentOS 操作系统，开始安装依赖...${NC}"
			yum install -y git
		fi

	# Debian
	if grep -qiE "debian" /etc/os-release; then
		# Debian
		if grep -qiE "debian" /etc/os-release; then
			echo -e "${GREEN}Debian 操作系统，开始安装依赖...${NC}"
			apt install -y git
		fi

		# Ubuntu
		if grep -qiE "ubuntu" /etc/os-release; then
			echo -e "${GREEN}Ubuntu 操作系统，开始安装依赖...${NC}"
			apt install -y git
		fi
	fi
else
	echo -e "${RED}无法确定操作系统类型，无法自动安装依赖。${NC}"
	exit 1
	fi

	# 检查依赖是否安装成功
	if command -v git &> /dev/null; then
		echo -e "${GREEN}依赖安装成功。${NC}"
	else
		echo -e "${RED}依赖安装失败，请检查安装命令或尝试手动安装依赖。${NC}"
		exit 1
	fi
}


install_dnmp(){
	install_base
	echo -e "${GREEN}开始安装 Dnmp...${NC}"
	if git clone https://github.com/RyanY610/Dnmp.git /var/dnmp; then
		echo -e "${GREEN}Dnmp 安装成功。${NC}"
	else
		echo -e "${RED}Dnmp 安装失败，请检查/var下是否存在dnmp目录。${NC}"
		exit 1
	fi
	back2menu
}

set_dnmp(){
	read -p "设置nginx的版本： " nginx_v
	sed -i -e "s/NGINX_V=.*$/NGINX_V=$nginx_v/" /var/dnmp/.env
	read -p "设置mysql的root密码： " mysql_password
	sed -i -e "s/MYSQL_PASSWORD=.*$/MYSQL_PASSWORD=$mysql_password/" /var/dnmp/.env
	read -p "设置mariadb的root密码： " mariadb_password
	sed -i -e "s/MARIADB_PASSWORD=.*$/MARIADB_PASSWORD=$mariadb_password/" /var/dnmp/.env
	read -p "设置redis的密码： " redis_password
	sed -i -e "s/REDIS_PASSWORD=.*$/REDIS_PASSWORD=$redis_password/" /var/dnmp/.env
	echo "设置的信息如下"
	echo -e "${GREEN}nginx的版本${NC}是${GREEN}$nginx_v${NC}"
	echo -e "${GREEN}mysql的root密码${NC}是${GREEN}$mysql_password${NC}"
	echo -e "${GREEN}mariadb的root密码${NC}是${GREEN}$mariadb_password${NC}"
	echo -e "${GREEN}redis的root密码${NC}是${GREEN}$redis_password${NC}"
	back2menu
}

run_dnmp() {
	echo -e "请选择你要启动的服务，默认启动${GREEN}1${NC}，${GREEN}3${NC}，${GREEN}5${NC}，${GREEN}7${NC}"
	echo -e " ${GREEN}1.${NC} 启动${GREEN}nginx${NC}"
	echo -e " ${GREEN}2.${NC} 启动${GREEN}php7.4${NC}"
	echo -e " ${GREEN}3.${NC} 启动${GREEN}php8.1${NC}"
	echo -e " ${GREEN}4.${NC} 启动${GREEN}php8.2${NC}"
	echo -e " ${GREEN}5.${NC} 启动${GREEN}mysql${NC}"
	echo -e " ${GREEN}6.${NC} 启动${GREEN}mariadb${NC}"
	echo -e " ${GREEN}7.${NC} 启动${GREEN}redis${NC}"
	read -rp "请输入选项 [1-7]: " service
	case $service in
		1) cd /var/dnmp && docker-compose up -d nginx ;;
		2) cd /var/dnmp && docker-compose up -d php7.4 ;;
		3) cd /var/dnmp && docker-compose up -d php8.1 ;;
		4) cd /var/dnmp && docker-compose up -d php8.2 ;;
		5) cd /var/dnmp && docker-compose up -d mysql ;;
		6) cd /var/dnmp && docker-compose up -d mariadb ;;
		7) cd /var/dnmp && docker-compose up -d redis ;;
		*) cd /var/dnmp && docker-compose up -d nginx php8.1 mysql redis ;;
	esac
	back3menu
}
stop_dnmp() {
	echo -e "请选择你要停止的服务${NC}"
	echo -e " ${GREEN}1.${NC} ${RED}停止nginx${NC}"
	echo -e " ${GREEN}2.${NC} ${RED}停止php7.4${NC}"
	echo -e " ${GREEN}3.${NC} ${RED}停止php8.1${NC}"
	echo -e " ${GREEN}4.${NC} ${RED}停止php8.2${NC}"
	echo -e " ${GREEN}5.${NC} ${RED}停止mysql${NC}"
	echo -e " ${GREEN}6.${NC} ${RED}停止mariadb${NC}"
	echo -e " ${GREEN}7.${NC} ${RED}停止redis${NC}"
	read -rp "请输入选项 [1-7]: " service
	case $service in
		1) docker stop nginx && docker rm nginx ;;
		2) docker stop php7.4 && docker rm php7.4 ;;
		3) docker stop php8.1 && docker rm php8.1 ;;
		4) docker stop php8.2 && docker rm php8.2 ;;
		5) docker stop mysql && docker rm mysql && rm -rf /var/dnmp/mysql ;;
		6) docker stop mariadb && docker rm mariadb && rm -rf /var/dnmp/mariadb ;;
		7) docker stop redis && docker rm redis && rm -rf /var/dnmp/redis ;;
	esac
	back4menu
}

uninstall_dnmp() {
	echo -e " ${RED}注意！！！卸载前请先使用主菜单备份 Dnmp 功能${NC}"

	rm -rf /var/dnmp
	echo -e "${GREEN}Dnmp 已彻底卸载!${NC}"
	back2menu
}

menu() {
	clear
	echo "#############################################################"
	echo -e "#                     ${RED}Dnmp堆栈一键脚本${NC}                      #"
	echo -e "#                     ${GREEN}作者${NC}: 你挺能闹啊🍏                    #"
	echo "#############################################################"
	echo ""
	echo -e " ${GREEN}1.${NC} ${GREEN}安装 Dnmp 堆栈${NC}"
	echo -e " ${GREEN}2.${NC} ${RED}卸载 Dnmp 堆栈${NC}"
	echo " -------------"
	echo -e " ${GREEN}3.${NC} 设置 Dnmp 信息"
	echo -e " ${GREEN}4.${NC} ${GREEN}启动 Dnmp 服务${NC}"
	echo -e " ${GREEN}5.${NC} ${RED}停止 Dnmp 服务${NC}"
	echo " -------------"
	echo -e " ${GREEN}5.${NC} 查看已申请的证书"
	echo -e " ${GREEN}6.${NC} 手动续期已申请的证书"
	echo -e " ${GREEN}7.${NC} 切换证书颁发机构"
	echo " -------------"
	echo -e " ${GREEN}0.${NC} 退出脚本"
	echo ""
	read -rp "请输入选项 [0-9]: " NumberInput
	case "$NumberInput" in
		1) install_dnmp ;;
		2) uninstall_dnmp ;;
		3) set_dnmp ;;
		4) run_dnmp ;;
		5) stop_dnmp ;;
		6) renew_cert ;;
		7) switch_provider ;;
		*) exit 1 ;;
	esac
}

menu
