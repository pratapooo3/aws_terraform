# Configure the AWS Provider
provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     =
   "us-west-2"
}

resource "aws_instance" "web" {
  ami             = "ami-005bdb005fb00e791"
  key_name        = "chefws"
  instance_type   = "t2.micro"
  security_groups = ["jenkins"]
  tags {
    Name = "ubuntu_tom"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = "${file("./chefws.pem")}"
  }

  provisioner "chef" {
    environment     = "_default"
    run_list        = ["apache_cookbook::default"]
    node_name       = "ubuntu"
    server_url      = "https://manage.chef.io/organizations/srifreelancer/"
    recreate_client = true
    user_name       = "srinivasreddymula"
    user_key        = "${file("./srinivasreddymula.pem")}"
    version         = "14.10.9"
    # If you have a self signed cert on your chef server change this to :verify_none
    ssl_verify_mode = ":verify_none"
  }
}

output "webip" {
  value = "${aws_instance.web.public_ip}"
}