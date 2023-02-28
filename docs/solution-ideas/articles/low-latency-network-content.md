[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This solution describes how manufacturers can use high-performance, low-latency 5G Standalone networks to scale up industrial automation and productivity.

## Architecture

:::image type="content" alt-text="Screenshot showing a 5G Standalone network that controls warehouse robots through an on-premises Azure Stack Edge server." source="../media/low-latency-network.png" lightbox="../media/low-latency-network.png":::

*Download a [Visio file](https://arch-center.azureedge.net/low-latency-network.vsdx) of this architecture.*

### Dataflow

1. Embedded 5G-enabled internet protocol (IP) modules connect warehouse robots to 5G Open Radio Access Network (ORAN) radio units. RAN is a common wireless network infrastructure for mobile networks.
1. The 5G radio units connect over a wired switching network to the 5G distribution unit software, which runs on private multi-access edge compute (MEC) on Azure Stack Edge.
1. The 5G distribution unit connects with the virtual router, 5G central unit, and 5G packet core, which run on a separate Azure private MEC instance on Azure Stack Edge.
1. The 5G packet core provides device authentication, an IP address, and connectivity based on a preconfigured profile.
1. Azure Network Function Manager controls both MEC instances.
1. Optimizing the 5G network and keeping traffic confined to Azure private MEC provides the low latency these connection scenarios require.

### Components

This solution uses the following Azure components:

- [Azure Stack Edge](https://azure.microsoft.com/products/azure-stack/edge) is a portfolio of devices that bring compute, storage, and intelligence to the IoT Edge.
- [Azure Network Function Manager](https://azure.microsoft.com/products/azure-network-function-manager) enables the deployment of network functions to the IoT Edge using consistent Azure tools and interfaces.

## Scenario details

5G Standalone networks reliably connect machines to other machines or controllers. 5G-enabled Internet of Things (IoT) devices like robots can communicate and operate autonomously on the factory or warehouse floors.

The 5G Standalone network is deployed as a Non-Public Network (NPN), with all data remaining on premises. The NPN configuration offers security, privacy, and reliability. Azure deploys and manages the network and devices.

### Potential use cases

This solution is ideal for the manufacturing, agriculture, energy, facilities, telecommunications, and robotics industries. Use this approach for scenarios like:

- Picking shipments efficiently in a warehouse.
- Dispersing seeds from an autonomous seed sprayer machines on a farm, based on information from soil sensors.
- Conserving energy in commercial buildings by shutting off lights when no motion is detected in a room.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

* [Nikhil Ravi](https://www.linkedin.com/in/nikhilravi) | Product Management Leader

## Next steps

- [Azure Private MEC](https://azure.microsoft.com/solutions/private-multi-access-edge-compute-mec)
- [Azure Industrial IoT](https://azure.microsoft.com/solutions/industry/manufacturing/iot)
- [Azure Network Function Manager simplifies 5G deployments (Video)](https://azure.microsoft.com/resources/videos/azure-network-function-manager-simplifies-5g-deployments)

## Related resources

- [Connect an on-premises network to Azure](../../reference-architectures/hybrid-networking/index.yml)
- [Condition monitoring for Industrial IoT](./condition-monitoring.yml)
