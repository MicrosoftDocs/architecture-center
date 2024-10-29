[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This article describes how to restrict access to an Azure Storage account from within a private network.

For typical Azure IoT deployments, the IoT client devices need to communicate directly with the Storage account to upload files. IoT client devices are typically distributed at disparate locations, and they aren't part of a private network, so they connect over the public internet. You can't integrate these devices into a private network, so the Storage account requires that you allow incoming internet traffic.

But for stricter network segmentation requirements, you can restrict access to the Storage account from within a private network. This solution blocks direct internet traffic to the Storage account so that the Storage account only accepts traffic that goes through the inbound Azure Application Gateway. If you implement a [hub-spoke network topology](../../networking/architecture/hub-spoke.yml), Azure Firewall typically must inspect traffic, which provides an extra layer of security.

## Architecture

:::image type="complex" source="./media/iothub-file-upload-private-link.png" alt-text="Diagram that shows an Azure IoT Hub file upload." border="false":::
   Diagram of the Azure IoT Hub file upload feature to a private storage account architecture.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/azure-iot-file-upload-private-network.vsdx) of this architecture.*

### Workflow

1. A hub-spoke network topology has a hub virtual network that peers to each resource virtual network, also called a *spoke*. All traffic goes through Azure Firewall for traffic inspection.

