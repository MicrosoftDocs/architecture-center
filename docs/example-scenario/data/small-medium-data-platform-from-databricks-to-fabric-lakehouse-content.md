## Instructions articles (to be removed)

//todo put diagrams into /media/small-medium-data-warehouse folder in .svg format. 
name smth like so MDPSMBADBFabric_3a.svg; MDPSMBADBFabric_3a-brief.svg ??? <- I'm sure we'll get feedback after initial submission

//my diagram is imported like so

[ ![Diagram that shows simplified architecture.](media/small-medium-data-warehouse/MDWSMB_2-brief.svg)](media/small-medium-data-warehouse/MDWSMB_2-brief.svg#lightbox)
## Introduction
Modern data platform for small and medium business from Azure Databricks to Fabric
 [Laurent and Ames]
 Give details on the scenario
 - Size Lakehouse ~ 600 Gb
 - Databricks for Lakehouse
 - ADF for orchestration
 - Potential reason to incorporate Fabric
   - Direct Lake Usage
   - Reduce the number of services used
   - etc
 - Include Architecture Databricks 

### Steps to migrate to Read approach in Fabric

- Introduction on the approach
 - Keep ADB for the compute
 - Potential Fabric Notebook for reading scenario
- Focus on One Lake Shortcuts
- Diagram on how to make current lakehouse built on ADB available in Fabric
- Automate/schedule One Lake shortcuts creation
- Orchestration change
- Include Diagram Scenario 3A
Modify ADB notebooks to point to OneLake

### Stepts to Write approach in Fabric

- Evaluate Batch Approach
  - Leverage Microsoft Spark Utilities
  - Identify any ADB specificities
  - Evaluate the Spark Pool size
- Evaluate Streaming approach
  - Leverage Real Time Analytics for streaming
  - Spark job could be also an option?
- Evaluate Data Governance
  - Leverage Purview in Fabric
- Evaluate Security
  - Leverage One Lake Security
- Build Delta Tables in One Lake using Fabric Notebook
  - Read Delta Tables created by ADB and save them in a OneLake location 
- Fabric Notebook (read/write) to point to OneLake
- Include Diagram Scenario 5

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
- ADB notebook migration
### Availability
### Operations
### Cost optimization
## Contributors
## Next steps

- [Synchronize one Lake with Unity Catalog](https://learn.microsoft.com/en-us/fabric/onelake/onelake-unity-catalog)
- [Spark compute size](https://learn.microsoft.com/en-us/fabric/data-engineering/capacity-settings-management)
- [Microsoft Spark Utilities](https://learn.microsoft.com/en-us/fabric/data-engineering/microsoft-spark-utilities)
- [Real Time in Fabric](https://learn.microsoft.com/en-us/fabric/real-time-intelligence/overview)
- [Purview in Fabric](https://learn.microsoft.com/en-us/fabric/governance/microsoft-purview-fabric)
- [Purview and Unity Catalog](https://learn.microsoft.com/en-us/purview/register-scan-azure-databricks-unity-catalog)
- [One Lake Security](https://learn.microsoft.com/en-us/fabric/onelake/security/get-started-security)
## Related resources
