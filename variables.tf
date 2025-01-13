
variable "bucket_name" {
  description = "The name of the S3 bucket for the website"
  type        = string
  default     = "valeries-bucket"
}

variable "environment" {
  description = "The environment for the deployment (e.g., Production, Staging)"
  type        = string
  default     = "Production"
}