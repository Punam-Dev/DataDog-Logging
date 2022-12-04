resource "aws_instance" "ec2a" {
  subnet_id = var.subnet_id[0]
  ami = var.ami
  instance_type = var.instance_type
  security_groups = [var.ec2_sg]
  iam_instance_profile = var.instance_profile
  key_name = "Key-Pair-Mumbai-Machmain"
  #root_block_device {
  #  volume_size = var.ebs_root_volume_size
  #}
  # user_data_base64 = "${base64encode(local.instance-userdata)}"
}


