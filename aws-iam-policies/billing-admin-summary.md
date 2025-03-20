# Billing Admin Role

## Policy Summary
The Billing Admin policy provides comprehensive access to billing, cost management, and payment services while implementing guardrails to prevent actions outside the financial domain.

### Main Policy Features:
- Grants full access to billing, cost management, and payment services
- Allows management of budgets, purchase orders, and savings plans
- Provides access to cost optimization tools and recommendations
- Permits viewing organization structure and account information
- Enables access to support cases related to billing
- Allows viewing of reserved instance information across services
- Provides read-only access to IAM information for cost allocation
- Permits access to resource tagging information for cost allocation

### Permission Boundary Features:
- Allows the same set of billing and cost management permissions as the main policy
- Explicitly denies organization management actions (creating/deleting accounts, etc.)
- Prevents account closure or modification of account contact information
- Restricts IAM management to the user's own account and billing-related roles
- Blocks access to resource creation or modification in services like EC2, RDS, DynamoDB, etc.
- Ensures the role remains focused on billing and cost management without the ability to provision or modify resources

## Use Case
This role is designed for finance and billing administrators who need to manage billing, analyze costs, set up budgets, and optimize spending across the AWS environment without allowing them to make changes to resources, organization structure, or user access.
