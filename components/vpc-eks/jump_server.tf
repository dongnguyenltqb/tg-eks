resource "aws_eip" "jump" {
  vpc = true
  tags = {
    Name = format("%sJumpServerEIP", var.cluster_name)
  }
  instance = aws_instance.jump.id
}

resource "aws_instance" "jump" {
  depends_on = [
    aws_security_group.jump
  ]
  ami                    = "ami-055d15d9cfddf7bd3"
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.tf-1a-public.id
  vpc_security_group_ids = [aws_security_group.jump.id]
  iam_instance_profile   = var.jump_server_profile_role_name
  tags = {
    Name = format("%sJumpServer", var.cluster_name)
  }
  key_name = aws_key_pair.jump_key.key_name
  root_block_device {
    tags        = merge(local.tags, var.tags)
    volume_size = 20
    volume_type = "gp3"
  }
}

resource "aws_security_group" "jump" {
  name        = format("%sJumpSg", var.cluster_name)
  description = "Security group for jump server"
  vpc_id      = aws_vpc.tf-vpc.id

  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = merge(local.tags, var.tags)
}

