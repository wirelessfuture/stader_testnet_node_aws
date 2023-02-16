################################
######        EC2         ######
################################

# Ubuntu AMI resource to use
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  owners = ["099720109477"] # Canonical
}

# EC2 Instance resource
resource "aws_instance" "stader_testnet_node" {
  count                       = var.resource_count
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.stader_testnet_subnet[count.index].id
  vpc_security_group_ids      = [aws_security_group.stader_testnet_sg[count.index].id]
  key_name                    = var.keypair_name
  associate_public_ip_address = true

  root_block_device {
    delete_on_termination = true
    volume_size           = 1024
    volume_type           = "gp3"
  }

  provisioner "file" {
    source      = "../init.sh"
    destination = "/home/ubuntu/init.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/ubuntu/init.sh",
      "sudo /home/ubuntu/init.sh",
    ]
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("../key/stader-testnet-deployer-key.pem")
    host        = self.public_ip
  }

  tags = {
    Name = "stader_testnet_${count.index}"
  }

  depends_on = [
    aws_internet_gateway.stader_testnet_igw,
    aws_security_group.stader_testnet_sg
  ]
}