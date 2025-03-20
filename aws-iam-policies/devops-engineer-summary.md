# DevOps Engineer Role

## Policy Summary
The DevOps Engineer policy provides comprehensive access to build, deploy, and manage infrastructure and applications while implementing guardrails to prevent destructive actions on critical resources.

### Main Policy Features:
- Grants broad access to infrastructure services (EC2, ELB, Auto Scaling)
- Allows management of container services (ECS, ECR, EKS)
- Permits configuration of serverless resources (Lambda, API Gateway)
- Enables CI/CD pipeline management (CodeBuild, CodeCommit, CodeDeploy, CodePipeline)
- Provides access to database services (RDS, DynamoDB)
- Allows management of service roles with specific naming patterns
- Permits creation of service-linked roles for specific AWS services
- Denies deletion of production infrastructure components

### Permission Boundary Features:
- Allows the same set of permissions as the main policy
- Denies access to organization and account management
- Prevents IAM user and group management
- Blocks modification of AWS service roles, security roles, and admin roles
- Prevents deletion or disabling of KMS keys
- Protects backup, audit, and log buckets from deletion
- Prevents disabling security services
- Reinforces protection of production infrastructure

## Use Case
This role is designed for DevOps engineers who need broad access to build, deploy, and manage infrastructure and applications while being prevented from making destructive changes to critical resources or accessing user management capabilities.
