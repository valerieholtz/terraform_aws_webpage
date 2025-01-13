# Create a CloudFront Origin Access Identity (OAI)
resource "aws_cloudfront_origin_access_identity" "oai" {
  comment = "OAI for CloudFront to access S3 bucket" 
  # OAI (Origin Access Identity) allows CloudFront to securely access a private S3 bucket.
}

# Create a CloudFront Distribution for the Website
resource "aws_cloudfront_distribution" "website_cdn" {

  # Define the origin for the CloudFront distribution
  origin {
    domain_name = aws_s3_bucket.website_bucket.bucket_regional_domain_name 
    # Specifies the domain name of the S3 bucket that serves as the origin.
    
    origin_id   = "S3-Website-Origin" 
    # A unique identifier for the origin.

    # Configure S3 as the origin using the OAI
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
      # Connects the CloudFront distribution to the S3 bucket securely using the OAI.
    }
  }

  # General distribution settings
  enabled             = true           # Enables the CloudFront distribution.
  is_ipv6_enabled     = true           # Enables IPv6 for improved network performance.
  default_root_object = "index.html"   # Specifies the default object to load for the root URL.

  # Configure the default cache behavior
  default_cache_behavior {
    target_origin_id       = "S3-Website-Origin" 
    # Links this cache behavior to the origin defined above.

    viewer_protocol_policy = "redirect-to-https" 
    # Enforces HTTPS for secure communication between viewers and CloudFront.

    # Allowed HTTP methods for cached content
    allowed_methods = ["GET", "HEAD"]  # Permits only GET and HEAD methods for accessing resources.
    cached_methods  = ["GET", "HEAD"]  # Specifies the methods to cache.

    # Configure forwarded values
    forwarded_values {
      query_string = false # Disables forwarding query strings to the origin.
      cookies {
        forward = "none"   # Disables forwarding cookies to the origin.
      }
    }

    # Caching time-to-live (TTL) settings
    min_ttl     = 0        # Minimum time an object is cached (0 seconds).
    default_ttl = 3600     # Default cache time (1 hour).
    max_ttl     = 86400    # Maximum cache time (1 day).
  }

  # Viewer certificate configuration
  viewer_certificate {
    cloudfront_default_certificate = true 
    # Use the default CloudFront SSL/TLS certificate to enable HTTPS.
  }

  # Configure geo-restrictions
  restrictions {
    geo_restriction {
      restriction_type = "none" 
      # No geographical restrictions, allowing global access.
    }
  }

  # Add tags to identify and manage the CloudFront distribution
  tags = {
    Name = "WebsiteDistribution" # Tag for naming the CloudFront distribution.
  }
}
