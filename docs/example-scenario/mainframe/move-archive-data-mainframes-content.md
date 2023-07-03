This reference architecture shows how to move data from mainframe and midrange systems to Azure. In this architecture, archived data is serviced and used only in the mainframe system. Azure is used only as a storage medium. 

## Architecture 

:::image type="content" border="false" source="media/mainframe-export-archive-data.svg" alt-text="Diagram that shows an architecture for archiving mainframe data to Azure." lightbox="media/mainframe-export-archive-data.svg"::: 

*Download a [Visio file](https://arch-center.azureedge.net/archive-mainframe-data.vsdx) of this architecture.*

To decide which method to use for moving data between the mainframe system and Azure storage, consider the frequency of data retrieval and the amount of data. Microsoft and third-party solutions are available: 

- **Microsoft solutions.** 
   - The Azure Data Factory FTP connector.
   - The Data Factory copy activity, which can copy data to any Azure storage solution.
   - *Mainframe JCL to Azure Blob using Java*, a custom solution for moving data from the mainframe system to Azure via Job Control Language (JCL). For more information, contact [datasqlninja@microsoft.com](mailto:datasqlninja@microsoft.com).
- [**Third-party archive solutions.**](#third-party-archive-solutions) Solutions that you can easily integrate with mainframe systems, midrange systems, and Azure services.

### Workflow

1. The Azure Data Factory [FTP connector moves data from the mainframe system to Azure Blob Storage](https://techcommunity.microsoft.com/t5/modernization-best-practices-and/copy-files-from-mainframe-to-azure-data-platform-using-adf-ftp/ba-p/3042555). This solution requires an intermediate virtual machine (VM) on which a self-hosted integration runtime is installed. 
1.	The Data Factory [copy activity connects to the Db2 database to copy data into Azure storage](/azure/data-factory/v1/data-factory-onprem-db2-connector). This solution also requires an intermediate VM on which a self-hosted integration runtime is installed. 
1. The Microsoft *Mainframe JCL to Azure Blob using Java* custom solution moves data between the mainframe system and Blob Storage, and vice versa. This solution is based on Java and runs on Unix System Services on the mainframe. You can get this solution by contacting [datasqlninja@microsoft.com](mailto:datasqlninja@microsoft.com).

    a. You need to complete a one-time configuration of the solution. This configuration involves getting the Blob Storage access keys and moving required artifacts to the mainframe system.

    b. A JCL submission moves files to and from the mainframe and Blob Storage. 

    c. Files are stored in binary format on Azure. You can configure the custom solution to convert EBCDIC to ASCII for simple data types. 
1. Optionally, Azure Data Box can help you physically transfer mainframe data to Azure. This option is appropriate when a large amount of data needs to be migrated and online methods of transmission take too long. (For example, if migration takes weeks.)
1. Easy interaction with the mainframe or midrange environment is provided by [third-party archive solutions](#third-party-archive-solutions). 
   
    These solutions interact with the mainframe and handle various mainframe parameters, like data types, record types, storage types, and access methods. They serve as a bridge between Azure and the mainframe. Some third-party solutions connect a storage drive to the mainframe and help transfer data to Azure. 
1. Data is periodically synced and archived via the third-party archive solution. After the data is available via the third-party solution, the solution can easily push it to Azure by using available connectors. 
1. Data is [stored in Azure](#azure-storage). 
1. As needed, [data is recalled from Azure](#data-recall) back to the mainframe or midrange systems. 

### Components

- [Azure storage](https://azure.microsoft.com/product-categories/storage) provides massively scalable, highly secure cloud storage for your data, apps, and workloads. [Azure Files](https://azure.microsoft.com/services/storage/files) provides simple and secure serverless cloud file shares. These components are used for synchronization and data retention. 
- [Azure Data Factory](https://azure.microsoft.com/services/data-factory) is a hybrid data integration service that you can use to create, schedule, and orchestrate your ETL and ELT workflows. 
- [Azure Data Box](https://azure.microsoft.com/services/databox) is a physical device that you can use to move on-premises data to Azure.

### Alternatives

You can use the classic method of moving the data out of the mainframe or midrange system via FTP. Data Factory provides an [FTP connector](/azure/data-factory/connector-ftp?tabs=data-factory) that you can use to archive the data on Azure.

## Scenario details

Mainframe and midrange systems generate, process, and store huge amounts of data. When this data gets old, it's not typically useful. However, compliance and regulatory rules sometimes require this data to be stored for a certain number of years, so archiving it is critical. By archiving this data, you can reduce costs and optimize resources. Archiving data also helps with data analytics and provides a history of your data. 

### Potential use cases

Archiving data to the cloud can help you: 
- Free up storage resources in mainframe and midrange systems. 
- Optimize performance for queries by storing only relevant data on the active system. 
- Reduce operational costs by storing data in a more economical way.
- Use archived data for analytics to create new opportunities and make better business decisions.

## Recommendations 

Depending on how you use data, you might want to convert it to ASCII from binary and then upload it to Azure. Doing so makes analytics easier on Azure. 

## Considerations

- Complex data types on the mainframe must be handled during archive. 
- Application subject matter experts can identify which data needs to be archived. 
- To determine the amount of time between syncs, consider factors like business criticality, compliance needs, and frequency of data access.

### Third-party archive solutions 

Some third-party solutions are available on [Azure Marketplace](https://azuremarketplace.microsoft.com/marketplace/apps?filters=partners&page=1&search=mainframe%20data). Each of these solutions requires unique configuration. Setting up these solutions is one of the primary tasks of implementing this architecture. 

### Azure storage 

Azure has a variety of options for different application and technical requirements, like frequent versus infrequent access, and structured versus unstructured data. You can set up various storage lifecycle configurations in Azure storage. You can define the rules to manage the lifecycle. For an overview, see [Configure a lifecycle management policy](/azure/storage/blobs/lifecycle-management-policy-configure).

### Data recall 

Recall of archived data is an important aspect of archive solutions. Few of the third-party solutions provide a seamless experience for recalling archived data. It's as simple as running a command on-premises. The third-party agent automatically gets the data from Azure and ingests it back into the mainframe system. 

### Cost optimization

Use the Azure [pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate the cost of implementing this solution.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

* [Pratim Dasgupta](https://www.linkedin.com/in/pratimdasgupta) | Engineering Architect

Other contributors:

* [Mick Alberts](https://www.linkedin.com/in/mick-alberts-a24a1414) | Technical Writer 
* [Ashish Khandelwal](https://www.linkedin.com/in/ashish-khandelwal-839a851a3) | Senior Engineering Architect Manager 
* [Ramanath Nayak](https://www.linkedin.com/in/ramanath-nayak-584a2685) | Engineering Architect 

## Next steps

For more information, contact [Azure Data Engineering - Mainframe/Midrange Modernization](mailto:datasqlninja@microsoft.com).

See these resources:

- [Azure Database Migration Guides](https://datamigration.microsoft.com)
- [What is Azure Data Factory?](/azure/data-factory/introduction)
- [Introduction to Azure Storage](/azure/storage/common/storage-introduction)
- [What is Azure Files?](/azure/storage/files/storage-files-introduction)
- [What is Azure Data Box?](/azure/databox/data-box-overview)
- [Explore Azure Storage services](/training/modules/azure-storage-fundamentals)

## Related resources

- [Azure mainframe and midrange architecture concepts and patterns](../../mainframe/mainframe-midrange-architecture.md) 
- [Modernize mainframe and midrange data](/azure/architecture/example-scenario/mainframe/modernize-mainframe-data-to-azure) 
- [Re-engineer IBM z/OS batch applications on Azure](../../example-scenario/mainframe/reengineer-mainframe-batch-apps-azure.yml) 
- [Replicate and sync mainframe data in Azure](../../reference-architectures/migration/sync-mainframe-data-with-azure.yml)