1. The Azure Blob Storage account denies public internet access. It only allows connections from other virtual networks. A [resource instance rule](/azure/storage/common/storage-network-security#grant-access-from-azure-resource-instances) allows a chosen Azure IoT Hub service to connect via a managed identity. The Storage account only supports Azure role-based access control (RBAC) for data plane access.
1. The application gateway has custom Domain Name System (DNS) and terminates Transport Layer Security (TLS) traffic. It resides within a virtual network. This virtual network peers with the virtual network that the Storage account's private link uses. The connection is established through a forced tunnel via the hub virtual network.
1. The IoT client device that uses the Azure IoT Hub SDK requests a shared access signature (SAS) URI for file upload to the IoT Hub. The IoT client device sends the request through the public internet.
1. Azure IoT Hub handles this request for the device. It connects directly to the Storage account via managed identity authentication, which has the permission of `Storage Blob Data Contributor` for user delegation key requests.

   Azure IoT Hub requests a user delegation key to the Storage account. A short-lived SAS token grants the device read-write permission on the requested blob in the blob container.

1. Azure IoT Hub sends the public Storage account URI and SAS token to the IoT client device, along with a correlation ID.
1. The IoT client device has logic to replace the public Storage URI with a custom domain, for example using a [Device Twin](/azure/iot-hub/iot-hub-devguide-device-twins). IoT Devices uses a standard Azure Blob Storage SDK to upload the file through the custom Storage DNS.
1. Azure Application Gateway receives the HTTP POST from the client device and sends it to the Storage account via Private Link.
1. When file upload is finished, the IoT client device uses the Azure IoT SDK to notify Azure IoT Hub.

   The IoT client device updates the file upload status so that IoT Hub can trigger a file upload notification to back-end services (if configured). It also releases resources that are associated with the file upload in the IoT Hub.

### Components

- [Application Gateway](/azure/well-architected/service-guides/azure-application-gateway) is a platform as a service (PaaS)-managed solution that you can use to build highly secure, scalable, and highly available front ends. In this architecture, Application Gateway handles the incoming internet HTTPS traffic, applies TLS termination, negotiates TLS with the Storage account, and forwards traffic through a private network to the Storage account.

- [Azure Firewall](/azure/well-architected/service-guides/azure-firewall) provides protection for your Azure Virtual Network resources. In this architecture, Azure Firewall filters and routes traffic between the perimeter network and spoke networks.
- [Azure IoT Hub](https://azure.microsoft.com/products/iot-hub/) is a PaaS-managed solution that acts as a central message hub for bidirectional communication between an IoT application and the devices that it manages. In this architecture, Azure IoT Hub is the central endpoint that IoT client devices connect to for control and data plane operations.
- [Azure Private Link](https://learn.microsoft.com/azure/private-link/) provides private access to services that are hosted on the Azure platform while keeping your data on the Microsoft network. In this architecture, Azure Private Link provides private communication between Application Gateway and the Storage account.
- [Storage](/azure/well-architected/service-guides/storage-accounts/security) offers a durable, highly available, and massively scalable cloud storage solution. It includes object, file, disk, queue, and table storage capabilities. In this architecture, devices use Storage to upload files to the cloud via short-lived SAS tokens that Azure IoT Hub provides through user delegation.
- [Private DNS zones](https://learn.microsoft.com/azure/dns/private-dns-overview) provide a reliable, secure DNS service to manage and resolve domain names in a virtual network without the need for a custom DNS solution. In this architecture, a private DNS zone provides a private DNS entry for Storage so that the Storage blob endpoint translates to its private IP endpoint within the network.
- [Azure Virtual Network](https://azure.microsoft.com/services/virtual-network/) is the fundamental building block for your private network in Azure. This service enables many types of Azure resources, such as Azure Virtual Machines, to securely communicate with each other, the internet, and on-premises networks. This architecture uses Azure Virtual Network to build a private network topology, which avoids internet public endpoints for Azure-based services.

## Scenario details

In regular deployments, Azure IoT client device needs to communicate directly to the Storage account to upload the file. Disabled internet traffic on the Storage account automatically blocks any client IoT client devices from uploading files. This is because Azure IoT Hub's file upload functionality acts only as a user delegation for generating a SAS token with read-write permission on a blob, where the file upload itself does not pass through Azure IoT Hub. An IoT client device uses the normal Blob Storage SDK for the actual upload.

When implementing this scenario, communication between the Azure IoT Hub and the Storage account still goes through the public endpoint. This exception is possible through Storage networking configuration for resource instances, which allows disabling public internet access to the Storage account while allowing Azure services and specific instances of resources to connect through the Azure backbone. This network perimeter is paired with a Microsoft Entra ID-based identity perimeter that uses Azure RBAC to restrict data plane access.

The Azure IoT Hub needs to be assigned a managed identity, and this managed identity needs to be assigned the role of Storage Blob Data Contributor to the specified Storage account. With this permission, Azure IoT Hub can request a user delegation key to construct a SAS token, which is given to the IoT client device for actual file upload process.

Application Gateway acts as the entry point for requests that go to the private endpoint of the Storage account, which is configured as the only back end. The Application Gateway uses a public IP address that can be mapped to an A record or CNAME at your custom DNS provider.

If you have internal security requirements to use private endpoints for many Azure PaaS services, you can implement this scenario to provide shorter validation cycles to deploy your IoT solutions in production.

### Potential use cases

This architecture can apply to any scenario that uses devices that need to communicate with a Storage account that isn't exposed publicly.

For example, an industrial automation vendor provides managed connected edge controllers and sensors. These sensors need to communicate with the Azure cloud through the public internet, but the vendor's security team requires the Storage account to be denied public internet access. This architecture solves this requirement.

### Alternatives

If you don't require the hub-spoke network topology that has Azure Firewall traffic inspection, you can implement a simplified networking topology to benefit from this approach. You could use a single virtual network that has distinct subnets to accommodate Application Gateway, Private Link, and the private DNS zone. The Storage account and Azure IoT Hub remain configured in the same manner.

The benefits of a simplified architecture include reduced complexity and cost. If you don't have specific business or enterprise requirements for a hub-spoke topology, use the simplified architecture to eliminate public internet endpoints from the Storage account. This approach also helps ensure that IoT applications that use the Azure IoT Hub file upload functionality work correctly.

For a sample that deploys a similar architecture, see [Set up Azure IoT Hub file upload to Storage through a private endpoint](https://github.com/Azure-Samples/azure-edge-extensions-iothub-fileupload-privatelink). This sample deploys a simulated IoT client device and uses device twins to replace the custom domain name for the Storage account.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Katrien De Graeve](https://linkedin.com/in/katriendg/) | Software Engineer
- [Vincent Misson](https://www.linkedin.com/in/vmisson/) | Cloud Solution Architect

Other contributors:

- [Nacim Allouache](https://www.linkedin.com/in/nacim-allouache/) | Cloud Solution Architect

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next step

Learn how to [upload files with IoT Hub](/azure/iot-hub/iot-hub-devguide-file-upload).

## Related resources

- [Hub-spoke network topology in Azure](../../networking/architecture/hub-spoke.yml)
- [Industry-specific Azure IoT reference architectures](../../reference-architectures/iot/industry-iot-hub-page.md)
