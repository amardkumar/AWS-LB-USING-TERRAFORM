resource "aws_key_pair" "key_pair" {
  key_name = "mykeypair"
  public_key = "${file("mykeypair.pub")}"
  
}

resource "aws_instance" "web-server" {
  ami = "ami-06e46074ae430fba6"
  instance_type = "t2.micro"
  count = 2
  key_name= aws_key_pair.key_pair.key_name
  security_groups = ["${aws_security_group.web-server.name}"]
  user_data = <<-EOF
     #!/bin/bash
     sudo su
     yum update -y
     yum install httpd -y
     systemctl start httpd
     systemctl enable httpd
     echo "<h1>loading from $(hostname -f)..</h1>" > /var/www/html/index.html
  EOF
  tags = {
    name ="instance_alb-${count.index}"
  }
}