This article describes various enterprise-scale analytical scenarios that are enabled by Azure Data Factory and Teradata VantageCloud Enterprise.

The architecture described here demonstrates how you can use Teradata VantageCloud Enterprise together with Azure Data Factory to develop data integration pipelines while writing little or no code. They describe how to quickly ingest or extract Vantage data over an enhanced-security connection by using Data Factory. The architecture is built on the foundation of Azure scalability, security, and governance.

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
 
The self-hosted IR can perform copy operations between cloud data stores and private-network data stores. You can also transform your compute resources in an on-premises network or an Azure virtual network. You need a local computer or virtual machine on your private network to install the self-hosted IR. For more information, see [Considerations for using a self-hosted IR](https://learn.microsoft.com/azure/data-factory/create-self-hosted-integration-runtime?tabs=data-factory#considerations-for-using-a-self-hosted-ir). This article describes how to use self-hosted IR to connect to VantageCloud and extract data to load into Azure Data Lake Storage.

### Teradata connector
 
In this architecture, Data Factory uses the Teradata connector to connect to Vantage. The Teradata connector supports:
- Teradata versions 14.10, 15.0, 15.10, 16.0, 16.10, and 16.20.
- Copying data by using basic, Windows, or LDAP authentication.
- Parallel copying from a Teradata source. For more information, see  [Parallel copy from Teradata](/azure/data-factory/connector-teradata?tabs=data-factory#parallel-copy-from-teradata).

This article describes how to set up linked services and datasets for the Data Factory Copy activity, which ingests data from Vantage and loads it into Data Lake Storage.

## Scenario 1: Data Factory extracts data from VantageCloud and loads it into Blob Storage

This scenario describes how to use Data Factory to exract data from VantageCloud Enterprise, perform some basic transformations, and then load the data into a Blob Storage container. 

The scenario highlights the native integration between Data Factory and Vantage and how easily you can build an enterprise ETL pipeline to integrate data in Vantage.

1.	Start by creating a linked service to Vantage using native connector. Select the **Manage** tab in your Azure Data Factory and select Linked Services, then select New:

    :::image type="content" source="media/create-linked-service.png" alt-text="Screenshot that shows the New button in Linked services." lightbox="media/create-linked-service.png":::


2.	Search for Teradata and select the Teradata connector, then select **Continue**.

    :::image type="content" source="media/teradata-linked-service.png" alt-text="Screenshot that shows the Teradata connector." lightbox="media/teradata-linked-service.png"::: 

3.	Configure the linked service details to connect to your Vantage database. We will be using basic authentication mechanism with user ID and password. But you can choose a different mechanism to connect based on your security posture and set other parameters accordingly. Refer to [Teradata connector linked service properties](https://learn.microsoft.com/azure/data-factory/connector-teradata?tabs=data-factory#prerequisites) for further details. You will use a self-hosted integration runtime. Refer [how to get a self-hosted integration runtime deployed](https://learn.microsoft.com/azure/data-factory/connector-teradata?tabs=data-factory#prerequisites). Deploy it in the same VNet as your Data Factory.

- Name: Enter a name for your linked service connection
- Connect Via integration runtime: Select SelfHostedIR  
- Server name:
  - If you are connecting via Vnet Peering option, provide the IP address of any of the VMs in the Teradata cluster. 
  - If you are connecting via PL option, provide the IP address of the private endpoint created in your Vnet to connect to Teradata Cluster via PL service.
- Authentication Type: Chose an authentication type, we are using basic authentication.
- Username and password: Provide the credentials
- Select Test connection to test your connection then select Create. Ensure that Interactive authoring is enabled for your integration runtime for the test connection functionality to work.

   :::image type="content" source="media/teradata-linked-service-configuration.png" alt-text="Screenshot that shows the configuration for the Teradata connector." lightbox="media/teradata-linked-service-configuration.png":::

We have already created a test database in Vantage named “NYCTaxiADFIntegration.” This database has a single table named Green_Taxi_Trip_Data. You can download the data for your testing purposes from [NYC OpenData](https://data.cityofnewyork.us/Transportation/2020-Green-Taxi-Trip-Data/pkmi-4kfn). Following is a sample create table statement to understand the schema of the table. 

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

4.	Next, we will create a simple pipeline to copy the data from the above table, perform some basic transformation and then load the data into an Azure Blob Storage container. For this purpose, we have already created an Azure Blob storage container in the customer subscription of the architecture as shown earlier. We will start by creating a linked service to it, which will be used as the sink in our pipeline to copy the data into. 

    - Select the **Manage** tab in your Azure Data Factory and select **Linked services**, then select **New**:
    
    :::image type="content" source="media/new-linked-service.png" alt-text="Screenshot that shows the New button." lightbox="media/new-linked-service.png":::

5.	Search for “Azure Blob” and select the Azure Blob Storage connector.

    :::image type="content" source="media/blob-stroage-connector.png" alt-text="Screenshot that shows the Blob Storage linked service." lightbox="media/blob-stroage-connector.png":::
    

6.	Configure the linked service to connect to the blob storage account:

    - **Name**: Enter a name for your linked service connection
    - **Connect via integration runtime**: Select AutoResolveIntegrationRuntime
    - **Authentication type**: select “Account key”
    - **Azure subscription**: enter your Azure subscription ID
    - **Storage account name**: enter your Azure storage account name
    
    Select **Test connection** to verify the connection, then select **Create**.

    :::image type="content" source="media/blob-storage-connector-configuration.png" alt-text="Screenshot that shows the configuration of the Blob Storage linked service." lightbox="media/blob-storage-connector-configuration.png":::
     

7.	Now create an Azure Data Factory pipeline:

    - Select the **Author** tab. 
    - Select the **+/plus** icon
    - Select **Pipeline**
    - Provide a **Name** for the pipeline.
    
      :::image type="content" source="media/azure-data-factory-pipeline.png" alt-text="Screenshot that shows the steps for creating a pipeline." lightbox="media/azure-data-factory-pipeline.png":::

8.	Now create two datasets.

- Select Author tab
- Select the +/plus icon
- Select dataset
- Create a dataset for the "Green_Taxi_Trip_Data" Teradata table: 
   - Select Teradata as the Data Stroe
   - Name: Provide a name for the data set
   - Linked Service: Select the linked service we created in steps 2 and 3 for Teradata.
   - Table Name: Select the Table from the dropdown list 
   - Select OK
- Create an Azure Blob dataset:
   - Select Azure Blob as Data Store 
   - Select the format type of your data. We are using parquet for this demo.
   - Linked Service: Select the linked service we created in steps 6.
   - File Path: Provide the file path for the blob file
   - Select None for Import Schema
   - Select OK

   :::image type="content" source="media/teradata-datasets.png" alt-text="Screenshot that shows the properties for the Teradata table." lightbox="media/teradata-datasets.png":::

   :::image type="content" source="media/azure-blob-dataset.png" alt-text="Screenshot that shows the properties for the Azure Blob Storage dataset." lightbox="media/azure-blob-dataset.png":::

9.	Create a Copy Data Activity.

    - Drag and drop the copy data activity onto the pipeline. Note that currently Teradata connector is not supported for Data Flow activity in Data Factory. If you are looking to perform transformation on the data, it is advised to create a Data flow activity following the copy activity. 
    - Configure the Copy Data Activity with source as the Teradata Table data set and destination as the Azure Blob Storage file as shown below.
    - Source dataset: Select Teradata dataset we created in previous step.
    - Use Query: Select Table
    - Leave other options as default.
      :::image type="content" source="media/copy-data-activity-source.png" alt-text="Screenshot that shows the steps for creating a copy data activity." lightbox="media/copy-data-activity-source.png":::

    - Sink Dataset: Choose the Azure blob data set we created in previous step.
    - Leave the other properties as default.
    
      :::image type="content" source="media/copy-data-activity-sink.png" alt-text="Screenshot that shows the configuration for the sink dataset." lightbox="media/copy-data-activity-sink.png":::
    
10.	Click on Debug and the pipeline will copy the data from Teradata Table to a parquet file on Azure Blob Storage.

## Scenario 2: Loading data into VantageCloud Enterprise with Data Factory

For this scenario we’ll use an ODBC connector to connect to the Teradata Vantage via the self-hosted IR VM to load the data. Since the integration time used for this needs to be installed and configured with the Teradata drive for ODBC, this option works only with Data Factory self-hosted IR option. Note that another option to load and transform data in Vantage is using TTU, Data Factory custom activity and Azure batch services can be found at this [link](https://www.teradata.com/Blogs/Connect-Teradata-Vantage-to-Azure-Data-Factory-Using-Custom-Activity-Feature). 

Tip: Evaluate both options for performance, cost, and management considerations to choose what is best based on your requirements. 

1.	We start by preparing the self-hosted IR we created in the previous scenario by installing the Teradata ODBC driver on it. We are using a windows 11 machine for self-hosted IR. 
    - [RDP] into the VM.
    - Download and install the [Teradata ODBC driver]. 
    - Download and install JAVA JRE, if it is not already present. 

2.	Create a 64-bit System DSN for the Teradata Database by [adding an ODBC Data source]. 
    - Make sure you are using the 64-bit DSN window.
    - Choose the Teradata Database ODBC Driver as shown on the following screenshot. 
    - Select Finish which will open the Drive setup window.

      :::image type="content" source="media/teradata-odbc-driver.png" alt-text="Screenshot that shows the steps for creating a data source." lightbox="media/teradata-odbc-driver.png":::


3.	Configure the DSN properties.
    - Name: Provide a name for the DSN . 
    - Teradata Server info: In the Teradata Server Info Name or IP Address:
      - If you are connecting via Vnet Peering option, provide the IP address of any of the VMs in the Teradata cluster. Note that you can connect to the IP address of any VM in the vantage cluster.
      - If you are connecting via PL option, provide the IP address of the private endpoint created in your Vnet to connect to Teradata Cluster via PL service.
    - Optionally provide the username and select test connection. This will prompt you to enter the credentials again. Select ok and ensure that your connection was successful. Note that you will provide the username and password in Data Factory while creating the ODBC Linked service which will be used to connect to the Teradata Database from Data Factory.
    - Leave the other fields blank.
    - Select Ok to finish the setup.

      :::image type="content" source="media/odbc-driver-configuration.png" alt-text="Screenshot that shows the configuration for the driver." lightbox="media/odbc-driver-configuration.png":::


4.	The ODBC Data source Administrator window will look like the following. Select Apply and it is ok to close the window. Your self-hosted IR is now ready to connect to Vantage database using ODBC connection. 

    :::image type="content" source="media/odbc-driver-configuration-2.png" alt-text="Screenshot that shows the ODBC linked service." lightbox="media/odbc-driver-configuration-2.png":::

5.	Head back to Azure Data Factory and create a linked service connection choosing ODBC as the Data store. 

    :::image type="content" source="media/odbc-linked-service.png" alt-text="Screenshot that shows the ODBC Data Source Administrator window." lightbox="media/odbc-linked-service.png":::

6.	Configure the linked service with the IR we configured in previous steps.

    - Name: Provide a name for the linked service.
    - Connect via integration runtime: Select SelfhostedIR
    - Connection string: enter the DSN connection string with the name of the DSN created in previous steps. 
    - Authentication type: Choose basic
    - Enter user name and password for your Teradata ODBC connection, this will be used to connect to it. 
    - Select Test connection to test your connect and then select Create.

      :::image type="content" source="media/teradata-linked-service-configuration-2.png" alt-text="Screenshot that shows the configurations for the linked service." lightbox="media/teradata-linked-service-configuration-2.png":::

7.	Now create a new Dataset with ODBC as the data store and choose the linked service we created in the earlier step. 
 
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
