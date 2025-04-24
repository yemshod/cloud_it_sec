# Amazon Q Security Guardrails for Exact Trust Environment

## Overview
This document defines technical guardrails for Amazon Q deployments in Exact Trust environments. These guardrails are designed to be implemented as code in validation tools (Checkov, CloudFormation Guard), detection mechanisms (Prisma Cloud), and enforcement controls. Each guardrail includes specific parameters that can be programmatically validated during infrastructure deployment pipelines or detected in runtime environments. These controls focus on currently available Amazon Q capabilities and configurations to ensure deployments maintain security compliance with organizational standards and industry frameworks.

## Security Guardrails Table

| Guardrail Description | Type of Guardrail | Framework Mappings | Other Comments |
|----------------------|-------------------|-------------------|----------------|
| **VPC Endpoint Validation**: Validate that Amazon Q Business is configured to use VPC endpoints with proper VPC configuration | Preventive | CIS AWS 2.1, NIST 800-53 SC-7, MITRE ATT&CK T1133 | IaC validator checks for presence of VPC configuration with subnet IDs and security group IDs in Amazon Q Business applications |
| **IAM Policy Scanner**: Detect IAM roles with `"Action": "*"` or `"Resource": "*"` in policies attached to Amazon Q resources | Preventive | CIS AWS 1.16, NIST 800-53 AC-6, MITRE ATT&CK T1078 | Scan IAM policy documents for wildcard permissions and block deployment if detected |
| **KMS Key Enforcement**: Validate that `kmsKeyId` parameter is set to a customer-managed key ARN (not AWS-managed) for Amazon Q Business applications | Preventive | CIS AWS 2.1.2, NIST 800-53 SC-28, MITRE ATT&CK T1530 | Check that KMS key ID follows pattern `arn:aws:kms:region:account-id:key/key-id` and not `aws/service` pattern |
| **Service Role Permission Boundary**: Verify that IAM roles used by Amazon Q have permission boundaries attached | Preventive | CIS AWS 1.16, NIST 800-53 AC-2(7), MITRE ATT&CK T1078 | Check for presence of permission boundary ARN in IAM role definitions used by Amazon Q |
| **Mandatory Tag Validator**: Check for presence of required tags (`Owner`, `DataClassification`, `Compliance`, `CostCenter`) on all Amazon Q resources | Preventive | CIS AWS 1.5, NIST 800-53 CM-8, MITRE ATT&CK T1526 | Validate that all required tags exist with non-empty values |
| **CloudTrail Integration**: Verify that Amazon Q API calls are captured in CloudTrail by checking `eventSource` patterns | Detective | CIS AWS 3.1, NIST 800-53 AU-2, MITRE ATT&CK T1530 | Validate CloudTrail is enabled and includes Amazon Q service events |
| **Region Restriction**: Validate that Amazon Q resources are only deployed in approved regions based on service availability and compliance requirements | Preventive | CIS AWS 1.22, NIST 800-53 CM-7, MITRE ATT&CK T1526 | Check AWS region in resource ARNs against allowlist of approved regions |
| **Security Group Rule Validation**: Verify that security groups associated with Amazon Q Business resources have no `0.0.0.0/0` ingress rules | Preventive | CIS AWS 4.1, NIST 800-53 AC-4, MITRE ATT&CK T1190 | Scan security group rules for overly permissive CIDR blocks |
| **Private Endpoint Validation**: For Amazon Q Business, verify that VPC configuration is properly set for private access | Preventive | CIS AWS 2.1, NIST 800-53 SC-7, MITRE ATT&CK T1133 | Validate VPC configuration parameters for private access only |
| **Resource-Based Policy Validation**: For Amazon Q Business applications, verify that resource-based policies restrict access to authorized principals only | Preventive | CIS AWS 1.16, NIST 800-53 AC-3, MITRE ATT&CK T1078 | Check resource policies for overly permissive principal elements |
| **Web Experience Authentication**: Verify that Amazon Q Business web experiences have authentication configured | Preventive | NIST 800-53 IA-2, MITRE ATT&CK T1078 | Check that authentication type is properly configured for web experiences |
| **Data Source Connection Security**: Validate that Amazon Q Business data source connectors use secure connection methods | Preventive | NIST 800-53 SC-8, MITRE ATT&CK T1048 | Verify secure connection parameters for data source connectors |
| **Retriever Configuration**: Verify that Amazon Q Business retrievers have proper index configuration with encryption enabled | Preventive | NIST 800-53 SC-28, MITRE ATT&CK T1530 | Check for proper configuration of retriever indices with encryption |
| **CloudWatch Logs Integration**: Validate that Amazon Q has logging enabled with proper log group configuration | Detective | CIS AWS 3.1, NIST 800-53 AU-2, MITRE ATT&CK T1530 | Check for CloudWatch Logs configuration with appropriate retention periods |
| **Service Quotas Monitoring**: Implement checks for Amazon Q service quotas to prevent resource exhaustion | Detective | NIST 800-53 SC-5, MITRE ATT&CK T1499 | Configure CloudWatch alarms for service quota utilization thresholds |
| **Cross-Account Access Control**: Validate that Amazon Q resource policies do not allow unintended cross-account access | Preventive | CIS AWS 1.2, NIST 800-53 AC-3, MITRE ATT&CK T1078 | Check resource policies for cross-account access patterns |
| **Conversation Retention Settings**: For Amazon Q Business, verify that conversation retention settings comply with data retention policies | Preventive | NIST 800-53 SI-12, MITRE ATT&CK T1530 | Validate conversation retention configuration against organizational policies |
| **Plugin Access Control**: For Amazon Q Business, validate that plugin access is restricted to authorized plugins only | Preventive | NIST 800-53 CM-7, MITRE ATT&CK T1195 | Check plugin configuration for adherence to approved plugin list |
| **Document Attribute Filtering**: Verify that Amazon Q Business applications implement proper document attribute filtering for access control | Preventive | NIST 800-53 AC-3, MITRE ATT&CK T1565 | Validate document attribute filtering configuration for proper access controls |
| **User Group Access Control**: For Amazon Q Business web experiences, validate that user group access controls are properly configured | Preventive | NIST 800-53 AC-3, MITRE ATT&CK T1078 | Check user group configuration for proper access restrictions |

