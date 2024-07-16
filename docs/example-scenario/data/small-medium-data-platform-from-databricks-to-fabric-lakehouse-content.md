## Introduction
This article outlines the possible steps to migrate your Lakehouse platform from Azure Databricks to Microsoft Fabric, or to use both services in tandem. 

The migration can be split into two parts:
 - Azure Databricks (Writing) + Fabric (Reading)
 - Fabric Platform (Reading and Writing)

The following architecture might be your current state
 ![Alt text](media/small-medium-data-warehouse/adb-ref-arch-overview-azure.png)

### 1 -  Transitioning read compute from Azure Databricks to Microsoft Fabric

It is recommended to first migrate the Read operations from Azure DataBricks to Fabric. 

/*added a little intro on building the bridge between ADB and Fabric using shortcuts and a diagram about it*/
Create shortcuts from external Azure DataBricks Delta tables to OneLake using a notebook: Integrate Databricks Unity Catalog with OneLake - Microsoft Fabric | Microsoft Learn This will make Azure DataBricks Unity Catalog tables available as shortcuts in lakehouses, SQL endpoints, and semantic models. 

You can schedule the notebook or use it in a data pipeline to sync the shortcuts periodically, so that you don’t need to sync tables manually if the metadata changes. New Azure DataBricks tables will be automatically added as shortcuts. 

Orchestration can be migrated to Fabric Data Factory from Azure Data Factory for better integration with Fabric – you will have access to the full range of Data Engineering and other transformation tasks in Fabric. A migration guide can be found here: Migrate to Data Factory - Microsoft Fabric | Microsoft Learn

/*now you can leverage reading functionalities from Fabric, notebook for reading from gold layer, EDA, as a data analust/scientist I can leverage notebook for reading or SQL endpoint from the lakehouse*/
[Direct lake to PBI scenario? – mention that once they are in Fabric they can do this and not copy over data. Add link to a guide]

Your architecture could look like this after adding Fabric:
 ![Alt text](media/small-medium-data-warehouse/adb-fabric-architecture.png)

### 2 -  Transitioning write compute from Azure Databricks to Microsoft Fabric

Migrating your data analytics platform from Azure Databricks to Microsoft Fabric involves several key considerations and steps. 
The following guide outlines the main steps, but please note that this list is not exhaustive.

