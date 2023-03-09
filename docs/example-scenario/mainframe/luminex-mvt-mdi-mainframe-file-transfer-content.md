### Dataflow

1. On a mainframe, secondary storage devices store data that's frequently and infrequently accessed. These devices include direct-access storage devices (DASDs) and sequential-access storage devices (SASDs).

1. DASDs are mounted on the mainframe. These devices are used for immediate data location and retrieval.

1. A tape is a type of SASD that's attached to the mainframe as external storage. Mainframes use virtual tapes (VTL) and physical tapes.

1. The Luminex MDI platform provides a way to send SMF data, VSAM files, sequential files, GDG etc. to Azure.

1. Luminex MVT CloudTape provides tape archival and backup.

1. MDI and MVT use FICON-based CGX controller devices to connect directly to the mainframe.

1. The mainframe data is transferred to Azure through a private, secure Azure ExpressRoute connection.

1. Luminex MDI zKonnect and other services stream the file data for big data analysis on Azure. For instance, system data like mainframe logs and SMF data is streamed to Azure Event Hubs. The transfer configuration determines the format of the transfered data in Azure: ASCII or EBCDIC.

1. Luminex MDI uses Luminex CGX devices to transfer file data to Azure. The transfer process can use a JCL, or the process can be monitored from the MDI UI. The operations team can also use a combination of the scheduler, the mainframe and the MDI UI for monitoring and troubleshooting. The MDI UI provides information like the job name, the job ID, the user or group, the start time, and the elapsed time. MDI retry mechanisms engage when the file transfer doesn't initially succeed. After the transfer finishes, the local storage can be removed.

1. Luminex MVT CloudTape sends mainframe tape data to Azure data stores like Azure Blob, Azure Files, ADLS. The data can be structured and unstructured. The transfer doesn't use a JCL. Instead, MVT Cloud Tape moves or replicates mainframe tapes in IBM 3490 or 3590 format that CGX controllers emulate.

1. Azure services are used for data processing, storage, analytics, and visualization.

### Components





