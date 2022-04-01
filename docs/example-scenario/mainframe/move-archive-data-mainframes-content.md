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

*Download a [Visio file](https://arch-center.azureedge.net/archive-mainframe-data.vsdx) of this architecture.*

This architecture outlines the archiving of mainframe and midrange data into Azure. The servicing channel is via mainframe and midrange only. At a high level, the solution consists of these components: 
- **Micofosoft solutions.** 
   - The Azure Data Factory FTP connector.
   - The Data Factory copy activity, which can copy data to any Azure storage solution.
   - A custom solution for moving data from the mainframe system to Azure via Job Control Language (JCL).
- **Third-party archive solutions.** Solutions that you can easily integrate with mainframe systems, midrange systems, and Azure services.
- **Data storage.** Archived data that can be stored in persistent storage in Azure.
- **Data recall.**  A mechanism for retrieving data on request from Azure back to mainframe and midrange systems.

### Workflow

1. The Azure Data Factory FTP connector moves data from the mainframe system to Azure Blob Storage. For more information, see [Copy files from mainframe to Azure data platform](https://techcommunity.microsoft.com/t5/modernization-best-practices-and/copy-files-from-mainframe-to-azure-data-platform-using-adf-ftp/ba-p/3042555). This solution requires an intermediate virtual machine (VM) on which a self-hosted integration runtime is installed. 
2.	The Data Factory copy activity connects to the Db2 database to copy data into Azure storage. For more information, see [Move data from Db2 by using the Data Factory copy activity](https://github.com/MicrosoftDocs/azure-docs/blob/main/articles/data-factory/v1/data-factory-onprem-db2-connector.md). This solution requires an intermediate VM on which a self-hosted integration runtime is installed. 
1. The Microsoft *Mainframe JCL to Azure Blob using Java* custom solution moves data between the mainframe system and Blob Storage, and vice versa. This solution is based on Java and runs on Unix System Services on the mainframe.    

    a. You need to complete a one-time configuration of the solution. This configuration involves getting the Blob Storage access keys and moving required artifacts to the mainframe system. 

    b. A JCL submission moves files to and from the mainframe and Blob Storage. 

    c. Files are stored in binary format in Azure. You can configure the custom solution to convert EBCDIC to ASCII for simple data types. 
4.	Optionally, Azure Data Box can help you transfer mainframe data to Azure. This option is appropriate when a large amount of data needs to be migrated and online methods of transmission are taking too long, like more than a week.
5.	Easy interaction with the mainframe or midrange environment is provided by third-party archive solutions. Some third-party solutions are available on [Azure Marketplace](https://azuremarketplace.microsoft.com/marketplace/apps?filters=partners&page=1&search=mainframe%20data). Each of these solutions requires unique configuration. Setting up these solutions is one of the primary tasks. 
   
    These solutions interact with the mainframe and handle various mainframe parameters, like data types, record types, storage types, and access methods. They serve as a bridge between Azure and the mainframe. Some third-party solutions connect a storage drive to the mainframe and help transfer data to Azure. 
6.	Data is periodically synched and archived via the third-party archive solution. Data that needs to be archived is identified by application subject matter experts. To determine the amount of time between synchs, consider factors like business criticality, compliance needs, and frequency of data access. After the data is available via the third-party solution, the solution can easily push it to Azure cloud by using available connectors. 
7.	Data is stored in Azure. Azure has a variety of options for different application and technical requirements, like frequent versus infrequent access, and structured versus unstructured data. You can set up various storage lifecycle configurations in Azure storage. You can define rules to manage the lifecycle. For an overview, see [Configure a lifecycle management policy](/azure/storage/blobs/lifecycle-management-policy-configure).
8.	As needed, data is recalled from Azure back to mainframe or midrange systems. Recall of archived data is an important aspect of archived data. Few of the third-party solutions provide a seamless experience for recalling archived data. It's as simple as running command on-premises. The third-party agent automatically gets the data from Azure and ingests it back into the mainframe system. 

## Components

- [Azure storage](https://azure.microsoft.com/product-categories/storage) desc. [Azure Files](https://azure.microsoft.com/services/storage/files) desc. 
- [Azure Data Factory] -is a hybrid data integration service that allows you to create, schedule, and orchestrate your ETL/ELT workflows. 
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
