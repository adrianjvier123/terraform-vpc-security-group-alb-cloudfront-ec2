resource "aws_security_group" "sg_allow_tls" {
  name        = "sg_allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    #cidr_blocks      = ["0.0.0.0/0"]
    security_groups = [aws_security_group.sg_alb_tls.id]
  }
  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "EFS mount target"
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "sg_allow_tls"
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

#security group alb
resource "aws_security_group" "sg_alb_tls" {
  name        = "sg_alb_allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "sg_alb_allow_tls"
  }
}

#security group db
resource "aws_security_group" "sg_db_to_ec2" {
  name        = "sg_db_to_ec2"
  description = "Allow traffic to db"
  vpc_id      = var.vpc_id

  ingress {
    description      = "db from ec2"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
 #   cidr_blocks      = ["0.0.0.0/0"]
    security_groups = [aws_security_group.sg_allow_tls.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg_db_to_ec2"
  }
}

resource "aws_security_group" "sg_allow_http" {
  name        = "sg_allow_tls_Jenkins"
  description = "Allow TLS inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "sg_allow_tls_Jenkins"
  }
}

#add rule ssh to sg jenkins
# resource "aws_security_group_rule" "ssh-jenkins" {
#   type = "ingress"
#   from_port = 22
#   to_port = 22
#   protocol = "tcp"
#   cidr_blocks = ["0.0.0.0/0"]

#   security_group_id = aws_security_group.sg_allow_http.id
# }