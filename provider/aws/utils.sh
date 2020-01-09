#!/bin/bash

#####################################################
# Function to install jq
#####################################################
install_jq_cli() {

	#####################################################
	# first check if JQ is installed
	#####################################################
	log "Installing jq"

	jq_v=`jq --version 2>&1`
	if [[ $jq_v = *"command not found"* ]]; then
	  curl -L -s -o jq "https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64"
	  chmod +x ./jq
	  cp jq /usr/bin
	else
	  log "jq already installed. Skipping"
	fi

	jq_v=`jq --version 2>&1`
	if [[ $jq_v = *"command not found"* ]]; then
	  log "error installing jq. Please see README and install manually"
	  echo "Error installing jq. Please see README and install manually"
	  exit 1 
	fi  

}

#####################################################
# Function to install terraform cli
#####################################################
install_terraform_cli() {
	log "Installing TERRAFORM_CLI"
	terraform_cli_version=`terraform --version 2>&1`
	log "Current Terraform CLi version: $terraform_cli_version"
	if [[ $terraform_cli_version = *"Terraform v"* ]]; then
	    log "Terraform CLI already installed.  Skipping"
	    return
	else
	    yum install -y unzip wget
	    wget https://releases.hashicorp.com/terraform/0.12.17/terraform_0.12.17_linux_amd64.zip
	    unzip terraform_0.12.17_linux_amd64.zip -d /usr/bin
	    rm -rf terraform_0.12.17_linux_amd64.zip
	fi
	log "Done installing Terraform CLI"

}


#####################################################
# Function to install gcloud cli
#####################################################
install_gcp_cli() {
	log "Installing gcloud sdk..."
	gcp_cli_version=`gcloud --version 2>&1`
	log "Current gcloud version: $gcp_cli_version"
	if [[ $gcp_cli_version = *"Google Cloud SDK"* ]]; then
	    log "gcloud cli already installed.  Skipping"
	    return
	fi
	yum install -y wget
	wget https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-273.0.0-linux-x86_64.tar.gz -P /tmp
	tar -xf /tmp/google-cloud-sdk-273.0.0-linux-x86_64.tar.gz -C /usr/local/bin
	echo "	" >> ~/.bashrc
	echo "# The next line updates PATH for the Google Cloud SDK." >> ~/.bashrc
	echo "if [ -f '/usr/local/bin/google-cloud-sdk/path.bash.inc' ]; then . '/usr/local/bin/google-cloud-sdk/path.bash.inc'; fi" >> ~/.bashrc	
	# initialize bash profile to see this add:
	. ~/.bash_profile
	# remove the dowloaded tmp file
	rm -f /tmp/google-cloud-sdk-273.0.0-linux-x86_64.tar.gz
	# activate the service account
	gcloud auth activate-service-account --key-file "$starting_dir/provider/gcp/keygcp.json"
	log "Done installing gcloud cli"
	
}

#####################################################
# Function to install aws cli
#####################################################
install_aws_cli() {
	log "Installing AWS_CLI"
  	aws_cli_version=`aws --version 2>&1`
  	log "Current CLI version: $aws_cli_version"
  	if [[ $aws_cli_version = *"aws-cli"* ]]; then
    		log "AWS CLI already installed. Skipping"
    		return
  	fi
    	yum -y install unzip
 	curl -s -O "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip"
  	unzip awscli-bundle.zip
  	./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws 
  	rm -rf awscli-bundle*
  	log "Done installing AWS CLI"
}

#####################################################
# Function to create ssh key pair
#####################################################
create_key_pair() {

#ssh-keygen -t rsa -b 2048 -C ${TF_VAR_cloud_username:?} -f ${starting_dir:?}${TF_VAR_key_file_path:?}${TF_VAR_key_filename:?} -q -P ""
#  chmod 0400 ${starting_dir:?}${TF_VAR_key_file_path:?}${TF_VAR_key_filename:?} 
	
	if [ -f ${starting_dir:?}${TF_VAR_key_file_path:?}${TF_VAR_private_key_name:?} ]; then
	  log "Key already exists: ${TF_VAR_private_key_name:?}.  Will reuse it."
	else
	  log "Creating the ssh key pair files..."
	  mkdir -p ${starting_dir:?}${TF_VAR_key_file_path:?}
	  umask 0277
          ssh-keygen -f ${starting_dir:?}${TF_VAR_key_file_path:?}${TF_VAR_private_key_name:?} -N "" -m PEM -t rsa -b 2048 -C ${TF_VAR_vm_ssh_user:?}
	  chmod 0400 ${starting_dir:?}${TF_VAR_key_file_path:?}${TF_VAR_private_key_name:?}
	  umask 0022 
	  log "Private key created: ${TF_VAR_private_key_name:?}"
	fi
}

