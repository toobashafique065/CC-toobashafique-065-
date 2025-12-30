# Create Key Pair
resource "aws_key_pair" "this" {
  key_name   = "${var.env_prefix}-${var.instance_name}-${var.instance_suffix}"
  public_key = file(var.public_key)
}

# Launch EC2 Instance
resource "aws_instance" "this" {
  ami                         = "ami-05524d6658fcf35b6"  # Replace with Amazon Linux 2023 AMI
  instance_type               = var.instance_type
  availability_zone           = var.availability_zone
  subnet_id                   = var.subnet_id
  key_name                    = aws_key_pair.this.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [var.security_group_id]

  user_data = file(var.script_path)

  tags = merge(var.common_tags, {
    Name = "${var.env_prefix}-${var.instance_name}-${var.instance_suffix}"
  })
}
