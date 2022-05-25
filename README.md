# Techpet DevOps challenge Part 2

## Jenkins-packer-deployment

For this exercise follow the instructions below.


## Instruction
1. Fork this repo.
2. Deploy Jenkins to an EC2 (with or without docker).
3. After successfully Deploying Jenkins, bake the image with Hashicorp Packer.
4. Deploy the baked custom AMI to an EC2.
5. For each of the proccesses above provide screenshots
6. Organize your code.
7. write a proper Readme.Md to explain your choices and the process.




## Part 1

### Deploy Jenkins to an EC2 (without docker)

In this section, we are going to install Jenkins without docker on an ec2 instance with the following commands.


- Sign in to your AWS [console](https://us-east-1.console.aws.amazon.com) and go to the AWS Services tab at the top left corner.

- Select EC2 from the list of services or simply type EC2 in the search box.

- Click on launch instance and complete the following fields:
 
  i. Enter a name for your instance e.g Jenkins Server
  
  ii. Select a base image for your instance e.g Ubuntu (ensure it is free tier eligible).

  iii. Create a new key pair for ssh access by clicking on "create new pair".
  
  iv. Enable SSH traffic by checking the box in Network settings.

  v. Click on Launch Instance to begin creation.

- Go to your ec2 dashboard to view your instance details

- Log in via SSH to your instance
  ```bash
   ssh -i "key" ec2-user@publicip
  ```

- Update the system's APT cache repository
  ```bash
   sudo apt update -y
  ```
- Install Open Java Developement Kit
  ```bash
   sudo apt install openjdk-11-jdk -y
  ```
- Verify that java is installed
  ```bash
   java --version
  ```
## Installation of Jenkins
- Add GPG keys
  ```bash
   wget -p -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
  ```

- After adding GPG keys, add the Jenkins package address to the sources list by typing the command given below:
  ```bash
   sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
  ```
- Update the system's APT cache repository
  ```bash
   sudo apt update -y
  ```
- Now, Install Jenkins
  ```bash
   sudo apt install jenkins -y
  ```
    Jenkins has installed successfully, Let's start and configure the server with the following command:

   ```bash
    sudo systemctl start jenkins.service && sudo systemctl status jenkins.service
   ```

## Set Up Jenkins
To set up Jenkins, type your domain name or IP address along with port 8080 in the browser’s address bar, and you should have the Unlock Jenkins page asking for a password, like the shown picture below.
<figure>
<img src="https://linuxhint.com/wp-content/uploads/2017/12/How-to-Install-Jenkins-on-Ubuntu-16.png" alt="Trulli" style="width:70%">
<figcaption align="right"><b>Fig.1 Jenkins Installation on Ubuntu </b></figcaption>
</figure>

<br/>



You can get the password from the given location using the cat command in the terminal. The command for getting the password would be like this:

   ```bash
    sudo cat /var/lib/jenkins/secrets/initialAdminPassword
   ```
 This command will print the password straight out and you can copy and paste it into the password field on the Jenkins Unlock screen and click on the “Continue” button.

It will navigate you to the next screen where it will ask for either “install the suggested plugins” or “select the plugins of your choice”.
<figure>
<img src="https://linuxhint.com/wp-content/uploads/2017/12/How-to-Install-Jenkins-on-Ubuntu-19.png" alt="Trulli" style="width:100%">
<figcaption align = "center"><b>Fig.2 Jenkins Installation on Ubuntu </b></figcaption>
</figure>

Select the “Install suggested plugins”. On the click, it will start installing the default plugins.

<figure>
<img src="https://linuxhint.com/wp-content/uploads/2017/12/How-to-Install-Jenkins-on-Ubuntu-20.png" alt="Trulli" style="width:100%">
<figcaption align = "center"><b>Fig.3 Jenkins Installation on Ubuntu </b></figcaption>
</figure>

After the successful installation of plugins, it will ask for the setting of the admin user’s user name, password, and email address.
<figure>
<img src="https://linuxhint.com/wp-content/uploads/2017/12/21-1.png" alt="Trulli" style="width:100%">
<figcaption align = "center"><b>Fig.4 Jenkins Installation on Ubuntu </b></figcaption>
</figure>



Provide the required input fields and hit the “Save and Continue” button.

<figure>
<img src="https://linuxhint.com/wp-content/uploads/2017/12/How-to-Install-Jenkins-on-Ubuntu-22.png" alt="Trulli" style="width:100%">
<figcaption align = "center"><b>Fig.4 Jenkins Installation on Ubuntu </b></figcaption>
</figure>

Next, it will navigate you to a page for configuring the Jenkins URL. 

<figure>
<img src="https://linuxhint.com/wp-content/uploads/2017/12/How-to-Install-Jenkins-on-Ubuntu-23.png" alt="Trulli" style="width:100%">
<figcaption align = "center"><b>Fig.5 Jenkins Installation on Ubuntu </b></figcaption>
</figure>

For now, go with the default auto-generated URL and click on the “Save and Finish” button in the bottom right corner.

On the completion of the Jenkins setup, you can have the screen with the success message “Jenkins is ready!”, as shown below. 

<figure>
<img src="https://linuxhint.com/wp-content/uploads/2017/12/How-to-Install-Jenkins-on-Ubuntu-24.png" alt="Trulli" style="width:100%">
<figcaption align = "center"><b>Fig.6 Jenkins Installation on Ubuntu </b></figcaption>
</figure>


##  Part 2

### Create an AMI with Harshicorp Packer

In this section, we are going to walk through the process of creating an Amazon Machine Image that consists of a base OS of Ubuntu 20.04, Java Development Kit and Jenkins using Harshicorp Packer.

To get started, we have to install Harshicorp Packer. Packer can be installed on Windows, Linux and Mac. for more information, visit the official Packer [website](https://learn.hashicorp.com/tutorials/packer/get-started-install-cli).

I will walk you through the process for installing Packer on Linux.

- Add the HashiCorp GPG key.

  ```bash
   curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
  ``` 
- Add the official HashiCorp Linux repository.

  ```bash
   sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
  ``` 

- Update and Install

  ```bash
   sudo apt-get update && sudo apt-get install packer
  ``` 
After installing Packer, verify the installation worked by opening a new command prompt or console, and checking that packer is available:


```bash
$ packer

Usage: packer [--version] [--help] <command> [<args>]

Available commands are:
    build           build image(s) from template
    console         creates a console for testing variable interpolation
    fix             fixes templates from old versions of packer
    fmt             Rewrites HCL2 config files to canonical format
    hcl2_upgrade    transform a JSON template into an HCL2 configuration
    init            Install missing plugins or upgrade plugins
    inspect         see components of a template
    validate        check that a template is valid
    version         Prints the Packer version
```


### Writing a Packer Template

A Packer template is a configuration file that defines the image you want to build and how to build it. Packer templates use the Hashicorp Configuration Language (HCL).

Create a new directory named packer_jenkins. This directory will contain our Packer template for this task.
 ```bash
   mkdir packer_jenkins
  ``` 

Navigate into the directory
   ```bash
     cd  packer_jenkins
  ``` 

Create a file aws-jenkins.pkr.hcl, add the following HCL block to it, and save the file.

  

```bash
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
```
This Packer template  builds an AWS Ubuntu AMI pre-bundled with Java and Jenkins. In the following sections, we shall  review each block of this template in more detail.

### Packer Block


```bash
packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}
  ```
The packer {} block contains Packer settings, including specifying a required Packer version.

In addition, you will find required_plugins block in the Packer block, which specifies all the plugin required by the template to build your image. Even though Packer is packaged into a single binary, it depends on plugins for much of its functionality. Some of these plugins, like the Amazon AMI Builder (AMI builder) which you will to use, are built, maintained, and distributed by HashiCorp but anyone can write and use plugins.

### Source Block


```bash
source "amazon-ebs" "ubuntu" {
  ami_name      = "learn-packer-linux-aws"
  instance_type = "t2.micro"
  region        = "us-west-2"
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

  ```
The source block configures a specific builder plugin, which is then invoked by a build block. Source blocks use builders and communicators to define what kind of virtualization to use, how to launch the image you want to provision, and how to connect to it. Builders and communicators are bundled together and configured side-by-side in a source block.

A source block has two important labels: a builder type and a name. These two labels together will allow us to uniquely reference sources later on when we define build runs.

In the example template, the builder type is amazon-ebs and the name is ubuntu

### Build Block


```bash
build {
  sources = [
    "source.amazon-ebs.ubuntu"
  ]
}
  ```
The build block defines what Packer should do with the EC2 instance after it launches.

In the example template, the build block references the AMI defined by the source block above (source.amazon-ebs.ubuntu).

### Provisioners

```bash

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
  ```

Provisioners are components of Packer that install and configure software within a running machine prior to that machine being turned into a static image. They perform the major work of making the image contain useful software.

In our case, we have included various bash commands that will enable us install Jenkins alongside its dependencies i.e Java.

```bash
"echo set debconf to Noninteractive", 
"echo 'debconf debconf/frontend select Noninteractive' | sudo debconf-set-selections",
  ```
These commands will enable us run our bash commands non-interactively with scripts. This is useful because our installations are being executed with packer, we aren't installing from the machine's terminal.


```bash
"sudo apt install -y openjdk-11-jdk",
"java --version"
  ```
These commands are used to install Java and also verify that it installed correctly.

```bash
 "wget -p -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -",
 "sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'",
 "sudo apt-get update -y",
 "sudo apt-get install jenkins -y",
  ```
These commands are used to install Jenkins alongside its GPG keys.

## Building our Packer Image
With our packer template setup, we shall proceed to building our image. To begin, complete the following procedures:

- Initialize your Packer configuration.
  ```bash
    packer init .
  ```
   You can also make sure your configuration is syntactically valid and internally consistent by using the packer validate command. If Packer detects any invalid configuration, Packer will print out the file name, the error type and line number of the invalid configuration. The example configuration provided above is valid, so Packer will return nothing.

- Validate your Packer configuration.
  ```bash
    packer validate .
  ```

- Build Packer Image
  ```bash
    packer build aws-jenkins.pkr.hcl
  ```
   Packer will begin the build process, this might take a while depending on your network speed and packages required to download.  Packer will print output similar to what is shown below when the build is complete.

Visit the [AWS](https://us-west-2.console.aws.amazon.com/ec2/v2/home?region=us-west-2#Images:visibility=owned-by-me;search=learn-packer-linux-aws;sort=name) Image page to verify that your image has been deployed successfully.


## Task 3: Deploy the AMI image to EC2

In this section will shall spin up an EC2 instance with our built image.

- Visit the [AWS](https://us-west-2.console.aws.amazon.com/ec2/v2/home?region=us-west-2#Images:visibility=owned-by-me;search=learn-packer-linux-aws;sort=name) AMI page on your dashboard

- Select the desired image and click on launch instance from AMI

- Fill in the required fields: Name, security group, key pair and networking.

- Finally, click on Launch Instance. Your image should now successfully spin up an EC2 instance.

## Summary
 We successfully deployed Jenkins on AWS and also built an AMI with Packer that is pre-bundled with Jenkins.
## References

- [Introduction to Packer](https://learn.hashicorp.com/tutorials/packer/aws-get-started-build-image?in=packer/aws-get-started)
- [Introduction to Pcker provisioners](https://learn.hashicorp.com/tutorials/packer/aws-get-started-provision)
- [Getting started with Jenkins](https://www.digitalocean.com/community/tutorials/how-to-install-jenkins-on-ubuntu-20-04)
