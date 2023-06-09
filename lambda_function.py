import json
import boto3
import pandas as pd
import io

def lambda_handler(event, context):
    # Specify your S3 bucket name and file paths
    bucket_name = 'bucket-sample1000'
    file_name = 'sample.csv'  # Replace with your file name
    
    # Create an S3 client
    s3 = boto3.client('s3')
    
    # Retrieve the object from S3
    try:
        response = s3.get_object(Bucket=bucket_name, Key=file_name)
        # Read the CSV data
        csv_data = response['Body'].read().decode('utf-8')
        
        # Create a DataFrame from the CSV data
        df = pd.read_csv(io.StringIO(csv_data))
        
        # Combine data by sex
        sex_counts = df['Sex'].value_counts()
        
        # Create a new DataFrame with the combined data
        combined_df = pd.DataFrame({'Sex': sex_counts.index, 'Count': sex_counts.values})
        
        # Convert DataFrame to CSV string
        csv_string = combined_df.to_csv(index=False)
        
        # Upload the CSV string to S3
        output_file_path = 'output/combined_data.csv'
        s3.put_object(Body=csv_string, Bucket=bucket_name, Key=output_file_path)
        
        # Print a success message
        print('Combined data saved to S3 successfully!')
        
    except Exception as e:
        print('Error occurred:', e)
        raise e
