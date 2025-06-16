Thank you for the clarification — in a large-scale multi-subscription cloud estate (100+ subs, hundreds of storage assets), **manual inspection is infeasible**. For accurate DSPM volume estimation, you’ll need **automated, programmatic discovery** that can scan across all subscriptions and projects.

Here’s an advanced, scalable approach for **Azure**, **GCP**, and **Wiz**, broken down into three categories:

---

## ✅ Goal: Estimate Total Data Volume Across Azure & GCP

### In support of DSPM pricing with Normalyze (Proofpoint)

---

## 🔹 AZURE (100+ Subscriptions) — Scalable Discovery via Azure Resource Graph

### 🔧 Use **Azure Resource Graph (ARG)** with Kusto Queries

ARG allows you to **query all subscriptions at once**, assuming you have **Reader access** or above.

### 📌 Sample ARG Query: Blob Storage Size

```kusto
Resources
| where type =~ 'microsoft.storage/storageaccounts'
| extend name = name, resourceGroup = resourceGroup, location = location, subscriptionId = subscriptionId
| join kind=leftouter (
    Usage
    | where name.value =~ "UsedCapacity"
    | extend storageAccountId = properties.resourceId
) on $left.id == $right.storageAccountId
| project subscriptionId, resourceGroup, name, location, storageCapacityBytes = properties.currentValue
```

You can run this from:

* **Azure Portal > Resource Graph Explorer**
* Or script via PowerShell/CLI using:

  ```bash
  az graph query -q "<insert query>" --first 1000
  ```

### 🧠 Extend this query for:

* Azure SQL DB: `microsoft.sql/servers/databases`
* Cosmos DB: `microsoft.documentdb/databaseaccounts`
* Data Lake Gen2: aggregate from `microsoft.storage/storageAccounts` with hierarchical namespace

---

## 🔹 GCP (Multi-Project) — Scalable Discovery with GCP Asset Inventory + Billing Export

### ✅ Option 1: **GCP Cloud Asset Inventory + BigQuery**

Export all assets across your org using:

```bash
gcloud asset search-all-resources --scope=organizations/ORG_ID --asset-types=storage.googleapis.com/Bucket
```

This gives metadata, but to get size:

### ✅ Option 2: **Use GCP Billing Export to BigQuery**

* Set up **Billing export** for storage usage:

  * Go to: `Billing > Billing Export > BigQuery`
* Query it using:

```sql
SELECT
  service.description AS service,
  sku.description AS sku,
  SUM(usage.amount_in_pricing_units) AS total_usage,
  usage.pricing_unit
FROM
  `billing_export.dataset.table`
WHERE
  service.description = 'Cloud Storage'
  AND usage_start_time BETWEEN TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 30 DAY) AND CURRENT_TIMESTAMP()
GROUP BY service, sku, usage.pricing_unit
```

This gives **real data consumption across all buckets and services** in TB, GB, etc.

---

## 🔹 WIZ — Metadata Aggregation Across Azure & GCP

Assuming Wiz is integrated with both clouds:

### 🧠 Use Wiz Inventory API (or Export to CSV via UI)

* Go to: `Inventory > Resources`
* Filter by:

  * Resource Type: Storage, Database, Data Warehouse
  * Cloud Provider: Azure + GCP
* Export metadata to CSV (includes storage types and sometimes size if CSP integration allows)

> If metadata doesn't include size: you may need to script **Cloud-native APIs** with Wiz’s context to extract resource IDs and map to actual size metrics.

---

## 🔧 Automation Scripts (Optional)

### For Azure via PowerShell:

```powershell
$subs = Get-AzSubscription
foreach ($sub in $subs) {
    Set-AzContext -SubscriptionId $sub.Id
    Get-AzStorageAccount | ForEach-Object {
        Get-AzStorageUsage -ResourceGroupName $_.ResourceGroupName -Name $_.StorageAccountName
    }
}
```

### For GCP via Cloud Asset API + gsutil:

```bash
gcloud projects list --format="value(projectId)" | while read project; do
  echo "Project: $project"
  gsutil du -s -h -a -p $project gs://*
done
```

---

## 🧮 Final Output Format for DSPM Sizing

| Platform | Service                       | Total Estimated Volume | Source                     |
| -------- | ----------------------------- | ---------------------- | -------------------------- |
| Azure    | Blob + SQL + Cosmos + Synapse | 300 TB                 | ARG + Metrics + Billing    |
| GCP      | GCS + BigQuery + Cloud SQL    | 120 TB                 | Asset Inventory + Billing  |
| Both     | (Total)                       | \~420 TB               | Normalyze Scope Planning   |
| Wiz      | Cross-mapping                 | N/A (metadata only)    | For validation/correlation |

---

## 📌 Recommendations for Your Use Case

* Use **Azure Resource Graph** and **GCP Billing Export** for authoritative data.
* Validate with **Wiz Inventory** to ensure all major data assets are represented in Normalyze’s scan scope.
* If you're building a **repeatable monthly process**, consider pushing this into a **central PowerBI or BigQuery dashboard** to automate DSPM usage tracking.

---

Would you like sample Terraform or Python automation for scheduled data pull and central dashboard ingestion?
