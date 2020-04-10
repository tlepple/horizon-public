#!/bin/bash

###########################################################################################################
# import parameters and utility functions 
###########################################################################################################

. /app/horizon-public/provider/aws/utils.sh
. /app/horizon-public/provider/aws/.env.template



#####################################################
#       Step 1: install the aws cli
#####################################################
install_aws_cli

#####################################################
#	Step 2: install the JQ cli
#####################################################
install_jq_cli

#####################################################
#       Step 3: install the Terraform cli
#####################################################
install_terraform_cli

#####################################################
#       Step 4: install python 3.7 from source
#####################################################
install_python37

#####################################################
#       Step 5: create an ssh key pair
#####################################################
#create_key_pair

#####################################################
#       Step 6: prepare IAM Policies and Roles 
#####################################################
prepare_templates

#####################################################
#       Step 7: build out AWS env with terraform 
#####################################################
. /app/horizon-public/provider/aws/assemble.sh

#####################################################
#       Step 8: replicate key to bind mnt
#####################################################
#replicate_key

