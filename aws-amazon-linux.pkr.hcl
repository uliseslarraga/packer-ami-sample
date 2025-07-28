packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.8"
      source  = "github.com/hashicorp/amazon"
    }
    ansible = {
      version = "~> 1"
      source = "github.com/hashicorp/ansible"
    }
  }
}

source "amazon-ebs" "amazon-linux" {
  ami_name          = "python-flask-app"
  instance_type     = "c8g.medium"
  region            = "" #put your region here
  vpc_id            = "" #put your vpc here
  subnet_id         = "" #put your public subnet here
  source_ami_filter {
    filters = {
      name                = "al2023-ami-2023*-kernel-6.1-arm64"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["amazon"]
  }
  ssh_username = "ec2-user"
}

build {
    name = "learn-packer"
    sources = [
      "source.amazon-ebs.amazon-linux"
    ]
    provisioner "ansible" {
      command = "ansible-playbook"
      playbook_file = "./ansible/playbooks/webapp.yml"
      extra_arguments = [ "--scp-extra-args", "'-O'" ]
      user = "ec2-user"
    }
    provisioner "file" {
      source = "config/cloudwatch/config.json"
      destination = "/tmp/config.json"
    }
    provisioner "shell" {
      inline = ["sudo mv /tmp/config.json /opt/aws/amazon-cloudwatch-agent/bin/"]
    }

}
