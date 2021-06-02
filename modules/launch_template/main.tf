# locals {
#   user_data = <<-EOT
#               #!/bin/bash
#               host=$(hostname)
#               apt update -y
#               apt install apache2 -y
#               systemctl start apache2
#               echo <html><body>Syed Iqbal  web server - $host</body></html>  > /var/www/html/index.html
#               EOT
# }

locals {
user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install httpd -y
              systemctl start httpd
              bash -c 'echo Syed Iqbal Web Server > /var/www/html/index.html'
              EOF
}


resource "aws_launch_template" "rs-asg-lt" {
  name_prefix   = var.name_prefix
  image_id      = var.image_id
  instance_type = var.instance_type

  network_interfaces {
    associate_public_ip_address = true
    subnet_id                   = var.subnet_id
    security_groups = [var.security_group_id]
  }
  user_data              = base64encode(local.user_data)
  
  lifecycle {
    create_before_destroy = true
  }
}