packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.8"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "amazon-linux" {
  ami_name      = "learn-packer-linux-aws"
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
    provisioner "shell" {
        environment_vars = [
            "FOO=hello world",
        ]
        #inline = [
        #    "echo Baking AMI images with Packer",
        #]

        script = "./scripts/setup.sh"
    }

}
