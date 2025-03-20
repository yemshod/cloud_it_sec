# Administrator Role

## Policy Summary
The Administrator policy provides full administrative access to all AWS resources while implementing guardrails to prevent destructive actions that could impact organizational integrity or critical security configurations.

### Main Policy Features:
- Grants full access to all AWS services and resources
- Denies destructive organization actions like leaving or deleting the organization
- Prevents account closure
- Blocks deletion of account password policies and aliases
- Prevents deletion or disabling of critical KMS keys

### Permission Boundary Features:
- Allows full access to all AWS services and resources
- Denies organization and account management actions
- Prevents IAM user creation/deletion and access key management
- Blocks modification of account password policies and aliases
- Prevents deletion or disabling of KMS keys
- Protects backup, audit, and log buckets from deletion
- Prevents disabling or deleting security services (CloudTrail, Config, GuardDuty, SecurityHub)

## Use Case
This role is designed for senior administrators who need broad access to manage AWS resources but should be prevented from taking actions that could severely impact organizational security or compliance posture.
