# Notes:
*  This was tested and run using Terraform v0.12.17

---
---
###   User Pre - Reqs for AWS:

	*  Instructions to create user and get your AWS Credentials here:   [Setup AWS User](https://github.com/tlepple/horizon-public-how2/blob/master/provider/aws/aws_user.md)
---
---

##  Begin Setup Here:

---
---

###  Update the file `.env.template` with needed items here:

1.    #### Update some variables to pass to the script.

``` 
       cd /app/horizon-public/provider/aws
       vi .env.template

       # Just need to update OWNER_NAME
       export OWNER_NAME="<your owner name>"

```

2.    #### Set the  Terraform variables in the file `var-properties.tfvars`:

```
       vi var-properties.tfvars

       #  Update these variables:
	owner_name="<your owner name>"
	owner_initials="<your initials>"
	aws_region="<aws region you exported earlier>"
	tag_enddate="<a future date>"

```

3.    ####  Export your aws credentials into memory

```
	export AWS_ACCESS_KEY_ID=<Your AWS Access Key>
	export AWS_SECRET_ACCESS_KEY=<Your AWS Secret Access Key>
	export AWS_DEFAULT_REGION=<Your AWS Region>
```

4.    #### Run the script:

```
	cd /app/horizon-public/provider/aws
	. aws_setup.sh

```

5.   #### Verify in the AWS GUI that these items exist:
	*  Policies
	*  Roles
	*  EC2 Key Pair 

6.   ####  Complete next steps within the CDP GUI from Okta Tile:


---
---
