[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This article describes how to use a private network to upload files to an Azure Storage account.

For typical Azure IoT deployments, the IoT client devices need to communicate directly with the Storage account to upload files. IoT client devices are typically distributed at disparate locations. They aren't part of a private network, so they connect over the public internet. You can't integrate these devices into a private network, so the Storage account requires that you allow incoming internet traffic.

But if you have stricter network segmentation requirements, you can restrict access to the Storage account from within a private network. This solution blocks direct internet traffic to the Storage account so that the Storage account only accepts traffic that goes through the inbound Azure Application Gateway instance. If you implement a [hub-spoke network topology](../../networking/architecture/hub-spoke.yml), Azure Firewall typically must inspect traffic, which provides an extra layer of security.

## Architecture

:::image type="complex" source="./media/azure-iot-file-upload-private-network.svg" alt-text="Diagram that shows the Azure IoT Hub private file upload architecture." border="false" lightbox="./media/azure-iot-file-upload-private-network.svg":::
   The diagram shows a numbered, nine-step workflow for uploading files from IoT client devices to a private Azure Blob Storage account through a hub-spoke network topology. On the far left, outside of any network boundary, an on-premises server icon represents other workloads. Below it, two stacked rectangles represent IoT client devices connected to the public internet. The entire Azure environment is enclosed in a large outer boundary. Four distinct virtual network boundaries are within the Azure environment. In the upper left, the hub virtual network contains two components stacked vertically: an Azure VPN gateway at the top and Azure Firewall below it. The hub virtual network connects via peered virtual networks to both the domain name system (DNS) virtual network on the upper right and the spoke virtual network on the right. In the upper right, the DNS virtual network contains Azure DNS Private Resolver within a resource subnets box. A dotted line that represents Private DNS zones surrounds this box. The spoke virtual network contains a resource subnets box that holds two private endpoint icons stacked vertically. To the right of the spoke virtual network, outside its boundary, Blob Storage connects to the upper private endpoint. Azure Key Vault is below the spoke virtual network boundary and connects to the lower private endpoint. At the bottom of the Azure environment section, the perimeter virtual network contains a resource subnets box with Application Gateway inside it. IoT Hub is at the bottom of the perimeter virtual network, below the resource subnets box. Step 1 labels the default route and peered virtual network connections that flow from the hub virtual network outward to the DNS virtual network, the spoke virtual network, and back through Azure Firewall, establishing the hub-spoke topology. Step 2 labels the resource instance allow list connection that runs horizontally from IoT Hub on the lower left to Blob Storage on the right, which represents the managed identity-based direct connection between IoT Hub and Blob Storage through the Azure backbone. Step 3 labels Application Gateway within the perimeter virtual network. Step 4 labels the arrow from the IoT client device on the left that goes into the perimeter virtual network toward IoT Hub, which represents the request over the public internet. Step 5 labels the arrow from Blob Storage going down to IoT Hub on the right side, which represents how IoT Hub retrieves the user-delegation key from Blob Storage. Step 6 labels IoT Hub within the perimeter virtual network. Step 7 labels the private route arrow that goes from the perimeter virtual network boundary upward toward the hub virtual network. This arrow represents traffic routing through Azure Firewall. Step 8 labels the connection from the spoke virtual network's private endpoint to Blob Storage, which represents the Azure Private Link path that Application Gateway uses to reach Blob Storage. Step 9 labels the arrow from the IoT client device to Application Gateway, which represents the HTTPS file upload request from the device through the public internet to Application Gateway.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/azure-iot-file-upload-private-network.vsdx) of this architecture.*

### Workflow

The following workflow corresponds to the previous diagram:

1. A hub-spoke network topology has a hub virtual network that peers to each resource virtual network, also called a *spoke*. Spoke-to-spoke and virtual network egress traffic goes through Azure Firewall for traffic inspection.

1. An Azure Blob Storage account denies public internet access. It allows access through private endpoints or virtual network rules for the private application path. A [resource instance rule](/azure/storage/common/storage-network-security#grant-access-from-azure-resource-instances) also allows an Azure IoT Hub service that you choose to connect through a managed identity. In this architecture, IoT Hub uses Microsoft Entra ID and Azure role-based access control (Azure RBAC) to request a user-delegation key from Blob Storage.

1. The application gateway uses a custom domain name configured in the domain name system (DNS) and terminates Transport Layer Security (TLS) traffic. The gateway requires a TLS 1.2 or newer connection. Application Gateway resides within a virtual network. This virtual network peers with the virtual network that hosts the Blob Storage account's private endpoint. A forced tunnel through the hub virtual network establishes the connection.

1. The IoT client device that uses the IoT Hub SDK requests a shared access signature (SAS) URI for file uploads to IoT Hub. The IoT client device sends the request through the public internet.

1. IoT Hub handles this request for the device. It connects directly to the Blob Storage account via managed identity authentication, which has *Storage Blob Data Contributor* permissions for user-delegation key requests.

   IoT Hub requests a user-delegation key to the Blob Storage account. A short-lived SAS token grants the device read-write permission on the requested blob in the blob container.

1. IoT Hub sends the public Blob Storage account URI and SAS token to the IoT client device, along with a correlation ID.

1. The IoT client device has logic to replace the public Blob Storage URI with a custom domain, for example a [device twin](/azure/iot-hub/iot-hub-devguide-device-twins). The IoT device uses a standard Blob Storage SDK to upload the file through the custom Blob Storage DNS.

1. Application Gateway receives the HTTPS upload requests from the client device and sends them to the Blob Storage account through Azure Private Link.

1. When the file upload completes, the IoT client device uses the Azure IoT SDK to notify IoT Hub.

   The IoT client device updates the file upload status so that IoT Hub can trigger a file upload notification to back-end services, if the notification is configured. The client device also releases resources associated with the file upload in IoT Hub.

### Components

- [Application Gateway](/azure/well-architected/service-guides/azure-application-gateway) is a platform as a service (PaaS)-managed solution that you can use to build secure, scalable, and highly available front ends. In this architecture, Application Gateway handles the incoming internet HTTPS traffic, applies TLS termination, negotiates TLS with the Blob Storage account, and forwards traffic through a private network to the Blob Storage account. Use the [web application firewall (WAF) v2 SKU](/azure/web-application-firewall/ag/ag-overview) for the public listener and configure the managed OWASP Core Rule Set in the associated WAF policy.

- [Azure Firewall](/azure/well-architected/service-guides/azure-firewall) is a service for network security that provides protection for your Azure Virtual Network resources. In this architecture, Azure Firewall filters and routes traffic between the perimeter network and spoke networks.

- [IoT Hub](/azure/iot-hub/iot-concepts-and-iot-hub) is a PaaS-managed solution that acts as a central message hub for bidirectional communication between an IoT application and the devices that it manages. In this architecture, IoT Hub is the central endpoint that IoT client devices connect to for control and data plane operations.

- [Private Link](/azure/private-link/private-link-overview) is a service that provides private access to services that the Azure platform hosts while keeping your data on the Microsoft network. In this architecture, Private Link provides private communication between Application Gateway and the Blob Storage account.

- [Storage](/azure/storage/common/storage-introduction) is a cloud storage solution that provides durable, highly available, and scalable cloud storage for modern data storage scenarios. It includes object, file, disk, queue, and table storage capabilities. In this architecture, devices use Blob Storage to upload files to the cloud via short-lived SAS tokens that IoT Hub provides through user delegation.

- [Private DNS zones](/azure/dns/private-dns-overview) are a feature that provides reliable, enhanced-security DNS services to manage and resolve domain names in a virtual network without the need for a custom DNS solution. In this architecture, a private DNS zone provides a private DNS entry for Blob Storage so that the Storage blob endpoint translates to its private IP endpoint within the network.

- [Virtual Network](/azure/virtual-network/virtual-networks-overview) is a networking service that helps you create and manage virtual private networks in Azure. This service allows many types of Azure resources, such as Azure virtual machines (VMs), to communicate with each other, the internet, and on-premises networks with enhanced security. This architecture uses Virtual Network to build a private network topology, which avoids internet public endpoints for Azure-based services.

- [Azure Key Vault](/azure/key-vault/general/overview) is a key-management solution that provides secure storage for secrets, keys, and certificates. In this architecture, Key Vault stores the TLS certificate, such as a wildcard or custom-domain certificate, that Application Gateway presents on the custom-domain listener. Key Vault uses a [private endpoint](/azure/key-vault/general/private-link-service) for network access and Azure RBAC for authorization.

## Scenario details

For typical deployments, an Azure IoT client device needs to communicate directly with a Storage account to upload a file. If you disallow internet traffic on the Storage account, you block IoT client devices from uploading files. The IoT Hub file upload functionality acts only as a user delegation for generating a SAS token that has read-write permissions on a blob. The file upload itself doesn't pass through IoT Hub. An IoT client device uses the normal Blob Storage SDK for the actual upload.

In this scenario, communication between IoT Hub and the Storage account continues to pass through the public endpoint. Networking configurations for resource instances in Storage make this exception possible. You can disallow public internet access to the Storage account and allow Azure services and specific instances of resources to connect through the Azure backbone. This network perimeter is paired with a Microsoft Entra ID-based identity perimeter that uses Azure RBAC to restrict data plane access.

This architecture assigns a managed identity to IoT Hub. The managed identity is assigned the *Storage Blob Data Contributor* role to the specified Storage account. With this permission, IoT Hub can request a user-delegation key to construct a short-lived SAS token. The IoT client device receives the SAS token for the file-upload process.

Application Gateway acts as the entry point for requests that go to the private endpoint of the Storage account, which is configured as the only back end. Application Gateway uses a public IP address. You can configure a custom DNS provider to map an *A* record to the public IP address or a *CNAME* record to the Application Gateway DNS name.

If you have internal security requirements to use private endpoints for many Azure PaaS services, you can implement this scenario to provide shorter validation cycles to deploy your IoT solutions in production.

This solution uses IoT Hub and standard device SDKs. It isn't an Azure IoT Edge or Azure IoT Operations pattern. For edge scenarios enabled by Azure Arc, evaluate [Azure IoT Operations](/azure/iot-operations/overview-iot-operations).

### Potential use cases

This architecture can apply to any scenario that uses devices that need to communicate with a Storage account that isn't exposed publicly.

For example, an industrial automation vendor provides managed connected edge controllers and sensors. These sensors need to communicate with the Azure cloud through the public internet, but the vendor's security team requires that you deny the Storage account public internet access. This architecture meets this requirement.

### Alternatives

If you don't require the hub-spoke network topology that uses Azure Firewall traffic inspection, you can implement a simplified networking topology to benefit from this approach. You might use a single virtual network that has distinct subnets to accommodate Application Gateway, Private Link, and the private DNS zone. The Storage account and IoT Hub can use the same configurations as the original architecture.

The benefits of a simplified architecture include reduced complexity and cost. If you don't have specific business or enterprise requirements for a hub-spoke topology, use the simplified architecture to eliminate public internet endpoints from the Storage account. This approach also helps ensure that IoT applications that use the IoT Hub file upload functionality work correctly.

To eliminate the public IP address on Application Gateway, you can expose the front end over [Application Gateway Private Link](/azure/application-gateway/private-link) to peered or consumer virtual networks.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- [Katrien De Graeve](https://www.linkedin.com/in/katriendg/) | Software Engineer
- [Vincent Misson](https://www.linkedin.com/in/vmisson/) | Cloud Solution Architect

Other contributor:

- [Nacim Allouache](https://www.linkedin.com/in/nacim-allouache/) | Cloud Solution Architect

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next step

- [Upload files by using IoT Hub](/azure/iot-hub/iot-hub-devguide-file-upload)

## Related resource

- [Hub-spoke network topology in Azure](../../networking/architecture/hub-spoke.yml)
