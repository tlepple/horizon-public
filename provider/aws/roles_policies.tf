##############################################################################################
#	idbroker - policy, role, attachment
##############################################################################################
resource "aws_iam_policy" "idbroker-assume-role" {
    name 	= "${var.owner_name}-idbroker-assume-role-policy"
    description = "CDP iam policy - idbroker assume role"
    policy	= file("/app/horizon-public/provider/aws/policies/idbroker_assume_role_policy.json")
}

resource "aws_iam_role" "idbroker-role" {
    name               =  "${var.owner_name}-idbroker-role"
    assume_role_policy = file("/app/horizon-public/provider/aws/roles/idbroker_role.json")

    tags = {
      owner   = var.owner_name
      project = var.tag_project
    }    
}

resource "aws_iam_policy_attachment" "idbroker-policy-attach" {
  name       = "${var.owner_name}-idbroker-policy-attachment"
  roles      = [aws_iam_role.idbroker-role.name]
  policy_arn = aws_iam_policy.idbroker-assume-role.arn
}

##############################################################################################
#	log - policy, role, attachment
##############################################################################################
resource "aws_iam_policy" "log-policy-s3access" {
    name        = "${var.owner_name}-log-policy-s3access"
    description = "CDP iam policy - log policy s3access"
    policy      = file("/app/horizon-public/provider/aws/policies/log_policy_s3access.json")
}

resource "aws_iam_role" "log-role" {
    name               =  "${var.owner_name}-log-role"
    assume_role_policy = file("/app/horizon-public/provider/aws/roles/log_role.json")

    tags = {
      owner   = var.owner_name
      project = var.tag_project
    }
}

resource "aws_iam_policy_attachment" "log-policy-attach" {
  name       = "${var.owner_name}-log-policy-attachment"
  roles      = [aws_iam_role.log-role.name]
  policy_arn = aws_iam_policy.log-policy-s3access.arn
}

##############################################################################################
#       bucket - policy, attachment
##############################################################################################
resource "aws_iam_policy" "bucket-policy-s3access" {
    name        = "${var.owner_name}-bucket-policy-s3access"
    description = "CDP iam policy - bucket policy s3access"
    policy      = file("/app/horizon-public/provider/aws/policies/bucket_policy_s3access.json")
}

resource "aws_iam_policy_attachment" "bucket-policy-attach" {
  name       = "${var.owner_name}-bucket-policy-attachment"
  roles      = [aws_iam_role.log-role.name]
  policy_arn = aws_iam_policy.bucket-policy-s3access.arn
}


##############################################################################################
#	ranger audit - policy, role,  attachment
##############################################################################################
resource "aws_iam_policy" "ranger-audit-policy-s3access" {
    name        = "${var.owner_name}-ranger-audit-policy-s3access"
    description = "CDP iam policy - ranger audit policy s3access"
    policy      = file("/app/horizon-public/provider/aws/policies/ranger_audit_policy_s3access.json")
}

resource "aws_iam_role" "ranger-audit-role" {
    name               =  "${var.owner_name}-ranger-audit-role"
    assume_role_policy = file("/app/horizon-public/provider/aws/roles/ranger_audit_role.json")

    tags = {
      owner   = var.owner_name
      project = var.tag_project
    }
}

resource "aws_iam_policy_attachment" "ranger-audit-policy-attach" {
  name       = "${var.owner_name}-ranger-audit-policy-attachment"
  roles      = [aws_iam_role.ranger-audit-role.name]
  policy_arn = aws_iam_policy.ranger-audit-policy-s3access.arn
}

resource "aws_iam_policy_attachment" "ranger-audit-bucket-policy-attach" {
  name       = "${var.owner_name}-ranger-audit-bucket-policy-attachment"
  roles      = [aws_iam_role.ranger-audit-role.name]
  policy_arn = aws_iam_policy.bucket-policy-s3access.arn
}

##############################################################################################
#       dynamodb - policy, attachment
##############################################################################################
resource "aws_iam_policy" "dynamodb-policy" {
    name        = "${var.owner_name}-dynamodb-policy"
    description = "CDP iam policy - dynamodb policy"
    policy      = file("/app/horizon-public/provider/aws/policies/dynamodb_policy.json")
}

