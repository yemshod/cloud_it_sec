# Amazon EMR Security Guardrails for Exact Trust Environment

## Overview
This document defines technical guardrails for Amazon EMR deployments in Exact Trust environments. These guardrails are designed to be implemented as code in validation tools (Checkov, CloudFormation Guard), detection mechanisms (Prisma Cloud), and enforcement controls. Each guardrail includes specific parameters that can be programmatically validated during infrastructure deployment pipelines or detected in runtime environments. These controls focus on currently available Amazon EMR capabilities and configurations to ensure deployments maintain security compliance with organizational standards and industry frameworks.

## Security Guardrails Table

| Guardrail Description | Type of Guardrail | Framework Mappings | Other Comments |
|----------------------|-------------------|-------------------|----------------|
| **Private Subnet Deployment**: Validate that EMR clusters are deployed in private subnets with `EmrManagedMasterSecurityGroup` and `EmrManagedSlaveSecurityGroup` | Preventive | CIS AWS 2.1, NIST 800-53 SC-7, MITRE ATT&CK T1133 | Check subnet configuration to ensure no public IP assignment and proper security group configuration |
| **Security Configuration Enforcement**: Verify that `SecurityConfiguration` parameter is specified and references a valid security configuration | Preventive | CIS AWS 2.1.2, NIST 800-53 SC-28, MITRE ATT&CK T1530 | Validate that all EMR clusters have an associated security configuration |
| **Encryption in Transit**: Validate that security configuration has `EnableInTransitEncryption` set to `true` | Preventive | CIS AWS 2.2.1, NIST 800-53 SC-8, MITRE ATT&CK T1048 | Check security configuration for in-transit encryption settings |
| **Encryption at Rest**: Verify that security configuration has `EnableAtRestEncryption` set to `true` with `SSE-KMS` for EMRFS | Preventive | CIS AWS 2.1.2, NIST 800-53 SC-28, MITRE ATT&CK T1530 | Validate that at-rest encryption is enabled with proper KMS configuration |
| **KMS Key Validation**: Verify that EMR encryption uses customer-managed KMS keys (not AWS-managed) | Preventive | CIS AWS 2.1.2, NIST 800-53 SC-28, MITRE ATT&CK T1530 | Check that KMS key ID follows pattern `arn:aws:kms:region:account-id:key/key-id` and not `aws/service` pattern |
| **IAM Role Least Privilege**: Validate that EMR service roles and instance profiles have no wildcard permissions | Preventive | CIS AWS 1.16, NIST 800-53 AC-6, MITRE ATT&CK T1078 | Scan IAM policy documents for `"Action": "*"` or `"Resource": "*"` patterns |
| **Security Group Rules**: Verify that EMR security groups have no `0.0.0.0/0` ingress rules | Preventive | CIS AWS 4.1, NIST 800-53 AC-4, MITRE ATT&CK T1190 | Scan security group rules for overly permissive CIDR blocks |
| **Mandatory Tag Validator**: Check for presence of required tags (`Owner`, `DataClassification`, `Compliance`, `CostCenter`) on EMR clusters | Preventive | CIS AWS 1.5, NIST 800-53 CM-8, MITRE ATT&CK T1526 | Validate that all required tags exist with non-empty values |
| **EMR Block Public Access**: Verify that `BlockPublicAccessConfiguration` is enabled with `BlockPublicSecurityGroupRules` set to `true` | Preventive | CIS AWS 2.1, NIST 800-53 SC-7, MITRE ATT&CK T1133 | Check for block public access configuration at account level |
| **Kerberos Authentication**: Validate that EMR clusters have Kerberos authentication enabled with proper `KerberosAttributes` | Preventive | NIST 800-53 IA-2, MITRE ATT&CK T1078 | Check for presence and proper configuration of Kerberos attributes |
| **Log Configuration**: Verify that EMR clusters have logging enabled with `LogUri` pointing to an S3 bucket with proper encryption | Detective | CIS AWS 3.1, NIST 800-53 AU-2, MITRE ATT&CK T1530 | Validate that logging is enabled and properly configured |
| **EMR Instance Types**: Validate that EMR instance types conform to approved list (`m5.xlarge`, `r5.xlarge`, etc.) | Preventive | NIST 800-53 CM-7, MITRE ATT&CK T1496 | Check instance types against allowlist of approved instance types |
| **EMR Version Control**: Verify that EMR release label is from approved versions list (e.g., `emr-6.6.0` or newer) | Preventive | NIST 800-53 CM-2, MITRE ATT&CK T1562 | Validate EMR release label against minimum approved version |
| **VPC Endpoint Configuration**: Validate that required VPC endpoints for EMR are configured (S3, DynamoDB, etc.) | Preventive | CIS AWS 2.1, NIST 800-53 SC-7, MITRE ATT&CK T1133 | Check for presence of required VPC endpoints in the VPC used by EMR |
| **EMR Step Execution Role**: Verify that EMR step execution roles have proper permission boundaries | Preventive | CIS AWS 1.16, NIST 800-53 AC-6, MITRE ATT&CK T1078 | Validate that step execution roles have permission boundaries attached |
| **Termination Protection**: Validate that `TerminationProtected` is set to `true` for production EMR clusters | Preventive | NIST 800-53 CP-10, MITRE ATT&CK T1485 | Check for termination protection configuration on production clusters |
| **EMR Notebook Security**: For EMR notebooks, verify that `SecurityGroupIds` are properly configured with no public access | Preventive | CIS AWS 4.1, NIST 800-53 AC-4, MITRE ATT&CK T1190 | Validate security group configuration for EMR notebooks |
| **S3 EMRFS Authorization**: Verify that EMRFS security configuration uses IAM roles for S3 access with proper authorization | Preventive | NIST 800-53 AC-3, MITRE ATT&CK T1078 | Check for proper EMRFS authorization configuration |
| **CloudWatch Metrics Integration**: Validate that EMR clusters have detailed monitoring enabled | Detective | CIS AWS 3.1, NIST 800-53 SI-4, MITRE ATT&CK T1530 | Check for detailed monitoring configuration |
| **Region Restriction**: Validate that EMR clusters are only deployed in approved regions | Preventive | CIS AWS 1.22, NIST 800-53 CM-7, MITRE ATT&CK T1526 | Check AWS region in resource ARNs against allowlist of approved regions |

