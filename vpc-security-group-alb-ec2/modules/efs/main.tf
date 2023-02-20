resource "aws_efs_file_system" "efs" {
  creation_token = "my-efs"

  tags = {
    Name = "MyProduct"
  }
}

resource "aws_efs_mount_target" "mount" {
  file_system_id = aws_efs_file_system.efs.id
  subnet_id      = var.public_subnet_az1_id
  security_groups = [var.sg_allow_tls_id]

}

resource "aws_efs_mount_target" "mount_2" {
  file_system_id = aws_efs_file_system.efs.id
  subnet_id      = var.public_subnet_az2_id
  security_groups = [var.sg_allow_tls_id]
}

#inspirado en https://github.com/Apeksh742/EFS_with_terraform/blob/master/main.tf