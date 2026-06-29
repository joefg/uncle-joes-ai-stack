#!/usr/bin/env bash

# Update the package list to ensure we get the latest versions
sudo apt-get update

# Install prerequisite packages for Docker and NVIDIA installation
sudo apt-get install -y ca-certificates curl gnupg lsb-release ubuntu-drivers-common

# --- Install NVIDIA Drivers ---

# Automatically install the recommended NVIDIA driver for the system
sudo ubuntu-drivers autoinstall

# --- Install Docker ---

# Add Docker's official GPG key
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Set up the Docker repository
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update the package list again after adding Docker repo
sudo apt-get update

# Install Docker Engine, CLI, and Docker Compose plugin
sudo apt-get install -y docker-ce docker-ci docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# --- Install NVIDIA Container Toolkit ---

# Configure the production repository for NVIDIA Container Toolkit
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
  && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

# Update package list with the new NVIDIA repository
sudo apt-get update

# Install the NVIDIA Container Toolkit
sudo apt-get install -y nvidia-container-toolkit

# Configure Docker to use the NVIDIA runtime
sudo nvidia-container-toolkit runtime configure --runtime=docker

# Restart Docker to apply the changes
sudo systemctl restart docker
