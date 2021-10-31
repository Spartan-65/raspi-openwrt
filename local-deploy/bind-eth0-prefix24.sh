#! /bin/bash

GATEWAY=`ip route | grep default | awk '{print $3}'`
HOSTIPADDR=`ip addr | grep eth0 | grep /24 | awk '{print $2}' | awk -F /24 '{print $1}'`
SUBNET=`echo $GATEWAY | awk -F . '{print $1"."$2"."$3"."0"/"24}'`

rand(){
    min=$1
    max=$(($2-$min+1))
    num=$(cat /dev/urandom| head -n 10 | cksum | awk '{print $1}')
    echo $(($num%$max+$min))
} 


docker_network_create(){
    docker network create -d macvlan --subnet=$SUBNET --gateway=$GATEWAY -o parent=eth0 macnet
}

docker_build(){
    randnum=$(rand 1 254)
    IPADDR=`echo $HOSTIPADDR | awk -F . '{print $1"."$2"."$3".""'$randnum'"}'`
    docker build -t my-openwrt:latest -f Dockerfile --build-arg IPADDR=$IPADDR --build-arg GATEWAY=$GATEWAY --build-arg DNSADDR=$GATEWAY .
    echo $IPADDR
}

docker_run(){
    docker stop openwrt || docker rm openwrt
    docker run --restart unless-stopped --name openwrt -d --network macnet --privileged my-openwrt:latest /sbin/init
}

docker_run_test(){
    docker run --rm --name openwrt -it --network macnet --privileged my-openwrt:latest /bin/bash
}
docker_network_create
docker_build
docker_run


