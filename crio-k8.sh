#! /bin/bash

# Variable Declaration

KUBERNETES_VERSION="1.22.6-00"
OS=xUbuntu_20.04
VERSION=1.21
# disable swap 
 swapoff -a
# keeps the swaf off during reboot
 sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

 apt-get update -y
 apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \

#install crio
echo "deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS/ /" > /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list
echo "deb http://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable:/cri-o:/$VERSION/$OS/ /" > /etc/apt/sources.list.d/devel:kubic:libcontainers:stable:cri-o:$VERSION.list

curl -L https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable:cri-o:$VERSION/$OS/Release.key | apt-key add -
curl -L https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS/Release.key | apt-key add -

apt-get update
apt-get install cri-o cri-o-runc cri-tools -y

# crio customize
cat <<EOF |tee /etc/crio/crio.conf
[crio.runtime]
conmon_cgroup = "pod"
cgroup_manager = "cgroupfs"
EOF

#start crio
systemctl enable crio --now

echo " CRI-O successfully running"

#install kubernetes

apt-get update
apt-get install -y apt-transport-https ca-certificates curl
curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg

echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" |  tee /etc/apt/sources.list.d/kubernetes.list

apt-get update -y

apt-get install -y kubelet kubectl kubeadm

apt-mark hold kubelet kubeadm kubectl

systemctl enable kubelet --now