## Implementation Examples

### Example 1: Checkov Custom Policy for Mandatory Tags
```python
def check_amazon_q_required_tags(cfg, params):
    required_tags = ['Owner', 'DataClassification', 'Compliance', 'CostCenter']
    resources = cfg.get('Resources', {})
    
    for resource_name, resource in resources.items():
        if resource.get('Type') == 'AWS::QBusiness::Application':
            tags = resource.get('Properties', {}).get('Tags', [])
            tag_keys = [tag.get('Key') for tag in tags]
            
            for required_tag in required_tags:
                if required_tag not in tag_keys:
                    return False, f"Resource {resource_name} is missing required tag: {required_tag}"
    
    return True, "All Amazon Q resources have required tags"
```

### Example 2: Prisma Cloud Policy for KMS Key Enforcement
```yaml
policy:
  name: "Amazon Q Business KMS Key Enforcement"
  description: "Ensures Amazon Q Business uses customer-managed KMS keys"
  severity: "high"
  resource: "aws_qbusiness_application"
  parameters: {}
  query: |
    kmsKeyId exists and
    kmsKeyId like "arn:aws:kms:*:*:key/*" and
    kmsKeyId not like "arn:aws:kms:*:*:key/aws/*"
```

### Example 3: CloudFormation Guard Rule for VPC Configuration
```ruby
rule amazon_q_business_vpc_config_check when resource.Type == "AWS::QBusiness::Application" {
  resource.Properties.RoleArn exists
  
  when resource.Properties.VpcConfiguration exists {
    resource.Properties.VpcConfiguration.SecurityGroupIds[*] exists
    resource.Properties.VpcConfiguration.SubnetIds[*] exists
    resource.Properties.VpcConfiguration.SubnetIds.size() >= 2
  }
}
```

### Example 4: Terraform Sentinel Policy for IAM Role Permissions
```hcl
import "tfplan/v2" as tfplan

# Get all IAM roles used by Amazon Q
amazon_q_roles = filter tfplan.resource_changes as _, rc {
  rc.type is "aws_iam_role" and
  rc.change.after.name matches "^AmazonQ" and
  rc.mode is "managed" and
  (rc.change.actions contains "create" or rc.change.actions contains "update")
}

# Check for wildcard permissions in policy documents
validate_no_wildcards = func(role) {
  for role.change.after.inline_policy as policy {
    if policy.policy contains "*" {
      return false
    }
  }
  return true
}

# Main rule
main = rule {
  all amazon_q_roles as _, role {
    validate_no_wildcards(role)
  }
}
```

## Regular Review Process

Establish a quarterly review process to:
- Evaluate the effectiveness of implemented guardrails
- Update guardrails based on new Amazon Q features or capabilities
- Incorporate lessons learned from security incidents or near-misses
- Align with evolving compliance requirements
