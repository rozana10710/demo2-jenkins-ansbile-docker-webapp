#!/bin/bash
set -euxo pipefail

hostnamectl set-hostname SLAVE
echo "SLAVE" >> /etc/hosts

export DEBIAN_FRONTEND=noninteractive

# Update and upgrade base system
apt-get update -y
apt-get upgrade -y

# Base utilities and prerequisites
apt-get install -y \
  software-properties-common \
  apt-transport-https \
  ca-certificates \
  curl \
  gnupg \
  lsb-release

# Install OpenJDK 17 (for Jenkins agent)
apt-get install -y openjdk-17-jdk

# Install Ansible
add-apt-repository --yes --update ppa:ansible/ansible
apt-get update -y
apt-get install -y ansible

# Install Docker CE
install -d -m 0755 /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

CODENAME="$(lsb_release -cs)"
ARCHITECTURE="$(dpkg --print-architecture)"

echo "deb [arch=${ARCHITECTURE} signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu ${CODENAME} stable" > /etc/apt/sources.list.d/docker.list

apt-get update -y
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Enable and start services
systemctl enable docker
systemctl start docker
# Ensure SSH server is enabled and running (usually present on cloud images)
if systemctl list-unit-files | grep -q '^ssh\.service'; then
  systemctl enable ssh || true
  systemctl restart ssh || true
fi

# Add default login user to docker group (UID 1000 or fallback to ubuntu)
DEFAULT_USER="$(getent passwd 1000 | cut -d: -f1 || true)"
if [ -z "$DEFAULT_USER" ]; then
  DEFAULT_USER="ubuntu"
fi
usermod -aG docker "$DEFAULT_USER" || true

# Print versions for diagnostics
java -version || true
ansible --version || true
docker --version || true