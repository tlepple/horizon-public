#!/bin/bash

#########################################################
# Input parameters
#########################################################

case "$1" in
        aws)
           echo "you chose aws"
            ;;
        azure)
           echo "you chose azure"
            ;;
        gcp)
	   echo "you chose gcp"
            ;;
        *)
            echo $"Usage: $0 {aws|azure|gcp}"
            echo $"example: ./start_instance.sh azure"
            echo $"example: ./start_instance.sh.sh aws"
            echo $"example: ./start_instance.sh gcp"
#            exit 0
esac

CLOUD_PROVIDER=$1

########################################################
# utility functions
########################################################
dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

starting_dir=`pwd`


########################################################
# Execute cloud provider specific code
########################################################

case "$CLOUD_PROVIDER" in
        aws)
            echo "execute aws code here... "
	  #  . /app/horizon-public/provider/aws/aws_setup.sh
            ;;
        azure)
           echo "execute azure code here"
          #  . /app/horizon-public/provider/azure/azure_setup.sh
            ;;
        gcp)
           echo "execute gcp code here..."
#             echo `pwd`
#             cd ./provider/gcp
             . /app/horizon-public/provider/gcp/gcp_start_instance.sh
            ;;
        *)
            echo "you had a different choice... is this block needed?"
	    ;;
esac

cd $starting_dir