#####################################################
# Function to  archive ssh key pair
#####################################################
archive_key_pair() {
	if [ -f ${starting_dir:?}${TF_VAR_key_file_path:?}${TF_VAR_private_key_name:?} ]; then
	  log "Archiving key pair [${TF_VAR_private_key_name:?}]"
	  mv -f ${starting_dir:?}${TF_VAR_key_file_path:?}${TF_VAR_private_key_name:?} ${starting_dir:?}${TF_VAR_key_file_path:?}.${TF_VAR_private_key_name:?}.OLD.$(date +%s)
	  mv -f ${starting_dir:?}${TF_VAR_key_file_path:?}${TF_VAR_public_key_name:?} ${starting_dir:?}${TF_VAR_key_file_path:?}.${TF_VAR_public_key_name:?}.OLD.$(date +%s)
	fi
}

#####################################################
# Function to  archive assemble_output.json
#####################################################
archive_assemble_json() {
	if [ -f ${starting_dir:?}/provider/aws/assemble_output.json ]; then
	   mv -f ${starting_dir:?}/provider/aws/assemble_output.json ${starting_dir:?}/provider/gcp/archive/.assemble_output.json.OLD.$(date +%s)
	fi
}

#####################################################
# Function to copy key file to a bind mount
#####################################################
replicate_key() {
	if [ -f ${starting_dir:?}${TF_VAR_key_file_path:?}${TF_VAR_private_key_name:?} ]; then
	    #  call some attribs variables
            . $starting_dir/provider/aws/get_attribs.sh
	    cp ${starting_dir:?}${TF_VAR_key_file_path:?}${TF_VAR_private_key_name:?} ${BIND_MNT_TARGET}/${LV_BIND_FILENAME}
	fi
}

#####################################################
# Function to delete bind key
#####################################################
delete_bind_key() {
	rm -f ${BIND_MNT_TARGET}/${LV_BIND_FILENAME}
}

