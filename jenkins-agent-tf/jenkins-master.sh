#!/bin/bash

USER_ID=$(id -u)

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

#jenkins installation
sudo curl -o /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo

sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
# sudo yum upgrade
# Add required dependencies for the jenkins package
sudo yum install fontconfig java-17-openjdk -y 
sudo yum install jenkins -y
sudo systemctl daemon-reload
sudo systemctl enable jenkins
sudo systemctl start jenkins
sudo systemctl status jenkins
VALIDATE $? "Jenkins Installation"