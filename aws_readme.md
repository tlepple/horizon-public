Notes:
*  This was tested and run using Terraform v0.12.17

---
---

###   Setup User Pre-Reqs for AWS:

Instruction for user creation and credentials are here:  [Setup AWS User](https://github.com/tlepple/horizon-public-how2/blob/master/provider/aws/aws_user.md)

---
---

##  Begin Terraform Setup Here:

---
---

####  Update the file `.env.template` with needed items here:

1.    #### Update some variables to pass to the script in your terminal docker session:

``` 
       cd /app/horizon-public/provider/aws
       vi .env.template

       # Just need to update OWNER_NAME
       export OWNER_NAME="<your owner name>"

```

2.    #### Set the  Terraform variables in the file `var-properties.tfvars` in your terminal docker session:

```
       vi var-properties.tfvars

       #  Update these variables:
	owner_name="<your owner name>"
	owner_initials="<your initials>"
	aws_region="<aws region you exported earlier>"
	tag_enddate="<a future date>"

```

3.    ####  Export your AWS Credentials into memory in your terminal docker session:

```
	export AWS_ACCESS_KEY_ID=<Your AWS Access Key>
	export AWS_SECRET_ACCESS_KEY=<Your AWS Secret Access Key>
	export AWS_DEFAULT_REGION=<Your AWS Region>
```

4.    #### Run the below script in your terminal docker session:

```
	cd /app/horizon-public/provider/aws
	. aws_setup.sh

```

*  This step will start the Terraform build to create policies, roles, and S3 buckets inside of AWS and associate needed items.
*  Type `Yes` in the terminal window when prompted

---
---

5.   #### Verify in the AWS GUI that these items exist:

	*  Policies
	*  Roles
	*  EC2 Key Pair 

--- 

![](./images/zzuserPolicies.png)

---

![](./images/zzuserRoles.png)

---

![](./images/verfiyKP.png)

---

6.   ####  Complete next steps within the CDP Sandbox GUI from your Okta tile:

Instruction for `CDP Environment` creation are here:  [Setup CDP Environment](https://github.com/tlepple/horizon-public-how2/blob/master/provider/aws/cdp_env.md)


---
---
