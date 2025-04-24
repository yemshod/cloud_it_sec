# Amazon Q Security Guardrails for Exact Trust Environment

## Overview
This document defines technical guardrails for Amazon Q deployments in Exact Trust environments. These guardrails are designed to be implemented as code in validation tools (Checkov, CloudFormation Guard), detection mechanisms (Prisma Cloud), and enforcement controls. Each guardrail includes specific parameters that can be programmatically validated during infrastructure deployment pipelines or detected in runtime environments. These controls ensure Amazon Q deployments maintain security compliance with organizational standards and industry frameworks.

## Security Guardrails Table

| Guardrail Description | Type of Guardrail | Framework Mappings | Other Comments |
|----------------------|-------------------|-------------------|----------------|
| **VPC Endpoint Validation**: Validate that Amazon Q is configured to use VPC endpoints with `aws:SourceVpc` or `aws:SourceVpce` conditions in resource policies | Preventive | CIS AWS 2.1, NIST 800-53 SC-7, MITRE ATT&CK T1133 | IaC validator checks for presence of VPC endpoint configuration and appropriate condition keys in resource policies |
| **IAM Policy Scanner**: Detect IAM roles with `"Action": "*"` or `"Resource": "*"` in policies attached to Amazon Q resources | Preventive | CIS AWS 1.16, NIST 800-53 AC-6, MITRE ATT&CK T1078 | Scan IAM policy documents for wildcard permissions and block deployment if detected |
| **KMS Key Enforcement**: Validate that `kmsKeyId` parameter is set to a customer-managed key ARN (not AWS-managed) for all Amazon Q storage resources | Preventive | CIS AWS 2.1.2, NIST 800-53 SC-28, MITRE ATT&CK T1530 | Check that KMS key ID follows pattern `arn:aws:kms:region:account-id:key/key-id` and not `aws/service` pattern |
| **TLS Version Checker**: Validate that `minimumTlsVersion` is set to `TLSv1.2` or higher in API configurations | Preventive | CIS AWS 2.2.1, NIST 800-53 SC-8, MITRE ATT&CK T1048 | Scan for security policy configurations and validate TLS version parameter |
| **Mandatory Tag Validator**: Check for presence of required tags (`Owner`, `DataClassification`, `Compliance`, `CostCenter`) on all Amazon Q resources | Preventive | CIS AWS 1.5, NIST 800-53 CM-8, MITRE ATT&CK T1526 | Validate that all four required tags exist with non-empty values |
| **CloudTrail Integration**: Verify that Amazon Q API calls are captured in CloudTrail by checking `eventSource` patterns | Detective | CIS AWS 3.1, NIST 800-53 AU-2, MITRE ATT&CK T1530 | Validate CloudTrail is enabled and includes Amazon Q service events |
| **Permission Boundary Enforcement**: Validate that `PermissionsBoundary` is attached to all IAM roles used by Amazon Q | Preventive | CIS AWS 1.16, NIST 800-53 AC-2(7), MITRE ATT&CK T1078 | Check for presence of permission boundary ARN in IAM role definitions |
| **Data Lifecycle Configuration**: Verify that `dataRetentionInDays` parameter is set and does not exceed maximum allowed value (90 days) | Preventive | CIS AWS 2.1.2, NIST 800-53 SI-12, MITRE ATT&CK T1530 | Validate that retention period is explicitly set and within allowed range |
| **Content Filter Configuration**: Validate that `contentFilterConfig` is enabled with `filterLevel: BLOCK` for PII and sensitive data | Preventive | NIST 800-53 SC-7, MITRE ATT&CK T1567 | Check for presence and proper configuration of content filtering parameters |
| **API Rate Limit Configuration**: Verify that `throttlingConfig` is set with `rateLimit` ≤ 100 requests per second | Preventive | NIST 800-53 SC-5, MITRE ATT&CK T1499 | Validate rate limiting parameters are configured with appropriate thresholds |
| **Region Restriction**: Validate that Amazon Q resources are only deployed in approved regions (`us-east-1`, `us-west-2`, `eu-west-1`) | Preventive | CIS AWS 1.22, NIST 800-53 CM-7, MITRE ATT&CK T1526 | Check AWS region in resource ARNs against allowlist of approved regions |
| **Secure Configuration Parameters**: Validate that `securityConfig` includes `preventDataExfiltration: true` and `blockUnsafeUrls: true` | Preventive | CIS AWS 2.1.1, NIST 800-53 CM-2, MITRE ATT&CK T1562 | Check for presence and correct values of security configuration parameters |
| **Integration Allowlist**: Verify that `allowedIntegrations` parameter only includes approved services from organization allowlist | Preventive | NIST 800-53 CA-3, MITRE ATT&CK T1199 | Validate integration configuration against predefined allowlist |
| **Anomaly Detection Configuration**: Validate that CloudWatch anomaly detection is configured with `evaluationPeriod` ≤ 5 minutes for Amazon Q usage metrics | Detective | NIST 800-53 SI-4, MITRE ATT&CK T1530 | Check for presence and proper configuration of CloudWatch anomaly detection |
| **Network ACL Validation**: Verify that VPC hosting Amazon Q has NACLs with explicit DENY rules for unauthorized outbound traffic | Preventive | NIST 800-53 SC-7, MITRE ATT&CK T1048 | Validate NACL configurations for proper egress filtering rules |
| **WAF Association**: Validate that Amazon Q API endpoints have WAF WebACL association with required rule groups | Preventive | CIS AWS 2.4, NIST 800-53 SC-7, MITRE ATT&CK T1190 | Check for presence of WAF WebACL ARN in API Gateway or ALB configurations |
| **Secrets Detection Pattern**: Verify that `dataProtectionConfig` includes patterns for detecting credentials (`[A-Za-z0-9/\\+=]{40}`, AWS key pattern) | Preventive | CIS AWS 1.20, NIST 800-53 IA-5, MITRE ATT&CK T1552 | Validate that credential detection patterns are properly configured |
| **Resource Policy Boundary**: Validate that Amazon Q resource policies include `aws:RequestedRegion` condition limiting to compliant regions | Preventive | NIST 800-53 SA-9, MITRE ATT&CK T1567 | Check for presence of regional boundary conditions in resource policies |
| **Security Group Rule Validation**: Verify that security groups associated with Amazon Q resources have no `0.0.0.0/0` ingress rules | Preventive | CIS AWS 4.1, NIST 800-53 AC-4, MITRE ATT&CK T1190 | Scan security group rules for overly permissive CIDR blocks |
| **Encryption in Transit Enforcement**: Validate that `enforceHttps` is set to `true` and `httpTokens` is set to `required` | Preventive | CIS AWS 2.2.1, NIST 800-53 SC-8, MITRE ATT&CK T1048 | Check for presence and correct values of HTTPS enforcement parameters |
| **Private Endpoint Validation**: Verify that `endpointType` is set to `PRIVATE` for all Amazon Q API endpoints | Preventive | CIS AWS 2.1, NIST 800-53 SC-7, MITRE ATT&CK T1133 | Validate endpoint configuration parameters for private access only |

