#EC2 jenkins-server
resource "aws_instance" "jenkins_server" {
  ami = data.aws_ami.rhel9.id
 
  subnet_id     = var.subnet_id
  security_groups = var.master_sg_id
  root_block_device {
        delete_on_termination = true
        volume_type = "gp3"
        volume_size = 50
  }
  instance_type = var.instance_type
  #  instance_market_options {
  #   market_type = "spot"
  #   spot_options {
  #     max_price = 0.0453  # 0.0031
  #   }
  # }
  tags = {
    Name = var.jenkins_server
  }
}

#EC2 jenkins-Agent
resource "aws_instance" "jenkins_agent" {
  ami = data.aws_ami.rhel9.id
 
  subnet_id     = var.subnet_id
  security_groups = var.agent_sg_id

  #EBS Volume
  root_block_device {
        delete_on_termination = true
        volume_type = "gp3"
        volume_size = 50
  }
  
  #Spot Instance
  instance_type = "t3.micro"
  #  instance_market_options {
  #   market_type = "spot"
  #   spot_options {
  #     max_price = 0.0453
  #   }
  # }
  tags = {
    Name = var.jenkins_agent
  }
}

#Records
module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  # version = "~> 3.0"

  zone_name = var.domain_name

  records = [
    {
      name    = "jenkins"
      type    = "A"
      ttl     = 1 
      records = [aws_instance.jenkins_server.public_ip]   #publicip -- jenkins_ip:8080 --jenkins opns port 8080
      allow_overwrite = true
    },
    {
      name    = "jenkins-agent"
      type    = "A"
      ttl     = 1
      records = [aws_instance.jenkins_agent.private_ip] #this is agent
      allow_overwrite = true
    }
  ]
}