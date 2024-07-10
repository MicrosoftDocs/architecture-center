Modern data platform for small and medium business from Azure Databricks to Fabric
 [Laurent and Ames]

Blurb on who this scenario would be appealing for.. e.g.    DW ~600GB, ADF for ingestion, ADB for ETL, Databrics with Fabric lakehouse. 

## Simplified Architecuture

Explain the context and the current ADB architecture
## Architecture

//todo put diagrams into /media/small-medium-data-warehouse folder in .svg format. 
name smth like so MDPSMBADBFabric_3a.svg; MDPSMBADBFabric_3a-brief.svg ??? <- I'm sure we'll get feedback after initial submission

//my diagram is imported like so

[ ![Diagram that shows simplified architecture.](media/small-medium-data-warehouse/MDWSMB_2-brief.svg)](media/small-medium-data-warehouse/MDWSMB_2-brief.svg#lightbox)



### Dataflow Read approach in Fabric (First Step)
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
## Related resources
