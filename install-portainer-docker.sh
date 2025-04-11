#!/bin/bash

# Step I: Remove old Docker-related packages
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do
    echo "Removing package: $pkg"
    sudo apt-get remove -y $pkg
done

# Step II: Update package lists
echo "Updating package lists..."
sudo apt update

# Step III: Upgrade packages
echo "Upgrading installed packages..."
sudo apt upgrade -y

# Step IV: Install dependencies
echo "Installing required dependencies..."
sudo apt install -y ca-certificates curl

# Step V: Create keyrings directory
echo "Creating Docker keyrings directory..."
sudo install -m 0755 -d /etc/apt/keyrings

# Step VI: Download Docker GPG key
echo "Downloading Docker GPG key..."
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc

# Step VII: Set permissions on Docker GPG key
echo "Setting permissions on Docker GPG key..."
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Step VIII: Add docker repo
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update

# Step IX: Install Docker packages
echo "Installing Docker and related packages..."
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Step X: Create 'docker' group if not exists
echo "Creating 'docker' group..."
sudo groupadd docker || echo "Group 'docker' already exists"

# Step XI: Add current user to 'docker' group
echo "Adding $USER to 'docker' group..."
sudo usermod -aG docker $USER

# Step XII: Clone the repository
echo "Cloning repository..."
git clone https://github.com/brunofaraujo/portainer-docker.git portainer

# Step XIII: Cd into script directory
cd portainer || { echo "Failed to cd into portainer"; exit 1; }

# Step XIV: Run docker compose up
echo "Starting Docker Compose..."
sudo docker compose up -d

echo "Script completed."
