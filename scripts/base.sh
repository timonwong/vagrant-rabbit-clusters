#!/usr/bin/env bash

# Change yum mirror
sed -i.backup 's/^enabled=1/enabled=0/' /etc/yum/pluginconf.d/fastestmirror.conf
mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
wget -O /etc/yum.repos.d/CentOS-Base-aliyun.repo http://mirrors.aliyun.com/repo/Centos-6.repo
yum makecache
yum update

# Install EPEL repository
wget http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
wget http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
rpm -Uvh remi-release-6*.rpm epel-release-6*.rpm

# EPEL Mirror
if [[ ! -f /etc/yum.repos.d/epel.repo.backup ]]; then
    mv /etc/yum.repos.d/epel.repo /etc/yum.repos.d/epel.repo.backup 2>/dev/null || :
fi

if [[ ! -f /etc/yum.repos.d/epel-testing.repo.backup ]]; then
    mv /etc/yum.repos.d/epel-testing.repo /etc/yum.repos.d/epel-testing.repo.backup 2>/dev/null || :
fi

wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-6.repo

# Install rabbitmq-server
yum -y install rabbitmq-server

# Disable iptables
iptables -F

service iptables stop
chkconfig iptables off
