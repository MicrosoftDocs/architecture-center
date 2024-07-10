## Instructions

//todo put diagrams into /media/small-medium-data-warehouse folder in .svg format. 
name smth like so MDPSMBADBFabric_3a.svg; MDPSMBADBFabric_3a-brief.svg ??? <- I'm sure we'll get feedback after initial submission

//my diagram is imported like so

[ ![Diagram that shows simplified architecture.](media/small-medium-data-warehouse/MDWSMB_2-brief.svg)](media/small-medium-data-warehouse/MDWSMB_2-brief.svg#lightbox)
## Introduction
Modern data platform for small and medium business from Azure Databricks to Fabric
 [Laurent and Ames]

Blurb on who this scenario would be appealing for.. e.g.    DW ~600GB, ADF for ingestion, ADB for ETL, Databrics with Fabric lakehouse.
Maybe list a few reason why customer would want to move Fabric+Databricks or Fabric only

##  Existing
Existing architecture in Databricks Diagram

### Dataflow Read approach in Fabric (First Step)

- test
 kopokppopk
Setup shortcuts in Fabric
Schedule Synchronization between UC and Fabric (shortcuts)
Keep ADB as a write engine
Modify ADB notebooks to point to OneLake
Diagram scenario 3 A
### Dataflow Write approach in Fabric (Second Step)
Expain the considerations to take in account
### Components
### Alternatives
## Scenario details
### Potential use cases
## Considerations
### Availability
### Operations
### Cost optimization
## Contributors
## Next steps

- [Synchronize one Lake with Unity Catalog](https://learn.microsoft.com/en-us/fabric/onelake/onelake-unity-catalog)
- [Spark compute size](https://learn.microsoft.com/en-us/fabric/data-engineering/capacity-settings-management)
- [Microsoft Spark Utilities](https://learn.microsoft.com/en-us/fabric/data-engineering/microsoft-spark-utilities)
- [Purview and Unity Catalog](https://learn.microsoft.com/en-us/purview/register-scan-azure-databricks-unity-catalog)
- [One Lake Security](https://learn.microsoft.com/en-us/fabric/onelake/security/get-started-security)
## Related resources
