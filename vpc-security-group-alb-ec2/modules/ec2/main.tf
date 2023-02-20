# change USERDATA varible value after grabbing RDS endpoint info
data "template_file" "user_data" {
  template = file("../modules/ec2/user_data.tpl")
  vars = {
  efs_dns = var.efs_dns_name
  }
}
# change USERDATA varible value after grabbing RDS endpoint info
data "template_file" "user_data_2" {
  template = file("../modules/ec2/mount_efs_on_ec2_wp.tpl")
    vars = {
  efs_dns = var.efs_dns_name
  }
}
resource "aws_instance" "wp" {
  depends_on = [var.efs_mount_target]
  ami                       = var.ami
  subnet_id                 = var.public_subnet_az1_id
  instance_type             = var.instance_type
  key_name = "myKey"
  associate_public_ip_address = "true"
  vpc_security_group_ids = [var.sg_allow_tls_id]
  user_data = data.template_file.user_data_2.rendered
  tags = {
     Name = "WEB1"
  } 
}

resource "aws_instance" "wp2" {
  depends_on = [var.efs_mount_2_target]
  ami                       = var.ami
  subnet_id                 = var.public_subnet_az2_id
  instance_type             = var.instance_type
  key_name = "myKey"
  associate_public_ip_address = "true"
  vpc_security_group_ids = [var.sg_allow_tls_id]
  user_data = data.template_file.user_data.rendered
  # user_data = <<EOF
  #    #! /bin/bash
  #    sleep 5m
	# 	 sudo su
  #    sudo yum install httpd php git -y -q
  #    sudo systemctl start httpd
  #    sudo systemctl enable httpd
  #    #sudo yum -y install nfs-utils -y   # Amazon ami has pre installed nfs utils
  #    sudo mount -t nfs -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${aws_efs_file_system.efs.dns_name}:/  /var/www/html
  #    #echo ${aws_efs_file_system.efs.dns_name}:/ /var/www/html nfs4 defaults,_netdev 0 0  | sudo cat >> /etc/fstab 
  #    sudo chmod go+rw /var/www/html
	# EOF
  tags = {
     Name = "WEB2"
  }
     provisioner "local-exec" {
   command = "echo ${var.efs_dns_name} > dnsfsP3.txt"
  }
}

resource "tls_private_key" "pk" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "kp" {
  key_name   = "myKey"       # Create a "myKey" to AWS!!
  public_key = tls_private_key.pk.public_key_openssh
}

resource "local_file" "ssh_key" {
  filename = "${aws_key_pair.kp.key_name}.pem"
  content = tls_private_key.pk.private_key_pem
}

resource "local_file" "ip" {
  filename = "publicipec2es.txt"
  content = aws_instance.wp.public_ip
}

# resource "null_resource" "configure_nfss" {
#   depends_on = [aws_efs_mount_target.mount]
#    connection {
#     type     = "ssh"
#     user     = "ec2-user"
#     private_key = tls_private_key.pk.private_key_pem
#     host     = aws_instance.ec2_efs.public_ip
#    }
#   provisioner "remote-exec" {
#     inline = [
#       "sudo su",
#       "sudo yum install httpd php git -y -q ",
#       "sudo systemctl start httpd",
#       "sudo systemctl enable httpd",
#       "sudo yum -y install nfs-utils -y",     # Amazon ami has pre installed nfs utils
#       "sudo mount -t nfs -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${aws_efs_file_system.efs.dns_name}:/  /var/www/html",
#       "echo ${aws_efs_file_system.efs.dns_name}:/ /var/www/html nfs4 defaults,_netdev 0 0  | sudo cat >> /etc/fstab " ,
#       "sudo chmod go+rw /var/www/html",
#       "sudo git clone https://github.com/Apeksh742/EC2_instance_with_terraform.git /var/www/html",
#     ]
#   }
# }

