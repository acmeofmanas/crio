>Last month Kubernetes release 1.24 and it comes with a major change which is removal of dockershim. The dockershim component of Kubernetes allows to use Docker as a Kubernetes's container runtime

![this is ] (https://d33wubrfki0l68.cloudfront.net/6b4290afef76cad8a084292cd1b5e468e31c9bb3/c26ce/images/blog/2018-05-24-kubernetes-containerd-integration-goes-ga/cri-containerd.png)

 **If you are looking for more details check out “https://kubernetes.io/docs/tasks/administer-cluster/migrating-from-dockershim/check-if-dockershim-removal-affects-you/"**

*As an alternative to docker, CRI-O can be used to deploy your Kubernetes’s CRI. Few of the biggest contributor and user of CRIO are Redhat,IBM,Hyper,Intel,Suse.*

***This guide will walk you through to install CRI-O runtime on Ubuntu and run your first pod and container on Ubuntu. CRI-O is container runtime interface designed to provide an integration path between OCI conformant runtime and kubelet.***

Setup CRI-O Repository:


