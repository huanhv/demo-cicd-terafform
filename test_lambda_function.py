import json
import boto3
from moto import mock_s3
import pandas as pd
import io
import pytest

from lambda_function import lambda_handler

# Mock the S3 service using moto
@mock_s3
def test_lambda_handler():
    # Create a mock S3 bucket
    bucket_name = 'bucket-sample1000'
    s3 = boto3.client('s3')
    s3.create_bucket(Bucket=bucket_name)
    
    # Upload a sample CSV file to the bucket
    file_name = 'sample.csv'
    sample_data = '''Index,User Id,First Name,Last Name,Sex,Email,Phone,Date of birth,Job Title
    1,1001,John,Doe,Male,john@example.com,1234567890,1990-01-01,Engineer
    2,1002,Jane,Smith,Female,jane@example.com,9876543210,1995-06-15,Manager
    3,1003,Michael,Johnson,Male,michael@example.com,5678901234,1985-09-20,Developer'''
    s3.put_object(Body=sample_data, Bucket=bucket_name, Key=file_name)
    
    # Call the lambda_handler function
    lambda_handler(None, None)
    
    # Read the output CSV file
    response = s3.get_object(Bucket=bucket_name, Key='output/combined_data.csv')
    output_csv_data = response['Body'].read().decode('utf-8')
    df = pd.read_csv(io.StringIO(output_csv_data))
    
    # Assert the expected values in the DataFrame
    assert len(df) == 2  # Expecting 2 rows (Male, Female)
    assert df['Sex'].tolist() == ['Male', 'Female']
    assert df['Count'].tolist() == [2, 1]