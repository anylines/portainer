#!/bin/bash

red='\033[0;31m'
plain='\033[0m'
#内网ip地址获取
ip=$(ifconfig | grep "inet addr" | awk '{ print $2}' | awk -F: '{print $2}' | awk 'NR==1')
if [[ ! -n "$ip" ]]; then
    ip="你的路由器IP"
fi
#默认安装目录/root
name=/root
#默认安装端口
nport=9000
# check root
[[ $EUID -ne 0 ]] && echo -e "${red}错误: ${plain} 必须使用root用户运行此脚本！\n" && exit 1

echo -e "输入portainer汉化文件安装目录：${red} \n（必须是绝对路径如：/opt，不懂的直接回车，默认目录$name）\n"
read -p "输入目录名（留空默认：$name）: " webdir
echo -e "${plain}"
    if [[ ! -n "$webdir" ]]; then
        webdir=$name
    fi
read -p "输入服务端口（请避开已使用的端口）[留空默认$nport]: " port
    if [[ ! -n "$port" ]]; then
        port=$nport
    fi
if [[ ! -d "$webdir" ]] ; then
cd $webdir
else
mkdir -p $webdir && cd $webdir
fi
curl -sL https://raw.githubusercontent.com/Anylines/portainer/main/public-public.tar.gz | tar xz

rm -rf public

mv public-public public
    
docker stop portainer

docker rm portainer

docker rmi portainer/portainer:linux-arm64

docker rmi portainer/portainer-ce:linux-arm64

docker run -d --restart=always --name="portainer" -p $port:9000 -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data -v $webdir/public:/public portainer/portainer-ce:linux-arm64

echo -e "portainer部署成功，${red}浏览器访问$ip:$port \c"
echo -e "${plain}"
