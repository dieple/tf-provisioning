provider "aws" {
  region = "eu-west-1"
}
 
resource "aws_instance" "devops-openvpn" {
  provisioner "chef" {
    server_url = "https://api.opscode.com/organizations/my-org"
    secret_key = "~/.chef/encrypted_data_bag_secret"
    validation_client_name = "my-validator"
    validation_key = "~/.chef/my-validator.pem"
    node_name = "devops-openvpn"
    environment = "development"
    run_list = [ "role[base]", "recipe[myorg-openvpn]" ]
    connection {
      user = "ubuntu"
      key_file = "~/.ssh/DevOpsService.pem"
      agent = false
    }
  }
  tags {
      Name = "devops-openvpn"
  }
  instance_type = "m3.large"
  availability_zone = "eu-west-1b"
  ami = "ami-47a23a30"
  key_name = "DevOpsService"
  associate_public_ip_address = true
  #vpc_security_group_ids = [ "sg-946cc3f0" ]
  #subnet_id = "subnet-047f0773"
}

output "address" {
    value = "${aws_instance.devops-openvpn.public_ip}"
}
