#!/bin/bash

set -e

# Step 1: Update Package Repositories
read -p "⚠️ Do you want to upgrade the system packages? (y/N): " upgrade_choice
if [[ "$upgrade_choice" =~ ^[Yy]$ ]]; then
    read -p "⚠️ Do you want to upgrade the system packages? (y/N): " upgrade_choice
if [[ "$upgrade_choice" =~ ^[Yy]$ ]]; then
    sudo apt update --allow-insecure-repositories -y && sudo apt upgrade -y
else
    echo "Skipping system upgrade..."
fi
else
    echo "Skipping system upgrade..."
fi

# Step 2: Install Dependencies
sudo apt install -y ca-certificates curl gnupg

# Function to check if a command exists
command_exists() {
    command -v "$1" &>/dev/null
}

# Function to install Docker 🐋
install_docker() {
    if command_exists docker; then
        echo "🐋 Docker is already installed. Skipping installation."
        return
    fi
    echo -e "\n🐋 Installing Docker...\n"
    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo tee /etc/apt/keyrings/docker.asc > /dev/null
    sudo chmod a+r /etc/apt/keyrings/docker.asc
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt update --allow-insecure-repositories -y
    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose docker-compose-plugin
    sudo systemctl enable --now docker
    sudo usermod -aG docker $USER
    echo "🔄 Please log out and log back in to apply the group membership changes."
    echo "✅ Docker & Docker Compose installed successfully!"
    echo "🔄 Please log out and log back in to apply the group membership changes."
}

# Function to install Jenkins 🤖
install_jenkins() {
    if systemctl is-active --quiet jenkins; then
        echo "🤖 Jenkins is already installed. Skipping installation."
        return
    fi
    echo -e "\n🤖 Installing Jenkins...\n"
    wget -q -O - https://pkg.jenkins.io/debian/jenkins.io-2023.key | sudo tee /etc/apt/keyrings/jenkins-keyring.asc > /dev/null
    sudo chmod a+r /etc/apt/keyrings/jenkins-keyring.asc
    echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list
    sudo apt update --allow-insecure-repositories
    sudo apt install -y jenkins
    sudo systemctl enable --now jenkins
    if ! systemctl is-active --quiet jenkins; then
        echo "❌ Jenkins failed to start. Check logs with: sudo journalctl -xeu jenkins"
    fi
    sudo chown -R jenkins:jenkins /var/lib/jenkins/
    sudo chmod -R 755 /var/lib/jenkins/
    echo -e "💡 Jenkins installed successfully!\n"
}

# Function to install OpenJDK 17 💻
install_openjdk() {
    if command_exists java; then
        echo "💻 OpenJDK 17 is already installed. Skipping installation."
        return
    fi
    echo -e "\n💻 Installing OpenJDK 17...\n"
    sudo apt update --allow-insecure-repositories
    sudo apt install -y openjdk-17-jdk
    echo -e "🚀 Java installed!\n"
    java -version
}

# Function to install Kubernetes ☸️
install_kubernetes() {
    if command_exists kubectl; then
        echo "☸️ Kubernetes is already installed. Skipping installation."
        return
    fi
    echo -e "\n☸️ Installing Kubernetes...\n"
    sudo apt update --allow-insecure-repositories
    sudo apt install -y apt-transport-https ca-certificates curl
    curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo tee /etc/apt/keyrings/kubernetes-archive-keyring.gpg > /dev/null
    sudo chmod a+r /etc/apt/keyrings/kubernetes-archive-keyring.gpg
    echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
    sudo apt update --allow-insecure-repositories
    sudo apt install -y kubelet kubeadm kubectl
    sudo systemctl enable --now kubelet
    echo -e "🚀 Kubernetes installation completed!\n"
}

# Display options to user
echo -e "\n🛠️ Welcome to the Jenkins, Docker & Kubernetes Installer!\n"
echo -e "What would you like to install?\n"
echo -e "1) 🐋 Docker"
echo -e "2) 🤖 Jenkins"
echo -e "3) 💻 OpenJDK 17"
echo -e "4) ☸️ Kubernetes"
echo -e "5) Install All"
echo -e "6) Exit\n"

while true; do
    read -p "Enter your choice (1-6): " choice
    if [[ $choice =~ ^[1-6]$ ]]; then
        break
    else
        echo "⚠️ Invalid input! Please enter a number between 1 and 6."
    fi
done

case $choice in
    1)
        install_docker
        ;;
    2)
        install_jenkins
        ;;
    3)
        install_openjdk
        ;;
    4)
        install_kubernetes
        ;;
    5)
        install_docker
        install_jenkins
        install_openjdk
        install_kubernetes
        ;;
    6)
        echo -e "👋 Exiting..."
        exit 0
        ;;
    *)
        echo -e "⚠️ Invalid option! Exiting..."
        exit 1
        ;;
esac

# Display Jenkins access URL and initial password if installed
if systemctl is-active --quiet jenkins; then
    echo -e "\n🔑 Access Jenkins at: http://localhost:8080"
    echo -e "\n🔐 Your Jenkins initial admin password:"
    sudo cat /var/lib/jenkins/secrets/initialAdminPassword
fi

echo -e "\n🚀 Installation process completed!\n"
