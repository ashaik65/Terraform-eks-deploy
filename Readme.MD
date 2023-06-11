### Steps to create EKS cluster from this terraform files ###
```yaml

As Part of this terrform Files we need to create step by step procedure to create resources so sequence follow like this
### Before excuting terraform files configure AWS access and secret key in your local system ###
### make sure that the region while configure aws is same for terraform backend o.w you will face issue ###

1. First will create our custom VPC:- 

for this we need to go to (networking) folder where all VPC relaeted files are presents but one things which is most important here all files refernce we are taking from (dev) folder so in (dev) folder we have file which is called as "networking.tfvars" so if we want to do any chnges so we can do in this file only now steps apply

anis.shaikh@C02F60RVML7H networking % ls
backend.tf      main.tf         output.tf       provider.tf     variables.tf

so as you see backend.tf so you can change as per your bucket name and region files content are

terraform {
  backend "s3" {
    bucket = "anis-terraform-backend1"
    key    = "networking/terraform.tfstate"
    region = "ap-south-1"
  }
}

anis.shaikh@C02F60RVML7H networking % terraform init  ---> it will initlaised backend and provider plugins

anis.shaikh@C02F60RVML7H networking % terraform apply -var-file ../dev/networking.tfvars  ---to apply files make  sure your path is correct for (dev) folder so once you apply so it will create your vpc resources

2. Create Bastion host:-
For this go to (ec2-demo) folder and make sure backned file is configured as for your bucket and region

anis.shaikh@C02F60RVML7H ec2-demo %  terraform init

anis.shaikh@C02F60RVML7H ec2-demo % terraform apply -var-file ../dev/ec2.tfvars 

In this case again we are taking variable refernce from (dev) folder

3. Create EKS cluster:-
Go to (eks_cluster) folder and again do the same like check terraform backend as per your need

anis.shaikh@C02F60RVML7H eks_cluster % terraform init

anis.shaikh@C02F60RVML7H eks_cluster % terraform apply -var-file ../../dev/eks.tfvars

## one important thing to noted in k8.tf file for ex if you are giving access to other team member so dont forget add (mapUsers property in k8.tf file ) ###

## Example :-
data = {
    mapRoles = yamlencode(
      [
        {
          rolearn  = "${aws_iam_role.WorkerNodeGroupRole.arn}"
          username = "system:node:{{EC2PrivateDNSName}}"
          groups   = ["system:masters", "system:nodes"]
        },
      ]
    )
    mapUsers = yamlencode(
      [
        {
          userarn  = "arn:aws:iam::312816102899:user/rohan-patil"
          username = "eks-admin"
          groups   = ["system:masters"]
        },
      ]
    )
  }
}

as above file you can see the  mapUsers = yamlencode so in userarn make sure put IAM arn and username you can put anything

4. EKS Nodegroup creation:-

switch to (nodegroup) folder and again do the same thing backend.tf check and do chnages

anis.shaikh@C02F60RVML7H nodegroup % terraform init

anis.shaikh@C02F60RVML7H nodegroup % terraform apply -var-file ../../dev/nodegroup.tfvars

once this is done you can now do go to AWS console click on your jump server and connect using SSM manager once this is done do this prequsist

## Prequsist:- Install AWS CLI

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
apt install unzip
unzip awscliv2.zip
sudo ./aws/install
aws --version

## Installing kubectl
curl -o kubectl https://s3.us-west-2.amazonaws.com/amazon-eks/1.24.7/2022-10-31/bin/linux/amd64/kubectl
chmod +x ./kubectl
mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin
echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc
kubectl version --short --client

## Run Update Kubeconfig file command 
aws eks update-kubeconfig --region region-code --name my-cluster 

## Now enjoy kubectl commands 

kubectl get no -owide




    














