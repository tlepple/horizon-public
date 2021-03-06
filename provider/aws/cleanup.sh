#!/bin/bash

BASE_DIR=$(cd $(dirname $0); pwd -L)

# get the public ip address of this host
GET_PUBLIC_IP=`curl -s ifconfig.me`

# set the public ip as a variable
export TF_VAR_my_publicip="${GET_PUBLIC_IP}"

#  call the terraform destroy
log "Build out cloud env via Terraform"
terraform destroy -var-file var-properties.tfvars
#terraform destroy -var-file var-properties.tfvars -auto-approve

# write terraform output to a json file:
#terraform output -json > $starting_dir/provider/aws/assemble_output.json
