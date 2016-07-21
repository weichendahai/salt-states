#!/bin/bash

HOSTNAME=$1
ETH0_IP=$2
ETH1_IP=$3

if [ "$HOSTNAME"x == "x" -o "$ETH0_IP"x == "x" -o "$ETH1_IP"x == "x" ] ;then
    echo '-1|params error'
    echo 'example: hostnamedev01 192.168.100.4 192.168.100.5'
    exit -1
fi

#ETH0_CONF=/etc/sysconfig/network-scripts/ifcfg-eth0
#ETH0_CONF=/etc/sysconfig/network-scripts/ifcfg-eth0
ETH0_CONF=eth0
ETH1_CONF=eth1
NETWORK_HOSTNAME=/etc/sysconfig/network
NETMASK=255.255.255.0
GATEWAY=192.168.178.2



#不然网卡启动失败
rm -rf /etc/udev/rules.d/70-persistent-net.rules

#修改主机名字
sed -i "s/^HOSTNAME/#HOSTNAME/g" $NETWORK_HOSTNAME
echo "HOSTNAME=$HOSTNAME" >>$NETWORK_HOSTNAME

cat>$ETH0_CONF<<EOF
DEVICE=eth0
TYPE=Ethernet
#UUID=a568b1cc-49ed-4591-8e69-42e783ae8e24
ONBOOT=yes
NM_CONTROLLED=yes
BOOTPROTO=none
IPADDR=$ETH0_IP
NETMASK=$NETMASK
GATEWAY=$GATEWAY
IPV6INIT=no
USERCTL=no
EOF

cat>$ETH1_CONF<<EOF
DEVICE=eth1
TYPE=Ethernet
#UUID=a568b1cc-49ed-4591-8e69-42e783ae8e24
ONBOOT=yes
NM_CONTROLLED=yes
BOOTPROTO=none
IPADDR=$ETH1_IP
NETMASK=$NETMASK
GATEWAY=$GATEWAY
IPV6INIT=no
USERCTL=no
EOF
