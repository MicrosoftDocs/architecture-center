[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

A split 5G/LTE core architecture is suited for large enterprises with multiple sites. It has control functions that affect all sites, and data plane functions for each site.

## Architecture

:::image type="content" source="../media/private-5g-network-inline.png" alt-text="Diagram shows a customer site with a shop floor network connected to Azure cloud with dataflow described below." lightbox="../media/private-5g-network-expanded.png" border="false":::

*Download a [PowerPoint file](https://arch-center.azureedge.net/private-5g-network.pptx) of this architecture.*

In this architecture, a 5G Core is split into a *data plane* and a *control plane*.

The data plane uses User Plane Function (UPF). The control plane uses Session Management Function (SMF) or Policy Control Function (PCF):

- UPF is a fundamental component of the Private 5G Core infrastructure system architecture. It allows you to move packet processing, traffic aggregation, and management functions to the edge of the network.
- SMF manages each user equipment session. It manages allocating of IP addresses, selecting user plane functionality, the control aspects of quality of service, and the control aspects of routing.
- PCF is a 5G control plane network function that is responsible for policy control, especially quality of service.

The data plane is hosted at the far edge, at customer data center. The control plane is hosted either in Azure or at the near edge.

### Dataflow

1. Devices and sensors create and gather data.
1. Devices and sensors send the data to the 5G network radio.
1. The 5G radio forwards the data to the Azure IoT Edge modules that run on Azure Stack Edge. Based on the use case, the data can be handled in two ways:
   1. Process the data at the edge by using multi-access edge computing (MEC):
      1. Applications that run in IoT Edge modules on Azure Stack Edge process the data.
      1. Applications send results to the Private 5G Core UFP.
   1. Send data that's not processed to the Private 5G Core UFP.  
1. Private 5G Core sends the data to the enterprise database for storage and to the Azure portal to create dashboards and alerts.

### Components

This solution uses the following Azure components:

- [Azure Stack Edge](https://azure.microsoft.com/products/azure-stack/edge) brings compute, storage, and intelligence to IoT Edge. Azure Stack Edge acts as a cloud storage gateway that makes it possible to transfer data to Azure, while retaining local access to files.
- [Azure 5G Core](https://azure.microsoft.com/products/private-5g-core) provides 5G core network functions including user plane, control plane, subscriber, and policy deployed on Azure private MEC.
- [Azure SQL Database](https://azure.microsoft.com/services/sql-database) can store data processed at the edge by applications on Azure Stack Edge, as in step 3.a.i.
- [Azure Analysis Services](https://azure.microsoft.com/products/analysis-services) provides data visualization, govern, deploy, test, and business intelligence (BI) solutions. The processed data from 3.a.ii in this scenario can be used to create dashboards.
- [Media Services Storage](https://azure.microsoft.com/products/media-services) uses Azure Storage to store large amounts of unprocessed data forwarded in step 3.b.
- Enterprise applications from the [Azure Marketplace](https://azuremarketplace.microsoft.com/marketplace/apps/category/internet-of-things?page=1&subcategories=iot-edge-modules), such as video inspection and AI machine learning.

## Scenario details

Manufacturing businesses often create a shop floor network that's separate from the corporate network. A shop floor network has stricter security and reliability requirements than a corporate network. An unreliable network on the shop floor can affect the production line. These requirements are typical for a shop floor network:

- Ability to handle future use cases
- Consistency in throughput and latency
- Easy scalability
- High reliability
- High security

Although you can implement this architecture at any manufacturing site, it's especially useful for large enterprises that have multiple production sites or research and development labs. You can consolidate data from different sites into one Azure database. Users can create reports from this consolidated data.

With a single control plane connected to multiple data plane sites, your enterprise can benefit from easier network operations. This architecture makes it easier for IT to push software upgrades, implement network policies, manage networks and devices, and add new sites.

The single core approach comes with a single point of failure. Azure resilience and redundancy benefits can address this issue.

### Potential use cases

Some of the use cases for manufacturing are:

- Augmented reality/virtual reality (AR/VR) assisted troubleshooting and support
- Automated guided vehicles (AGVs)
- Collaborative robots (Cobots)
- Digital twins
- Predictive maintenance
- Robotic arms
- Remotely-operated equipment
- Video analytics, such as Automated Optical Inspection (AOI), where a camera autonomously scans the product for failures and quality defects
- Voice, such as push to talk (PTT), which is a half-duplex communication service that works like a walkie-talkie
- Worker health and safety, such as forklift collision avoidance, hard hat enforcement, posture monitoring, and assisted assembly

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributor.*

Principle author:

- [Shobhit Jain](https://www.linkedin.com/in/sjshobhitjain) | Technical Program Manager

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Introduction to 5G for Azure in the Enterprise](/training/modules/intro-5g-enterprise)
- [Enterprise 5G technologies for Azure Cloud Services](/training/modules/enterprise-5g-technologies)
- [Azure Arc overview](/azure/azure-arc/overview)
- [Azure Stack Edge documentation](/azure/databox-online)
- [What is Azure Internet of Things](/azure/iot-fundamentals/iot-introduction)

## Related resources

- [Data analysis workloads for regulated industries](/azure/architecture/example-scenario/data/data-warehouse)
- [End-to-end computer vision at the edge for manufacturing](../../reference-architectures/ai/end-to-end-smart-factory.yml)
- [Industrial IoT connectivity patterns](../../guide/iiot-patterns/iiot-connectivity-patterns.yml)
- [IoT and data analytics](../../example-scenario/data/big-data-with-iot.yml)
- [IoT Edge railroad maintenance and safety system](../../example-scenario/predictive-maintenance/iot-predictive-maintenance.yml)
- [Video capture and analytics for retail](../../solution-ideas/articles/video-analytics.yml)
