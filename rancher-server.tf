provider "aws" {
  region = "eu-west-1"
}
 
resource "aws_instance" "devops-rancher-server" {
  provisioner "chef" {
    server_url = "https://api.opscode.com/organizations/my-org"
    secret_key = "~/.chef/encrypted_data_bag_secret"
    validation_client_name = "my-validator"
    validation_key = "~/.chef/my-validator.pem"
    node_name = "devops-rancher-server"
    environment = "development"
    run_list = [ "role[base]", "recipe[myorg-docker::docker-server]" ]
    connection {
      user = "ubuntu"
      key_file = "~/.ssh/rancher-machine.pem"
      agent = false
    }
  }
  tags {
      Name = "devops-rancher-server"
  }
  instance_type = "m3.large"
  availability_zone = "eu-west-1c"
  ami = "ami-47a23a30"
  key_name = "rancher-machine"
  associate_public_ip_address = true
  vpc_security_group_ids = [ "sg-946cc3f0" ]
  subnet_id = "subnet-047f0773"
}

output "address" {
    value = "${aws_instance.devops-rancher-server.public_ip}"
}
