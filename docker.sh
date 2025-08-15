#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

echo "script started executing at $TIMESTAMP" &>> $LOGFILE

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2 ... $R FAILED $N"
        exit 1
    else
        echo -e "$2 ... $G SUCCESS $N"
    fi
}

if [ $ID -ne 0 ]
then
    echo -e "$R ERROR:: Please run this script with root access $N"
    exit 1 # you can give other than 0
else
    echo "You are root user"
fi # fi means reverse of if, indicating condition end

dnf -y install dnf-plugins-core #install docker
VALIDATE $? "Installed dnf-plugins-core"

dnf config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo
VALIDATE $? "Added docker repo"

dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
VALIDATE $? "Installed docker components"

systemctl start docker
VALIDATE $? "Started docker"

systemctl enable docker
VALIDATE $? "Enabled docker"

usermod -aG docker centos
VALIDATE $? "added centos user to docker group"
echo -e "$R Logout and login again $N"

#install kubectl
curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.33.3/2025-08-03/bin/linux/amd64/kubectl
chmod +x ./kubectl
mv kubectl /usr/local/bin/kubectl
VALIDATE $? "Kubectl installation"

ARCH=amd64
PLATFORM=$(uname -s)_$ARCH   #installl eksctl
curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_$PLATFORM.tar.gz"
tar -xzf eksctl_$PLATFORM.tar.gz -C /tmp && rm eksctl_$PLATFORM.tar.gz
install -m 0755 /tmp/eksctl /usr/local/bin && rm /tmp/eksctl
sudo mv /tmp/eksctl /usr/local/bin
VALIDATE $? "eksctl installation"

sudo git clone https://github.com/ahmetb/kubectx /opt/kubectx
sudo ln -s /opt/kubectx/kubens /usr/local/bin/kubens
VALIDATE $? "kubens installation"



