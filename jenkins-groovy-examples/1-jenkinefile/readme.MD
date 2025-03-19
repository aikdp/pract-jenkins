# Free Style Project:
* Manually created infra vs IaaC
1.	you cannot restore if something goes wrong
2.	We cannot track we did changes
3.	We cannot reuse
4.	No review of changes
5.	No version control

# Create AGENT 
* Launch Agent. Before Lanching the AGENT, you should install JAVA on it, as jenkins is used java.
```
sudo yum install java-17-openjdk -y
```

## Resize the VOlume

```
sudo lsblk

sudo growpart /dev/nvme0n1 4

sudo lvextend -l +50%FREE /dev/RootVG/rootVol 

sudo lvextend -l +50%FREE /dev/RootVG/varVol

sudo xfs_growfs /

sudo xfs_growfs /var

df -hT
```

# Plugins
1. Pipeline: Stage View