<!-- Use the aac-browse-header.yml -->

[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

In typical Azure IoT deployments, the IoT client devices need to communicate directly with the Azure Storage account to upload files. Because IoT client devices are typically distributed at disparate locations and not not part of a private network, they connect over public Internet. As these devices cannot be integrated into a private network, the Storage account requires allowing incoming Internet traffic. However, for stricter network segmentation requirements, a common practice involves restricting access to the Storage account from within a private network.
This solution proposes a strategy that blocks direct Internet traffic to the Storage account. Instead, only traffic routed through the inbound Application Gateway is permitted to the Storage account. For customers implementing a [Hub-Spoke network topology](/azure/architecture/networking/architecture/hub-spoke), traffic is typically forced to go through Azure Firewall for traffic inspection, providing an extra layer of security.

## Architecture

:::image type="complex" source="./media/iothub-file-upload-private-link.png" alt-text="Diagram Azure IoT Hub file upload":::
   Diagram of the Azure IoT Hub file upload feature to a private storage account architecture.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/azure-iot-file-upload-private-network.vsdx) of this architecture.*

### Workflow

1. A Hub-Spoke network topology is utilized where a hub virtual network is peered to each resource virtual network (called a spoke), and all traffic is routed through Azure Firewall for traffic inspection.
1. The Blob storage account denies public Internet access, and it only allows connections from other virtual networks. A [resource instance rule](/azure/storage/common/storage-network-security#grant-access-from-azure-resource-instances) allows a chosen Azure IoT Hub service to connect, authenticating via a managed identity. Also, the Storage account is configured to only support Azure RBAC for data plane access.
1. The application gateway is configured with custom DNS and terminates transport layer security (TLS) traffic. It resides within a virtual network. This virtual network is peered with the Virtual Network used by the Storage account's private link through a forced tunnel via the Hub virtual network.
1. IoT client device using Azure IoT Hub SDK requests a SAS URI for File Upload to the IoT Hub, through public Internet.
1. Azure IoT Hub handles this request for the device. It connects directly to the Azure Storage account with Managed Identity authentication which has been given the permission of `Storage Blob Data Contributor` for user delegation key requests.

   Azure IoT Hub requests a user delegation key to the Storage account. A short-lived SAS token is constructed which grants the device read-write permission on the requested blob in the blob container.

1. Azure IoT Hub sends the public Storage account URI and SAS token to the IoT client device, along with a correlation ID.
1. IoT client device has logic to replace the public Storage URI with a custom domain it's supplied with, for example using a [Device Twin](/azure/iot-hub/iot-hub-devguide-device-twins). IoT Devices uses standard Azure Blob Storage SDK to upload the file through the custom Storage DNS.
1. Azure Application Gateway receives the HTTP POST from the client device and tunnels it through via Private Link to the Storage account.
1. When file upload is finished, IoT client device uses Azure IoT SDK to inform Azure IoT Hub of file upload completion.

   The IoT client device updates the file upload status in order for IoT Hub to trigger a file upload notification to backend services (if configured), and allows for the release of resources associated to the file upload in the IoT Hub.

### Components

- [Azure Application Gateway](/azure/well-architected/service-guides/azure-application-gateway) is a PaaS managed service, hosted in the cloud, to build highly secure, scalable, highly available front ends. In this architecture, Azure Application Gateway handles the incoming Internet HTTPS traffic, applies TLS termination, negotiates TLS with the Storage account, and forwards traffic through a private network to the Storage account.
- [Azure Firewall](/azure/well-architected/service-guides/azure-firewall) provides protection for your Azure Virtual Network resources. In this architecture, Azure Firewall filters and routes traffic between the DMZ and spoke networks.
- [Azure IoT Hub](https://azure.microsoft.com/products/iot-hub/) is a PaaS managed service, hosted in the cloud, that acts as a central message hub for bidirectional communication between an IoT application and the devices it manages. In this architecture, Azure IoT Hub is the central endpoint IoT client devices connect to for control and data plane operations.
- [Azure Private Link](https://learn.microsoft.com/azure/private-link/) enables private access to services that are hosted on the Azure platform while keeping your data on the Microsoft network. In this architecture, Azure Private Link is used to enable private communication between Application Gateway and the Storage account.
- [Azure Storage](/azure/well-architected/service-guides/storage-accounts/security) offers a durable, highly available, and massively scalable cloud storage solution. It includes object, file, disk, queue, and table storage capabilities. In this architecture, Azure Storage enables devices to upload files to the cloud by using short-lived SAS tokens provided through user-delegation by Azure IoT Hub.
- [Private DNS Zone](https://learn.microsoft.com/azure/dns/private-dns-overview) provides a reliable, secure DNS service to manage and resolve domain names in a virtual network without the need to add a custom DNS solution. In this architecture, Private DNS Zone is used to create a private DNS entry for Azure Storage so that the Storage blob endpoint translates to its private IP endpoint within the network.
- [Azure Virtual Network](https://azure.microsoft.com/services/virtual-network/) is the fundamental building block for your private network in Azure. This service enables many types of Azure resources, such as Azure Virtual Machines, to securely communicate with each other, the Internet, and on-premises networks. In this architecture, Azure Virtual Network is used to build a private network topology preventing Internet public endpoints for Azure based services where supported.

## Scenario details

In regular deployments, Azure IoT client device needs to talk directly to the Storage account to upload the file. Disabling Internet traffic on the Storage account would automatically block any client IoT client devices from uploading files. This is because Azure IoT Hub's file upload functionality acts only as a user delegation for generating a SAS token with read-write permission on a blob, where the file upload itself does not pass through Azure IoT Hub. An IoT client device uses the normal Blob Storage SDK for the actual upload.

When implementing this scenario, communication between the Azure IoT Hub and the Azure Storage account still goes through the public endpoint. This exception is possible through Azure Storage Networking configuration for Resource instances, which allows disabling public Internet access to the Storage account while allowing Azure Services and specific instances of resources to connect through the Azure backbone. This network perimeter is paired with a Microsoft Entra ID-based identity perimeter that uses Azure RBAC to restrict data plane access.

The Azure IoT Hub needs to be assigned a managed identity, and this managed identity needs to be assigned the role of Storage Blob Data Contributor to the specified Storage account. With this permission, Azure IoT Hub is capable of requesting a user delegation key to construct a SAS token which is given to the IoT client device for actual file upload process.

Azure Application Gateway acts as the entry point for requests forwarded to the private endpoint of the Azure Storage account, which is configured as the only backend. The Application Gateway uses a Public IP address that can be mapped to an A record or CNAME at your custom DNS provider.

By implementing this scenario, customers with internal security requirements to use Private Endpoints for many Azure PaaS services have shorter validation cycles to deploy their IoT solutions in production.

### Potential use cases

An industrial automation vendor offers managed connected edge controllers and sensors. These sensors need to communicate with the Azure cloud through the public Internet, but vendor's security team requires the Azure Storage account to be denied public Internet access. This architecture approach solves this requirement.

The same use case can apply to any industry where devices need to communicate with an Azure Storage account that isn't exposed publicly.

### Alternatives

Customers who don't require the Hub-Spoke network topology with traffic inspection through Azure Firewall can still benefit from this approach by implementing a simplified networking topology. In this scenario, a single virtual network with distinct subnets to accommodate Azure Application Gateway, Private Link, and Private DNS Zone would suffice. The Storage account would remain configured in the same manner, as would Azure IoT Hub.

The benefit of a simplified architecture includes reduced complexity and cost. When there are no specific business or enterprise requirements for Hub-Spoke topology, the simplified architecture allows for eliminating public Internet endpoints from the Storage account while ensuring that IoT applications using Azure IoT Hub's file upload functionality work correctly.

For a sample that deploys a similar architecture, see [Setting up Azure IoT Hub file upload to Azure Storage through Private Endpoint](https://github.com/Azure-Samples/azure-edge-extensions-iothub-fileupload-privatelink). This sample deploys a simulated IoT client device and shows usage of device twins for exchanging the custom domain name for the Storage account.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Katrien De Graeve](https://linkedin.com/in/katriendg/) | "Software Engineer"
- [Vincent Misson](https://www.linkedin.com/in/vmisson/) | "Cloud Solution Architect"

Other contributors:

- [Nacim Allouache](https://www.linkedin.com/in/nacim-allouache/) | "Cloud Solution Architect"

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

Learn how to [Upload files with IoT Hub](/azure/iot-hub/iot-hub-devguide-file-upload).

## Related resources

- [Hub-spoke network topology in Azure](/azure/architecture/networking/architecture/hub-spoke)
- [Industry specific Azure IoT reference architectures](/azure/architecture/reference-architectures/iot/industry-iot-hub-page)
