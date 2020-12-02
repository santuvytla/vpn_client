output "dev_ip" {
  value = aws_instance.dev.public_ip
}
output "dev_id" {
  value = aws_instance.dev.id
}
/*
output "dev1_ip" {
  value = aws_instance.dev1.public_ip
}
output "dev1_id" {
  value = aws_instance.dev1.id
}
*/
