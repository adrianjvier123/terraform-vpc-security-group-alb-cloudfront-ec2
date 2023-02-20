resource "aws_eip" "elastic_ip_wp_totem" {
  instance = var.ec2_web_page_totem_id
  vpc      = true
}
resource "aws_eip_association" "eip_assoc_ec2_wp_totem" {
  instance_id   = var.ec2_web_page_totem_id
  allocation_id = aws_eip.elastic_ip_wp_totem.id
}

resource "local_file" "hostname" {
  filename = "hostname_static_ip_ec2_totem.txt"
  content = "http://${aws_eip.elastic_ip_wp_totem.public_dns}"
}
