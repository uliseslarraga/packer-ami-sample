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
  ami_name      = "learn-packer-linux-aws-2"
  instance_type = "t2.micro"
  region        = "us-east-2"
  source_ami_filter {
    filters = {
      name                = "al2023-ami-2023.*.*-kernel-6.1-x86_64"
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

}
