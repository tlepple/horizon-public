#!/bin/bash

BASE_DIR=$(cd $(dirname $0); pwd -L)

# get the public ip address of this host
GET_PUBLIC_IP=`curl -s ifconfig.me`

# set the public ip as a variable
export TF_VAR_my_publicip="${GET_PUBLIC_IP}"

#  call the terraform build
#log "Build out cloud env via Terraform"
echo "before"
echo `pwd`
cd /app/horizon-public/provider/aws
echo "after"
echo `pwd`
terraform init
terraform apply -var-file /app/horizon-public/provider/aws/var-properties.tfvars
#terraform apply -var-file var-properties.tfvars -auto-approve

# write terraform output to a json file:
#terraform output -json > $starting_dir/provider/aws/assemble_output.json
