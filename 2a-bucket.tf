resource "aws_s3_bucket" "frontend" {
  bucket_prefix = "static-site-frontend-"
  force_destroy = true
 

  tags = {
    Name = "Frontend Bucket"
  }
}




resource "aws_s3_bucket_website_configuration" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

}


resource "aws_s3_object" "frontend" {
  for_each = tomap({
    #"index.html"          = "text/html"
    "styles.css"          = "text/css"
    "error.html"          = "text/html"
  })

  bucket       = aws_s3_bucket.frontend.bucket
  key          = each.key                               # S3 key matches the file path
  source       = "${path.module}/website/frontend/${each.key}" # Local path to the file
  content_type = each.value                             # Content type from the map
  depends_on   = [aws_s3_bucket_public_access_block.frontend, aws_s3_bucket_policy.frontend]

}

# Define the image URLs as a list in a locals block
locals {
  image_urls = [
    for obj in aws_s3_object.host :
    "https://${aws_s3_bucket.host.bucket}.s3.us-east-1.amazonaws.com/${obj.key}"
  ]
}

# Pass each image URL as a separate key to the template
data "template_file" "frontend_index" {
  template = file("${path.module}/website/frontend/index.html.tmpl")
  vars = {
    image_url_1 = local.image_urls[0]  # First image URL
    image_url_2 = local.image_urls[1]  # Second image URL
    image_url_3 = local.image_urls[2]  # Third image URL
  }
}

# Resource to create the S3 object for index.html
resource "aws_s3_object" "frontend_index" {
  bucket       = aws_s3_bucket.frontend.id
  key          = "index.html"
  content      = data.template_file.frontend_index.rendered
  content_type = "text/html"
}



########### IAM ####################
resource "aws_s3_bucket_public_access_block" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  block_public_acls       = false
  ignore_public_acls      = false
  block_public_policy     = false
  restrict_public_buckets = false
}

# Bucket Policy to allow public access to all objects in the bucket
resource "aws_s3_bucket_policy" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.frontend.arn}/*" # Allow access to all objects
      }
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.frontend] # Explicit dependency
}