#### Step 1: Evaluate Notebook Migration
- Microsoft Spark Utilities vs. Databricks Utilities (dbutils):
  - Check if [Microsoft Spark Utilities](https://learn.microsoft.com/en-us/fabric/data-engineering/microsoft-spark-utilities) can fulfill your specific requirements.
  - Identify any Azure Databricks-specific features or dependencies outside of [dbutils](https://learn.microsoft.com/en-us/azure/databricks/dev-tools/databricks-utils) that you are currently using.

#### Step 2: Evaluate Real-Time Scenario Migration
- Real-Time Analytics:
 - Determine if Real-Time Analytics in Fabric suits your scenario, especially if you prefer a low-code approach.
- Spark Streaming Jobs:
  - Assess if Fabric's Spark Streaming Jobs meet the needs of more advanced real-time data processing scenarios.
#### Step 3: Evaluate Governance, Monitoring, and Security in Fabric
 - Ensure your requirements for governance, monitoring, and security are covered by Microsoft Fabric.
   You can refer to [the governance and compliance overview provided by Microsoft](https://learn.microsoft.com/en-us/fabric/governance/governance-compliance-overview)
#### Step 4: Confirm the Migration Feasibility
- After evaluating the above aspects, confirm that you can migrate the compute part of your workload to Fabric.
- It's important to re-write your data using Fabric Spark compute to avoid limitations related to having two separate Spark computes writing to Delta Tables. 
For more details, refer to [the OneLake Unity Catalog considerations](https://learn.microsoft.com/en-us/fabric/onelake/onelake-unity-catalog#other-considerations).
#### Step 5: Data Migration
Migrate your data to a new OneLake location. 
Given the scenario involves a volume of 600 GB maximum, performance issues during migration are unlikely.
#### Step 6: Update Your Notebooks
- Replace your Azure Databricks Notebooks with Fabric Notebooks.
- Point the Fabric Notebooks to the new OneLake location for both reading and writing data.

By following these steps, you can  transition from Azure Databricks to Microsoft Fabric, ensuring that your data analytics platform remains efficient and effective. 

Your architecture could look like this after following the guidance:
 ![Alt text](media/small-medium-data-warehouse/fab-architecture-lakehouse.png)

### Components
- [Fabric Data Factory](https://learn.microsoft.com/en-us/fabric/data-factory/)
- [Fabric Data Engineering](https://learn.microsoft.com/en-us/fabric/data-engineering/)
- [One Lake Shortcuts](https://learn.microsoft.com/en-us/fabric/onelake/onelake-shortcuts)
- [Real Time Analytics](https://learn.microsoft.com/en-us/fabric/real-time-intelligence/overview)
- [Purview in Fabric](https://learn.microsoft.com/en-us/fabric/governance/microsoft-purview-fabric)
- [Azure Databricks](https://learn.microsoft.com/en-us/azure/databricks/introduction/)
- [Unity Catalog](https://learn.microsoft.com/en-us/azure/databricks/data-governance/unity-catalog/)
  
### Alternatives
- Orchestration: You can choose to keep Azure Data Factory for orchestration instead of switching to Fabric’s orchestration capabilities.
- Selective Migration: You may opt to migrate only specific layers of your Lakehouse to Fabric, based on your business needs and workload requirements.
## Scenario details
Your enterprise might be considering reducing the number of services you use, leveraging a SaaS platform or specific functionalities of Microsoft Fabric. 
 
It targets small businesses (SMBs) with about 600 GB of data. 

## Considerations
- Link to Scenarios 3a and 5 consideations
### Availability
- Link to Scenarios 3a and 5 availabitiy
### Operations
- Link to Scenarios 3a and 5 operations
### Cost optimization
- Based on the size of your data and requirements, consider using a small starter pool for an efficient and cost-effective transition. For more information, refer to [the small starter pool configuration guide](https://learn.microsoft.com/en-us/fabric/data-engineering/configure-starter-pools).
- Link to Scenarios 3a and 5 cost optimization
## Contributors
## Next steps
- [Integrate Unity Catalog with One Lake](https://learn.microsoft.com/en-us/fabric/onelake/onelake-unity-catalog#other-considerations)
- [Notebooks in Fabric](https://learn.microsoft.com/en-us/fabric/data-engineering/author-execute-notebook)

## Related resources
- [Spark Streaming in Fabric](https://learn.microsoft.com/en-us/fabric/data-engineering/get-started-streaming)
- [Synchronize one Lake with Unity Catalog](https://learn.microsoft.com/en-us/fabric/onelake/onelake-unity-catalog)
- [Spark compute size](https://learn.microsoft.com/en-us/fabric/data-engineering/capacity-settings-management)
- [Microsoft Spark Utilities](https://learn.microsoft.com/en-us/fabric/data-engineering/microsoft-spark-utilities)
- [Monitoring in Fabric](https://learn.microsoft.com/en-us/fabric/admin/monitoring-hub)
- [Real Time in Fabric](https://learn.microsoft.com/en-us/fabric/real-time-intelligence/overview)
- [Purview in Fabric](https://learn.microsoft.com/en-us/fabric/governance/microsoft-purview-fabric)
- [Purview and Unity Catalog](https://learn.microsoft.com/en-us/purview/register-scan-azure-databricks-unity-catalog)
- [One Lake Security](https://learn.microsoft.com/en-us/fabric/onelake/security/get-started-security)
- [Governance in Fabric](https://learn.microsoft.com/en-us/fabric/governance/governance-compliance-overview)
- [Direct Lake](https://learn.microsoft.com/en-us/fabric/get-started/direct-lake-overview)
