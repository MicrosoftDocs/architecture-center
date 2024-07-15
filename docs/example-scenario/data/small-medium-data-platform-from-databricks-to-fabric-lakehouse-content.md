## Introduction
Modern data platform for small and medium business from Azure Databricks to Fabric
 [Laurent and Ames]
 Give details on the scenario
 - Size Lakehouse ~ 600 Gb
 - Databricks for Lakehouse
 - ADF for orchestration
 - Potential reason to incorporate Fabric (keep only the relevant ones for SMB-SMC)
   - Direct Lake Usage
   - Reduce the number of services used
   - SaaS Plaform
   - Graph API call on top of Lakehouse
   - Data Sharing between tenants (https://learn.microsoft.com/en-us/fabric/governance/external-data-sharing-overview)
   - etc
 - Current Customer Architecture (find a simplest diagram)
 ![Alt text](media/small-medium-data-warehouse/adb-ref-arch-overview-azure.png)

### 1 - Steps to migrate to Read approach in Fabric

- Introduction on the approach
 - Keep ADB for the compute (write)
 - Potential Fabric Notebook for reading scenario
- Focus on One Lake Shortcuts
- Diagram on how to make current lakehouse built on ADB available in Fabric
- Automate/schedule One Lake shortcuts creation
- Orchestration change
Read Approach in Fabric Result (add a link to scenario 3A)
 ![Alt text](media/small-medium-data-warehouse/adb-fabric-architecture.png)

### 2 -  Transitioning write compute from Azure Databricks to Microsoft Fabric

Migrating your data analytics platform from Azure Databricks to Microsoft Fabric involves several key considerations and steps. 
The following guide outlines the main steps, but please note that this list is not exhaustive.

#### Step 1: Evaluate Notebook Migration
- Microsoft Spark Utilities vs. Databricks Utilities (DBUtils):
  - Check if [Microsoft Spark Utilities](https://learn.microsoft.com/en-us/fabric/data-engineering/microsoft-spark-utilities) can fulfill your specific requirements.
  - Identify any Azure Databricks-specific features or dependencies outside of DBUtils that you are currently using.

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
Your architecture could look like this:
 ![Alt text](media/small-medium-data-warehouse/fab-architecture-lakehouse.png)

### Components
- Fabric Data Factory
- Fabric Data Engineering
- MSSpark Utils
- One Lake Shortcuts
- Real Time Analytics
- Direct Lake
- Purview in Fabric
  
### Alternatives
- Keep ADF
- Use Fabric only for Gold Layer to leverage Direct Lake
## Scenario details
### Potential use cases
## Considerations
- Link to Scenarios 3a and 5
### Availability
- Link to Scenarios 3a and 5
### Operations
- Link to Scenarios 3a and 5
### Cost optimization
- Link to Scenarios 3a and 5
## Contributors
## Next steps
- [Integrate Unity Catalog with One Lake](https://learn.microsoft.com/en-us/fabric/onelake/onelake-unity-catalog#other-considerations)

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
