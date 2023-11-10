Real-time analytics can help you make quick decisions and perform autmomated actions based on current insights. It can also help you deliver enhanced customer experiences. This solution shows how to keep Azure Synapse Analytics data pools in sync with operational data changes in MongoDB.

## Architecture

The following diagram shows how to implement a real-time sync from Atlas to Azure Synapse Analytics. This simple flow ensures that any changes that occur in the MongoDB Atlas collection are replicated to the default Azure Data Lake Storage repository of the Azure Synapse Analytics workspace. After the data is in Data Lake Storage, you can use Azure Synapse Analytics pipelines to push the data to dedicated SQL pools, Spark pools, or other solutions, depending on your analytics requirements.

![](media/image7.png)

*Figure 1*

*Download a [Visio file](https://arch-center.azureedge.net/[filename].vsdx) of this architecture.* 

### Dataflow

Real-time changes in the operational data store (ODS) powered by MongoDB Atlas are captured and made available to Data Lake Storage in Azure Synapse Analytics for real-time analytics use cases, live reports, and dashboards using the preceding figure. 

The steps in the flow are: 

1. Real-time data changes occurring in the operational/ transactional datastore powered by MongoDB Atlas are captured by [MongoDB Atlas Triggers](https://www.mongodb.com/docs/atlas/app-services/triggers/).

1. [MongoDB Atlas Database trigger](https://www.mongodb.com/docs/atlas/app-services/triggers/database-triggers/) on identifying an event, passes the change type and the document that underwent change (full or delta) to a [MongoDB Atlas function](https://www.mongodb.com/docs/atlas/app-services/functions/).

1. Atlas function triggers an Azure function passing the change event and the json document.

1. Azure function uses the Data Lake client and writes the changed document to the configured Synapse ADLS Gen2 storage.

1. Once the data is in ADLS Gen2 it can be sent to Dedicated SQL pools, Spark pools, other solutions. Alternatively, you can convert the data from JSON to parquet/delta formats using Dataflow or Synapse Copy pipelines to further run BI reporting or AI/ML on the current data. 

### Components

MongoDB Atlas[ ](https://www.mongodb.com/docs/manual/changeStreams/)[Change Streams](https://www.mongodb.com/docs/manual/changeStreams/) are a feature in MongoDB Atlas which facilitates applications to be notified of any changes to a particular collection, database or entire deployment cluster. Implementing Change Streams provides applications access to real time data changes and to immediately react to changes. This functionality is critical in use cases such as IoT event tracking and financial data changes where alarms need to be raised and responsive actions need to be taken immediately. MongoDB Atlas Triggers use change streams to watch collections for changes and automatically invoke the associated Atlas function in response to the trigger event.

[MongoDB Atlas Triggers ](https://www.mongodb.com/docs/atlas/app-services/triggers/database-triggers/)respond to document inserts, updates and deletes on a specific collection and can automatically invoke an Atlas function in response to the change event. This powerful feature wraps the code required to listen to a change occurring in a collection and trigger an Atlas function in response to the change.

[Atlas functions](https://www.mongodb.com/docs/atlas/app-services/functions/)  are serverless server-side javascript code that can take actions based on the events that invoke an Atlas Trigger. Atlas Triggers combined with Atlas functions makes implementation of event-driven architectures extremely easy and a straightforward experience.

[Azure Functions](https://azure.microsoft.com/products/functions/) are built on an event-driven, serverless compute platform that allows you to develop more efficiently using a programming language of your choice and connect seamlessly with other Azure services. In this scenario, the Azure Function captures the change event and uses that to write a blob with the changed data into ADLS Gen 2 using the DataLake Service client.

[Synapse Storage (ADLS Gen2)](/azure/storage/blobs/data-lake-storage-introduction) is the default storage in Synapse Analytics. The storage can be queried directly using serverless pools.

[Pipelines/](/azure/synapse-analytics/get-started-pipelines) [Dataflow](/azure/synapse-analytics/concepts-data-flow-overview) in Synapse can be used to further push this incoming blob with the MongoDB changed data to Dedicated SQL pools or Spark pools for further analysis. Synapse Pipelines  allow you to act on changed data sets in ADLSGen2 by using both [storage event triggers](/azure/data-factory/how-to-create-event-trigger?tabs=data-factory) and [scheduled triggers](/azure/data-factory/how-to-create-schedule-trigger?tabs=data-factory) to build solutions for both real time and near real time use cases. This integration accelerates downstream consumption of change data sets. 

![](media/image2.png)

*Figure 2*

### Alternatives

This solution uses MongoDB Atlas triggers to wrap the code to listen to MongoDB Atlas change streams and trigger Azure Functions in response to the change event. Thus, it's much simpler to implement than the earlier provided [alternate solution](/azure/architecture/example-scenario/analytics/azure-synapse-analytics-integrate-mongodb-atlas), wherein developers had to code the logic to listen to change streams in an [App service](https://azure.microsoft.com/products/app-service).

Another alternative is using the [MongoDB Spark streaming connector](https://www.mongodb.com/blog/post/introducing-mongodb-spark-connector-version-10-1) to read MongoDB stream data and write the same to Delta tables. The code is run continuously in a Spark notebook which is part of a Pipeline in Synapse. Refer to this [GitHub](https://github.com/mongodb-partners/Synapse-Spark-Streaming) guide for a reference on how this solution can be implemented.

However, using Atlas triggers with Azure Functions means adopting a completely serverless solution. Being serverless, the solution provides benefits of robust scalability accompanied with cost optimization. The costs will be purely based on the Pay As you Go mechanism. Further cost savings can be achieved in this solution by using the MongoDB Atlas function to combine a few change events before invoking the Azure Function endpoint. This can be a useful strategy in a heavy traffic scenario.

Also, with the launch of [Microsoft Fabric,](https://www.microsoft.com/microsoft-fabric) which unifies your varied data estate and makes it much easier to run analytics and AI over the data enables you to get maximum insights in the shortest time possible. Synapse Data engineering, Data Science, Data Warehouse and Real-Time analytics in Fabric can now make better use of the MongoDB data pushed to OneLake. With both Dataflow Gen 2 and Data Pipeline connectors for MongoDB Atlas, you can now load MongoDB Atlas data directly to OneLake. This is a powerful and no code mechanism to ingest data from Atlas to OneLake.  

![](media/image8.png)

*Figure 3*

Also, the data that is pushed to ADLS Gen 2 can be referenced directly in Fabric using [OneLake Shortcuts](https://learn.microsoft.com/fabric/onelake/onelake-shortcuts), without the need for any ETL.

The data can be further pushed to Power BI for creating exhaustive reports and visualizations for BI reporting.

## Scenario details 

MongoDB Atlas, being the operational data layer of many enterprise applications, stores data from internal applications, customer-facing services and third-party APIs coming from multiple channels. This data can be combined with relational data from other traditional applications and unstructured data from sources like logs, object stores, and clickstreams using the Data Pipelines in Synapse. Enterprises use MongoDB capabilities like [aggregations](https://www.mongodb.com/docs/manual/aggregation/), [analytical nodes, ](https://www.mongodb.com/docs/atlas/cluster-config/multi-cloud-distribution/)[Atlas Search, V](https://www.mongodb.com/atlas/search)[ector search](https://www.mongodb.com/products/platform/atlas-vector-search) , [Atlas Data Lake](https://www.mongodb.com/atlas/data-lake), [Atlas SQL](https://www.mongodb.com/atlas/sql), [Atlas Data Federation](https://www.mongodb.com/atlas/data-federation), and [Charts](https://www.mongodb.com/products/charts) to power application driven intelligence. However, the transactional data in MongoDB is extracted, transformed, and loaded to Synapse SQL/ Spark pools for batch, AI/ML and data warehouse based BI analytics and intelligence.

**There are two scenarios of data movement between MongoDB Atlas to Synapse:**

**Batch Integration ** 

Batch and micro-batch integration enables fetching the entire historical data at once or fetching incremental data based on a filter criterion from MongoDB Atlas to Synapse ADLS Gen2.

Both MongoDB on-prem instances and MongoDB Atlas can be seamlessly integrated as a Source or as a Sink resource in Azure Synapse Analytics. Refer [here](/azure/data-factory/connector-mongodb-atlas?tabs=data-factory) for the MongoDB Atlas connector and link[ ](/azure/data-factory/connector-mongodb?tabs=data-factory)[here](/azure/data-factory/connector-mongodb?tabs=data-factory) for the MongoDB Enterprise Advanced connector setup and configuration details. 

The source connector makes it extremely convenient to run Synapse analytics on top of the operational data stored in MongoDB On-prem and/or Atlas. We can fetch data from Atlas using the source connector and load the data to Azure Data Lake Gen2 storage as a parquet, Avro, JSON, text, or a CSV blob storage. These files can then be transformed or joined with other files from other data sources in multi-database, multi-cloud, or hybrid cloud scenarios, which is a common use-case for EDW and analytics-at-scale. The results of the analytics can also be stored back in MongoDB Atlas using the Sink connector. Refer to the [previous architecture document](/azure/architecture/example-scenario/analytics/azure-synapse-analytics-integrate-mongodb-atlas) for a deep dive into Batch integration.  

**  Real-Time Sync** 

The Architecture detailed in this solution provides value to customers looking for this real-time sync feature to keep their Synapse storage current with MongoDB’s operational data.  

This solution is composed of two primary functions: 

A. *Capture of the changes in MongoDB Atlas*  

This is achieved by the MongoDB Atlas trigger which is configured in the “Add Trigger” UI or using [Atlas admin APIs](https://www.mongodb.com/docs/atlas/app-services/admin/api/v3/) to listen to database changes due to database events like Inserts, Updates and Deletes. Atlas trigger also triggers an Atlas function on detection of a change event. This Atlas function can be added in the “Add Trigger” UI itself. We can also create an Atlas function using the [Atlas admin ](https://www.mongodb.com/docs/atlas/app-services/admin/api/v3/)API and associate it as the trigger invocation endpoint in the [Create trigger admin API](https://www.mongodb.com/docs/atlas/app-services/admin/api/v3/).

Figure 2 shows the form that is presented to create and edit an Atlas Trigger. Trigger Source details specify the collection that the trigger will watch for change events and the database events it will watch for (Insert, Update, Delete or Replace).

:::image type="content" source="media/image3.png" alt-text="form for creating an Atlas trigger." border="true":::

*Figure* *4*

The trigger can invoke an Atlas function as a response to the event it is enabled for. Figure 3 shows the simple JavaScript code added as Atlas function to be invoked in response to the database trigger. The Atlas function just invokes another Azure function passing it the metadata of the change event along with the actual document that was inserted/ updated or deleted depending on what the trigger was enabled for.

:::image type="content" source="media/image4.png" alt-text="Java code added" border="true":::

*Figure* *5*

 Atlas function code:

The Atlas function code triggers the Azure function associated with the Azure function end point by passing the entire changeEvent in the body of the request to the Azure function.

The `<<azure function url endpoint>>` needs to be replaced with the actual Azure function url/ endpoint.

    exports =  function(changeEvent) {
    
        // Invoke Azure function inserting the change stream into ADLS gen2
        console.log(typeof fullDocument);
        const response =  context.http.post({
          url: "<<azure function url endpoint>>",
          body: changeEvent,
          encodeBodyAsJSON: true
        });
        return response;
    };


B. *Trigger the Azure function to Propagate the Changes to Synapse:* 

Atlas function is coded to invoke an Azure function which writes the change document to Synapse ADLS Gen2. The Azure function uses the [ADLS Gen2 Python ](/azure/storage/blobs/data-lake-storage-directory-file-acl-python?tabs=azure-ad)SDK and creates an instance of the *DataLakeServiceClient* class in the SDK representing your storage account.

The Azure function uses a storage key as the mechanism for authentication. However, it can be changed with Microsoft Entra ID-based OAuth implementations also. The storage_account_key and other ADLS Gen2 storage related attributes are fetched from the set OS environment variables. After decoding the request body, the *fullDocument* (the entire document that was inserted or updated) is parsed from the request body and then written to ADLS Gen 2 using the Data Lake client functions of *append_data* and *flush_data*.

You will notice in the code that for a Delete operation the *fullDocumentBeforeChange* is used instead of *fullDocument*. The *fullDocument* will not have any value for Delete and thus, we need to fetch the document that was deleted which is captured in *fullDocumentBeforeChange*. Note that the fullDocumentBeforeChange is only populated when the *Document Preimage* setting is set to ON as in *Figure 3*.

    import json
    import logging
    import os
    import azure.functions as func
    from azure.storage.filedatalake import DataLakeServiceClient
    
    def main(req: func.HttpRequest) -> func.HttpResponse:
     logging.info('Python HTTP trigger function processed a new request.')
     logging.info(req)
     storage_account_name = os.environ["storage_account_name"]
     storage_account_key = os.environ["storage_account_key"]
     storage_container = os.environ["storage_container"]
     storage_directory = os.environ["storage_directory"]
     storage_file_name = os.environ["storage_file_name"]
     service_client = DataLakeServiceClient(account_url="{}://{}.dfs.core.windows.net".format(
             "https", storage_account_name), credential=storage_account_key)
     json_data = req.get_body()
     logging.info(json_data)
     object_id = "test"
     try:
         json_string = json_data.decode("utf-8")
         json_object = json.loads(json_string)
    
         if json_object["operationType"] == "delete":
             object_id = json_object["fullDocumentBeforeChange"]["_id"]["$oid"]
             data = {"operationType": json_object["operationType"], "data":json_object["fullDocumentBeforeChange"]}
         else:
             object_id = json_object["fullDocument"]["_id"]["$oid"]
             data = {"operationType": json_object["operationType"], "data":json_object["fullDocument"]}
         
         logging.info(object_id)
         encoded_data = json.dumps(data)
     except Exception as e:
         logging.info("Exception occured : "+ str(e)) 
         
     file_system_client = service_client.get_file_system_client(file_system=storage_container)
     directory_client = file_system_client.get_directory_client(storage_directory)
     file_client = directory_client.create_file(storage_file_name + "-" + str(object_id) + ".txt")
     file_client.append_data(data=encoded_data, offset=0, length=len(encoded_data))
     file_client.flush_data(len(encoded_data))
     return func.HttpResponse(f"This HTTP triggered function executed successfully.")


So far, we saw how the Atlas trigger captures any change that occurred and passes it to Azure function via an Atlas function and that the Azure function writes the change document as a new file in ADLS Gen 2 storage of the Synapse Analytics workspace. 

Once the file is added to the ADLS Gen 2, a [storage trigger](/azure/data-factory/how-to-create-event-trigger?tabs=data-factory) can be set up to trigger a Pipeline which can then write the change document to a Dedicated SQL Pool or to a Spark Pool table. The Pipeline can use the flexible Copy activity and transform the data using a Data flow as detailed in the article here. Alternatively, if your final target is the Dedicated SQL Pool, you can modify the Azure function to write directly to the Dedicated SQL Pool in Synapse. Use [link](/azure/synapse-analytics/sql/connection-strings?view=azuresql) to get the ODBC connection string for the SQL Pool connection and refer [here](/azure/azure-sql/database/connect-query-python?context=%2Fazure%2Fsynapse-analytics%2Fcontext%2Fcontext&view=azuresql) for an example python code to query the SQL Pool table using the connection string. This code can be modified to use Insert query to write to the Dedicated SQL Pool. There are configuration settings and adequate roles that need to be assigned to be able to use the function to write to Azure Dedicated SQL Pool, which is out of scope of this paper. 

Note that if you are looking for a near real-time solution and there isn’t a requirement to have the data synchronized in real-time, having scheduled Pipeline runs might be a good option. You can set up scheduled triggers to trigger a Pipeline with Copy activity or Dataflow, at a frequency which is at the near real-time frequency that your business can afford to use the [MongoDB connector](/azure/data-factory/connector-mongodb?tabs=data-factory) to fetch the data from MongoDB that was inserted/updated/deleted since last scheduled run to the current run. The Pipeline uses the MongoDB connector as source connector to fetch the delta data from MongoDB Atlas and push it to ADLS Gen2 or Synapse Dedicated SQL Pools using these as sink connections. This will be a PULL mechanism (as opposed to the solution described in this article which is a PUSH mechanism) from MongoDB Atlas as changes occur in the MongoDB Atlas collection being listened to by the Atlas trigger.

### Potential use cases

Using MongoDB's versatility and Azure Synapse’s Enterprise Data Warehouse (EDW) and Analytical services, we can serve numerous use cases that can directly benefit the customers. 

The use cases span across multiple industries including Retail, Financial Services, Automotive, Manufacturing etc. 

A short summary of the prominent use cases is listed below: 

Retail

* Building intelligence into product bundling and product promotion
* Customer 360 and hyper-personalisation
* Predicting stock depletion and optimizing supply-chain orders
* Dynamic discount pricing and smart search in ecommerce

Banking and finance

* Customizing customer financial services
* Detecting and blocking fraudulent transactions

Telecommunications

* Optimizing next-generation networks
* Maximizing the value of edge networks

Automotive

* Optimizing parameterization of connected vehicles
* Detecting anomalies in IoT communication in connected vehicles

Manufacturing

* Providing predictive maintenance for machinery
* Optimizing storage and inventory management  

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see[ Microsoft Azure Well-Architected Framework](/azure/well-architected/). 

### Security

The solution is based on Azure functions with MongoDB Atlas triggers and functions. Azure functions, being serverless managed services by Azure, the app resources and platform components are actively secured and hardened. However, it is recommended to ensure HTTPS protocol and latest TLS versions are used. It is also a good practice to validate the input to ensure it is a MongoDB change document. Refer [here](/azure/azure-functions/security-concepts?tabs=v4) for multiple Security considerations for Azure functions. MongoDB Atlas, being a managed database as a service, the platform security is well ensured by MongoDB. MongoDB provides multiple mechanisms to ensure 360-degree security for the data stored including Database access, Network security, encryption at rest and in transit and Data sovereignty.  Refer [here](https://www.mongodb.com/collateral/mongo-db-atlas-security) for the MongoDB Atlas security whitepaper and other articles which will help you understand and ensure that the data in MongoDB is secure throughout the data lifecycle.

### Performance efficiency

Atlas Triggers and Azure functions being serverless functions are time tested for performance and scalability. Refer [here](/azure/azure-functions/durable/durable-functions-perf-and-scale) to understand performance and scalability considerations for Azure functions. Refer [here](https://www.mongodb.com/cloud/atlas/performance) for some of the considerations for enhancing the performance of your MongoDB atlas instances and also refer [here](https://www.mongodb.com/basics/best-practices) for some best practices for MongoDB Atlas setup. 

### Cost optimization

To estimate the cost of Azure products and configurations, visit the[ ](https://azure.microsoft.com/pricing/calculator/)[Azure pricing calculator](https://azure.microsoft.com/pricing/calculator/). Azure helps you avoid unnecessary costs by identifying the correct number of resources, analyzing spending over time, and scaling to meet business needs without overspending. Azure functions being serverless, will incur costs only when invoked. However, depending on the volume of changes in the MongoDB Atlas, you can evaluate using a batching mechanism in the Atlas function to store changes in another temporary collection and trigger the Azure function only if the Batch exceeds a certain limit. Refer [here](https://www.mongodb.com/developer/products/atlas/5-ways-reduce-costs-atlas/) for ways to reduce your Atlas cluster costs and [here](https://www.mongodb.com/docs/atlas/billing/cluster-configuration-costs/) to understand the cluster configuration costs. [MongoDB pricing page](https://www.mongodb.com/pricing?utm_source=google&utm_campaign=search_gs_pl_evergreen_atlas_core_prosp-brand_gic-null_apac-in_ps-all_desktop_eng_lead&utm_term=atlas%20mongodb%20pricing&utm_medium=cpc_paid_search&utm_ad=e&utm_ad_campaign_id=12212624347&adgroup=115749713263&cq_cmp=12212624347&gad=1&gclid=Cj0KCQjwz8emBhDrARIsANNJjS6R53mr3nEGpwqvdpsjQpORFwAQRrM4M7cjrn4p9273HWFoHTxqJe4aAhfiEALw_wcB) helps you understand the pricing options for MongoDB Atlas clusters and other offerings of the MongoDB Atlas developer data platform. [Atlas Data Federation](https://www.mongodb.com/cloud/atlas/lp/data-federation?utm_source=google&utm_campaign=search_gs_pl_evergreen_data-lake_product_prosp-brand_gic-null_ww-multi_ps-all_desktop_eng_lead&utm_term=mongodb%20atlas%20data%20federation&utm_medium=cpc_paid_search&utm_ad=e&utm_ad_campaign_id=11759330849&adgroup=134320821261&cq_cmp=11759330849&gad=1&gclid=Cj0KCQjwy4KqBhD0ARIsAEbCt6gHmj9m4zGeJmsRLHTypKe6EOacWsygPeaOzdIg5sUl7rXbEY45P0oaAmkLEALw_wcB) now [supports Azure Blob storage](https://www.mongodb.com/blog/post/atlas-data-federation-can-be-deployed-azure-supports-azure-blob-storage-private-preview) also as a target in private preview. Writing to Azure Blob storage instead of a MongoDB temporary collection, may also be considered if Batching is being looked at for cost optimization options.

**Conclusion** 

MongoDB Atlas seamlessly integrates into Azure Synapse Analytics enabling Atlas customers to easily use Atlas as their source or sink for Synapse Analytics. To be able to use Atlas Operation Data Layer’s dynamic schema and versatile data in Synapse analytics in real-time, enables customers to be able to use scalable and rich analytics for their real-time business requirements. This solution empowers them to use MongoDB operational data in real-time from Synapse Analytics for complex analytics and AI inferences.

## Deploy this scenario

[Link to Deploy Process](https://github.com/Azure/Azure_Synapse_RealTimeSync_Using_AtlasTrigger_and_AzureFunction) 

## Contributors 

*This article is maintained by Microsoft. It was originally written by the following contributors.* 

Principal authors:  

- [Diana Annie Jenosh](http://www.linkedin.com/in/diana-jenosh-0b014814) | Senior Solutions Architect - MongoDB Partners team 
- [Venkatesh Shanbag](https://www.linkedin.com/in/venkatesh-shanbhag?lipi=urn%3Ali%3Apage%3Ad_flagship3_profile_view_base_contact_details%3BN6lzuIoYT0Sr6RvASXfXQw%3D%3D)| Senior Solutions Architect - MongoDB Partners team 

Other contributors:  

- [Sunil Sabat](https://www.linkedin.com/in/sunilsabat/) | Principal Program Manager - ADF team 
- [Wee Hyong Tok](https://www.linkedin.com/in/weehyongtok/) | Principal Director of PM - ADF team 

