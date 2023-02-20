resource "aws_security_group" "sg_allow_tls" {
  name        = "sg_allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    #security_groups = [aws_security_group.sg_alb_tls.id]
  }
  ingress {
    description = "SSH from VPC 1"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_public_ip_1]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "sg_allow_tls_ssh_ec2_ecopetrol"
  }
}

# #add rule to sg
# resource "aws_security_group_rule" "ssh" {
#   type = "ingress"
#   from_port = 22
#   to_port = 22
#   protocol = "tcp"
#   cidr_blocks = ["0.0.0.0/0"]

#   security_group_id = aws_security_group.sg_allow_tls.id
# }
