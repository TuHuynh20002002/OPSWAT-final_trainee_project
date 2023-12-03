################################################################################
# S3 bucket
################################################################################

resource "aws_s3_bucket" "bucket" {
  bucket        = var.s3-bucket_name
  force_destroy = var.s3-force_destroy

  provisioner "local-exec" {
    when        = destroy
    command     = "./scripts/remove_contents.sh"
    interpreter = ["sh"]
    working_dir = path.module
    environment = {
      BUCKET_ID = self.id
    }
  }
}

# resource "aws_s3_bucket_acl" "example" {
#   bucket = aws_s3_bucket.bucket.id
#   acl    = "public-read-write"
# }

resource "aws_s3_bucket_versioning" "version" {
  bucket = aws_s3_bucket.bucket.id
  versioning_configuration {
    status = "Disabled"
  }
}

################################################################################
# S3 bucket static web
################################################################################

resource "aws_s3_bucket_public_access_block" "access" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_object" "object" {
  key                    = "somekey"
  bucket                 = aws_s3_bucket.bucket.id
  server_side_encryption = "AES256"
}

resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.bucket.id

  index_document {
    suffix = "index.html"
  }

  # error_document {
  #   key = "error.html"
  # }
}

data "aws_iam_policy_document" "allow_access_from_another_account" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject",
      # "s3:ListBucket",
    ]

    resources = [
      aws_s3_bucket.bucket.arn,
      "${aws_s3_bucket.bucket.arn}/*",
    ]
  }
}

resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket     = aws_s3_bucket.bucket.id
  policy     = data.aws_iam_policy_document.allow_access_from_another_account.json
  depends_on = [aws_s3_bucket_public_access_block.access]
}

################################################################################
# S3 bucket upload
################################################################################

resource "null_resource" "remove_and_upload_to_s3" {
  provisioner "local-exec" {
    command     = "aws s3 sync ./build/ s3://${aws_s3_bucket.bucket.id}"
    working_dir = path.module
  }
}