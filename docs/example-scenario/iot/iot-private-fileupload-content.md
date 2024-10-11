<!-- Use the aac-browse-header.yml -->

[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

In typical Azure IoT deployments, the client devices need to communicate directly with the Azure Storage account to upload files. So, the Storage account must allow incoming Internet traffic. However, for stricter network segmentation requirements, a common practice involves restricting access to the Storage account from within a private network.
This solution proposes a strategy that blocks direct Internet traffic to the Storage account. Instead, only traffic routed through the inbound Application Gateway is permitted to the Storage account. Additionally, this setup allows for traffic inspection via Azure Firewall, providing an extra layer of security.

## Architecture

:::image type="complex" source="./media/iothub-file-upload-private-link.png" alt-text="Diagram Azure IoT Hub file upload":::
   Diagram of the Azure IoT Hub file upload feature to a private storage account architecture.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/azure-iot-file-upload-private-network.vsdx) of this architecture.*

### Workflow

1. The Blob storage account denies public internet access, and it only allows connections from other virtual networks. A [resource instance rule](/azure/storage/common/storage-network-security#grant-access-from-azure-resource-instances) allows a chosen Azure IoT Hub service to connect, authenticating via a managed identity. Also, the Storage account is configured to only support Azure RBAC for data plane access.
1. The application gateway is configured with custom DNS and terminates transport layer security (TLS) traffic. It resides within a virtual network. This virtual network is granted access or peered with the Virtual Network used by the Storage account's private link.
1. IoT client device using Azure IoT Hub SDK requests a SAS URI for File Upload to the IoT Hub.
1. Azure IoT Hub handles this request for the device. It connects directly to the Azure Storage account with Managed Identity authentication which has been given the permission of `Storage Blob Data Contributor`.

   A short-lived SAS token is generated which grants the device read-write permission on the requested blob in the blob container.

1. Azure IoT Hub sends the public Storage account URI and SAS token to the IoT client device, along with a correlation ID.
1. IoT client device has logic to replace the public Storage URI with a custom domain it's supplied with, for example using a [Device Twin](/azure/iot-hub/iot-hub-devguide-device-twins). IoT Devices uses standard Azure Blob Storage SDK to upload the file through the custom Storage DNS.
1. Azure Application Gateway receives the HTTP POST from the client device and tunnels it through via Private Link to the Storage account.
1. When file upload is finished, IoT client device uses Azure IoT SDK to inform Azure IoT Hub of file upload completion.

   The IoT client device updates the file upload status in order for IoT Hub to trigger a file upload notification to backend services (if configured), and allows for the release of resources associated to the file upload in the IoT Hub.

### Components

- [Azure Application Gateway](/azure/well-architected/service-guides/azure-application-gateway)
- [Azure Firewall](/azure/well-architected/service-guides/azure-firewall)
- [Azure IoT Hub](https://azure.microsoft.com/products/iot-hub/)
- [Azure Private Link](https://learn.microsoft.com/azure/private-link/)
- [Azure Storage](/azure/well-architected/service-guides/storage-accounts/security)
- [Private DNS Zone](https://learn.microsoft.com/azure/dns/private-dns-overview)

## Scenario details

In regular deployments, Azure IoT client device needs to talk directly to the Storage account to upload the file. Disabling Internet traffic on the Storage account would automatically block any client IoT client devices from uploading files. This is because Azure IoT Hub's file upload functionality acts only as a user delegation for generating a SAS token with read-write permission on a blob, where the file upload itself does not pass through Azure IoT Hub. An IoT client device uses the normal Blob Storage SDK for the actual upload.

Customers with stricter networking requirements should make the Blob storage accessible only from a virtual network and inspect any inbound traffic through a firewall or gateway. Often the implementation is in the form of a [Hub-Spoke network topology](/azure/architecture/networking/architecture/hub-spoke).

Communication between the Azure IoT Hub and the Azure Storage account still goes through the public endpoint. This exception is possible through Azure Storage Networking configuration for Resource instances, which allows disabling public Internet access while allowing Azure Services and specific instances of resources to connect through the Azure backbone. This network perimeter is paired with a Microsoft Entra ID-based identity perimeter that uses Azure RBAC to restrict data plane access.

The Azure IoT Hub needs to be assigned a managed identity, and this managed identity needs to be assigned the role of Storage Blob Data Contributor to the specified Storage account.

Azure Application Gateway acts as the entry point for requests forwarded to the private endpoint of the Azure Storage account, which is configured as the only backend. The Application Gateway uses a Public IP address that can be mapped to an A record or CNAME at your custom DNS provider.

By implementing this scenario, customers with internal security requirements to use Private Endpoints for many Azure PaaS services have shorter validation cycles to deploy their IoT solutions in production.

For a sample that deploys a similar architecture, see [Setting up Azure IoT Hub file upload to Azure Storage through Private Endpoint](https://github.com/Azure-Samples/azure-edge-extensions-iothub-fileupload-privatelink). This sample deploys a simulated IoT client device and shows usage of device twins for exchanging the custom domain name for the Storage account. It also contains more extensive documentation on setting up the architecture with Azure Firewall and a hub-spoke network topology.

### Potential use cases

An industrial automation vendor offers managed connected edge controllers and sensors. These sensors need to communicate with the Azure cloud through the public internet, but vendor's security team requires the Azure Storage account to be denied public internet access. This architecture approach solves this requirement.

The same use case can apply to any industry where devices need to communicate with an Azure Storage account that isn't exposed publicly.

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
