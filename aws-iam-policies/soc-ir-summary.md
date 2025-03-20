# SOC_IR (Security Operations Center and Incident Response) Role

## Policy Summary
The SOC_IR policy provides comprehensive access to security monitoring and incident response capabilities while implementing guardrails to prevent destructive actions on critical resources.

### Main Policy Features:
- Grants comprehensive read access to security services (CloudTrail, GuardDuty, SecurityHub, etc.)
- Allows investigation of security findings and events
- Permits limited remediation actions like updating security groups, stopping compromised instances, and disabling compromised access keys
- Enables creation of forensic snapshots of instances
- Allows configuration of security monitoring and alerting
- Provides access to logs and metrics for investigation
- Permits execution of incident response automation via SSM
- Allows communication with security teams via SNS and support cases
- Restricts destructive IAM actions to only resources tagged as SOC-IR-Managed

### Permission Boundary Features:
- Allows the same set of security monitoring and response permissions as the main policy
- Explicitly denies destructive EC2 actions (terminating instances, deleting VPCs, etc.)
- Prevents creation or deletion of IAM users, groups, roles, and policies
- Blocks organization management actions
- Protects backup, audit, and log buckets from deletion or policy changes
- Prevents disabling or deleting security and compliance services

## Use Case
This role is designed for security operations center (SOC) analysts and incident responders who need to monitor, detect, investigate, and respond to security incidents while being prevented from making destructive changes to critical infrastructure or identity resources.
