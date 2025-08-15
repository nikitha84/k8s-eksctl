resource "aws_instance" "web" {
    ami = "ami-0b4f379183e5706b9"
    instance_type = "t3.micro"
    vpc_security_group_ids = [aws_security_group.web.id]
    subnet_id = 
    user_data = file("docker.sh")
    tags = {
    Name = "helloweb"
  }
}

resource "aws_security_group" "web" {
  name        = "web"
  description = "allow_all"
  

    ingress {
        description = "allow_all"
        from_port   = var.inbound_from_port
        to_port     = 0
        protocol    = "tcp"
        cidr_blocks = var.cidr_blocks
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
    Name = "allow_all"
  }
}