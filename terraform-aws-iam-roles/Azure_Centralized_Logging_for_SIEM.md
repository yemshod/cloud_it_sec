# Azure Centralized Logging Strategy for SIEM Integration

## Executive Summary

This document outlines our strategy for centralizing Azure logs and integrating them with our enterprise SIEM solution (Sentinel/Splunk). The approach ensures comprehensive visibility across our Azure environment while optimizing for both security value and cost efficiency. The strategy leverages Azure's native capabilities for log collection and aggregation, while establishing a structured approach to log prioritization based on security value and operational impact.

## Current Architecture

* Limited centralized logging with inconsistent configuration across subscriptions
* Ad-hoc log collection with varying retention policies
* Fragmented visibility across the Azure estate
* Incomplete SIEM integration with manual processes

## Target Architecture

![Azure Centralized Logging Architecture](https://via.placeholder.com/800x500?text=Azure+Centralized+Logging+Architecture)

The target architecture will:

1. Implement a dedicated Log Analytics workspace in a centralized security subscription
2. Leverage Azure Policy for consistent log configuration across all subscriptions
3. Use Azure Event Hubs for real-time log streaming to our SIEM
4. Utilize Azure Storage for cost-effective long-term storage and compliance
5. Implement automated lifecycle management for log retention

## Critical Azure Logs for SIEM Integration

The following logs are considered **critical** and should be prioritized for SIEM integration:

| Log Source | Description | Security Value | Implementation Approach |
|------------|-------------|---------------|------------------------|
| **Azure Activity Logs** | Control plane operations across all Azure subscriptions | Critical for detecting unauthorized administrative actions, privilege escalation, and resource manipulation | Configure diagnostic settings to send all Activity Logs to central Log Analytics workspace with Event Hub forwarding |
| **Azure Active Directory Sign-in Logs** | Authentication attempts and sign-in activities | Critical for detecting credential-based attacks, brute force attempts, and suspicious sign-ins | Enable AAD P1/P2 and configure diagnostic settings to send to central Log Analytics workspace |
| **Azure Active Directory Audit Logs** | Changes to directory objects and permissions | Critical for detecting unauthorized permission changes and privilege escalation | Enable AAD P1/P2 and configure diagnostic settings to send to central Log Analytics workspace |
| **Key Vault Logs** | Access attempts and operations on secrets, keys, and certificates | Critical for detecting unauthorized access to sensitive credentials | Configure diagnostic settings on all Key Vaults to send logs to central Log Analytics workspace |
| **Azure Firewall Logs** | Network traffic and security rule matches | Critical for network threat detection and lateral movement analysis | Enable all log categories and configure diagnostic settings to send to central Log Analytics workspace |
| **Network Security Group Flow Logs** | Network traffic metadata for NSG interfaces | Critical for detecting suspicious network patterns and data exfiltration | Enable NSG flow logs with 1-minute intervals and traffic analytics |
| **Azure SQL Database Audit Logs** | Database authentication and query activities | Critical for detecting unauthorized data access and SQL injection | Enable auditing on all Azure SQL servers with logs sent to central Log Analytics workspace |
| **Azure Kubernetes Service Audit Logs** | Kubernetes API server audit logs | Critical for container orchestration security | Enable AKS diagnostic settings with master logs sent to central Log Analytics workspace |
| **Azure App Service HTTP Logs** | Web application request logs | Critical for detecting web-based attacks and application layer exploits | Configure diagnostic settings on all App Services with logs sent to central Log Analytics workspace |
| **Azure Security Center Alerts** | Security alerts from Microsoft Defender for Cloud | Critical security findings that require immediate triage | Configure continuous export to Log Analytics workspace and Event Hub |

## Important Azure Logs for SIEM Integration

The following logs are **important** and should be included in the SIEM integration when possible:

| Log Source | Description | Security Value | Implementation Approach |
|------------|-------------|---------------|------------------------|
| **Azure Storage Analytics Logs** | Storage account operations and access | Important for detecting unauthorized data access | Enable diagnostic settings on storage accounts with logs sent to central Log Analytics workspace |
| **Azure Front Door Logs** | Edge CDN and WAF traffic | Important for detecting web attacks at the edge | Configure diagnostic settings to send logs to central Log Analytics workspace |
| **Azure Application Gateway Logs** | Layer 7 load balancer and WAF traffic | Important for web application security monitoring | Enable all log categories with logs sent to central Log Analytics workspace |
| **Azure Functions Logs** | Serverless function execution logs | Important for detecting unauthorized code execution | Configure App Insights and diagnostic settings to send logs to central Log Analytics workspace |
| **Azure Logic Apps Logs** | Workflow execution logs | Important for integration security monitoring | Enable diagnostic settings with logs sent to central Log Analytics workspace |
| **Azure API Management Logs** | API gateway request and policy logs | Important for API security monitoring | Configure diagnostic settings with logs sent to central Log Analytics workspace |
| **Azure Event Hub Logs** | Messaging infrastructure operations | Important for messaging security | Enable diagnostic settings with logs sent to central Log Analytics workspace |
| **Azure Service Bus Logs** | Message broker operations | Important for messaging security | Enable diagnostic settings with logs sent to central Log Analytics workspace |
| **Azure Virtual Machine Security Events** | OS-level security events from VMs | Important for host-based security monitoring | Deploy Microsoft Monitoring Agent with security events collection enabled |
| **Azure Bastion Logs** | Secure remote access session logs | Important for administrative access monitoring | Enable diagnostic settings with logs sent to central Log Analytics workspace |

## Nice-to-Have Azure Logs for SIEM Integration

The following logs provide additional context but may be considered optional based on cost and volume considerations:

| Log Source | Description | Security Value | Implementation Approach |
|------------|-------------|---------------|------------------------|
| **Azure Cosmos DB Logs** | NoSQL database operations | Useful for data access monitoring | Enable diagnostic settings with logs sent to central Log Analytics workspace |
| **Azure Data Factory Logs** | ETL pipeline execution logs | Useful for data processing security | Enable diagnostic settings with logs sent to central Log Analytics workspace |
| **Azure Synapse Analytics Logs** | Data warehouse operations | Useful for analytics security monitoring | Enable diagnostic settings with logs sent to central Log Analytics workspace |
| **Azure Cache for Redis Logs** | In-memory cache operations | Useful for detecting cache manipulation | Enable diagnostic settings with logs sent to central Log Analytics workspace |
| **Azure IoT Hub Logs** | IoT device connection and message logs | Useful for IoT security monitoring | Enable diagnostic settings with logs sent to central Log Analytics workspace |
| **Azure Container Registry Logs** | Container image repository operations | Useful for supply chain security | Enable diagnostic settings with logs sent to central Log Analytics workspace |
| **Azure Automation Logs** | Automation runbook execution logs | Useful for automation security | Enable diagnostic settings with logs sent to central Log Analytics workspace |
| **Azure Service Health Logs** | Service health and advisory notifications | Useful for availability impact analysis | Configure Service Health to send alerts to Log Analytics |
| **Azure Site Recovery Logs** | Disaster recovery operation logs | Useful for DR security monitoring | Enable diagnostic settings with logs sent to central Log Analytics workspace |
| **Azure HDInsight Logs** | Big data cluster operations | Useful for big data security monitoring | Enable diagnostic settings with logs sent to central Log Analytics workspace |

## Implementation Considerations

### Log Collection Strategy

1. **Centralized Log Analytics Workspace**: Deploy a dedicated Log Analytics workspace in a security subscription
2. **Azure Policy Enforcement**: Use Azure Policy to automatically configure diagnostic settings across all resources
3. **Real-time vs. Batch**: Use Event Hubs for real-time streaming of critical logs and Storage for high-volume logs
4. **Log Analytics Workspace Design**: Consider workspace design based on data sovereignty, retention, and access control requirements

### Log Transformation and Enrichment

1. **Field Normalization**: Use Azure Monitor Workbooks and KQL to standardize field names
2. **Context Enrichment**: Add subscription context, resource tags, and business context using Log Analytics
3. **Sensitive Data Handling**: Implement data masking for sensitive fields using Azure Policy
4. **Log Structure**: Leverage Azure Monitor's structured log format for consistent processing

### SIEM Integration

1. **Azure Sentinel Option**: Consider Azure Sentinel as the SIEM solution for native Azure integration
2. **External SIEM Integration**: Use Event Hubs as the streaming backbone for external SIEM integration
3. **Splunk Add-on**: Leverage the Azure Monitor Add-on for Splunk for optimized data collection
4. **Failure Handling**: Implement Event Hub capture for backup of streaming data

### Retention and Compliance

1. **Tiered Storage**: Configure Log Analytics workspace retention (30-90 days) with long-term archival to Azure Storage
2. **Retention Periods**:
   * Security investigation logs: 90 days in Log Analytics
   * Compliance logs: 1 year in warm storage
   * Archive logs: 7 years in cold storage
3. **Encryption**: Enforce encryption at rest using customer-managed keys
4. **Access Controls**: Implement RBAC with least-privilege access to log storage

## Implementation Roadmap

| Phase | Timeline | Activities |
|-------|----------|------------|
| **Planning & Design** | Weeks 1-2 | Finalize architecture, sizing, and cost estimates |
| **Foundation** | Weeks 3-4 | Set up central Log Analytics workspace, Event Hubs, and Storage accounts |
| **Critical Logs** | Weeks 5-8 | Implement collection for all critical log sources |
| **Azure Policy** | Weeks 9-10 | Develop and deploy Azure Policies for automated log configuration |
| **Important Logs** | Weeks 11-14 | Implement collection for important log sources |
| **SIEM Integration** | Weeks 15-18 | Develop and test SIEM connectors and dashboards |
| **Optimization** | Weeks 19-22 | Fine-tune collection, filtering, and alerting |
| **Nice-to-Have Logs** | Ongoing | Incrementally add additional log sources |

## Cost Optimization Strategies

1. **Log Filtering**: Use Azure Monitor filtering capabilities to reduce ingested data volume
2. **Data Collection Rules**: Implement Azure Monitor Data Collection Rules to filter logs at source
3. **Workspace Design**: Optimize Log Analytics workspace configuration for cost efficiency
4. **Capacity Reservations**: Consider Log Analytics capacity reservations for predictable workloads
5. **Retention Optimization**: Implement appropriate retention periods based on data value

## Monitoring and Maintenance

1. **Log Ingestion Monitoring**: Set up alerts for log ingestion failures or delays
2. **Volume Anomalies**: Configure alerts for unexpected changes in log volumes
3. **Coverage Gaps**: Use Azure Policy compliance reports to identify logging gaps
4. **Cost Monitoring**: Implement regular cost reviews and optimization

## Governance and Compliance

1. **Log Configuration Drift**: Use Azure Policy to detect and remediate logging configuration drift
2. **Regulatory Mapping**: Map log sources to specific regulatory requirements (GDPR, PCI-DSS, etc.)
3. **Access Reviews**: Implement regular access reviews for log data
4. **Audit Trail**: Maintain an audit trail of changes to logging configuration

## Conclusion

This centralized logging strategy provides comprehensive visibility across our Azure environment while balancing security value with cost efficiency. By leveraging Azure's native capabilities for log collection and using a tiered approach to log prioritization, we can achieve both effective threat detection and compliance requirements.

The implementation will require cross-team collaboration between Security, Cloud Infrastructure, and Application teams to ensure proper configuration and minimal operational impact.

## Appendix A: Azure Policy Examples

```json
{
  "properties": {
    "displayName": "Configure diagnostic settings for Azure Key Vault to Log Analytics workspace",
    "description": "Deploys the diagnostic settings for Azure Key Vault to stream to a Log Analytics workspace when any Key Vault which is missing this diagnostic settings is created or updated.",
    "mode": "Indexed",
    "parameters": {
      "logAnalyticsWorkspace": {
        "type": "String",
        "metadata": {
          "displayName": "Log Analytics workspace",
          "description": "Select Log Analytics workspace from dropdown list. If this workspace is outside of the scope of the assignment you must manually grant 'Log Analytics Contributor' permissions to the policy assignment's principal ID.",
          "strongType": "omsWorkspace"
        }
      },
      "effect": {
        "type": "String",
        "defaultValue": "DeployIfNotExists",
        "allowedValues": [
          "DeployIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Effect",
          "description": "Enable or disable the execution of the policy"
        }
      }
    },
    "policyRule": {
      "if": {
        "field": "type",
        "equals": "Microsoft.KeyVault/vaults"
      },
      "then": {
        "effect": "[parameters('effect')]",
        "details": {
          "type": "Microsoft.Insights/diagnosticSettings",
          "name": "setByPolicy",
          "existenceCondition": {
            "allOf": [
              {
                "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                "equals": "true"
              },
              {
                "field": "Microsoft.Insights/diagnosticSettings/workspaceId",
                "equals": "[parameters('logAnalyticsWorkspace')]"
              }
            ]
          },
          "roleDefinitionIds": [
            "/providers/Microsoft.Authorization/roleDefinitions/92aaf0da-9dab-42b6-94a3-d43ce8d16293"
          ],
          "deployment": {
            "properties": {
              "mode": "Incremental",
              "template": {
                "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                "contentVersion": "1.0.0.0",
                "parameters": {
                  "resourceName": {
                    "type": "String"
                  },
                  "logAnalyticsWorkspace": {
                    "type": "String"
                  },
                  "location": {
                    "type": "String"
                  }
                },
                "variables": {},
                "resources": [
                  {
                    "type": "Microsoft.KeyVault/vaults/providers/diagnosticSettings",
                    "apiVersion": "2017-05-01-preview",
                    "name": "[concat(parameters('resourceName'), '/', 'Microsoft.Insights/setByPolicy')]",
                    "location": "[parameters('location')]",
                    "dependsOn": [],
                    "properties": {
                      "workspaceId": "[parameters('logAnalyticsWorkspace')]",
                      "logs": [
                        {
                          "category": "AuditEvent",
                          "enabled": true
                        }
                      ]
                    }
                  }
                ],
                "outputs": {}
              },
              "parameters": {
                "logAnalyticsWorkspace": {
                  "value": "[parameters('logAnalyticsWorkspace')]"
                },
                "resourceName": {
                  "value": "[field('name')]"
                },
                "location": {
                  "value": "[field('location')]"
                }
              }
            }
          }
        }
      }
    }
  }
}
```

## Appendix B: KQL Query Examples

```kusto
// Detect privileged role assignments
AzureActivity
| where OperationNameValue == "Microsoft.Authorization/roleAssignments/write"
| where ActivityStatusValue == "Success"
| extend roleDefinitionId = tostring(parse_json(tostring(parse_json(Properties).requestbody)).Properties.roleDefinitionId)
| where roleDefinitionId contains "8e3af657-a8ff-443c-a75c-2fe8c4bcb635" // Owner role
    or roleDefinitionId contains "18d7d88d-d35e-4fb5-a5c3-7773c20a72d9" // User Access Administrator role
    or roleDefinitionId contains "b24988ac-6180-42a0-ab88-20f7382dd24c" // Contributor role
| extend principalId = tostring(parse_json(tostring(parse_json(Properties).requestbody)).Properties.principalId)
| project TimeGenerated, SubscriptionId, Caller, CallerIpAddress, principalId, roleDefinitionId
```

## Appendix C: Cost Estimates

*[Include detailed cost estimates based on current environment scale]*

---

**Document Owner:** [Security Architecture Team]  
**Last Updated:** [Current Date]  
**Review Cycle:** Quarterly
