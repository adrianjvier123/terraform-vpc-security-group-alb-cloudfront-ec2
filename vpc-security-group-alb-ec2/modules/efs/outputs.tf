output "efs_dns_name" {
  value = aws_efs_file_system.efs.dns_name
}

output "efs_mount_target" {
  value = aws_efs_mount_target.mount
}
output "efs_mount_2_target" {
  value = aws_efs_mount_target.mount_2
}