# 🛠️ Jenkins, Docker & Kubernetes Installer

Welcome to the Jenkins, Docker & Kubernetes Installer! This script automates the installation of Jenkins, Docker, OpenJDK 17, and Kubernetes on your Ubuntu system. 🚀

## 📌 Features
- Installs **Docker 🐋**, **Jenkins 🤖**, **OpenJDK 17 💻**, and **Kubernetes ☸️**
- Checks if the application is already installed before proceeding
- Ensures correct **permissions and dependencies** are set up
- Guides the user with interactive prompts

## 📖 Installation Guide

### **Prerequisites**
Ensure your system meets the following requirements:
- **Operating System:** Ubuntu 20.04/22.04
- **Permissions:** Root or sudo access
- **Network Access:** Internet connectivity for package installation

### **Clone the Repository**
```bash
sudo apt install -y git
cd /opt
sudo git clone https://github.com/Lalatenduswain/Install-Jenkins-Docker.git
cd Install-Jenkins-Docker
```

### **Run the Installer**
```bash
sudo chmod +x install-jenkins-docker.sh
sudo ./install-jenkins-docker.sh
```

### **Installation Options**
The script provides an interactive menu to choose what to install:
1. 🐋 Docker
2. 🤖 Jenkins
3. 💻 OpenJDK 17
4. ☸️ Kubernetes
5. Install All
6. Exit

## 📜 Script Explanation

The script performs the following steps:
1. Updates the system (optional, based on user input)
2. Installs required dependencies like `curl`, `gnupg`, and `ca-certificates`
3. Installs selected applications while checking for existing installations
4. Configures Jenkins, Docker, and Kubernetes to start automatically
5. Provides access details and initial passwords (if applicable)

## ❗ Disclaimer | Running the Script

**Author:** Lalatendu Swain | [GitHub](https://github.com/Lalatenduswain) | [Website](https://blog.lalatendu.info/)

This script is provided as-is and may require modifications based on your environment. Use it at your own risk. The author is not responsible for any damages caused by running this script.

## 💖 Support & Donations

If you find this script useful, consider supporting its development:
- **Buy Me a Coffee**: [Buy Me a Coffee](https://www.buymeacoffee.com/lalatendu.swain)
- **Patreon**: [Patreon](https://www.patreon.com/lalatenduswain)
- **PayPal**: [Donate via PayPal](https://www.paypal.com/paypalme/lalatenduswain)

## ❓ Support or Contact

Encountering issues? Submit an issue on our [GitHub Issues Page](https://github.com/Lalatenduswain/Install-Jenkins-Docker/issues).
