provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_policy" "lambda_policy" {
  name        = "lambda_policy"
  description = "Policy for Lambda function"

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
      "Resource": "arn:aws:s3:::bucket-sample1000/sample.csv"
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject"
      ],
      "Resource": "arn:aws:s3:::bucket-sample1000/output/*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  policy_arn = "arn:aws:iam::762676724532:policy/lambda_policy"
  role       = "arn:aws:iam::762676724532:role/Clone_data_from_GCS_to_S3_role_v2xqo06p"
}

resource "aws_lambda_function" "sample_lambda" {
  function_name    = "sample_lambda_function_ff"
  role             = "arn:aws:iam::762676724532:role/service-role/Clone_data_from_GCS_to_S3-role-v2xqo06p"
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.8"
  timeout          = 60
  memory_size      = 128

  filename         = "lambda_function.py"

  environment {
    variables = {
      BUCKET_NAME = "bucket-sample1000"
      FILE_NAME   = "sample.csv"
    }
  }
}

output "lambda_function_name" {
  value = aws_lambda_function.sample_lambda.function_name
}
