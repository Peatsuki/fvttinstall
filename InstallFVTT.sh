#!/bin/bash
# sh initialization

version="CentOS Linux release 7."
release=$(cat /etc/redhat-release)
result=$(echo $release | grep "${version}")
cd $home

if [[ "$result" != "" ]]
	then
		echo "CentOS 7.X 确认，等待载入脚本."
		# stop 停止防火墙
		systemctl stop firewalld
		# 键入下载URL
		read -p "请输入Node.js文件包安装下载地址： " fvtturl
		# 安装基本环境
		cd $home
		yum install -y openssl-devel unzip zip
		curl --silent --location https://rpm.nodesource.com/setup_12.x | sudo bash -
		yum install -y nodejs
		# 创建文件夹
		mkdir foundryvtt
		mkdir foundrydata
		cd foundryvtt
		#下载文件包
		wget -O foundryvtt.zip "$fvtturl"
		#wget -O foundryvtt.zip https://www.peatsuki.com/sh/foundryvtt.zip --no-check-certificate
		unzip foundryvtt.zip
		cd $home
		#后台模式选择
		echo "请选择后台安装模式 [P] PM2 [其他任意键]nohup"
		read -n 1 -p "请输入: " background
		if [[ "$background" = "P" ]]
			then
				#以PM2运行fvtt
				npm install -g pm2
				pm2 start foundryvtt/resources/app/main.js
		else 
				#以nohup运行fvtt并下载重启脚本
				wget https://www.peatsuki.com/sh/startfvtt.sh --no-check-certificate
				nohup node foundryvtt/resources/app/main.js --dataPath=$HOME/foundrydata &
		fi
		
else
		echo "系统类型与版本校验错误，脚本退出."
		exit 1
fi
