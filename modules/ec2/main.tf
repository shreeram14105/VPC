locals {
  nginx_userdata = <<-EOF
#!/bin/bash
yum install nginx -y
systemctl start nginx
systemctl enable nginx
EOF

  tomcat_userdata = <<-EOF
#!/bin/bash
yum install java-1.8.0-openjdk -y
yum install tomcat -y
systemctl start tomcat
systemctl enable tomcat
EOF
}

resource "aws_instance" "this" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.sg_id]
  key_name                    = var.key_name
  associate_public_ip_address = var.associate_public

  user_data = var.server_type == "nginx" ? local.nginx_userdata : local.tomcat_userdata
}
