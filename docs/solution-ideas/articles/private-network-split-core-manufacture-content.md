[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Manufacturing businesses often create a shop floor network that is separate from the corporate network. A shop floor network has stricter security and reliability requirements than a corporate network. An unreliable network on shop floor can impact the production line. These requirements are typical for a shop floor network:

- Able to handle future use cases
- Consistency in throughput and latency
- Easy scalability
- High reliability
- High security

A split 5G/LTE core architecture is suited for large enterprises with multiple sites. It offers common control functions and dedicated data plane functions for each site.

## Architecture

:::image type="content" source="../media/private-5g-network-inline.png" alt-text="Diagram shows a customer site with a shop floor network connected to Azure cloud with dataflow described below." lightbox="../media/private-5g-network-expanded.png" border="false":::

*Download a [PowerPoint file](https://arch-center.azureedge.net/private-5g-network.pptx) of this architecture.*

In this architecture, the Azure Private 5G Core is split into a *data plane* and a *control plane*.

The data plane uses User Plane Function (UPF). The control plane uses Session Management Function (SMF) or Policy Control Function (PCF):

- UFP is a fundamental component of the Private 5G Core infrastructure system architecture, which allows you to move packet processing, traffic aggregation, and management functions to the edge of the network.
- SMF manages each user equipment session. It manages allocating IP addresses, selecting user plane functionality, control aspects of quality of service, and control aspects of routing.
- PCF is a 5G control plane network function, which is responsible for policy control, especially quality of service.

The data plane is hosted at the far edge, for instance, at customer data center. The control plane is hosted either in Azure or at the near edge.

### Dataflow

1. Devices and sensors create and gather data.
1. Send the data to the 5G network radio.
1. The 5G radio forwards the data to the Azure IoT Edge modules running on Azure Stack Edge. Based on the use case, the data can be handled in two ways:
   1. Process the data at the edge by using multi-access edge computing (MEC):
      1. Applications that run on IoT Edge modules on Azure Stack Edge process the data.
      1. They send results to the Private 5G Core UFP.
   1. Send data to the Private 5G Core UFP without processing at the enterprise site.  
1. Private 5G Core sends the data to enterprise database for storage and to the Azure portal to create dashboards and alerts.

### Components

This solution uses the following Azure components:

- [Azure Stack Edge](https://azure.microsoft.com/products/azure-stack/edge) is a portfolio of devices that bring compute, storage, and intelligence to IoT Edge. Azure Stack Edge acts as a cloud storage gateway that enables data transfers to Azure, while retaining local access to files.
- [Azure 5G Core](https://azure.microsoft.com/products/private-5g-core) offers 5G core network functions including user plane, control plane, subscriber, and policy deployed on Azure private MEC.
- [Azure SQL Database](https://azure.microsoft.com/services/sql-database) can store processed data from step 3.a.i in this scenario.
- [Azure Analysis Services](https://azure.microsoft.com/products/analysis-services) offers data visualization, govern, deploy, test, and business intelligence (BI) solutions. The processed data from 3.a.ii in this scenario can be used to create dashboards.
- [Media Services Storage](https://azure.microsoft.com/products/media-services) uses Azure Storage to store large amounts of raw data, like the data generated in step 3.b in this scenario.
- Enterprise applications from the [Azure Marketplace](https://azuremarketplace.microsoft.com/marketplace/apps/category/internet-of-things?page=1&subcategories=iot-edge-modules), such as video inspection and AI machine learning.

## Scenario details

Although you can implement this architecture at any manufacturing site, it's especially useful for large enterprises that have multiple production sites or research and development labs. You can consolidate data from different sites into one Azure database. Users can create reports from this consolidated data.

With a single control plane connected to multiple data plane sites, your enterprise can benefit from easier network operations. This architecture makes it easier for IT to push software upgrades, implement network policies, support single pane of inventory, manage networks and devices, and add new sites.

The single core approach comes with a single point of failure. Azure resilience and redundancy benefits can address this issue.

### Potential use cases

Some of the use cases for manufacturing as seen in the industry are:

- Augmented reality/virtual reality (AR/VR) assisted troubleshooting and support
- Automated guided vehicles (AGVs)
- Collaborative robots (Cobots)
- Digital twins
- Predictive maintenance
- Robotic arms
- Remotely operated equipment
- Video analytics, such as Automated Optical Inspection (AOI), where a camera autonomously scans the product for failure and quality defects, and security
- Voice, such as push to talk (PTT), a half-duplex communication service that works like a walkie-talkie
- Worker health and safety, such as forklifts collision avoidance, hard hat, posture, and assisted assembly

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributor.*

- [Shobhit Jain](https://www.linkedin.com/in/sjshobhitjain) | Technical Program Manager

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Introduction to 5G for Azure in the Enterprise](/training/modules/intro-5g-enterprise)
- [Enterprise 5G technologies for Azure Cloud Services](/training/modules/enterprise-5g-technologies)
- [Azure Arc overview](/azure/azure-arc/overview)
- [Azure Stack Edge documentation](/azure/databox-online)
- [What is Azure Internet of Things](/azure/iot-fundamentals/iot-introduction)

## Related resources

- [Data analysis workloads for regulated industries](../../example-scenario/data/data-analysis-regulated-industries.yml)
- [End-to-end computer vision at the edge for manufacturing](../../architecture/reference-architectures/ai/end-to-end-smart-factory.yml)
- [Industrial IoT connectivity patterns](https://learn.microsoft.com/azure/architecture/guide/iiot-patterns/iiot-connectivity-patterns)
- [IoT and data analytics](../../example-scenario/data/big-data-with-iot.yml)
- [IoT Edge railroad maintenance and safety system](../../example-scenario/predictive-maintenance/iot-predictive-maintenance)
- [Video capture and analytics for retail](https://learn.microsoft.com/azure/architecture/solution-ideas/articles/video-analytics)
