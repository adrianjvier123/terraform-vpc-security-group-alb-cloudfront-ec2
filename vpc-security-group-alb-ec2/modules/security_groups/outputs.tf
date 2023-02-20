output "sg_allow_tls_id" {
  value = aws_security_group.sg_allow_tls.id
}
output "sg_alb_tls_id" {
  value = aws_security_group.sg_alb_tls.id
}

output "sg_db_to_ec2_id" {
  value = aws_security_group.sg_db_to_ec2.id
}

output "sg_allow_http_id" {
  value = aws_security_group.sg_allow_http.id
}