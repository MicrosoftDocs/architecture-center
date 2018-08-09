---
title: Example scenario for IoT and data analytics in the construction industry.
description: Use IoT devices and data analytics to provide comprehensive management and operation of construction projects.
author: alexbuckgit
ms.date: 08/08/2018
---

# Example scenario for IoT and data analytics in the construction industry.

This example scenario is relevant to organizations that ...
    - Construction
    - Manufacturing
    - Information and Communications Technology

In this scenario, a construction equipment manufacturer...
    Monitor equipment via IoT and GPS
    	- Monitor operating conditions & vehicle health
    	- Minimize equipment downtime
    	- Reduce theft
    	- Control ICT construction equipment automatically
    		○ Counters labor shortage
    		○ Enables lower skilled workers
    	- Maximizing productivity requires holistic approach across processes

    Smart Construction - 
    	Used in 4000+ construction sites
    	Connect all info from across a construction site (not equipment only)
    	Improves productivity and safety more holistically, with less labor
    	Use collected data in disaster recovery 
    		Manage progress of current construction work
    		Apply data to simulations of subsequent construction plans
    
The company has legacy data sources across different platforms. The company wants to ... The company's goals include:
    Replace legacy on-prem solution
    	40 servers
    	Replacement would have been time and labor intensive
    		6+ months
    	Couldn't scale to the required data volume
    	Too labor intensive for small enterprises involved
    		Need infrastructure costs as low as possible
    High volumes of data
    	1 piece of equipment can generate ~5 datasets/second
    	~1 million records in 6 hours
       
Using managed Azure services such as ... If you have additional data analytics needs, you should review the list of available [fully managed data analytics services in Azure][product-category].
            
## Potential use cases

Consider this solution for the following use cases:

* Industry specific use cases?
* Large-scale collection of device data for storage and analysis
* Ingest and analyzing large datasets using a lambda architecture 

## Architecture

![Architecture for IoT and data analytics in the construction industry][architecture]

The data flows through the solution as follows:

1. Data is gathered by IoT sensors on construction equipment, vehicles, and drones and sent to IoT Hub.
2. IoT Hub sends the raw data collected to Stream Analytics, where the data is analyzed and the results stored in an Azure SQL database. The raw data collected is also saved in Azure Blob storage.
3. The Smart Construction Cloud web application is available to analysts and end users to view and analyze sensor data. Batch jobs are initiated by the user of the web app. 
4. [TBD: Spark / HDInsight: Where does this data come from?]
5. [TBD: Cassandra: How is this data later used or accessed?]
6. [TBD: Why is "construction results data" sent through a jumpbox to Cassandra?] 

Architecture:
	- Similar to lambda architecture to handle both real time event and large data stored in Cassandra cluster.
            
### Components

* [IoT Hub][docs-iot-hub] acts as a central message hub for secure bi-directional communication between the cloud platform and the construction equipment and other site elements. IoT Hub can rapidly collect data for each device for ingestion into the data analytics pipeline.
* [Azure Stream Analytics][docs-stream-analytics] is an event-processing engine that can analyze high volumes of data streaming from devices and other data sources. It also supports extracting information from data streams to identify patterns and relationships. In this scenario, Stream Analytics ingests and analyze data from IoT devices and stores the results in Azure SQL Database. 
* [Azure SQL Database][docs-azure-sql-database] contains the results of analyzed data from IoT devices and meters, which can be viewed by analysts and users via an Azure-based Web application. 
* [Azure Blob storage][docs-blob-storage] stores the raw data gathered from the IoT hub devices. The raw data can be queried via the web application.
* [Traffic Manager]
* [Load Balancer]
* [Azure Virtual Machines][docs-virtual-machines] provide a jumpbox or bastion host environment, allowing administrators to securing access the Cassandra cluster and its associated infrastructure.
* [Web Apps][docs-web-apps] hosts the end-user web application, which can be used to query and analyze source data such as payload metrics. Users can also initiate batch Spark jobs via the application.
* [Apache Spark on HDInsight][docs-apache-spark] supports in-memory processing to boost the performance of big-data analytic applications. In this scenario, Spark is used to run complex algorithms to be stored in Cassandra. [TBD: Unclear on source data based on the architecture diagram. Is this sourced from the on-prem KOMTRAX data (existing on-prem infrastructure)?
* [Apache Cassandra][cassandra] is a distributed NoSQL datbase that hosts the results of the data analytics jobs run in Spark on HDInsight.

### Alternatives

[Cosmos DB] - vs. lack of Cassandra multi-master?

If you are working with very large datasets, consider using [Data Lake Storage](/azure/storage/data-lake-storage/introduction), which provides limitless storage for analytics data, rather than Blob storage.

For comparisons of different relevant technology options, see the following:    
* [Choosing a batch processing technology in Azure](/azure/architecture/data-guide/technology-choices/batch-processing)
* [Choosing an analytical data store in Azure](/azure/architecture/data-guide/technology-choices/analytical-data-stores)
            
## Considerations

Azure advantages
	Multi-region both globally and domestically
		Helps with DR domestically
	Comparatively high speed communication btw regions
	Contract compliance
	OSS support
	Ease of scaling
	Drastically reduced operating workload
	Accelerate adoption of new technologies
	Costs ~ 1/2 of an on-prem solution

### Availability

The example scenario takes advantage of multiple Azure regions, both globally and domestically. Some countries have more than one Azure region, which can help significantly in meeting legal and contractual requirements.
                
For other availability topics, see the [availability checklist][availability] in the Azure Architecure Center.
    
### Scalability

TBD: Discuss scalability of Azure specific to the case study vs. just technologies? Scalability of workforce? Lower costs to scale?

For other scalability topics, see the [scalability checklist][scalability] in the Azure Architecure Center.

### Security
            
For general guidance on designing secure solutions, see the [Azure Security Documentation][security].

### Resiliency

For general guidance on designing resilient solutions, see [Designing resilient applications for Azure][resiliency].

## Pricing

To explore the cost of running this solution, all of the services are pre-configured in the cost calculator.  To see how the pricing would change for your particular use case, change the appropriate variables to match your expected traffic.

We have provided three sample cost profiles based on amount of traffic you expect to get:

* [Small][small-pricing]: this correlates to .
* [Medium][medium-pricing]: this correlates to .
* [Large][large-pricing]: this correlates to .

## Related Resources

This example scenario is based on a version of this architecture used by  [Komatsu][customer-site] For more information, see their [customer story][customer-story]. 

Guidance for big data architectures is available in the [Azure Data Architecture Guide](/azure/architecture/data-guide/).

<!-- links -->
[product-category]: https://azure.microsoft.com/product-categories/analytics/
[customer-site]: https://home.komatsu/en/
[customer-story]: https://customers.microsoft.com/story/komatsu-manufacturing-azure-iot-hub-japan
[small-pricing]: https://azure.com/e/9444b5ce08b7490a9b9f2207203e67f5
[medium-pricing]: https://azure.com/e/b798fb70c53e4dd19fdeacea4db78276
[large-pricing]: https://azure.com/e/f204c450314141a7ac803d72d2446a24
[architecture]: ./images/architecture-diagram-big-data-with-iot.png
[availability]: /azure/architecture/checklist/availability
[resource-groups]: /azure/azure-resource-manager/resource-group-overview
[resiliency]: /azure/architecture/resiliency/
[security]: /azure/security/
[scalability]: /azure/architecture/checklist/scalability
