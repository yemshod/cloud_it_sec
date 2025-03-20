# Security Admin Role

## Policy Summary
The Security Admin policy provides comprehensive access to security services and configurations while implementing guardrails to prevent destructive actions on critical security resources.

### Main Policy Features:
- Grants full access to security services (Config, CloudTrail, GuardDuty, SecurityHub, etc.)
- Allows management of security-related resources (KMS, WAF, Shield, Network ACLs, Security Groups)
- Permits creation and management of security-related IAM roles and policies
- Enables monitoring and alerting via CloudWatch, SNS, and EventBridge
- Allows security assessment and auditing capabilities
- Permits creating service-linked roles for security services

### Permission Boundary Features:
- Allows the same set of security management permissions as the main policy
- Denies destructive actions on organization resources
- Prevents IAM user and group management
- Blocks modification of AWS service roles and non-security roles (admin, finance, devops)
- Prevents modification of AWS service policies and non-security policies
- Blocks deletion of critical infrastructure components
- Prevents disabling or deleting security services and monitoring

## Use Case
This role is designed for security administrators who need to implement, monitor, and enforce security controls across the AWS environment while being prevented from making destructive changes to critical resources or accessing user management capabilities.
