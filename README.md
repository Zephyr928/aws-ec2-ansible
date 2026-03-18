# aws-ec2-ansible

**Getting started**

1. Setup EC2 instance and Security Groups
2. Configure Terraform to provision servers

**Done so far**
1. Provisioned an Amazon Linux server, setup security groups, and installed Ansible on it.
2. Configured awscli on Ansible server
3. Created place holder files for both Ansible and Terraform
4. Configured the terraform/main.tf (Need to go back and look at Production IP cidr block and SSH keys)
5. Configured the terraform/variables.tf file


**To-Do List**
1. Figure out what production IP addresses will be.  Once decided edit the terraform/main.tf file and change the Security Group cidr_blocks to production IP's.
2. Figure out what Key Pairs I need for the terraform/main.tf file.  
