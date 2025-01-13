output "website_url" {
  value = aws_cloudfront_distribution.website_cdn.domain_name # Outputs the CloudFront distribution domain name. This is helpful for quick access to the deployed site.
}