resource "aws_iam_policy_attachment" "dynamodb-policy-attach" {
  name       = "${var.owner_name}-dynamodb-policy-attachment"
  roles      = [aws_iam_role.ranger-audit-role.name]
  policy_arn = aws_iam_policy.dynamodb-policy.arn
}

##############################################################################################
#	datalake admin - policy, role,  attachment
##############################################################################################
resource "aws_iam_policy" "datalake-admin-policy-s3access" {
    name        = "${var.owner_name}-datalake-admin-policy-s3access"
    description = "CDP iam policy - datalake admin policy s3access"
    policy      = file("/app/horizon-public/provider/aws/policies/datalake_admin_policy_s3access.json")
}

resource "aws_iam_role" "datalake-admin-role" {
    name               =  "${var.owner_name}-datalake-admin-role"
    assume_role_policy = file("/app/horizon-public/provider/aws/roles/datalake_admin_role.json")

    tags = {
      owner   = var.owner_name
      project = var.tag_project
    }
}

resource "aws_iam_policy_attachment" "datalake-admin-policy-attach" {
  name       = "${var.owner_name}-datalake-admin-policy-attachment"
  roles      = [aws_iam_role.datalake-admin-role.name]
  policy_arn = aws_iam_policy.datalake-admin-policy-s3access.arn
}

resource "aws_iam_policy_attachment" "datalake-admin-dynamodb-policy-attach" {
  name       = "${var.owner_name}-datalake-admin-dynamodb-policy-attachment"
  roles      = [aws_iam_role.datalake-admin-role.name]
  policy_arn = aws_iam_policy.dynamodb-policy.arn
}

resource "aws_iam_policy_attachment" "datalake-admin-bucket-policy-attach" {
  name       = "${var.owner_name}-datalake-admin-bucket-policy-attachment"
  roles      = [aws_iam_role.datalake-admin-role.name]
  policy_arn = aws_iam_policy.bucket-policy-s3access.arn
}


##############################################################################################
#	dataeng - policy, role, attachment
##############################################################################################
resource "aws_iam_policy" "dataeng-policy" {
    name        = "${var.owner_name}-dataeng-policy"
    description = "CDP iam policy - dataeng policy"
    policy      = file("/app/horizon-public/provider/aws/policies/dataeng_policy.json")
}

resource "aws_iam_role" "dataeng-role" {
    name               =  "${var.owner_name}-dataeng-role"
    assume_role_policy = file("/app/horizon-public/provider/aws/roles/dataeng_role.json")

    tags = {
      owner   = var.owner_name
      project = var.tag_project
    }
}       

resource "aws_iam_policy_attachment" "dataeng-policy-attach" {
  name       = "${var.owner_name}-dataeng-policy-attachment"
  roles      = [aws_iam_role.dataeng-role.name]
  policy_arn = aws_iam_policy.dataeng-policy.arn
}

resource "aws_iam_policy_attachment" "dataeng-dynamodb-policy-attach" {
  name       = "${var.owner_name}-dataeng-dynamodb-policy-attachment"
  roles      = [aws_iam_role.dataeng-role.name]
  policy_arn = aws_iam_policy.dynamodb-policy.arn
}


##############################################################################################
#	datasci - policy, role, attachment
##############################################################################################
resource "aws_iam_policy" "datasci-policy" {
    name        = "${var.owner_name}-datasci-policy"
    description = "CDP iam policy - datasci policy"
    policy      = file("/app/horizon-public/provider/aws/policies/datasci_policy.json")
}

resource "aws_iam_role" "datasci-role" {
    name               =  "${var.owner_name}-datasci-role"
    assume_role_policy = file("/app/horizon-public/provider/aws/roles/datasci_role.json")

    tags = {
      owner   = var.owner_name
      project = var.tag_project
    }
}

resource "aws_iam_policy_attachment" "datasci-policy-attach" {
  name       = "${var.owner_name}-datasci-policy-attachment"
  roles      = [aws_iam_role.datasci-role.name]
  policy_arn = aws_iam_policy.datasci-policy.arn
}

resource "aws_iam_policy_attachment" "datasci-dynamodb-policy-attach" {
  name       = "${var.owner_name}-datasci-dynamodb-policy-attachment"
  roles      = [aws_iam_role.datasci-role.name]
  policy_arn = aws_iam_policy.dynamodb-policy.arn
}

##############################################################################################
#
##############################################################################################

