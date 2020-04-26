# Copying files between two EC2 instances using S3 and polling

The following components get created:
+ 1 keypair (run ssh-keygen in your home folder to create a key "~/.ssh/tfvpce/id_rsa.pub")
+ 1 VPC with 1 private subnet
+ 2 ec2

## Generate a keypair to access EC2 instances

    ssh-keygen

## Terraform commands
    
    terraform init
    
    terraform validate
    
    terraform plan -out=tfplan
    
    terraform apply -auto-approve tfplan
    or
    terraform apply -auto-approve
    
    terraform destroy -auto-approve

## To delete Terraform state files
    rm -rfv **/.terraform # remove all recursive subdirectories
    
<br>