## Implementation Examples

### Example 1: Checkov Custom Policy for Mandatory Tags
```python
def check_amazon_q_required_tags(cfg, params):
    required_tags = ['Owner', 'DataClassification', 'Compliance', 'CostCenter']
    resources = cfg.get('Resources', {})
    
    for resource_name, resource in resources.items():
        if resource.get('Type') == 'AWS::QBusiness::Application' or resource.get('Type') == 'AWS::QDeveloper::Application':
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
  name: "Amazon Q KMS Key Enforcement"
  description: "Ensures Amazon Q uses customer-managed KMS keys"
  severity: "high"
  resource: "aws_qbusiness_application"
  parameters: {}
  query: |
    kmsKeyId exists and
    kmsKeyId like "arn:aws:kms:*:*:key/*" and
    kmsKeyId not like "arn:aws:kms:*:*:key/aws/*"
```

### Example 3: CloudFormation Guard Rule for VPC Endpoint Validation
```ruby
rule amazon_q_vpc_endpoint_check when resource.Type == "AWS::QBusiness::Application" {
  resource.Properties.NetworkConfiguration.VpcConfiguration exists
  resource.Properties.NetworkConfiguration.VpcConfiguration.SecurityGroupIds[*] exists
  resource.Properties.NetworkConfiguration.VpcConfiguration.SubnetIds[*] exists
}

rule amazon_q_resource_policy_check when resource.Type == "AWS::QBusiness::Application" {
  resource.Properties.ResourcePolicy exists
  resource.Properties.ResourcePolicy.Condition.StringEquals["aws:SourceVpc"] exists or
  resource.Properties.ResourcePolicy.Condition.StringEquals["aws:SourceVpce"] exists
}
```

## Regular Review Process

Establish a quarterly review process to:
- Evaluate the effectiveness of implemented guardrails
- Update guardrails based on new Amazon Q features or capabilities
- Incorporate lessons learned from security incidents or near-misses
- Align with evolving compliance requirements
