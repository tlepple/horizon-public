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

