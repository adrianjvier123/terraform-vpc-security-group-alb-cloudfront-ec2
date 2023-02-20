#!/bin/bash
# sudo yum update -y
# sudo yum install -y httpd.x86_64
# sudo systemctl start httpd.service
# sudo systemctl enable httpd.service

# yum update -y
# yum install -y httpd
# systemctl start httpd
# systemctl enable httpd
# echo "<h1>Hello World from $(hostname -f)</h1>" > /var/www/html/index.html

sleep 5m
sudo su
sudo yum install httpd php git -y -q
sudo systemctl start httpd
sudo systemctl enable httpd
#sudo yum -y install nfs-utils -y   # Amazon ami has pre installed nfs utils
dnsefs="${efs_dns}"
sudo mount -t nfs -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport $dnsefs:/  /var/www/html
sudo chmod go+rw /var/www/html