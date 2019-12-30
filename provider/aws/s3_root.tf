resource "aws_s3_bucket" "s3-root" {
    bucket = "${var.owner_name}-cdp"
    acl = "private"
    versioning {
        enabled = true
    }
    tags = {
      Name    = "${var.owner_name}-${var.name_prefix}-s3-root-bucket"
      owner   = var.owner_name
      project = var.tag_project
      enddate = var.tag_enddate
    }
}

resource "aws_s3_bucket_object" "s3-logs" {
    bucket = aws_s3_bucket.s3-root.id
    acl = "private"
    key = "logs/"
    source = "/dev/null"
    tags = {
      Name    = "${var.owner_name}-${var.name_prefix}-s3-logs"
      owner   = var.owner_name
      project = var.tag_project
      enddate = var.tag_enddate
    }

}

resource "aws_s3_bucket_object" "s3-logs-user" {
    bucket = aws_s3_bucket.s3-root.id
    acl = "private"
    key = "logs/${var.owner_name}-01/"
    source = "/dev/null"
    tags = {
      Name    = "${var.owner_name}-${var.name_prefix}-s3-logs-user"
      owner   = var.owner_name
      project = var.tag_project
      enddate = var.tag_enddate
    }

}

resource "aws_s3_bucket_object" "s3-data" {
    bucket = aws_s3_bucket.s3-root.id
    acl = "private"
    key = "${var.owner_name}-01/"
    source = "/dev/null"
    tags = {
      Name    = "${var.owner_name}-${var.name_prefix}-s3-data"
      owner   = var.owner_name
      project = var.tag_project
      enddate = var.tag_enddate
    }

}

resource "aws_s3_bucket_object" "s3-dataeng" {
    bucket = aws_s3_bucket.s3-root.id
    acl = "private"
    key = "${var.owner_name}-01/dataeng/"
    source = "/dev/null"
    tags = {
      Name    = "${var.owner_name}-${var.name_prefix}-s3-dataeng"
      owner   = var.owner_name
      project = var.tag_project
      enddate = var.tag_enddate
    }

}

resource "aws_s3_bucket_object" "s3-datasci" {
    bucket = aws_s3_bucket.s3-root.id
    acl = "private"
    key = "${var.owner_name}-01/datasci/"
    source = "/dev/null"
    tags = {
      Name    = "${var.owner_name}-${var.name_prefix}-s3-datasci"
      owner   = var.owner_name
      project = var.tag_project
      enddate = var.tag_enddate
    }

}
