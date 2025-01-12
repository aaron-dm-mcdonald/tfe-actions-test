output "frontend_index_endpoint" {
  value = "https://${aws_s3_bucket.frontend.bucket}.s3.us-east-1.amazonaws.com/index.html"
}


output "frontend_static_site_url" {
  value = "http://${aws_s3_bucket_website_configuration.frontend.website_endpoint}"

}

output "host_object_endpoints" {
  value = local.image_urls
}

resource "local_file" "frontend_index" {
  content  = data.template_file.frontend_index.rendered
  filename = "${path.module}/test-index.html"
}

