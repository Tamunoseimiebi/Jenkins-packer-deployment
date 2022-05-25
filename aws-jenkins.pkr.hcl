packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "jenkins-ec2"
  instance_type = "t2.micro"
  region        = "us-east-1"
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-focal-20.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
}

build {
  name = "jenkins-ec2"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]
  
provisioner "shell" {
    inline = [
    "echo set debconf to Noninteractive", 
    "echo 'debconf debconf/frontend select Noninteractive' | sudo debconf-set-selections",
    "sudo apt install -y openjdk-11-jdk",
    "java --version",
    "wget -p -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -",
    "sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'",
    "sudo apt-get update -y",
    "sudo apt-get install jenkins -y",
    ]
  }
    
}
    
