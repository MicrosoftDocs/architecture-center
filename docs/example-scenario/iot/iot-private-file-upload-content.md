[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This article describes how to use a private network to upload files to an Azure Storage account.

For typical Azure IoT deployments, the IoT client devices need to communicate directly with the Storage account to upload files. IoT client devices are typically distributed at disparate locations, and they aren't part of a private network, so they connect over the public internet. You can't integrate these devices into a private network, so the Storage account requires that you allow incoming internet traffic.

But if you have stricter network segmentation requirements, you can restrict access to the Storage account from within a private network. This solution blocks direct internet traffic to the Storage account so that the Storage account only accepts traffic that goes through the inbound Azure Application Gateway instance. If you implement a [hub-spoke network topology](../../networking/architecture/hub-spoke.yml), Azure Firewall typically must inspect traffic, which provides an extra layer of security.

## Architecture

:::image type="content" source="./media/azure-iot-file-upload-private-network.svg" alt-text="Diagram that shows the Azure IoT Hub private file upload architecture." border="false" lightbox="./media/azure-iot-file-upload-private-network.svg":::

*Download a [Visio file](https://arch-center.azureedge.net/azure-iot-file-upload-private-network.vsdx) of this architecture.*

### Workflow

The following workflow corresponds to the preceding diagram.

1. A hub-spoke network topology has a hub virtual network that peers to each resource virtual network, also called a *spoke*. All traffic goes through Azure Firewall for traffic inspection.

1. An Azure Blob Storage account denies public internet access. It only allows connections from other virtual networks. A [resource instance rule](/azure/storage/common/storage-network-security#grant-access-from-azure-resource-instances) allows a chosen Azure IoT Hub service to connect via a managed identity. The Blob Storage account only supports Azure role-based access control (Azure RBAC) for data plane access.
1. The application gateway has custom Domain Name System (DNS) and terminates Transport Layer Security (TLS) traffic. It resides within a virtual network. This virtual network peers with the virtual network that the Blob Storage account's private link uses. A forced tunnel via the hub virtual network establishes the connection.
1. The IoT client device that uses the IoT Hub SDK requests a shared access signature (SAS) URI for file uploads to IoT Hub. The IoT client device sends the request through the public internet.
1. IoT Hub handles this request for the device. It connects directly to the Blob Storage account via managed identity authentication, which has *Storage Blob Data Contributor* permissions for user-delegation key requests.

   IoT Hub requests a user-delegation key to the Blob Storage account. A short-lived SAS token grants the device read-write permission on the requested blob in the blob container.

1. IoT Hub sends the public Blob Storage account URI and SAS token to the IoT client device, along with a correlation ID.
1. The IoT client device has logic to replace the public Blob Storage URI with a custom domain, for example a [device twin](/azure/iot-hub/iot-hub-devguide-device-twins). The IoT device uses a standard Blob Storage SDK to upload the file through the custom Blob Storage DNS.
1. Application Gateway receives the HTTP POST from the client device and sends it to the Blob Storage account via Azure Private Link.
1. When the file upload is finished, the IoT client device uses the Azure IoT SDK to notify IoT Hub.

   The IoT client device updates the file upload status so that IoT Hub can trigger a file upload notification to back-end services, if the notification is configured. The client device also releases resources that are associated with the file upload in IoT Hub.

### Components

- [Application Gateway](https://azure.microsoft.com/products/application-gateway) is a platform as a service (PaaS)-managed solution that you can use to build highly secure, scalable, and highly available front ends. In this architecture, Application Gateway handles the incoming internet HTTPS traffic, applies TLS termination, negotiates TLS with the Blob Storage account, and forwards traffic through a private network to the Blob Storage account.

- [Azure Firewall](https://azure.microsoft.com/products/azure-firewall) provides protection for your Azure Virtual Network resources. In this architecture, Azure Firewall filters and routes traffic between the perimeter network and spoke networks.
- [IoT Hub](https://azure.microsoft.com/products/iot-hub/) is a PaaS-managed solution that acts as a central message hub for bidirectional communication between an IoT application and the devices that it manages. In this architecture, IoT Hub is the central endpoint that IoT client devices connect to for control and data plane operations.
- [Private Link](https://azure.microsoft.com/products/private-link) provides private access to services that are hosted on the Azure platform while keeping your data on the Microsoft network. In this architecture, Private Link provides private communication between Application Gateway and the Blob Storage account.
- [Storage](https://azure.microsoft.com/products/category/storage) offers a durable, highly available, and massively scalable cloud storage solution. It includes object, file, disk, queue, and table storage capabilities. In this architecture, devices use Blob Storage to upload files to the cloud via short-lived SAS tokens that IoT Hub provides through user delegation.
- [Private DNS zones](/azure/dns/private-dns-overview) provide a reliable, enhanced-security DNS service to manage and resolve domain names in a virtual network without the need for a custom DNS solution. In this architecture, a private DNS zone provides a private DNS entry for Blob Storage so that the Storage blob endpoint translates to its private IP endpoint within the network.
- [Virtual Network](https://azure.microsoft.com/products/virtual-network/) is the fundamental building block for your private network in Azure. This service enables many types of Azure resources, such as Azure virtual machines, to communicate with each other, the internet, and on-premises networks with enhanced security. This architecture uses Virtual Network to build a private network topology, which avoids internet public endpoints for Azure-based services.

## Scenario details

For regular deployments, an Azure IoT client device needs to communicate directly to a Storage account to upload a file. Disabling internet traffic on the Storage account blocks any client IoT client devices from uploading files. The IoT Hub file upload functionality acts only as a user delegation for generating a SAS token that has read-write permissions on a blob. The file upload itself doesn't pass through IoT Hub. An IoT client device uses the normal Blob Storage SDK for the actual upload.

In this scenario, communication between IoT Hub and the Storage account still goes through the public endpoint. This exception is possible through Storage networking configurations for resource instances. You can disable public internet access to the Storage account and allow Azure services and specific instances of resources to connect through the Azure backbone. This network perimeter is paired with a Microsoft Entra ID-based identity perimeter that uses Azure RBAC to restrict data plane access.

This architecture assigns a managed identity to IoT Hub. The managed identity is assigned the role of *Storage Blob Data Contributor* to the specified Storage account. With this permission, IoT Hub can request a user-delegation key to construct a short-lived SAS token. The IoT client device receives the SAS token for the file-upload process.

Application Gateway acts as the entry point for requests that go to the private endpoint of the Storage account, which is configured as the only back end. Application Gateway uses a public IP address. A custom DNS provider can be configured to map the public IP address to an *A* record or *CNAME* record.

If you have internal security requirements to use private endpoints for many Azure PaaS services, you can implement this scenario to provide shorter validation cycles to deploy your IoT solutions in production.

### Potential use cases

This architecture can apply to any scenario that uses devices that need to communicate with a Storage account that isn't exposed publicly.

For example, an industrial automation vendor provides managed connected edge controllers and sensors. These sensors need to communicate with the Azure cloud through the public internet, but the vendor's security team requires the Storage account to be denied public internet access. This architecture meets this requirement.

### Alternatives

If you don't require the hub-spoke network topology that has Azure Firewall traffic inspection, you can implement a simplified networking topology to benefit from this approach. You could use a single virtual network that has distinct subnets to accommodate Application Gateway, Private Link, and the private DNS zone. The Storage account and IoT Hub can use the same configurations as the original architecture.

The benefits of a simplified architecture include reduced complexity and cost. If you don't have specific business or enterprise requirements for a hub-spoke topology, use the simplified architecture to eliminate public internet endpoints from the Storage account. This approach also helps ensure that IoT applications that use the IoT Hub file upload functionality work correctly.

For a sample that deploys a similar architecture, see [Set up IoT Hub file upload to Storage through a private endpoint](https://github.com/Azure-Samples/azure-edge-extensions-iothub-fileupload-privatelink). This sample deploys a simulated IoT client device and uses device twins to replace the custom domain name for the Storage account.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Katrien De Graeve](https://www.linkedin.com/in/katriendg/) | Software Engineer
- [Vincent Misson](https://www.linkedin.com/in/vmisson/) | Cloud Solution Architect

Other contributor:

- [Nacim Allouache](https://www.linkedin.com/in/nacim-allouache/) | Cloud Solution Architect

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next step

Learn how to [upload files with IoT Hub](/azure/iot-hub/iot-hub-devguide-file-upload).

## Related resources

- [Hub-spoke network topology in Azure](../../networking/architecture/hub-spoke.yml)
