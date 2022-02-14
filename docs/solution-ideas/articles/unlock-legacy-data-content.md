[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Use Azure Stack to update and extend your legacy application data with the latest cloud technology such as Azure web services, containers, serverless computing, and microservices architectures. This is a solution to create new applications while integrating and preserving legacy data in mainframe and core business process applications.

## Architecture

![Architecture diagram](../media/unlock-legacy-data.png)
*Download an [SVG](../media/unlock-legacy-data.svg) of this architecture.*

### Data flow

1. User enters data into Azure-based web app.
1. Application commits data to database over virtual network-to-virtual network VPN connection to Azure Stack.
1. Data is processed by applications running on a Kubernetes cluster on Azure Stack.
1. Kubernetes cluster communicates with legacy system on corporate network.

### Components

* [Virtual Network](https://azure.microsoft.com/services/virtual-network): Provision private networks, optionally connect to on-premises datacenters
* [VPN Gateway](https://azure.microsoft.com/services/vpn-gateway): Establish secure, cross-premises connectivity

## Next steps

* [Virtual Network documentation](/azure/virtual-network/virtual-networks-overview)
* [VPN Gateway documentation](/azure/vpn-gateway/vpn-gateway-about-vpngateways)
