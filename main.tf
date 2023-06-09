provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "sample_bucket" {
  bucket = "bucket-sample1000"
}

resource "aws_lambda_function" "sample_lambda" {
  function_name = "sample_lambda_function"
  handler      = "lambda_function.lambda_handler"
  runtime      = "python3.8"
  role         = aws_iam_role.sample_lambda_role.arn
  source_code_hash = filebase64sha256("lambda_function.py")

  environment {
    variables = {
      BUCKET_NAME = aws_s3_bucket.sample_bucket.bucket
      FILE_NAME   = "sample.csv"
    }
  }
}

resource "aws_iam_role" "sample_lambda_role" {
  name = "sample_lambda_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}
