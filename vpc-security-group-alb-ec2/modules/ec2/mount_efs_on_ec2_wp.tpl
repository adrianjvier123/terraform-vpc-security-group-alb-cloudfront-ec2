#!/bin/bash
sleep 5m
sudo su
sudo yum install httpd php git -y -q
sudo systemctl start httpd
sudo systemctl enable httpd
#sudo yum -y install nfs-utils -y   # Amazon ami has pre installed nfs utils
dnsefs="${efs_dns}"
sudo mount -t nfs -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport $dnsefs:/  /var/www/html
sudo chmod go+rw /var/www/html
sudo git clone https://github.com/website-template/html5-simple-personal-website.git /var/www/html