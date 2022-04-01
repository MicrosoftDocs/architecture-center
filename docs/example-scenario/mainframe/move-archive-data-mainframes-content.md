Mainframe and midrange systems generate, process, and store huge amounts of data. When this data gets old, it's not typically useful. However, compliance and regulatory rules sometimes require this data to be stored for a certain number of years, so archiving it is critical. Archiving this data helps in cost reduction, resource optimization, and data analytics.

You can archive data for compliance and to provide data history. This reference architecture shows how to move data from mainframe and midrange systems to Azure. In this architecture, archived data is serviced and used only in the mainframe system. Azure is used only as a storage medium. When deciding which method to use for moving data between the mainframe system and Azure storage, consider factors like cost, time, and speed. To determine the time interval between archives, consider the business criticality of the data.

## Potential use cases

Archiving data to the cloud can help you: 
- Free up storage resources in mainframe and midrange systems. 
- Optimize performance for queries by storing only relevant data on the active system. 
- Reduce operational costs by storing data in a more economic solution.
- Use archived data for analytics to create new opportunities and make better business decisions.

## Architecture 

:::image type="content" border="false" source="media/mainframe-export-archive-data.png" alt-text="Diagram that shows an architecture for archiving mainframe data to Azure." lightbox="mainframe-export-archive-data.png"::: 

visio link  


This architecture outlines archival of Mainframe and Midrange data into Azure, where servicing channel is through  Mainframe/Midrange only. 
- **1st Party solution:** ADF FTP Connector, ADF Copy activity, and custom solution to move data from Mainframe to Azure using a JCL
- **3rd Party Archival solutions:** Usage of 3rd Party archival solutions which can be easily integrated with Mainframe/Midrange and Azure services. 
- **Data Storage:** Archived data which can be stored in different persistent storage in Azure
- **Data Retrieval:**  How data can be retrieved on request from Azure back to Mainframe/Midrange systems.

Architecture Annotations

1. **1st Party Solution:** ADF has an FTP connector that can help in moving data from Mainframe to Azure Blob in a seamless way. Details about the solution have been highlighted [in this link]. This solution would need an intermediate VM which has Self-hosted integration runtime installed. 
2.	**ADF also has a copy activity that can connect to the Db2 database and get data onto any storage solution on Azure.** More details on this solution are found [at this link]. This solution would need an intermediate VM which has Self-hosted integration runtime installed. 
3. Microsoft has created a “Mainframe JCL to Azure Blob using Java” custom solution that can help in data movement between Mainframe to Azure Blob and vice versa. This is a java based and runs on Mainframe Unix system services(USS).    

    a. The user will have to do a one-time setup of the solution, which involves getting the Access keys of Azure Blob and moving required artifacts to the Mainframe. 

    b. On submission of a JCL, files can be moved to and from Mainframe to Blob. 

    c. Files will be stored in Binary format in Azure. The solution is configurable to do the EBCDIC to ASCII conversion for simple datatypes. 
4.	Azure data boxes also help in physically transferring mainframe data to Azure. This option is suited, when there is a huge amount of data to be migrated and online methods of transmission are taking an unacceptable amount of time like weeks together. The deciding factor on when to use Databox relies on multiple parameters which are decided by the customer & the workload needs. 
5.	**3rd Party Integration:** Easy interaction with the Mainframe/Midrange environment is provided by third-party archival solutions. Some of the third-party solutions are available in [Azure Marketplace].  Each of these third-party solutions has a different configuration. Setting up these solutions would be one of the primary tasks. These archival solutions interact with the mainframe and understand various parameters of the mainframe like data types, record types, storage types, access methods. They help as a bridge between Azure and Mainframe. There are third-party solutions that connect a storage drive to the mainframe and help in transferring the data to Azure. 
6.	**Data selection and movement:** Data that needs to be archived can be identified by application subject matter experts. This data can be periodically synced up with the 3rd Party archival solution. Period of archival can be decided based on various parameters like business criticality, compliance needs, frequency of data access.  Once the data is available with the 3rd party archival solution, it can then easily push this data into Azure cloud using connectors that are already tried and tested by these vendors. 
7.	 **Azure Storage** has a wide variety of choices that can cater to different application and technical requirements like frequent/in-frequent access, structured / Unstructured, etc.  Various storage lifecycle configurations can be configured on the Azure storage. It can be easily managed using rules which are defined by the customer. An overview of how to set the rules is present in [this link].
8.	**Data Recall:** Recall of Archived data is also an important aspect of archived data. Few of the 3rd party solutions provide a seamless experience for mainframe professionals to recall archived data. It is as simple as giving a command in on-premises and the 3rd party agent will automatically get the data from Azure and place it back into the mainframe. 

Components

- Storage
   - [Azure Storage Accounts / File Shares] - Durable, highly available, and massively scalable cloud storage. They are used for synchronization and data retention. It offers scalable, high-availability storage such as tables, queues, files, blobs.
- Data Integrators 
   - [Azure Data Factory] -is a hybrid data integration service that allows you to create, schedule, and orchestrate your ETL/ELT workflows. 
- Data Movement:
   - [Azure Data Box] – Physical solution to move data from on-premises to Azure.

Recommendations

Depending on the data usage, data could either be converted to ASCII from Binary and then uploaded to Azure as that would help in doing analytics on Azure. 

Alternatives

The classic method of moving the data out of Mainframe/Midrange through FTP can be used. We also have an FTP connector in ADF which can be used to archive the data on Azure. 

Considerations

Complex data types on the mainframe must be handled while archival. Depending on the retrieval frequency, size of the data one of the preferred and most suitable solutions can be chosen for archival.

Pricing

Use the Azure [pricing calculator] to estimate the cost of implementing this solution.

Next steps
- For more information, please contact Azure Data Engineering - Mainframe/Midrange Modernization @ [datasqlninja@microsoft.com].
- Read the [Migration Guide here]
