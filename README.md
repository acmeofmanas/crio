# CRI-O Installation Instructions
With the release of Kubernetes 1.24 a major change happened; which is removal of dockershim. So far the dockershim component of Kubernetes allows to use Docker as a Kubernetes's container runtime.

![this is ](https://d33wubrfki0l68.cloudfront.net/6b4290afef76cad8a084292cd1b5e468e31c9bb3/c26ce/images/blog/2018-05-24-kubernetes-containerd-integration-goes-ga/cri-containerd.png)

 **For more information please visit the [Kubernetes Migrating from dockershim](https://kubernetes.io/docs/tasks/administer-cluster/migrating-from-dockershim/check-if-dockershim-removal-affects-you/).**

*As an alternative to docker, CRI-O can be used to deploy your Kubernetes’s CRI. Few of the biggest contributor and user of [CRIO](https://cri-o.io) are Redhat,IBM,Hyper,Intel,Suse.*

***This guide will walk you through the installation of [CRI-O](https://github.com/cri-o/cri-o) runtime on Ubuntu and run your first pod and container on Ubuntu. CRI-O is [container runtime interface](https://github.com/kubernetes/community/blob/master/contributors/design-proposals/node/container-runtime-interface-v1.md) designed to provide an integration path between OCI conformant runtime and kubelet.***

## Setup CRI-O Repository:
1. install pre-req dependecies 
```
apt update
apt install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common
```
2. set env for CRI-O & OS version
``` 
export OS_VERSION=xUbuntu_20.04
export CRIO_VERSION=1.21
```
3. add gpg key for repo
```
curl -fsSL https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS_VERSION/Release.key |  gpg --dearmor -o /usr/share/keyrings/libcontainers-archive-keyring.gpg
curl -fsSL https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable:/cri-o:/$CRIO_VERSION/$OS_VERSION/Release.key |  gpg --dearmor -o /usr/share/keyrings/libcontainers-crio-archive-keyring.gpg
```
4. add repo 
```
echo "deb [signed-by=/usr/share/keyrings/libcontainers-archive-keyring.gpg] https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS_VERSION/ /" |  tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list
echo "deb [signed-by=/usr/share/keyrings/libcontainers-crio-archive-keyring.gpg] https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable:/cri-o:/$CRIO_VERSION/$OS_VERSION/ /" |  tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable:cri-o:$CRIO_VERSION.list
```
## Install CRI-O & start service
```
 apt update
 apt install -y cri-o cri-o-runc cri-tools
 systemctl enable crio —now
```
# Validate CRI-O service status
<sub>we can use below syntax to validate our cri-o service</sub>
```
crictl -r unix:///run/crio/crio.sock version
Version:  0.1.0
RuntimeName:  cri-o
RuntimeVersion:  1.21.7
RuntimeApiVersion:  v1

crictl info
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

systemctl status crio
● crio.service - Container Runtime Interface for OCI (CRI-O)
     Loaded: loaded (/lib/systemd/system/crio.service; enabled; vendor preset: enabled)
     Active: active (running) since Wed 2022-08-03 21:44:22 +08; 2h 5min ago
       Docs: https://github.com/cri-o/cri-o
   Main PID: 16084 (crio)
      Tasks: 11
     Memory: 11.0M
     CGroup: /system.slice/crio.service
             └─16084 /usr/bin/crio

Aug 03 21:44:22 worker1 crio[16084]: time="2022-08-03 21:44:22.800749410+08:00" level=info msg="Node configuratio>
Aug 03 21:44:22 worker1 systemd[1]: Started Container Runtime Interface for OCI (CRI-O)
```
### Let's play now to run first container, as it's not as stright as docker run that you might have used to. 
<sub> first let's pull image that we want to run</sub>
```
crictl pull nginx
Image is up to date for docker.io/library/nginx@sha256:691eecfa41f219b32acea5a3561a8d8691d8320e5a00e1cb4574de5827e077a7

crictl img
IMAGE                     TAG                 IMAGE ID            SIZE
docker.io/library/nginx   latest              f493a2ff29351       139MB

```
<sub>at first we need to create 2 files to run pod and container for this example we named it as pod-config.json and container-config.json</sub>
```
cat >pod-config.json <<EOF 
{
    "metadata": {
        "name": "nginx",
        "namespace": "default",
        "attempt": 1,
        "uid": "hdishd83djaidwnduwk28bcsb"
    },
    "hostname": "nginx-proxy",
    "port_mapping": [
      {
        "container_port": 80
      }
     ],
    "linux": {
    },
    "log_directory": "/tmp"
}
EOF

cat >container-config-1.json <<EOF
{
  "metadata": {
    "name": "nginx-container",
    "attempt": 1
  },
  "image": {
    "image": "nginx"
  },
  "log_path": "nginx.log",
  "linux": {
    "security_context": {
      "namespace_options": {}
    }
  }
}
EOF

```
<sub>now we have our config file let's run and start our container</sub>

<sup> run first pod</sup>
```
crictl runp pod-config.json
bc41cd776db7368c4094f8af5d9fc12a71a195821ec81cbd44093c07452904db

crictl pods
POD ID              CREATED             STATE               NAME                NAMESPACE           ATTEMPT             RUNTIME
bc41cd776db73       29 seconds ago      Ready               ngnix-pod           default             1                   (default)
```
<sup>now that pod is ready, let's create container inside this pod.</sup>

*bc41cd776db73* is the pod id we will use in below syntax:

```
crictl create bc41cd776db73 container-config-1.json pod-config.json
026eabd68200fd936e2429fd23e8b2760b1375d4a3e29b0238f74a0604fe2855

crictl pods
POD ID              CREATED             STATE               NAME                NAMESPACE           ATTEMPT             RUNTIME
bc41cd776db73       2 minutes ago       Ready               ngnix-pod           default             1                   (default)

crictl ps
CONTAINER           IMAGE               CREATED             STATE               NAME                ATTEMPT             POD ID

crictl ps -a
CONTAINER           IMAGE               CREATED             STATE               NAME                ATTEMPT             POD ID
026eabd68200f       nginx               19 seconds ago      Created             nginx-container     1                   bc41cd776db73
```

<sup>now we see the pod and container is ready but still container state is  *Created*; so lets strt the container now</sup>

```
crictl start 026eabd68200f
026eabd68200f

crictl ps
CONTAINER           IMAGE               CREATED             STATE               NAME                ATTEMPT             POD ID
026eabd68200f       nginx               39 seconds ago      Running             nginx-container     1                   bc41cd776db73
```

