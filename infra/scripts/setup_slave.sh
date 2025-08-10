#!/bin/bash
set -e

# Change hostname to MASTER
hostnamectl set-hostname SLAVE
echo "SLAVE" >> /etc/hosts

# Update packages
apt-get update -y



echo "Updating system packages..."
sudo apt update && sudo apt upgrade -y

sudo apt install -y openjdk-17-jdk

echo "Installing dependencies..."
sudo apt install software-properties-common -y

echo "Adding Ansible PPA..."
sudo add-apt-repository --yes --update ppa:ansible/ansible

echo "Installing Ansible..."
sudo apt install ansible -y

echo "Ansible installation complete."
ansible --version