#!/bin/bash
set -euxo pipefail

hostnamectl set-hostname SLAVE || true
echo "SLAVE" >> /etc/hosts || true

export DEBIAN_FRONTEND=noninteractive

retry() {
  local attempts=$1; shift
  local delay=$1; shift
  local n=0
  until "$@"; do
    n=$((n+1))
    if [ $n -ge $attempts ]; then
      echo "Command failed after ${attempts} attempts: $*" >&2
      return 1
    fi
    sleep "$delay"
  done
}

# Update and upgrade
retry 5 10 apt-get update -y
retry 5 10 apt-get upgrade -y || true

# Base utilities
retry 5 10 apt-get install -y \
  software-properties-common \
  apt-transport-https \
  ca-certificates \
  curl \
  gnupg \
  lsb-release

# OpenJDK 17
retry 5 10 apt-get install -y openjdk-17-jdk

# Ansible
add-apt-repository --yes --update ppa:ansible/ansible || true
retry 5 10 apt-get update -y
retry 5 10 apt-get install -y ansible

# Docker CE
install -d -m 0755 /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

CODENAME="$(lsb_release -cs)"
ARCHITECTURE="$(dpkg --print-architecture)"
echo "deb [arch=${ARCHITECTURE} signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu ${CODENAME} stable" > /etc/apt/sources.list.d/docker.list

retry 5 10 apt-get update -y
retry 5 10 apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Enable and start Docker
systemctl enable docker || true
systemctl start docker || true

# Ensure SSH server is enabled (present on Ubuntu cloud images)
systemctl enable ssh || true
systemctl restart ssh || true

# Add default login user to docker group
DEFAULT_USER="$(getent passwd 1000 | cut -d: -f1 || true)"
if [ -z "$DEFAULT_USER" ]; then
  DEFAULT_USER="ubuntu"
fi
usermod -aG docker "$DEFAULT_USER" || true

# Diagnostics
(java -version || true) 2>&1 | tee /root/userdata-java.txt || true
(ansible --version || true) 2>&1 | tee /root/userdata-ansible.txt || true
(docker --version || true) 2>&1 | tee /root/userdata-docker.txt || true