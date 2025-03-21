#!/bin/bash

USER_ID=$(id -u)
ARCH=amd64
PLATFORM=$(uname -s)_$ARCH

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo "$2 is FAILED"
        exit 1
    else
        echo "$2 is SUCCESS"
     fi
}

CHECK(){
    if [ $USER_ID -ne 0 ]
    then 
        echo "Please Run this scirpt with ROOT previleges"
        exit 1
    fi
}
CHECK

#java
sudo yum install java-17-openjdk -y
VALIDATE $? "Installation of JAVA"

#docker
sudo dnf -y install dnf-plugins-core

sudo dnf config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo

sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

sudo usermod -aG docker ec2-user
sudo usermod -aG docker jenkins

sudo systemctl start docker
docker run hello-world

docker --version
VALIDATE $? "Docker installation"

#Resize Disk
lsblk

growpart /dev/nvme0n1 4
VALIDATE $? "Disk Partition"

lvextend -L +10G /dev/mapper/RootVG-homeVol
lvextend -L +10G /dev/mapper/RootVG-varVol
lvextend -l +100%FREE /dev/mapper/RootVG-varTmpVol

xfs_growfs /home
VALIDATE $? "Resize of HOME"

xfs_growfs /var/tmp
VALIDATE $? "Resize of TEMP"

xfs_growfs /var
VALIDATE $? "Resize of VAR"

#Install NodeJS
sudo dnf module disable nodejs -y
sudo dnf module enable nodejs:20 -y
sudo dnf install nodejs -y
VALIDATE $? "NodeJS installation"

#Terraform 
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
sudo yum -y install terraform
terraform -version
VALIDATE $? "Terraform Installation"

#EKSCTL
ARCH=amd64
PLATFORM=$(uname -s)_$ARCH

sudo curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_$PLATFORM.tar.gz"
sudo tar -xzf eksctl_$PLATFORM.tar.gz -C /tmp && rm eksctl_$PLATFORM.tar.gz
sudo mv /tmp/eksctl /usr/local/bin
VALIDATE $? "EKSCTL Installation"

#KUBECTL
sudo curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.32.0/2024-12-20/bin/linux/amd64/kubectl
sudo chmod +x ./kubectl
sudo mv kubectl /usr/local/bin/kubectl
VALIDATE $? "KUBECTL Installation"

#HELM
sudo curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
sudo chmod 700 get_helm.sh
sudo ./get_helm.sh
VALIDATE $? "HELM Installation of Jenkins-AGENT"