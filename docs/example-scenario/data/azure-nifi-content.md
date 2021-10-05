This example scenario shows how to run [Apache NiFi][Apache NiFi] on Azure. Apache NiFi provides a system for processing and distributing data. NiFi works well for moving data and managing the flow of data:

- Connecting decoupled systems in the cloud
- Moving data in and out of Azure Storage and other data stores
- Integrating edge-to-cloud and hybrid-cloud applications with Azure IoT, Azure Stack, and Azure Kubernetes Service

In this scenario, NiFi runs in a clustered configuration across virtual machines in a scale set. But most recommendations also apply to scenarios that run NiFi in single-instance mode on a single virtual machine (VM). The best practices in this article demonstrate a scalable, high-availability, and secure deployment.

Apache®, Apache NiFi®, and NiFi® are either registered trademarks or trademarks of the Apache Software Foundation in the United States and/or other countries. No endorsement by The Apache Software Foundation is implied by the use of these marks.

- A paragraph that describes what the solution does (the domain)
- A paragraph that contains a brief description of the main Azure services that make up the solution.

## Potential use cases

This solution applies to many areas:

- Modern data warehouses (MDWs) bring structured and unstructured data together at scale. They collect and store data from a variety of sources, sinks, and formats. Apache NiFi excels at ingesting data into Azure-based MDWs for the following reasons:

  - Over 200 processors are available for reading, writing, and manipulating data.
  - The system supports Storage services including Blob Storage, ADLS Gen2, Event Hubs, Queue Storage, Cosmos DB, and Synapse.
  - Robust data provenance capabilities make it possible to implement compliant solutions. For information about capturing data provenance in Azure Log Analytics, see [][].

- NiFi can run standalone on small-footprint devices. In such cases, NiFi makes it possible to process edge data and move that data to larger NiFi instances or clusters in the cloud. NiFi helps filter, transform, and prioritize edge data in motion, ensuring reliable and efficient data flows.

- Industrial IoT (IIoT) solutions manage the flow of data from the edge to the data center. That flow starts with data acquisition from industrial control systems and equipment. The data then moves to data management solutions and MDWs. Apache NiFi offers capabilities that make it well suited for data acquisition and movement:

  - Edge data processing functionality
  - Support for protocols that IoT gateways and devices use
  - Integration with Azure Event Hubs and Azure Storage services

  IoT applications in the areas of predictive maintenance and supply chain management can make use of this functionality.

## Architecture

:::image type="content" source="./media/azure-nifi-architecture.svg" alt-text="Architecture diagram showing how data flows through an H T A P solution with Azure SQL Database at its center." border="false":::

*Download a [Visio file][Visio file of architecture diagram] of this architecture.*


### Components

## Considerations

## Pricing


## Next steps

## Related resources

[Apache NiFi]: https://nifi.apache.org/
[Visio file of architecture diagram]: https://arch-center.azureedge.net/US-1875891-azure-nifi-architecture.vsdx