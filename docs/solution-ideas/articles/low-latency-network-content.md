[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This solution describes how manufacturers can use high-performance, low-latency 5G Standalone networks to scale up industrial automation and productivity. 5G Standalone reliably connects machines to other machines or controllers. 5G-enabled IoT devices communicate and operate autonomously on the manufacturing floor. The 5G Standalone network is deployed as a Non-Public Network (NPN), with all data remaining on premises. The NPN configuration offers security, privacy, and reliability. Azure deploys and manages the network and devices.

## Potential use cases

Use this approach for scenarios like:

- Picking shipments from a warehouse efficiently.
- Dispersing seeds from an autonomous seed sprayer machine on a farm based on information from soil sensors.
- Conserving energy in commercial buildings by shutting off lights when no motion is detected in a room.

## Architecture

![Screenshot showing a 5G Standalone network that controls warehouse robots through an on-premises Azure Stack Edge server. An Azure network function manager controls the private multi-access edge compute nodes on Azure Stack Edge.](./media/media/image1.png)

1. Embedded 5G-enabled internet protocol (IP) modules connect the Open Radio Access Network (ORAN) Radio Units (RUs).
1. The RUs connect over a wired switching network to the ORAN Distribution Unit (DU) software running on Azure Stack Edge with private multi-access edge compute (MEC).
1. The DU connects with the Central Unit (CU) and the 5G packet core on a different Azure private MEC node.
1. The 5G packet core provides device authentication, IP address, and connectivity based on a preconfigured profile.
1. The optimized ORAN and traffic localization on Azure private MEC provide the low-latency, high-performance connectivity these scenarios require.

## Components

This solution uses the following components:

- [Azure Stack Edge](https://azure.microsoft.com/products/azure-stack/edge/) is a portfolio of devices that bring compute, storage, and intelligence to the IoT edge.
- [7P Private 5G Network (Stand Alone)](https://azuremarketplace.microsoft.com/marketplace/apps/sevenprinciplesag1603729177296.7p-pmn-5g-sa-hybrid?tab=Overview) is a powerful and secure private, on-premises mobile network.
- [Metaswitch Fusion Core 5G Packet Core](https://azuremarketplace.microsoft.com/marketplace/apps/metaswitch.fusioncore_0-1-0?tab=Overview) creates a low-footprint enterprise private network experience in the cloud for 4G and 5G access.
- [Azure Network Function Manager](https://azure.microsoft.com/search/?q=network+function+manager) deploys network functions to the edge.

## Next steps

[Connect an on-premises network to Azure](/azure/architecture/reference-architectures/hybrid-networking/)

## Related resources

- [Azure Private Edge Zones](/azure/networking/edge-zones-overview#private-edge-zones)

