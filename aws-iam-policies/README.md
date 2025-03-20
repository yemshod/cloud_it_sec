# AWS IAM Policies for Least Privilege Access

This repository contains a collection of AWS IAM policies designed to follow the principle of least privilege for various roles within an AWS environment. Each role has both a main policy and a permission boundary policy to provide defense in depth.

## Roles Included

1. **Administrator** - Full administrative access with guardrails to prevent destructive actions
2. **DevOps Engineer** - Access to build, deploy, and manage infrastructure and applications
3. **Security Admin** - Access to security services and configurations
4. **Network Admin** - Access to network infrastructure and connectivity services
5. **ViewOnly** - Read-only access across all AWS services
6. **Billing Admin** - Access to billing, cost management, and payment services
7. **SOC_IR** - Access for security operations center and incident response activities
8. **Audit and Governance** - Access for compliance monitoring, auditing, and governance
9. **DBA** - Access to database services and related resources

## Policy Structure

For each role, there are three files:
- `<role>-policy.json` - The main IAM policy for the role
- `<role>-permission-boundary.json` - The permission boundary policy for the role
- `<role>-summary.md` - A summary of the policy features and use case

## Implementation Guidance

1. Create the permission boundary policies first
2. Create the IAM roles with the main policies
3. Attach the permission boundaries to the roles
4. Assign roles to users or groups as needed

## Best Practices

- Review and customize these policies to match your specific requirements
- Regularly audit role permissions using IAM Access Analyzer
- Implement additional guardrails using Service Control Policies (SCPs) at the organization level
- Use AWS CloudTrail to monitor role usage and identify potential issues
- Periodically review and update policies to remove unnecessary permissions

## Security Considerations

These policies are designed to provide a starting point for implementing least privilege access in your AWS environment. They include various guardrails to prevent destructive actions, but should be reviewed and customized to match your specific security requirements.

Key security features implemented across these policies include:
- Preventing deletion of production resources
- Blocking disabling of security services
- Restricting access to sensitive data
- Limiting IAM management capabilities
- Protecting critical infrastructure components
