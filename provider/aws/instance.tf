resource "aws_instance" "ec2" {
  ami                    = "ami-0f2b4fc905b0bd1f1"
  instance_type          = "m4.xlarge"
  key_name               = aws_key_pair.horizon-kp.key_name
  subnet_id		 = aws_subnet.public-subnet.id
#  subnet_id              = "${aws_subnet.public-subnet.id}"

  depends_on = [
    aws_route_table_association.rtb_assoc,
  ]

  timeouts {
    create = "10m"
  }

  root_block_device {
    volume_type           = "gp2"
    volume_size           = "10"
    delete_on_termination = true
  }

  ebs_block_device {
    device_name           = "/dev/sdf"
    volume_type           = "gp2"
    volume_size           = "20"
  }

  tags = {
      Name    = "${var.owner_name}-${var.name_prefix}-ec2"
      owner   = var.owner_name
      project = var.tag_project
      enddate = var.tag_enddate
  }

}
