# change USERDATA varible value after grabbing RDS endpoint info
data "template_file" "user_data" {
  template = file("../modules/ec2/user_data.tpl")

}

resource "aws_instance" "web_page_totem" {
  ami                       = var.ami
  subnet_id                 = var.public_subnet_az1_id
  instance_type             = var.instance_type
  key_name = "myKey"
  associate_public_ip_address = "true"
  vpc_security_group_ids = [var.sg_allow_tls_id]
  user_data = data.template_file.user_data.rendered
  tags = {
     Name = "web_page_totem"
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
resource "local_file" "ssh_connection" {
  filename = "ssh_connection_wp_totem.txt"
  content = "ssh -i \"myKey.pem\" ec2-user@${aws_instance.web_page_totem.public_dns}"
}