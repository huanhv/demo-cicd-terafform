provider "aws" {
  region = "us-east-1"  # Replace with your desired region
}

resource "aws_iam_role" "lambda_execution_role" {
  name = "lambda_execution_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
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

  # Attach the necessary policies to the IAM role (adjust as per your requirements)
  policy {
    name   = "lambda_policy"
    policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject"
      ],
      "Resource": "arn:aws:s3:::bucket-sample1000/sample.csv"  # Replace with your S3 bucket and file ARN
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject"
      ],
      "Resource": "arn:aws:s3:::bucket-sample1000/output/*"  # Replace with your S3 bucket output folder ARN
    }
  ]
}
EOF
}

resource "aws_lambda_function" "sample_lambda" {
  function_name    = "sample_lambda_function"  # Replace with your desired Lambda function name
  role             = aws_iam_role.lambda_execution_role.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.8"
  timeout          = 60
  memory_size      = 128  # Adjust as per your requirements

  filename         = "lambda_function.py"  # Replace with the actual filename if different

  # Environment variables (if required)
  environment {
    variables = {
      BUCKET_NAME = "bucket-sample1000"  # Replace with your S3 bucket name
      FILE_NAME   = "sample.csv"  # Replace with your file name
    }
  }
}

output "lambda_function_name" {
  value = aws_lambda_function.sample_lambda.function_name
}
