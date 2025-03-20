# Database Administrator (DBA) Role

## Policy Summary
The Database Administrator policy provides comprehensive access to database services and related resources while implementing guardrails to prevent destructive actions on production databases.

### Main Policy Features:
- Grants comprehensive access to database services (RDS, DynamoDB, Redshift, etc.)
- Allows management of database-related networking components (security groups, etc.)
- Permits configuration of monitoring, logging, and alerting for databases
- Enables management of database secrets and parameters
- Allows access to database-related S3 buckets for imports/exports
- Permits passing roles to database services
- Enables creation and management of database-related event rules
- Denies deletion of production database resources

### Permission Boundary Features:
- Allows the same set of database management permissions as the main policy
- Explicitly denies organization and account management
- Prevents IAM user, group, role, and policy management
- Blocks EC2 instance and VPC infrastructure management
- Restricts S3 bucket creation and deletion to database-related buckets only
- Prevents KMS key creation, disabling, or deletion
- Blocks deletion of secrets in Secrets Manager
- Reinforces protection of production database resources

## Use Case
This role is designed for database administrators who need to create, configure, monitor, and maintain database resources across various AWS database services while being prevented from making changes to non-database resources or accessing user management capabilities.
