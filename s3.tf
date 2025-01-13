# Create an S3 Bucket
resource "aws_s3_bucket" "website_bucket" {
  bucket = var.bucket_name # Use a unique bucket name (defined as a variable) to avoid global name conflicts.

  tags = {
    Name        = "StaticWebsiteBucket" # Tag for identifying the resource.
    Environment = var.environment       # Tag indicating the deployment environment (e.g., dev, prod).
  }
}

# Set Bucket Ownership Controls
resource "aws_s3_bucket_ownership_controls" "ownership" {
  bucket = aws_s3_bucket.website_bucket.id # Reference to the created S3 bucket.

  rule {
    object_ownership = "BucketOwnerPreferred" # Ensures the bucket owner owns all objects uploaded to the bucket.
  }
}


# Restrict Public Access
resource "aws_s3_bucket_public_access_block" "public_access_block" {
  bucket = aws_s3_bucket.website_bucket.id # Reference to the created S3 bucket.

  block_public_acls       = true # Prevent public access via Access Control Lists (ACLs).
  block_public_policy     = true # Disallow public bucket policies.
  ignore_public_acls      = true # Ignore existing public ACLs.
  restrict_public_buckets = true # Restrict bucket from being made public.
}

# Set Bucket Policy
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.website_bucket.id # Reference to the S3 bucket.

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow", # Allow access to the S3 bucket.
        Principal = {
          AWS = "${aws_cloudfront_origin_access_identity.oai.iam_arn}" # Grant access only to CloudFront's Origin Access Identity (OAI).
        },
        Action    = "s3:GetObject", # Allow only GET requests to retrieve objects.
        Resource  = "${aws_s3_bucket.website_bucket.arn}/*" # Allow access to all objects in the bucket.
      }
    ]
  })
}

# Configure Static Website Hosting
resource "aws_s3_bucket_website_configuration" "website_config" {
  bucket = aws_s3_bucket.website_bucket.id # Reference to the S3 bucket.

  index_document {
    suffix = "index.html" # Defines the main page of the website.
  }

  error_document {
    key = "error.html" # Defines the error page for the website.
  }
}

# Upload Website Content
resource "aws_s3_object" "index_html" {
  bucket       = aws_s3_bucket.website_bucket.id # Reference to the S3 bucket.
  key          = "index.html" # Name of the object in the bucket.
  source       = "${path.module}/index.html" # Path to the HTML file to be uploaded.
  content_type = "text/html" # Content type of the file.
  acl          = "private" # Sets object to private for security.
}
