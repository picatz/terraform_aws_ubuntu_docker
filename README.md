# Terraform Example using AWS to build a Ubuntu VM with Docker Provisioned

Setup your AWS enviroment variables:

```
export AWS_ACCESS_KEY_ID=XX
export AWS_DEFAULT_REGION=XX     
export AWS_SECRET_ACCESS_KEY=XX
```

Clone this repository.
```
git clone https://github.com/picatz/terraform_aws_ubuntu_docker
```

Change into the local directory you just cloned.
```
cd terraform_aws_ubuntu_docker
```

Run the setup script.
```
bash setup.sh
```

Run `terraform apply` with the `public_ip` variable set to your local public IP.
```
terraform apply -auto-approve -var "public_ip=$(dig +short myip.opendns.com @resolver1.opendns.com)"
```

Now you can `ssh` into the newly created AWS box. 
```
ssh ubuntu@instance_public_ip -i ubuntu_ssh
```

When you're done, on your host you can now `destroy` the box and everything associted with it.
```
terraform destroy -force -var "public_ip=$(dig +short myip.opendns.com @resolver1.opendns.com)"
```
