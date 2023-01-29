#!/bin/bash

#systemctl stop firewalld && systemctl disable firewalld
#sed -i 's/enforcing/disabled/' /etc/selinux/config && setenforce 0

swapoff -a
sed -ri 's/.*swap.*/#&/' /etc/fstab

cat > /etc/sysctl.d/k8s.conf << EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
vm.swappiness = 0
EOF
sysctl -p

modprobe ip_vs
modprobe ip_vs_rr
modprobe ip_vs_wrr
modprobe ip_vs_sh
modprobe nf_conntrack_ipv4

cat > /etc/modules-load.d/ip_vs.conf << EOF 
ip_vs
ip_vs_rr
ip_vs_wrr
ip_vs_sh
nf_conntrack_ipv4
EOF

apt-get install -y ipvsadm ipset sysstat conntrack libseccomp-dev wget git ntpdate apt-transport-https

ntpdate time.windows.com

sudo apt-get update
sudo apt-get -y install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg | sudo apt-key add -
curl https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg | apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://mirrors.aliyun.com/docker-ce/linux/ubuntu $(lsb_release -cs) stable"
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb https://mirrors.aliyun.com/kubernetes/apt/ kubernetes-xenial main
EOF
# Step 4: 更新并安装Docker-CE
sudo apt-get -y update
sudo apt-get -y install docker-ce

mkdir -p /etc/docker/
cat > /etc/docker/daemon.json << EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "insecure-registries": [
    "registry.bocloud.io:5000"
  ]
}
EOF
systemctl daemon-reload && systemctl enable docker && systemctl start docker

apt-get install -y kubelet=1.22.5-00 kubeadm=1.22.5-00 kubectl=1.22.5-00
systemctl enable kubelet
