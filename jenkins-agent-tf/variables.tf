#Subnet ID
variable "subnet_id" {
  type        = string
  default     = "subnet-020e28d5acdc9ff4f"
  description = "Subnet ID"
}


#SG
variable "sg_id" {
  type = list(string)
  default = ["sg-0f487d954cbe820ef"]
}

#Instance type
variable "instance_type" {
    default = "t3.small"
}

#Zone NAme
variable "domain_name" {
    default = "telugudevops.online"
}

variable "jenkins_agent" {
    default ="jenkins-agent"
}

variable "jenkins_server" {
    default ="jenkins-server"
}