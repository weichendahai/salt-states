#!/bin/bash
#auto Change ip netmask gateway scripts
#weichen 2016-07-21
#源自网络
cat<<EOF

++++++++自动修改ip和主机名等相关信息+++++++++
ETHCONF=/etc/sysconfig/network-scripts/ifcfg-eth0
HOSTS=/etc/hosts
NETWORK=/etc/sysconfig/network
DIR=/data/backup/`date +%Y%m%d`
NETMASK=255.255.255.0
+++++++++-------------------------+++++++++++
EOF
#echo "$DESC"
#Define Path  定义变量，可以根据实际情况修改
ETHCONF=/etc/sysconfig/network-scripts/ifcfg-eth0
HOSTS=/etc/hosts
NETWORK=/etc/sysconfig/network
DIR=/data/backup/`date +%Y%m%d`
NETMASK=255.255.255.0
echo "================================================"
echo
#定义change_ip函数
function Change_ip ()
{
#判断备份目录是否存在，中括号前后都有空格，！叹号在shell表示相反的意思#
if
   [ ! -d $DIR ];then
   mkdir -p $DIR
fi
  echo "Now Change ip address ,Doing Backup Interface eth0"
  cp $ETHCONF $DIR
  grep "dhcp"  $ETHCONF
#如下$?用来判断上一次操作的状态，为0，表示上一次操作状态正确或者成功#
if
  [ $? -eq 0 ];then
#read -p 交互输入变量IPADDR，注冒号后有空格，sed -i 修改配置文件#
  read -p "Please insert ip Address:" IPADDR
  sed -i 's/dhcp/static/g' $ETHCONF
#awk -F. 意思是以.号为分隔域，打印前三列#
  echo -e "IPADDR=$IPADDR\nNETMASK=$NETMASK\nGATEWAY=`echo $IPADDR|awk -F. '{print $1"."$2"."$3}'`.254" >>$ETHCONF
  echo "This IP address Change success !"
else
  echo -n  "This $ETHCONF is static exist ,please ensure Change Yes or NO":
  read i
fi
if
  [ "$i" == "y" -o "$i" == "yes" ];then
  read -p "Please insert ip Address:" IPADDR
count=(`echo $IPADDR|awk -F. '{print $1,$2,$3,$4}'`)
 #定义数组， ${#count[@]}代表获取变量值总个数#
A=${#count[@]}
 #while条件语句判断，个数是否正确，不正确循环提示输入，也可以用[0-9]来判断ip#
while
  [ "$A" -ne "4" ]
do
  read -p "Please re Inster ip Address,example 192.168.0.11 ip": IPADDR
count=(`echo $IPADDR|awk -F. '{print $1,$2,$3,$4}'`)
A=${#count[@]}
done
 #sed -e 可以连续修改多个参数#
  sed -i -e 's/^IPADDR/#IPADDR/g' -e 's/^NETMASK/#NETMASK/g' -e 's/^GATEWAY/#GATEWAY/g' $ETHCONF
 #echo -e \n为连续追加内容，并自动换行#
  echo -e "IPADDR=$IPADDR\nNETMASK=$NETMASK\nGATEWAY=`echo $IPADDR|awk -F. '{print $1"."$2"."$3}'`.254" >>$ETHCONF
  echo "This IP address Change success !"
else
  echo "This $ETHCONF static exist,please exit"
  exit $?
fi
}
#定义hosts函数
############function hosts##############
function Change_hosts ()
{
if
   [ ! -d $DIR ];then
   mkdir -p $DIR
fi
  cp $HOSTS $DIR
  read -p "Please insert ip address": IPADDR
host=`echo $IPADDR|sed 's/\./-/g'`
  cat $HOSTS |grep 127.0.0.1 |grep "$host"
if
  [ $? -ne 0 ];then
  sed -i "s/127.0.0.1/127.0.0.1 $host/g" $HOSTS
  echo "This hosts change success "
else
  echo "This $host IS Exist .........."
fi
}
###########fuction network###############
#定义network函数
function Change_network ()
{
   if
   [ ! -d $DIR ];then
   mkdir -p $DIR
 fi
  cp $NETWORK $DIR
  read -p "Please insert ip address": IPADDR
host=`echo $IPADDR|sed 's/\./-/g'`
  grep "$host" $NETWORK
   if
  [ $? -ne 0 ];then
  sed -i "s/^HOSTNAME/#HOSTNAME/g" $NETWORK
  echo "NETWORK=$host" >>$NETWORK
else
  echo "This $host IS Exist .........."
  fi
}
#PS3一般为菜单提示信息#
PS3="Please Select ip or hosts Menu":
#select为菜单选择命令，格式为select $var in ..command.. do .... done
  select i in  "Change_ip" "Change_hosts" "Change_network"
do
#case 方式，一般用于多种条件下的判断
case $i in
     Change_ip )
     Change_ip
;;
     Change_hosts )
     Change_hosts
;;
     Change_network )
     Change_network
;;
     *)
     echo
     echo "Please Insert $0: Change_ip(1)|Change_hosts(2)|Change_network(3)"
     echo
;;
esac
done
