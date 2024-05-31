# launch the ec2 instance and install website
resource "aws_instance" "ec2_instance" {
  ami                    = data.aws_ami.amzlinux2.id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_group_ids
  user_data              = file("${path.module}/apache-install.sh")

  tags = {
    Name = "${var.tag_name}"
  }
}
