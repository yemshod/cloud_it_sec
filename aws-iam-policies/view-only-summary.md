# ViewOnly Role

## Policy Summary
The ViewOnly policy provides read-only access across all AWS services for monitoring, troubleshooting, and auditing purposes without allowing any modifications or access to sensitive data.

### Main Policy Features:
- Grants read-only permissions across all major AWS services
- Includes permissions to view resources, configurations, logs, and metrics
- Allows access to security and compliance information
- Permits viewing cost and billing information
- Enables access to monitoring and health data
- Provides visibility into resource relationships and tags

### Permission Boundary Features:
- Allows the same set of read-only permissions as the main policy
- Explicitly denies access to sensitive data in S3 buckets with specific naming patterns
- Prevents access to secret values, parameters, and encrypted content
- Blocks ability to view actual data in databases or function code
- Ensures the role remains strictly read-only without access to sensitive information

## Use Case
This role is designed for users who need comprehensive visibility into the AWS environment for monitoring, troubleshooting, and auditing purposes without allowing any modifications or access to sensitive data. It's suitable for auditors, support staff, and other users who need visibility without write access.
