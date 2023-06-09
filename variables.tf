variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
  default     = "bucket-sample1000"
}

variable "file_name" {
  description = "The name of the CSV file"
  type        = string
  default     = "sample.csv"
}

variable "lambda_function_name" {
  description = "The name of the Lambda function"
  type        = string
  default     = "sample_lambda_function"
}

variable "aws_region" {
  description = "The AWS region where the resources will be deployed"
  type        = string
  default     = "us-east-1"
}