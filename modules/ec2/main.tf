
#key pair


resource "aws_key_pair" "auth" {
  key_name  =var.key_name
  public_key = file(var.public_key_path)
}


#dev server

resource "aws_instance" "dev" {
  instance_type = var.dev_instance_type
  ami = var.dev_ami
  tags = {
    Name = "echoworks-dev"
  }

  key_name = aws_key_pair.auth.id
  vpc_security_group_ids = [var.aws_security_group_public_id]

  subnet_id = var.aws_subnet_public_id[0]
}
/*
resource "aws_instance" "dev1" {
  instance_type = var.dev_instance_type
  ami = var.dev_ami
  tags = {
    Name = "echoworks-dev1"
  }

  key_name = aws_key_pair.auth.id
  vpc_security_group_ids = [var.aws_security_group_public_id]

  subnet_id = var.aws_subnet_public_id[1]
  user_data = file("userdata")
*/
/*
  provisioner "local-exec" {
    command = <<EOD
cat <<EOF > aws_hosts
[dev]
${aws_instance.dev.public_ip}
${aws_instance.dev1.public_ip}
EOF
EOD
  }

  provisioner "local-exec" {
    command = "sleep 3m && ansible-playbook -i aws_hosts site.yml --extra-vars='{\"rds_endpoint\": ${var.aws_rds_endpoint}}'"
  }
  
}
*/


