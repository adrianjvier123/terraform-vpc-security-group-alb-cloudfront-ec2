resource "aws_db_subnet_group" "RDS_subnet_grp" {
  subnet_ids = ["${var.private_data_subnet_az1_id}", "${var.private_data_subnet_az2_id}"]
}

#create db
resource "aws_db_instance" "db_data" {
  allocated_storage    = 10
  db_name              = "mydb"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  username             = "foo"
  password             = "foobarbaz"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  vpc_security_group_ids = [var.db_security_group_id]
  db_subnet_group_name   = aws_db_subnet_group.RDS_subnet_grp.id
}