This article describes various enterprise-scale analytical scenarios that are enabled by Azure Data Factory and Teradata VantageCloud Enterprise.

The architecture described here demonstrates how you can use Teradata VantageCloud Enterprise together with Azure Data Factory to develop data integration pipelines while writing little or no code. It shows how to quickly ingest or extract Vantage data over an enhanced-security connection by using Data Factory. The architecture is built on the foundation of Azure scalability, security, and governance.

This article describes three scenarios:

- Data Factory pulling data from VantageCloud Enterprise and loading it into Azure Blob Storage
- Loading data into VantageCloud Enterprise with Data Factory
- Using the Native Object Storage (NOS) functionality of VantageCloud Enterprise to access data transformed and loaded into Blob Storage by Data Factory

## Architecture

The following diagram illustrates a version of the architecture that uses virtual network peering connectivity. It uses a self-hosted integration runtime (IR) to connect to the analytics database. Teradata's VMs are deployed with only private IP addresses.

:::image type="content" source="media/teradata-azure-data-factory-vnet-peering.png" alt-text="Diagram that shows a version of the architecture that uses virtual network peering connectivity." lightbox="media/teradata-azure-data-factory-vnet-peering.png" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/best-practices-for-teradata-vantage-and-azure-data-factory.vsdx) of this architecture.*

The following diagram illustrates a version of the architecture that uses Azure Private Link connectivity.

:::image type="content" source="media/teradata-vantage-azure-data-factory-private-link.png" alt-text="Diagram that shows a version of the architecture that uses Private Link connectivity." lightbox="media/teradata-vantage-azure-data-factory-private-link.png" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/best-practices-for-teradata-vantage-and-azure-data-factory.vsdx) of this architecture.*

VantageCloud Enterprise on Azure is a fully managed service that's deployed in a Teradata-owned Azure subscription. You deploy cloud services in your own Azure subscription, which is then connected to the Teradata-managed subscription via one of the approved connectivity options. Teradata supports the following types of connectivity between your Azure subscription and VantageCloud Enterprise on Azure:

- Virtual network peering
- Private Link
- Azure Virtual WAN

