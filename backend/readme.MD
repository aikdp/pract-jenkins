# Backend NodeJs Application
* Create Jenkin Master abd jenkins Agents (Both EC2 or agent Docker container)
* Install below tools Jenkins Agent (EC2)
1. Java: Jenkins is developed by java
2. Resize Configs for Agent (/ , varVol, varTem)
3. Terraform: If your are crating any infra using Terraform,then install terraform as well.
4. Docker: To build docker container
5. Nodej: As Backend we are using NODEJS, SO install nodejs.

* Once Your jenkins Master up and running. Browse:(jenkins default port is 8080) 
```
jenkins.telugudevops.online:8080
```
* Password: (RUN below command in Jenkins Master EC2)
```
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

# Install Jenkins Plugins:
1. Pipeline: Stage View: Pipeline Stages
2. Pipeline Utility Steps:     Reading files
3. AWS Credentails : Store Credentails
4. AWS steps    
5. Rebuilder    : check previous builds
6. AnsiColor    : Visualisation
7. Docker Pipeline
8. SonarQube Scanner

# Create Agent in jenkins:
* Configure Master with Agent Node. NewNode-->Name: AGNET-1, Root--> /home/ec2-user/jenkins-agent, Label: AGENT-1(U need to use same name in the jenkins pipeline, then only pipeline will run in this agent), via SSH--> ADD Credentials of user and password of EC2 or Keys.

* Before you deploy the appication, You need infra ready.

* Use terraform to infra ready or You can try using Jenkins pipelines to automatically run the upstream jobs. (VPC-CDN)



## Try Use Jenkins Agent with Docker Container or Kubernetes Pods

VMs:
--We need to maintain multiple agents for multiple projects (Nodejs, Java, Python, etc)
--if no one is scheduled jobs or not used any agents, then all resources are wasted.

Containers:
--We no need to maintain
--No resources are waste. No need to maintain multiple agents. You can just use different images for diff projects.

