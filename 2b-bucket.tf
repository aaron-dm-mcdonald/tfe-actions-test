resource "aws_s3_bucket" "host" {
  bucket_prefix = "static-site-cors-host-"
  force_destroy = true
  

  tags = {
    Name = "Images Host"
  }

}

resource "aws_s3_bucket_cors_configuration" "host" {
  bucket = aws_s3_bucket.host.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT", "POST"]
    allowed_origins = ["*"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }

  cors_rule {
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
  }
}







resource "aws_s3_object" "host" {
  for_each = tomap({
    "images/image-1.jpg" = "image/jpeg"
    "images/image-2.jpg" = "image/jpeg"
    "images/image-3.jpg" = "image/jpeg"
  })

  bucket       = aws_s3_bucket.host.bucket
  key          = each.key                               # S3 key matches the file path
  source       = "${path.module}/website/host/${each.key}" # Local path to the file
  content_type = each.value                             # Content type from the map
  depends_on   = [aws_s3_bucket_public_access_block.host, aws_s3_bucket_policy.host]

}


########### IAM ####################
resource "aws_s3_bucket_public_access_block" "host" {
  bucket = aws_s3_bucket.host.id

  block_public_acls       = false
  ignore_public_acls      = false
  block_public_policy     = false
  restrict_public_buckets = false
}

# Bucket Policy to allow public access to all objects in the bucket
resource "aws_s3_bucket_policy" "host" {
  bucket = aws_s3_bucket.host.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.host.arn}/*" # Allow access to all objects
      }
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.host] # Explicit dependency
}

