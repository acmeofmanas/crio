# Last month Kubernetes release 1.24 and it comes with a major change which is removal of dockershim. So far the dockershim component of Kubernetes allows to use Docker as a Kubernetes's container runtime

![this is ](https://d33wubrfki0l68.cloudfront.net/6b4290afef76cad8a084292cd1b5e468e31c9bb3/c26ce/images/blog/2018-05-24-kubernetes-containerd-integration-goes-ga/cri-containerd.png)

 **If you are looking for more details check out “https://kubernetes.io/docs/tasks/administer-cluster/migrating-from-dockershim/check-if-dockershim-removal-affects-you/"**

*As an alternative to docker, CRI-O can be used to deploy your Kubernetes’s CRI. Few of the biggest contributor and user of CRIO are Redhat,IBM,Hyper,Intel,Suse.*

***This guide will walk you through to install CRI-O runtime on Ubuntu and run your first pod and container on Ubuntu. CRI-O is container runtime interface designed to provide an integration path between OCI conformant runtime and kubelet.***

## Setup CRI-O Repository:
1. install pre-req dependecies 
- apt update
- apt install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common

2. set env for CRI-O & OS version
- export OS_VERSION=xUbuntu_20.04
- export CRIO_VERSION=1.21

3. add gpg key for repo
- curl -fsSL https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS_VERSION/Release.key |  gpg --dearmor -o /usr/share/keyrings/libcontainers-archive-keyring.gpg
- curl -fsSL https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable:/cri-o:/$CRIO_VERSION/$OS_VERSION/Release.key |  gpg --dearmor -o /usr/share/keyrings/libcontainers-crio-archive-keyring.gpg

4. add repo 
- echo "deb [signed-by=/usr/share/keyrings/libcontainers-archive-keyring.gpg] https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS_VERSION/ /" |  tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list
- echo "deb [signed-by=/usr/share/keyrings/libcontainers-crio-archive-keyring.gpg] https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable:/cri-o:/$CRIO_VERSION/$OS_VERSION/ /" |  tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable:cri-o:$CRIO_VERSION.list

## Install CRI-O & start service
```
1. apt update
2. apt install -y cri-o cri-o-runc cri-tools
3. systemctl enable crio —now
```
# Validate service status
```
1. crictl -r unix:///run/crio/crio.sock version
Version:  0.1.0
RuntimeName:  cri-o
RuntimeVersion:  1.21.7
RuntimeApiVersion:  v1

2. crictl info
{
  "status": {
    "conditions": [
      {
        "type": "RuntimeReady",
        "status": true,
        "reason": "",
        "message": ""
      },
      {
        "type": "NetworkReady",
        "status": true,
        "reason": "",
        "message": ""
      }
    ]
  }
}
```
