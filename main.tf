terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.81.0"
    }
  }
}
resource "aws_instance" "teflon" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = [ for s in var.instance_type : lower(s)][2]
  key_name      = var.key

  metadata_options {
    http_tokens   = "required"
    http_endpoint = "enabled"
  }

  root_block_device {
    encrypted = true
  }

  vpc_security_group_ids = [aws_security_group.elk_sg.id]

  depends_on = [aws_security_group.elk_sg]


  tags = {
    Name = "HelloDaughter"
  }
}

resource "aws_eip" "ip" {
  instance = aws_instance.teflon.id
}