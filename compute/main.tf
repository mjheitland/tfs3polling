#--- compute/main.tf

#--- key pair
resource "aws_key_pair" "keypair" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

#--- data sources

data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
  }

  filter {
      name   = "root-device-type"
      values = ["ebs"]
    }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }  
}  

#--- provider
data "template_file" "userdata_provider" {
  template = file("${path.module}/userdata_provider.tpl")
  vars = {
    server_name = "provider"
  }
}

resource "aws_instance" "provider" {
  instance_type           = "t3.micro"
  ami                     = data.aws_ami.amazon-linux-2.id
  key_name                = aws_key_pair.keypair.id
  subnet_id               = var.subpub1_id
  vpc_security_group_ids  = [var.sgpub1_id]
  user_data               = data.template_file.userdata_provider.*.rendered[0]
  tags = { 
    Name = format("%s_provider", var.project_name)
    project_name = var.project_name
  }
}

#--- Consumer
data "template_file" "userdata_consumer" {
  template = file("${path.module}/userdata_consumer.tpl")
  vars = {
    server_name = "consumer"
  }
}
resource "aws_instance" "consumer" {
  instance_type           = "t3.micro"
  ami                     = data.aws_ami.amazon-linux-2.id
  key_name                = aws_key_pair.keypair.id
  subnet_id               = var.subpub1_id
  vpc_security_group_ids  = [var.sgpub1_id]
  user_data               = data.template_file.userdata_consumer.*.rendered[0]
  tags = { 
    Name = format("%s_consumer", var.project_name)
    project_name = var.project_name
  }
}