## Implementation Examples

### Example 1: Checkov Custom Policy for EMR Private Subnet Deployment
```python
def check_emr_private_subnet(cfg, params):
    resources = cfg.get('Resources', {})
    
    for resource_name, resource in resources.items():
        if resource.get('Type') == 'AWS::EMR::Cluster':
            instances = resource.get('Properties', {}).get('Instances', {})
            ec2_subnet_id = instances.get('Ec2SubnetId')
            
            if ec2_subnet_id:
                # Check if subnet reference exists in the template
                for subnet_resource_name, subnet_resource in resources.items():
                    if subnet_resource.get('Type') == 'AWS::EC2::Subnet' and subnet_resource_name == ec2_subnet_id.split('.')[-1]:
                        # Check if MapPublicIpOnLaunch is false
                        if subnet_resource.get('Properties', {}).get('MapPublicIpOnLaunch') == True:
                            return False, f"EMR cluster {resource_name} is using a public subnet"
            
            # Check for security groups
            if not instances.get('EmrManagedMasterSecurityGroup') or not instances.get('EmrManagedSlaveSecurityGroup'):
                return False, f"EMR cluster {resource_name} is missing required security group configuration"
    
    return True, "All EMR clusters are deployed in private subnets with proper security groups"
```

### Example 2: Prisma Cloud Policy for EMR Encryption
```yaml
policy:
  name: "EMR Encryption Configuration"
  description: "Ensures EMR clusters have encryption enabled"
  severity: "high"
  resource: "aws_emr_cluster"
  parameters: {}
  query: |
    security_configuration exists and
    security_configuration.*.encryption_configuration.*.enable_at_rest_encryption is true and
    security_configuration.*.encryption_configuration.*.enable_in_transit_encryption is true
```

### Example 3: CloudFormation Guard Rule for EMR Security Configuration
```ruby
rule emr_security_configuration_check when resource.Type == "AWS::EMR::Cluster" {
  resource.Properties.SecurityConfiguration exists
  
  # If we have access to the security configuration content
  when resource.Properties.SecurityConfiguration is_string {
    let security_config = resource.Properties.SecurityConfiguration
    security_config.EncryptionConfiguration.EnableInTransitEncryption == true
    security_config.EncryptionConfiguration.EnableAtRestEncryption == true
    security_config.EncryptionConfiguration.AtRestEncryptionConfiguration.S3EncryptionConfiguration.EncryptionMode == "SSE-KMS"
  }
}
```

### Example 4: Terraform Sentinel Policy for EMR Block Public Access
```hcl
import "tfplan/v2" as tfplan

# Get all EMR block public access configurations
emr_bpa_configs = filter tfplan.resource_changes as _, rc {
  rc.type is "aws_emr_block_public_access_configuration" and
  rc.mode is "managed" and
  (rc.change.actions contains "create" or rc.change.actions contains "update")
}

# Check for proper block public access configuration
validate_block_public_access = func(config) {
  return config.change.after.block_public_security_group_rules is true
}

# Main rule
main = rule {
  all emr_bpa_configs as _, config {
    validate_block_public_access(config)
  }
}
```

### Example 5: AWS Config Custom Rule for EMR Kerberos Authentication
```python
def evaluate_compliance(configuration_item, rule_parameters):
    if configuration_item['resourceType'] != 'AWS::EMR::Cluster':
        return 'NOT_APPLICABLE'
    
    cluster_properties = configuration_item['configuration']
    
    # Check if Kerberos is enabled
    if 'KerberosAttributes' not in cluster_properties:
        return 'NON_COMPLIANT'
    
    kerberos_attributes = cluster_properties['KerberosAttributes']
    
    # Check for required Kerberos attributes
    if not kerberos_attributes.get('Realm') or not kerberos_attributes.get('KdcAdminPassword'):
        return 'NON_COMPLIANT'
    
    return 'COMPLIANT'
```

## Regular Review Process

Establish a quarterly review process to:
- Evaluate the effectiveness of implemented guardrails
- Update guardrails based on new Amazon EMR features or capabilities
- Incorporate lessons learned from security incidents or near-misses
- Align with evolving compliance requirements
