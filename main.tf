provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "ubuntu_instance" {
  ami           = "ami-0866a3c8686eaeeba" 
  instance_type = "t2.micro"
  key_name      = "Nasibademo.pem" 

  # User data script to install Ansible and run a playbook
  user_data = <<-EOF
    #!/bin/bash
    sudo apt update
    sudo apt install -y ansible
    echo "
    - hosts: localhost
      tasks:
        - name: Ensure Git is installed
          apt:
            name: git
            state: present
        - name: Clone a Git repository (Optional)
          git:
            repo: 'https://github.com/your-repo.git'
            dest: /home/ubuntu/repo
    " > /home/ubuntu/playbook.yml
    ansible-playbook /home/ubuntu/playbook.yml
  EOF

  tags = {
    Name = "Ubuntu24.04-Instance"
  }

  # Allow inbound SSH connections (port 22)
  security_groups = ["default"]
}

output "instance_public_ip" {
  value = aws_instance.ubuntu_instance.public_ip
}