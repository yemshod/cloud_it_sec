# Network Admin Role

## Policy Summary
The Network Admin policy provides comprehensive access to network infrastructure and connectivity services while implementing guardrails to prevent destructive actions on critical network resources.

### Main Policy Features:
- Grants comprehensive permissions to manage network infrastructure (VPCs, subnets, route tables, etc.)
- Allows management of network connectivity services (VPN, Direct Connect, Transit Gateway)
- Permits configuration of network security components (security groups, NACLs, network firewalls)
- Enables management of network-related services (Route 53, CloudFront, API Gateway, Load Balancers)
- Provides access to monitoring and logging for network resources
- Allows creating service-linked roles for network-related services
- Denies deletion of production network infrastructure

### Permission Boundary Features:
- Allows the same set of network management permissions as the main policy
- Denies access to organization and account management
- Prevents IAM user, group, policy, and role management
- Blocks access to compute, storage, and database resources (EC2 instances, RDS, S3, etc.)
- Reinforces protection of production network infrastructure
- Prevents disabling or deleting security and compliance services

## Use Case
This role is designed for network administrators who need to design, implement, and manage network infrastructure and connectivity while being prevented from making changes to non-network resources or accessing user management capabilities.