If you plan to use virtual network peering, work with [Teradata support](https://support.teradata.com/csm) or your Teradata account team to ensure that required security group settings are in place to initiate traffic from the self-hosted IR to the database via the virtual network peering link.

## Components

To implement this architecture, you need to be familiar with Data Factory, Blob Storage, Teradata VantageCloud Enterprise, and Teradata Tools and Utilities (TTU).

These components and versions are used in the integration scenarios:

- [Teradata VantageCloud Enterprise 17.20, hosted on Azure](https://www.teradata.com/Cloud/Azure)
- [Azure Data Factory](https://azure.microsoft.com/products/data-factory)
- [Azure Blob Storage](https://azure.microsoft.com/products/storage/blobs/)
- [TTU 17.20](https://downloads.teradata.com/download/database/teradata-tools-and-utilities-13-10) 
- [Teradata ODBC Driver 17.20.12](https://downloads.teradata.com/download/connectivity/odbc-driver/windows)
- [Teradata Studio 17.20](https://downloads.teradata.com/download/tools/teradata-studio)

### Teradata Vantage

Vantage provides what Teradata calls Pervasive Data Intelligence. Users across your organization can use it to get real-time, intelligent answers. In this architecture, Vantage hosted on Azure is used as a source or destination for data integration tasks. Vantage NOS is used to integrate with data in Blob Storage.

### Data Factory

Data Factory is a serverless cloud extract, transform, and load (ETL) service. You can use it to orchestrate and automate data movement and transformation. It provides a code-free user interface for data ingestion and intuitive authoring and single-pane-of-glass monitoring and management.

You can use Data Factory to create and schedule data-driven workflows (called pipelines) that can ingest data from disparate data stores. You can create complex ETL processes that visually transform data by using dataflows that run on Spark or compute services like Azure Batch, Azure Machine Learning, Apache Spark, SQL, Azure HDInsight with Hadoop, and Azure Databricks. Working with Data Factory involves the following layers, listed from the highest level of abstraction to the software that's closest to the data.

- **Pipelines** are graphical interfaces that contain activities and data paths.
- **Activities** perform operations on data.
- **Sources and sinks** are activities that specify where data comes from and where it goes.
- **Datasets** are well-defined sets of data that Data Factory ingests, loads, and transforms.
- **Linked services** enable Data Factory to access connection information for specific external data sources.
- **The integration runtime (IR)** provides a gateway between Data Factory and data or compute resources.

### Self-hosted IR 
 
The self-hosted IR can perform copy operations between cloud data stores and private-network data stores. You can also transform your compute resources in an on-premises network or an Azure virtual network. You need a local computer or virtual machine on your private network to install the self-hosted IR. For more information, see [Considerations for using a self-hosted IR](https://learn.microsoft.com/azure/data-factory/create-self-hosted-integration-runtime?tabs=data-factory#considerations-for-using-a-self-hosted-ir). This article describes how to use the self-hosted IR to connect to VantageCloud and extract data to load into Azure Data Lake Storage.

### Teradata connector
 
In this architecture, Data Factory uses the Teradata connector to connect to Vantage. The Teradata connector supports:
- Teradata versions 14.10, 15.0, 15.10, 16.0, 16.10, and 16.20.
- Copying data by using basic, Windows, or LDAP authentication.
- Parallel copying from a Teradata source. For more information, see  [Parallel copy from Teradata](/azure/data-factory/connector-teradata?tabs=data-factory#parallel-copy-from-teradata).

This article describes how to set up linked services and datasets for the Data Factory Copy activity, which ingests data from Vantage and loads it into Data Lake Storage.

## Scenario 1: Load data into Blob Storage from VantageCloud

This scenario describes how to use Data Factory to exract data from VantageCloud Enterprise, perform some basic transformations, and then load the data into a Blob Storage container.

The scenario highlights the native integration between Data Factory and Vantage and how easily you can build an enterprise ETL pipeline to integrate data in Vantage.

To complete this procedure, you need to have an Blob Storage container in your subscription, as shown in the architecture diagrams. 

1.	To create a native connector to Vantage, in your data factory, select the **Manage** tab, select **Linked services**, and then select **New**:

    :::image type="content" source="media/create-linked-service.png" alt-text="Screenshot that shows the New button in Linked services." lightbox="media/create-linked-service.png":::

2.	Search for *Teradata* and then select the **Teradata** connector. Then select **Continue**:

    :::image type="content" source="media/teradata-linked-service.png" alt-text="Screenshot that shows the Teradata connector." lightbox="media/teradata-linked-service.png"::: 

3.	Configure the linked service to connect to your Vantage database. This procedure shows how to use a basic authentication mechanism with a user ID and password. Alternatively, depending on your security needs, you can choose a different authentication mechanism and set other parameters accordingly. For more information, see [Teradata connector linked service properties](/azure/data-factory/connector-teradata?tabs=data-factory#prerequisites). You'll use a self-hosted IR. For more information, see these [instructions for deploying a self-hosted IR](https://learn.microsoft.com/azure/data-factory/connector-teradata?tabs=data-factory#prerequisites). Deploy it in the same virtual network as your sata factory.

    Use the following values to configure the linked service: 

    - **Name**: Enter a name for your linked service connection.
    - **Connect via integration runtime**: Select **SelfHostedIR**.  
    - **Server name**:
       - If you're connecting via virtual network peering, provide the IP address of any VM in the Teradata cluster. You can connect to the IP address of any VM in the cluster.
       - If you're connecting via Private Link, provide the IP address of the private endpoint that you created in your virtual network to connect to the Teradata cluster via Private Link.
    - **Authentication type**: Choose an authentication type. This procedure shows how to use basic authentication.
    - **User name** and **Password**: Provide the credentials.
    - Select **Test connection**, and then select **Create**. Be sure that interactive authoring is enabled for your IR so that the test connection functionality works.

    :::image type="content" source="media/teradata-linked-service-configuration.png" alt-text="Screenshot that shows the configuration for the Teradata connector." lightbox="media/teradata-linked-service-configuration.png":::

    For testing, you can use a test database in Vantage that's called `NYCTaxiADFIntegration`. This database has a single table named `Green_Taxi_Trip_Data`. You can download the database from [NYC OpenData](https://data.cityofnewyork.us/Transportation/2020-Green-Taxi-Trip-Data/pkmi-4kfn). The following CREATE TABLE statement can help you understand the schema of the table.

    ```sql
    CREATE MULTISET TABLE NYCTaxiADFIntegration.Green_Taxi_Trip_Data, FALLBACK ,
         NO BEFORE JOURNAL,
         NO AFTER JOURNAL,
         CHECKSUM = DEFAULT,
         DEFAULT MERGEBLOCKRATIO,
         MAP = TD_MAP1
         (
          VendorID BYTEINT,
          lpep_pickup_datetime DATE FORMAT ‘YY/MM/DD’,
          lpep_dropoff_datetime DATE FORMAT ‘YY/MM/DD’,
          store_and_fwd_flag VARCHAR(1) CHARACTER SET LATIN CASESPECIFIC,
          RatecodeID BYTEINT,
          PULocationID SMALLINT,
          DOLocationID SMALLINT,
          passenger_count BYTEINT,
          trip_distance FLOAT,
          fare_amount FLOAT,
          extra DECIMAL(18,16),
          mta_tax DECIMAL(4,2),
          tip_amount FLOAT,
          tolls_amount DECIMAL(18,16),
          ehail_fee BYTEINT,
          improvement_surcharge DECIMAL(3,1),
          total_amount DECIMAL(21,17),
          payment_type BYTEINT,
          trip_type BYTEINT,
          congestion_surcharge DECIMAL(4,2))
    NO PRIMARY INDEX ;
    ```

4.	Next, you'll create a simple pipeline to copy the data from the table, perform some basic transformation, and then load the data into a Blob Storage container. As noted at the start of this procedure, you should have already created the Blob Storage container in your subscription. You'll first create a linked service to connect to the container, which is the sink that you'll copy the data into.

    - Select the **Manage** tab in your data factory, select **Linked services**, and then select **New**:
    
      :::image type="content" source="media/new-linked-service.png" alt-text="Screenshot that shows the New button." lightbox="media/new-linked-service.png":::

5.	Search for *Azure Blob*, select the **Azure Blob Storage** connector, and then select **Connect**:

    :::image type="content" source="media/blob-stroage-connector.png" alt-text="Screenshot that shows the Blob Storage linked service." lightbox="media/blob-stroage-connector.png":::
    

6.	Configure the linked service to connect to the Blob Storage account:

    - **Name**: Enter a name for your linked service connection.
    - **Connect via integration runtime**: Select **AutoResolveIntegrationRuntime**.
    - **Authentication type**: Select **Account key**.
    - **Azure subscription**: Enter your Azure subscription ID.
    - **Storage account name**: Enter your Azure storage account name.
    
    Select **Test connection** to verify the connection, and then select **Create**.

    :::image type="content" source="media/blob-storage-connector-configuration.png" alt-text="Screenshot that shows the configuration of the Blob Storage linked service." lightbox="media/blob-storage-connector-configuration.png":::
     

7.	Create a Data Factory pipeline:

    - Select the **Author** tab. 
    - Select the **+** button.
    - Select **Pipeline**.
    - Provide a **Name** for the pipeline.
    
      :::image type="content" source="media/azure-data-factory-pipeline.png" alt-text="Screenshot that shows the steps for creating a pipeline." lightbox="media/azure-data-factory-pipeline.png":::

8.	Create two datasets:

    - Select the **Author** tab.
    - Select the **+** button.
    - Select **Dataset**.
    - Create a dataset for the `Green_Taxi_Trip_Data` Teradata table: 
      - Select **Teradata** as the Data Store.
      - **Name**: Provide a name for the dataset.
      - **Linked service**: Select the linked service that you created for Teradata in steps 2 and 3.
      - **Table name**: Select the table from the list. 
      - Select **OK**.
    
    :::image type="content" source="media/teradata-datasets.png" alt-text="Screenshot that shows the properties for the Teradata table." lightbox="media/teradata-datasets.png":::
    
    - Create an Azure Blob dataset:
      - Select **Azure Blob** as the Data Store.
      - Select the format of your data. Parquet is used in this demonstration.
      - **Linked service**: Select the linked service that you created in step 6.
      - **File path**: Provide the file path of the blob file.
      - **Import schema**: Select **None**.
      - Select **OK**.

    :::image type="content" source="media/azure-blob-dataset.png" alt-text="Screenshot that shows the properties for the Azure Blob Storage dataset." lightbox="media/azure-blob-dataset.png":::

9.	Drag a Copy activity onto the pipeline. 

    Note that the Teradata connector doesn't currently support the Data Flow activity in Data Factory. If you want to perform transformation on the data, we recommend that you add a Data Flow activity after the Copy activity. 
    
10. Configure the Copy activity:
    
    - On the **Source** tab, under **Source dataset**, select the Teradata table dataset that you created in the previous step.
    - For **Use query**, select **Table**.
    - Use the default values for the other options.
      :::image type="content" source="media/copy-data-activity-source.png" alt-text="Screenshot that shows the steps for creating a copy data activity." lightbox="media/copy-data-activity-source.png":::

    - On the **Sink** tab, under **Sink sataset**, select the Azure Blob dataset that you created in the previous step.
    - Use the default values for the other options.
    
      :::image type="content" source="media/copy-data-activity-sink.png" alt-text="Screenshot that shows the configuration for the sink dataset." lightbox="media/copy-data-activity-sink.png":::
    
11.	Select **Debug**. The pipeline copies the data from the Teradata table to a Parquet file in Blob Storage.

## Scenario 2: Load data into VantageCloud from Blob Storage

This scenario describes how to use an ODBC connector to connect to Vantage via the self-hosted IR VM to load data. Because the IR needs to be installed and configured with the Teradata ODBC driver, this option works only with a Data Factory self-hosted IR. 

You can also use TTU, Data Factory custom activities, and Azure Batch to load data into Vantage and transform it. For more information, see [Connect Teradata Vantage to Azure Data Factory Using Custom Activity Feature](https://www.teradata.com/Blogs/Connect-Teradata-Vantage-to-Azure-Data-Factory-Using-Custom-Activity-Feature). We recommend that you evaluate both options for performance, cost, and management considerations and choose the option that's best suited to your requirements.

1.	Start by preparing the self-hosted IR that you created in the previous scenario. You need to install the Teradata ODBC driver on it. This scenario uses a Windows 11 VM for the self-hosted IR. 
    1. [RDP](/azure/virtual-machines/windows/connect-rdp) into the VM.
    1. Download and install the [Teradata ODBC driver](https://downloads.teradata.com/download/connectivity/odbc-driver/windows). 
    1. If the JAVA JRE isn't already on the VM, download and install it. 

2.	Create a 64-bit system DSN for the Teradata database by [adding an ODBC data source](https://support.microsoft.com/office/administer-odbc-data-sources-b19f856b-5b9b-48c9-8b93-07484bfab5a7).
    - Be sure to use the 64-bit DSN window.
    - Select the **Teradata Database ODBC Driver**, as shown in the following screenshot. 
    - Select **Finish** to open the driver setup window.

      :::image type="content" source="media/teradata-odbc-driver.png" alt-text="Screenshot that shows the steps for creating a data source." lightbox="media/teradata-odbc-driver.png":::

3.	Configure the DSN properties.
    - **Name**: Provide a name for the DSN. 
    - Under **Teradata Server Info**, in **Name or IP address**:
      - If you're connecting via virtual network peering, provide the IP address of any VM in the Teradata cluster. You can connect to the IP address of any VM in the cluster.
      - If you're connecting via Private Link, provide the IP address of the private endpoint that you created in your virtual network to connect to the Teradata cluster via Private Link.
    - Optionally, provide the **Username** and select **Test**. You're prompted enter the credentials. Select **OK** and ensure that the connection succeeds. Note that you will provide the user name and password in Data Factory when you create the ODBC linked service that's used to connect to the Teradata database from Data Factory.
    - Leave the other fields blank.
    - Select **OK**.

      :::image type="content" source="media/odbc-driver-configuration.png" alt-text="Screenshot that shows the configuration for the driver." lightbox="media/odbc-driver-configuration.png":::

4.	The ODBC Data Source Administrator window will look like the one in the following screenshot. Select **Apply**. You can now close the window. Your self-hosted IR is now ready to connect to Vantage by using ODBC. 

    :::image type="content" source="media/odbc-driver-configuration-2.png" alt-text="Screenshot that shows the ODBC Data Source Administrator window." lightbox="media/odbc-driver-configuration-2.png":::

5.	In Data Factory, create a linked service connection. Choose **ODBC** as the data store:

    :::image type="content" source="media/odbc-linked-service.png" alt-text="Screenshot that shows the ODBC linked service." lightbox="media/odbc-linked-service.png":::

6.	Configure the linked service with the IR that you configured in the previous steps:

    - **Name**: Provide a name for the linked service.
    - **Connect via integration runtime**: Select **SelfhostedIR**.
    - **Connection string**: Enter the DSN connection string with the name of the DSN that you created in the previous steps.
    - **Authentication type**: Select **Basic**.
    - Enter the user name and password for your Teradata ODBC connection. 
    - Select **Test connection**, and then select **Create**.

      :::image type="content" source="media/teradata-linked-service-configuration-2.png" alt-text="Screenshot that shows the configurations for the linked service." lightbox="media/teradata-linked-service-configuration-2.png":::

7.	Complete the following steps to create a dataset with ODBC as the data store. Use the linked service that you created earlier. 
 
    - Select Author tab
    - Select the +/plus icon
    - Select dataset
    - Create a dataset for the "Green_Taxi_Trip_DataIn" Teradata table: 
      - Select ODBC as the Data store and select continue
      - Name : Provide a name for the data set
      - Linked Service : Select the ODBC linked service we created in the previous step.
      - Table Name : Select the Table from the dropdown list 
      - Select OK

      Tip :When loading the data, use a staging table with generic data types to avoid data type mismatch errors. For example, instead of using Decimal Datatype for certain columns our staging table is using Varchar. You can then perform data type transformations in vantage database.

      :::image type="content" source="media/odbc-dataset.png" alt-text="Screenshot that shows the properties for the Teradata table." lightbox="media/odbc-dataset.png":::

8.	Next, create an Azure Blob connection to the source file we want to load into Teradata Vantage database using steps 4 to 6 and 8 as mentioned in scenario 1. Note that you are creating this for the source file, so the path for your file will be different one.
9.	Next, create a new pipeline with a copy data activity as in scenario 1. 

    - Create a Copy Data Activity.
    - Drag and drop the copy data activity onto the pipeline. Note that currently Teradata ODBC connector is not supported for Data Flow activity in Data Factory. If you are looking to perform transformation on the data, it is advised to create a Data flow activity before the copy activity.
    - Source dataset : Select the file data set you are loading into Teradata.
    - Leave other options as default.
    - Sink Dataset: Choose the Teradata table dataset created through ODBC connection.
    - Leave the other properties as default.
    
      :::image type="content" source="media/copy-data-source.png" alt-text="Screenshot that shows the steps for creating a copy activity." lightbox="media/copy-data-source.png":::

      :::image type="content" source="media/copy-data-sink.png" alt-text="Screenshot that shows the properties for the sink dataset." lightbox="media/copy-data-sink.png":::

10.	Select Debug and the pipeline will copy the data from the parquet file to the Teradata. 

## Scenario 3 : Accessing data transformed and loaded into Azure Blob Storage by Data Factory, from VantageCloud Enterprise using Native Object Storage functionality of Teradata.

In this scenario we will access the data that was put into Azure Blob storage using [Native Object store (NOS)](https://docs.teradata.com/r/Teradata-VantageTM-Native-Object-Store-Getting-Started-Guide/January-2021/Welcome-to-Native-Object-Store) capabilities of VantageCloud Enterprise. While the previous scenario is ideal when you want to load the data into Vantage on a continued or scheduled basis, this scenario shows you how to access data in a one-off manner from Azure Blob storage, with or without loading the data into Vantage Database. Note that you can also [export data to Azure Blob Storage](https://quickstarts.teradata.com/create-parquet-files-in-object-storage.html) using NOS capabilities. 

1.	The following query will allow you to read the data transformed and loaded into Azure Blob Storage with  Data Factory without loading the data into the database, from Vantage in place, I am using Teradata SQL Query Editor to run queries. To access that data in the blob, you supply the storage account name and access key in Access ID and Access Key fields. Note that it also returns an added field called Location specifying the path of the file the record was read from. 

    ```sql
    FROM (  LOCATION=’/AZ/yourstorageaccount.blob.core.windows.net/vantageadfdatain/NYCGreenTaxi/’
    AUTHORIZATION=’{“ACCESS_ID”:”youstorageaccountname”,”ACCESS_KEY”:”yourstorageaccesskey”}’
    ) as GreenTaxiData;
    ```

    :::image type="content" source="media/nos-query-blob.png" alt-text="Screenshot that shows a query for reading the data." lightbox="media/nos-query-blob.png":::

2.	The following is another example of querying data in-place using the READ_NOS Table operator.

    :::image type="content" source="media/nos-query-blob-2.png" alt-text="Screenshot that shows another example of querying data in place." lightbox="media/nos-query-blob-2.png":::


3.	You can also query data in place or load data in Teradata database by creating a foreign table to the object store. For this, you will first need to create an Authorization object which will use the storage account name and access key in User and Password fields, respectively, as shown below. You can now use this to create your foreign table and you do not have to provide the keys during the table creation process.

    ‘YOUR-ACCESS-KEY-ID’      
       ‘YOUR-SECRET-ACCESS-KEY’;

    We now create the foreign table to access the data. The following query will create the table with for our green taxi data using the authorization object created above. Note that while loading the parquet file ensure that you are mapping the right datatypes. You can [preview the parquet schema using READ_NOS](https://docs.teradata.com/r/Teradata-VantageTM-Native-Object-Store-Getting-Started-Guide/January-2021/Reading-Parquet-Data/Parquet-Examples-For-DBAs-and-Advanced-Users/Previewing-the-Parquet-Schema-Using-READ_NOS) command to match the datatypes.

    ```sql
    Create Foreign Table 
    NYCTaxiADFIntegration.GreenTaxiForeignTable
    , External security definer trusted DefAuth3
    ( 
    VendorID INT,
          lpep_pickup_datetime TIMESTAMP,
          lpep_dropoff_datetime TIMESTAMP,
          store_and_fwd_flag VARCHAR(40) CHARACTER SET UNICODE CASESPECIFIC,
          RatecodeID INT,
          PULocationID INT,
          DOLocationID INT,
          passenger_count INT,
          trip_distance FLOAT,
          fare_amount FLOAT,
          extra DECIMAL(38,18),
          mta_tax DECIMAL(38,18),
          tip_amount FLOAT,
          tolls_amount DECIMAL(38,18),
          ehail_fee INT,
          improvement_surcharge DECIMAL(38,18),
          total_amount DECIMAL(38,18),
          payment_type INT,
          trip_type INT,
          congestion_surcharge DECIMAL(38,18)
    )   
    USING (    
    LOCATION(‘/AZ/adfvantagestorageaccount.blob.core.windows.net/vantageadfdatain/NYCGreenTaxi’)
       STOREDAS (‘PARQUET’))
    NO PRIMARY INDEX
         , PARTITION BY COLUMN;
    ```

    Now you can query the data from the foreign table just like any other table as shown below.

    :::image type="content" source="media/nos-query-blob-3.png" alt-text="Screenshot that shows how to query the data from the foreign table." lightbox="media/nos-query-blob-3.png":::

4.	Till now you have seen options to query the data in object storage in place. However, you may want to load the data permanently into a table in the database for better performance of your queries. You can load data from Azure Blob Storage into a permanent table by using the following statements. Some options may only work for certain datafile format, please refer to Teradata documentation for details. You can find some sample code at the following [link](https://docs.teradata.com/r/Teradata-VantageTM-Native-Object-Store-Getting-Started-Guide/January-2021/Reading-Parquet-Data/Parquet-Examples-For-DBAs-and-Advanced-Users/Loading-External-Parquet-Data-into-the-Database/Loading-External-Data-into-the-Database-Using-CREATE-TABLE-AS...WITH-DATA). 

|Method|	Description|
|-|-|
|CREATE TABLE AS…WITH DATA	|Accesses table definitions and data from an existing foreign table and creates a new permanent table inside the database|
|CREATE TABLE AS...FROM READ_NOS	|Accesses data directly from the object store and creates a permanent table inside the database|
|INSERT SELECT	|Stores values from external data in a persistent database table using an INSERT SELECT statement|

 Following are some samples of code to create permanent table using our GreenTaxiData

```sql
CREATE Multiset table NYCTaxiADFIntegration.GreenTaxiNosPermanent As (
SELECT D.PULocationID as PickupSite, Sum(fare_amount) AS TotalFarebyPickuploation
FROM NYCTaxiADFIntegration.GreenTaxiForeignTable AS D
GROUP BY 1
) with Data
No Primary Index;


INSERT INTO NYCTaxiADFIntegration.GreenTaxiNosPermanent
SELECT D.PULocationID as PickupSite, Sum(fare_amount) AS TotalFarebyPickuploation
FROM NYCTaxiADFIntegration.GreenTaxiForeignTable AS D
GROUP BY 1;
```

## Best practices

1. Make sure you follow the connector performance tips and best practices  as described [here](/azure/data-factory/connector-teradata?tabs=data-factory#teradata-as-source).
1. Make sure the self-hosted IR is sized correctly for data volume. You may want to scale out SHIR to get more performance. You can follow self-hosted IR performance guide.
1.	You can use [Copy Performance Guide](https://learn.microsoft.com/azure/data-factory/copy-activity-performance) to fine tune Data Factory pipeline for performance.
1.	Use  Data Factory Copy Wizard [link](https://learn.microsoft.com/en-us/azure/data-factory/quickstart-hello-world-copy-data-tool) to setup pipelines and run on schedules quickly.
1.	Consider using an Azure VM with a self-hosted IR to manage the cost of running pipelines. If you want to run twice a day, you start VM twice only and then shut it down.
1.	You can use   to implement GIT enabled continuous integration and development practice.
1.	Optimize your pipeline activity count. Unnecessary activities add up cost and make pipeline complex.
1.	You can use [Mapping data flows](https://learn.microsoft.com/azure/data-factory/concepts-data-flow-overview) to transform Azure Blob data visually with no-code and low-code to prepare Vanatage data for downstream use like PowerBI reporting.
1.	In addition to schedule trigger, you can use mix of tumbling window and event trigger to land Vantage data in destinations of your choice. Reduce unnecessary triggers to reduce cost.
1.	Use Teradata Vantage NOS for ad-hoc query to supply data for upstream applications easily.

## Conclusion.

This article highlights the various ways in which Azure Data Factory and Teradata VantageCloud Enterprise databases demonstrate enterprise integration and analytics capabilities. 
As discussed, Private Link, VNet Peering and Virtual WAN are used to connect an Azure Subscription and VNet with Teradata’s VNet where VantageCloud Enterprise database is deployed in a SaaS model. 

The scenarios demonstrate how to: 

- pull data from Vantage using Teradata native connector in  Data Factory by utilizing a self-hosted IR deployment and discussed the configurations that are needed to set it up and connect to Teradata over Private Link or VNet Peering.
- push data into Vantage using ODBC connector in  Data Factory and configure self-hosted IR with the required ODBC drivers and software and connection parameters to prepare your DSN and connect to Teradata over Private Link or VNet Peering. We also pointed to solution using the custom activity in  Data Factory and utilize TTU to load/un-load large scale data at scale in Teradata. 
- process data that has been transformed using  Data Factory and loaded into Azure Blob by reading it in-place or load it into Teradata using its NOS capabilities. 

## Next steps

- [Teradata Vantage on Azure]()
- [Azure Data Factory]()
- [Azure VNET peering]()
- [Azure Private Link Service]()
- [Data Factory Teradata Connector]
- [Self Hosted Integration Runtime]
- 
- https://learn.microsoft.com/en-us/azure/storage/blobs/
