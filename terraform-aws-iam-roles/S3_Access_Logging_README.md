# S3 Access Logging - Centralized Configuration Guide

## Overview

This document provides guidance on configuring your S3 buckets to send access logs to our centralized logging bucket. All S3 access logs across the organization should be directed to the central logging bucket in the audit account to ensure comprehensive visibility, consistent retention policies, and simplified security monitoring.

## Centralized Logging Bucket Information

- **Bucket Name**: `wal-s3-access-log`
- **Account**: Audit Account
- **Log Path Format**: `<account-id>/<region>/<bucket-name>/<date>/<logname>`
- **Retention Policy**: Logs are retained for 365 days with automated lifecycle management

## Benefits of Centralized S3 Access Logging

- **Security Monitoring**: Enables centralized detection of unauthorized access attempts
- **Compliance**: Supports audit requirements with consistent log retention
- **Forensics**: Provides historical access data for security investigations
- **Cost Efficiency**: Optimizes storage costs through consolidated management

## Configuration Steps

### Option 1: Using AWS Console

1. **Sign in to the AWS Management Console**
   - Log in to your AWS account where your S3 bucket is located

2. **Navigate to S3**
   - Go to Services > S3

3. **Select Your Bucket**
   - Click on the bucket name you want to configure for access logging

4. **Access Bucket Properties**
   - Click on the "Properties" tab

5. **Configure Server Access Logging**
   - Scroll down to "Server access logging"
   - Click "Edit"

6. **Enable Logging**
   - Select "Enable" for server access logging
   - For the Target bucket, enter: `arn:aws:s3:::wal-s3-access-log`
   - For the Target prefix, enter: `<your-account-id>/<region>/<your-bucket-name>/`
   - Click "Save changes"

### Option 2: Using AWS CLI

Run the following AWS CLI command, replacing the placeholders with your specific information:

```bash
aws s3api put-bucket-logging \
  --bucket <your-bucket-name> \
  --bucket-logging-status '{
    "LoggingEnabled": {
      "TargetBucket": "wal-s3-access-log",
      "TargetPrefix": "<your-account-id>/<region>/<your-bucket-name>/"
    }
  }'
```

### Option 3: Using CloudFormation

Include the following in your CloudFormation template:

```yaml
Resources:
  MyS3Bucket:
    Type: 'AWS::S3::Bucket'
    Properties:
      BucketName: <your-bucket-name>
      LoggingConfiguration:
        DestinationBucketName: wal-s3-access-log
        LogFilePrefix: <your-account-id>/<region>/<your-bucket-name>/
```

### Option 4: Using Terraform

```hcl
resource "aws_s3_bucket" "my_bucket" {
  bucket = "<your-bucket-name>"
}

resource "aws_s3_bucket_logging" "my_bucket_logging" {
  bucket = aws_s3_bucket.my_bucket.id
  
  target_bucket = "wal-s3-access-log"
  target_prefix = "${data.aws_caller_identity.current.account_id}/${data.aws_region.current.name}/${aws_s3_bucket.my_bucket.id}/"
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
```

## Verification

After configuring access logging, you should verify that logs are being delivered correctly:

1. Wait approximately 1-2 hours for logs to begin appearing
2. Check the target path in the centralized logging bucket:
   `wal-s3-access-log/<your-account-id>/<region>/<your-bucket-name>/`
3. Confirm that log files are being created with recent timestamps

## Log Format and Contents

S3 access logs contain detailed information about requests made to your bucket, including:

- Requester identity
- Bucket name
- Request time
- Request action
- Response status
- Error code (if applicable)

Example log entry:
```
79a59df900b949e55d96a1e698fbacedfd6e09d98eacf8f8d5218e7cd47ef2be awsexamplebucket [06/Feb/2019:00:00:38 +0000] 192.0.2.3 79a59df900b949e55d96a1e698fbacedfd6e09d98eacf8f8d5218e7cd47ef2be 3E57427F3EXAMPLE REST.GET.VERSIONING - "GET /awsexamplebucket?versioning HTTP/1.1" 200 - 113 - 7 - "-" "S3Console/0.4" - s9lzHYrFp76ZVxRcpX9+5cjAnEH2ROuNkd2BHfIa6UkFVdtjf5mKR3/eTPFvsiP/XV/VLi31234= SigV4 ECDHE-RSA-AES128-GCM-SHA256 AuthHeader awsexamplebucket.s3.us-west-1.amazonaws.com TLSV1.2
```

## Troubleshooting

### Common Issues

1. **Logs Not Appearing**
   - Verify the target bucket name is correct
   - Ensure the prefix follows the required format
   - Check that your account has permission to write to the target bucket

2. **Permission Errors**
   - The centralized logging bucket already has the necessary bucket policy to allow all accounts in the organization to write logs
   - If you receive permission errors, contact the Security team

3. **Invalid Prefix Format**
   - Ensure your prefix follows the exact format: `<account-id>/<region>/<bucket-name>/`
   - Do not include any leading or trailing slashes in your bucket name

### Support

For assistance with S3 access logging configuration, please contact:
- **Security Operations**: security-ops@example.com
- **Cloud Infrastructure Team**: cloud-support@example.com

## Compliance Requirements

All S3 buckets containing sensitive or regulated data **must** have access logging enabled and directed to the centralized logging bucket. This is enforced through:

1. AWS Config Rules
2. Security scanning during regular compliance audits
3. Automated remediation for non-compliant buckets

## FAQ

**Q: Will enabling access logging affect performance of my bucket?**  
A: No, S3 access logging is designed to have no impact on bucket performance.

**Q: How much does this cost my team?**  
A: There is no charge for sending logs to the centralized bucket. All storage costs for the logs are covered by the Security team.

**Q: Can I access my bucket's logs directly?**  
A: Yes, you can request read access to your specific log prefix in the centralized bucket by submitting a request to the Security team.

**Q: Are these logs used for billing purposes?**  
A: No, these logs are used for security monitoring and compliance purposes only. Separate mechanisms are used for billing analysis.

---

**Document Owner:** Security Operations Team  
**Last Updated:** [Current Date]  
**Review Cycle:** Annual
