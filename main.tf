# Configure the AWS Provider
provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
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