#####################################################
# Function to prepare template files
#####################################################
prepare_templates() {
	# policies
	cp ${starting_dir:?}/provider/aws/templates/policies/idbroker_assume_role_policy.json.template ${starting_dir:?}/provider/aws/policies/idbroker_assume_role_policy.json
	cp ${starting_dir:?}/provider/aws/templates/policies/log_policy_s3access.json.template ${starting_dir:?}/provider/aws/policies/log_policy_s3access.json
        sed -i "s/YourOwnerName/${OWNER_NAME}/g" ${starting_dir:?}/provider/aws/policies/log_policy_s3access.json
	cp ${starting_dir:?}/provider/aws/templates/policies/ranger_audit_policy_s3access.json.template ${starting_dir:?}/provider/aws/policies/ranger_audit_policy_s3access.json
        sed -i "s/YourOwnerName/${OWNER_NAME}/g" ${starting_dir:?}/provider/aws/policies/ranger_audit_policy_s3access.json
        cp ${starting_dir:?}/provider/aws/templates/policies/datalake_admin_policy_s3access.json.template ${starting_dir:?}/provider/aws/policies/datalake_admin_policy_s3access.json
        sed -i "s/YourOwnerName/${OWNER_NAME}/g" ${starting_dir:?}/provider/aws/policies/datalake_admin_policy_s3access.json
        cp ${starting_dir:?}/provider/aws/templates/policies/bucket_policy_s3access.json.template ${starting_dir:?}/provider/aws/policies/bucket_policy_s3access.json
        sed -i "s/YourOwnerName/${OWNER_NAME}/g" ${starting_dir:?}/provider/aws/policies/bucket_policy_s3access.json
        cp ${starting_dir:?}/provider/aws/templates/policies/dynamodb_policy.json.template ${starting_dir:?}/provider/aws/policies/dynamodb_policy.json
        sed -i "s/YourOwnerName/${OWNER_NAME}/g" ${starting_dir:?}/provider/aws/policies/dynamodb_policy.json
        cp ${starting_dir:?}/provider/aws/templates/policies/dataeng_policy.json.template ${starting_dir:?}/provider/aws/policies/dataeng_policy.json
        sed -i "s/YourOwnerName/${OWNER_NAME}/g" ${starting_dir:?}/provider/aws/policies/dataeng_policy.json
        cp ${starting_dir:?}/provider/aws/templates/policies/datasci_policy.json.template ${starting_dir:?}/provider/aws/policies/datasci_policy.json
        sed -i "s/YourOwnerName/${OWNER_NAME}/g" ${starting_dir:?}/provider/aws/policies/datasci_policy.json
        cp ${starting_dir:?}/provider/aws/templates/policies/crossaccount_sase_policy.json.template ${starting_dir:?}/provider/aws/policies/crossaccount_sase_policy.json

	# roles
	cp ${starting_dir:?}/provider/aws/templates/roles/idbroker_role.json.template ${starting_dir:?}/provider/aws/roles/idbroker_role.json
        cp ${starting_dir:?}/provider/aws/templates/roles/log_role.json.template ${starting_dir:?}/provider/aws/roles/log_role.json
        cp ${starting_dir:?}/provider/aws/templates/roles/ranger_audit_role.json.template ${starting_dir:?}/provider/aws/roles/ranger_audit_role.json
	sed -i "s/YourOwnerName/${OWNER_NAME}/g" ${starting_dir:?}/provider/aws/roles/ranger_audit_role.json
	sed -i "s/YOUR_AWS_ACCOUNT_ID/`aws sts get-caller-identity | jq -r '.Account'`/g" ${starting_dir:?}/provider/aws/roles/ranger_audit_role.json
        cp ${starting_dir:?}/provider/aws/templates/roles/datalake_admin_role.json.template ${starting_dir:?}/provider/aws/roles/datalake_admin_role.json
	sed -i "s/YourOwnerName/${OWNER_NAME}/g" ${starting_dir:?}/provider/aws/roles/datalake_admin_role.json
	sed -i "s/YOUR_AWS_ACCOUNT_ID/`aws sts get-caller-identity | jq -r '.Account'`/g" ${starting_dir:?}/provider/aws/roles/datalake_admin_role.json
        cp ${starting_dir:?}/provider/aws/templates/roles/dataeng_role.json.template ${starting_dir:?}/provider/aws/roles/dataeng_role.json
	sed -i "s/YourOwnerName/${OWNER_NAME}/g" ${starting_dir:?}/provider/aws/roles/dataeng_role.json
	sed -i "s/YOUR_AWS_ACCOUNT_ID/`aws sts get-caller-identity | jq -r '.Account'`/g" ${starting_dir:?}/provider/aws/roles/dataeng_role.json
        cp ${starting_dir:?}/provider/aws/templates/roles/datasci_role.json.template ${starting_dir:?}/provider/aws/roles/datasci_role.json
	sed -i "s/YourOwnerName/${OWNER_NAME}/g" ${starting_dir:?}/provider/aws/roles/datasci_role.json
	sed -i "s/YOUR_AWS_ACCOUNT_ID/`aws sts get-caller-identity | jq -r '.Account'`/g" ${starting_dir:?}/provider/aws/roles/datasci_role.json
        cp ${starting_dir:?}/provider/aws/templates/roles/crossaccount_sase_role.json.template ${starting_dir:?}/provider/aws/roles/crossaccount_sase_role.json
}

#####################################################
# Function to install standalone python 3.7.4
#####################################################
install_python37() {

   py_v=`python3.7 --version 2>&1`
   if [[ $py_v = *"command not found"* ]]; then 

	# install some tools:
	log "Install needed yum tools"
	yum groupinstall -y 'development tools'
	yum install -y zlib-dev openssl-devel sqlite-devel bzip2-devel xz-libs xz-devel wget libffi-devel cyrus-sasl-devel

	log "Install python3.7.4 from source"
	# create directory
	mkdir -p /usr/local/downloads

	# change to dir
	cd /usr/local/downloads

	# download source
	wget https://www.python.org/ftp/python/3.7.4/Python-3.7.4.tar.xz

	# unzip and untar this file:
	xz -d Python-3.7.4.tar.xz
	tar -xvf Python-3.7.4.tar

	# change dir
	cd Python-3.7.4

	# build from source and install
	./configure --prefix=/usr/local
	make
	make altinstall

	# Update PATH and re-initialize
	log "Update PATH for python3"
	sed -i '/^PATH=/ s/$/:\/usr\/local\/bin/' ~/.bash_profile

	log "source bash_profile"
	source ~/.bash_profile

   else
	log "python3.7 already installed.  Skipping"
   fi
}

#####################################################
# Function to install CDPCLI
#####################################################
install_cdpcli() {

}

