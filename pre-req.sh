KUBERNETES_VERSION="1.22.6-00"
OS=xUbuntu_20.04
VERSION=1.24.2

dnf module enable cri-o:$VERSION
dnf install cri-o

#yum install make
yum install -y \
  containers-common \
  device-mapper-devel \
  git \
  glib2-devel \
  glibc-devel \
  glibc-static \
  go \
  gpgme-devel \
  libassuan-devel \
  libgpg-error-devel \
  libseccomp-devel \
  libselinux-devel \
  pkgconfig \
  make \
  runc

git clone https://github.com/containers/conmon
cd conmon
make
sudo make install


#add conman and copy few binary
echo "PATH=$PWD/conman/bin:$PATH" >> /etc/sysconfig/crio
#
cp /usr/bin/pinns conmon/bin/
cp /usr/bin/nsenter conmon/bin/
cp /usr/bin/runc conmon/bin/
