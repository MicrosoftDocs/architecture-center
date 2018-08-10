---
title: Example scenario for IoT and data analytics in the construction industry.
description: Use IoT devices and data analytics to provide comprehensive management and operation of construction projects.
author: alexbuckgit
ms.date: 08/08/2018
---

# Example scenario for IoT and data analytics in the construction industry.

This example scenario is relevant to organizations building solutions that integrate data from many IoT devices into a comprehensive data analysis architecture to improve and automate decision making. Potential applications include construction, mining, manufacturing, or other industry solutions involving large volumes of data from many IoT-based data inputs.

In this scenario, a construction equipment manufacturer builds vehicles, meters, and drones that use IoT and GPS technologies to emit telemetry data. The company wants to modernize their data architecture to better monitor operating conditions and equipment health. Replacing the company's legacy solution using on-premises infrastructure would be both time and labor intensive, and would not be able to scale sufficiently to handle the anticipated data volume.

The company wants to build a cloud-based "smart construction" solution for gathering a comprehensive set of data for a construction site and automates the operation and maintenance of the various elements of the site. The company's goals include:
* Integrating and analyzing all construction site equipment and data to minimize equipment downtime and reduce theft.
* Remotely and automatically controlling construction equipment to mitigate the effects of a labor shortage, ultimately requiring fewer workers and enabling  lower skilled workers to succeed.
* Minimizing the operating costs and labor requirements for the supporting infrastructure, while increasing productivity and safety
* Easily scaling the infrastructure to support increases in telemetry data.
* Complying with all relevant legal requirements by provisioning resources in-country without compromising system availability.  
* Using open-source software to maximize the investment in workers' current skills.

Using managed Azure services such as IoT Hub and HDInsight will allow the customer to rapidly build and deploy a comprehensive solution with a lower operating cost. If you have additional data analytics needs, you should review the list of available [fully managed data analytics services in Azure][product-category].
            
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

* [IoT Hub][/azure/iot-hub] acts as a central message hub for secure bi-directional communication between the cloud platform and the construction equipment and other site elements. IoT Hub can rapidly collect data for each device for ingestion into the data analytics pipeline.
* [Azure Stream Analytics][/azure/stream-analytics] is an event-processing engine that can analyze high volumes of data streaming from devices and other data sources. It also supports extracting information from data streams to identify patterns and relationships. In this scenario, Stream Analytics ingests and analyze data from IoT devices and stores the results in Azure SQL Database. 
* [Azure SQL Database][/azure/sql-database] contains the results of analyzed data from IoT devices and meters, which can be viewed by analysts and users via an Azure-based Web application. 
* [Azure Blob storage][/azure/storage/blobs] stores the raw data gathered from the IoT hub devices. The raw data can be queried via the web application.
* [Traffic Manager][/azure/traffic-manager] controls the distribution of user traffic for service endpoints in different Azure regions.
* [Load Balancer]
* [Azure Virtual Machines][/azure/virtual-machines] provide a jumpbox or bastion host environment, allowing administrators to securing access the Cassandra cluster and its associated infrastructure.
* [Web Apps][/azure/web-apps] hosts the end-user web application, which can be used to query and analyze source data such as payload metrics. Users can also initiate batch Spark jobs via the application.
* [Apache Spark on HDInsight][/azure/hdinsight/spark] supports in-memory processing to boost the performance of big-data analytic applications. In this scenario, Spark is used to run complex algorithms to be stored in Cassandra. [TBD: Unclear on source data based on the architecture diagram. Is this sourced from the on-prem KOMTRAX data (existing on-prem infrastructure)?]
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
