#!/bin/bash
red='\033[0;31m'

plain='\033[0m'

# check root
[[ $EUID -ne 0 ]] && echo -e "${red}错误: ${plain} 必须使用root用户运行此脚本！\n" && exit 1

cd /root &&
curl -sL https://raw.githubusercontent.com/Anylines/portainer/main/onex86.sh | tar xz &&
rm -rf public &&
mv public-public public &&
docker stop portainer &&
docker rm portainer &&
docker rmi portainer/portainer &&
docker rmi portainer/portainer-ce &&
docker run -d --restart=always --name="portainer" -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data -v /root/public:/public portainer/portainer-ce
