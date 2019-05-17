# Configure the AWS Provider
provider "aws" {
  access_key = "your aws access key"
  secret_key = "your aws secret key"
  region     = "us-west-2"
}

resource "aws_instance" "web" {
  ami             = "ami-005bdb005fb00e791"
  key_name        = "chefws"
  instance_type   = "t2.micro"
  security_groups = ["jenkins"]

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = "${file("./chefws.pem")}"
  }

  provisioner "remote-exec" {
    "inline" = [
      "sudo apt update -y",
      "sudo apt install git -y",
      "sudo apt install apache2 -y"
    ]
  }
}
