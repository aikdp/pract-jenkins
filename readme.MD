# Jenkins CICD
* Create Jenkins Server (EC2). Install Jenkins Commands.
* Create Jenkins Agent (EC2). Install required tools Java, terraform, docker, kubectl, eksctl, helm, etc

* Open browser, Search: <Jenkins-Server-public-ip>:8080 or create route 53 record as jenkins.telugudevops.online:8080

# Install Jenkins Plugins:
1. Pipeline Utility Steps
2. AnsiColor
3. Pipeline Stage View
4. Rebuilder
5. AWS Credentials
6. AWS Steps
7. SonarQube Scanner
8. Docker:Pipeline

# BAstion:
docker:
```
sudo dnf -y install dnf-plugins-core
sudo dnf config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo
sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
sudo systemctl start docker
sudo usermod -aG docker ec2-user
sudo docker run hello-world
docker --version
```

eksctl:

```
ARCH=amd64
PLATFORM=$(uname -s)_$ARCH

sudo curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_$PLATFORM.tar.gz"
sudo tar -xzf eksctl_$PLATFORM.tar.gz -C /tmp && rm eksctl_$PLATFORM.tar.gz
sudo mv /tmp/eksctl /usr/local/bin
```

kubectl:
```
sudo curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.32.0/2024-12-20/bin/linux/amd64/kubectl
sudo chmod +x ./kubectl
sudo mv kubectl /usr/local/bin/kubectl
```

helm:
```
sudo curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
sudo chmod 700 get_helm.sh
sudo ./get_helm.sh
````

Resize:
```
lsblk
growpart /dev/nvme0n1 4
lvextend -l +50%FREE /dev/RootVG/rootVol 
lvextend -l +50%FREE /dev/RootVG/varVol
xfs_growfs /
xfs_growfs /var
```

kubens:
```
sudo git clone https://github.com/ahmetb/kubectx /opt/kubectx
sudo ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx
sudo ln -s /opt/kubectx/kubens /usr/local/bin/kubens
```

# RUN RDS Configurations

Take Bastion(EC2) as Client (should installed eksctl, kubectl, aws configure, docker, helm, resize, etc.)
Run below commands
```
mysql -h <rds-endpoint_address> -u root -p<DB_Password>
```
EG:1
``` 
mysql -h expense-dev.czn6yzxlcsiv.us-east-1.rds.amazonaws.com -u root -pExpenseApp1
```
Eg:2
```
mysql -h mysql-dev.telugudevops.online -u root -pExpenseApp1
```

```
USE transactions;
```
```
CREATE TABLE IF NOT EXISTS transactions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    amount INT,
    description VARCHAR(255)
);
```

```
CREATE USER IF NOT EXISTS 'expense'@'%' IDENTIFIED BY 'ExpenseApp@1';

```

```
GRANT ALL ON transactions.* TO 'expense'@'%';
```

```
FLUSH PRIVILEGES;
```
# RUN AWS LB Cpntroller Configuration to communicate with AWS ALB
* Should install LB controller along with some OIDC, IAM Policies, IAM Role, Service Account, Helm to install AWS Load balancer Controller etc.


1. Create an IAM OIDC provider. You can skip this step if you already have one for your cluster.
```
eksctl utils associate-iam-oidc-provider \
    --region us-east-1 \
    --cluster expense-dev \
    --approve
```
2. If your cluster is in any other region:
```
curl -o iam-policy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.12.0/docs/install/iam_policy.json
```
3. Create an IAM policy named AWSLoadBalancerControllerIAMPolicy. If you downloaded a different policy, replace iam-policy with the name of the policy that you downloaded.
```
aws iam create-policy \
    --policy-name AWSLoadBalancerControllerIAMPolicy \
    --policy-document file://iam-policy.json
```
4. Create an IAM role and Kubernetes ServiceAccount for the LBC. Use the ARN from the previous step.
```
eksctl create iamserviceaccount \
--cluster=expense-dev \
--namespace=kube-system \
--name=aws-load-balancer-controller \
--attach-policy-arn=arn:aws:iam::537124943253:policy/AWSLoadBalancerControllerIAMPolicy \
--override-existing-serviceaccounts \
--region us-east-1 \
--approve
```

5. Add the EKS chart repo to Helm.
```
helm repo add eks https://aws.github.io/eks-charts
```

6. Helm install command for clusters with IRSA: (Note: if Service account not created then, put true)
```
helm install aws-load-balancer-controller eks/aws-load-balancer-controller -n kube-system --set clusterName=expense-dev --set serviceAccount.create=false --set serviceAccount.name=aws-load-balancer-controller
```
(ref: https://kubernetes-sigs.github.io/aws-load-balancer-controller/latest/deploy/installation/)

* Check: Once the above steps completed. You will get below info of AWS LB Controller running.
```
kubectl get pods -n kube-system
```
NAME                                            READY   STATUS    RESTARTS   AGE
aws-load-balancer-controller-5fd7794f55-277qq   1/1     Running   0          24s
aws-load-balancer-controller-5fd7794f55-9wzwm   1/1     Running   0          24s
aws-node-jspd2                                  2/2     Running   0          16m
aws-node-q252t                                  2/2     Running   0          16m
coredns-789f8477df-bg5jh                        1/1     Running   0          21m
coredns-789f8477df-vw699                        1/1     Running   0          21m
eks-pod-identity-agent-25sjl                    1/1     Running   0          16m
eks-pod-identity-agent-qqkz2                    1/1     Running   0          16m
kube-proxy-7dgzm                                1/1     Running   0          17m
kube-proxy-z4zdb                                1/1     Running   0          17m

Note: Create NAMESPACE

## Target Group Binding:
* If you are using AWS Application Load Balancer which is creating mannually or provisioing with terraform. 
* You can use Target Group Binding resource or Choose Ingress as well
* Here Our frontend Nginx is listens port on 8080. 
* Change target group port number to 8080
* Service port of Fronetnd to 8080
* nginx.conf: 8080 (kubernetes not able open port 80 for nginx, as we have used thin image for FE)


* Add the AWS target group arn in yaml file and run
```
apiVersion: elbv2.k8s.aws/v1beta1
kind: TargetGroupBinding
metadata:
  name: alb-tgb
  namespace: expense
spec:
  serviceRef:
    name: frontend # route traffic to the frontend service
    port: 8080
  targetGroupARN: arn:aws:elasticloadbalancing:us-east-1:537124943253:targetgroup/expense-dev-frontend/acda3c710fda1014
  targetType: ip
```

# Connect Node (Jenkins-AGENT):
* Install required tools Java, terraform, docker, kubectl, eksctl, helm, Resize: /var, /home, /var/tmp etc
* Add Credentails and if any (AWS, docker, EC2, SonarQube, etc)
* Create Pipelines
* Build Pipelines

## Backend:
* Makesure Infra and pipleines ready without any errors or issues.
* In backend, configmap DB_HOST should replace with RDS endpoint address.
* In Helm (backend): replace imageName to ECR imageURI of backend
Build Stages:
* Read Version 
* Install npm dependecies mentioned in the package.json
* Build image
* Deploy in K8s
* Code Scans and Image Scans, Unit Test, etc

## Frontend:
* Makesure Infra and pipleines ready without any errors or issues.
* In Helm (Frontend): replace imageName with ECR imageURI of frontend
* Build Image
* Deploy Image
* Code Scans and Image Scans, Unit Test, etc

