#!/bin/bash

set -e  # Exit on error

echo "Detecting OS..."
OS_TYPE=$(grep -Ei 'ubuntu|amazon linux' /etc/os-release | awk -F= '{print $2}' | tr -d '"')

if echo "$OS_TYPE" | grep -q "Ubuntu"; then
    echo "Ubuntu detected. Installing Vault..."
    sudo apt update -y
    sudo apt install -y curl gpg unzip
    curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
    sudo apt update -y
    sudo apt install -y vault

elif echo "$OS_TYPE" | grep -q "Amazon Linux"; then
    echo "Amazon Linux detected. Installing Vault..."
    sudo yum install -y curl unzip
    sudo rpm --import https://rpm.releases.hashicorp.com/gpg
    sudo tee /etc/yum.repos.d/hashicorp.repo << EOM
[hashicorp]
name=HashiCorp Stable - \$basearch
baseurl=https://rpm.releases.hashicorp.com/AmazonLinux/2/\$basearch/stable
enabled=1
gpgcheck=1
gpgkey=https://rpm.releases.hashicorp.com/gpg
EOM
    sudo yum install -y vault
else
    echo "Unsupported OS detected. Exiting."
    exit 1
fi

echo "Enabling and starting Vault service..."
sudo systemctl enable vault
sudo systemctl start vault

echo "Vault installation complete!"
vault --version
