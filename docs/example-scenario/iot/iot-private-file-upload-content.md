[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This article describes how to use a private network to upload files to an Azure Storage account.

For typical Azure IoT deployments, the IoT client devices need to communicate directly with the Storage account to upload files. IoT client devices are typically distributed at disparate locations. They aren't part of a private network, so they connect over the public internet. This scenario applies when you can't integrate these devices into a private network through a VPN or Azure ExpressRoute.

If you have stricter network segmentation requirements, you can restrict access to the Storage account from within a private network. This solution blocks direct internet traffic from devices to the Storage account so that device uploads only reach the Storage account through the inbound Azure Application Gateway instance. A resource instance rule separately allows IoT Hub to access the Storage public endpoint. If you implement a [hub-spoke network topology](../../networking/architecture/hub-spoke.yml), Azure Firewall can inspect traffic, which provides an extra layer of security.

## Architecture

:::image type="complex" source="./media/azure-iot-file-upload-private-network.svg" alt-text="Diagram that shows the Azure IoT Hub private file upload architecture." border="false" lightbox="./media/azure-iot-file-upload-private-network.svg":::
   The diagram shows IoT devices on the left and Azure resources on the right. A hub virtual network contains a VPN gateway above Azure Firewall. On-premises workloads connect to the VPN gateway. Peering connects the hub to a DNS network with DNS Private Resolver and private DNS zones, a spoke with private endpoints for Blob Storage and Key Vault, and a perimeter network with Application Gateway. IoT Hub is below and outside the perimeter network. Number 1 marks network routes and 2 marks the resource instance allow list from IoT Hub to Storage. Number 3 marks Application Gateway. Numbers 4 and 6 mark the device connection and IoT Hub, and 5 marks the connection from IoT Hub to Storage. Number 7 marks the device upload to Application Gateway. A private route leads from the gateway through Azure Firewall toward the spoke, with 8 beside the spoke connection. Number 9 marks the device's completion notification to IoT Hub. Blob Storage and Key Vault sit outside the spoke and connect to their private endpoints.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/azure-iot-file-upload-private-network.vsdx) of this architecture.*

### Workflow

The following workflow corresponds to the previous diagram:

1. A hub-spoke network topology has a hub virtual network that peers to each resource virtual network, also called a *spoke*. Spoke-to-spoke and virtual network egress traffic goes through Azure Firewall for traffic inspection.

1. An Azure Blob Storage account denies direct public internet access from devices. It allows access through a private endpoint for the private application path. A [resource instance rule](/azure/storage/common/storage-network-security-resource-instances) also allows an Azure IoT Hub service that you choose to connect through a system-assigned managed identity. In this architecture, IoT Hub uses Microsoft Entra ID and Azure role-based access control (Azure RBAC) to access Blob Storage.

1. The application gateway uses a custom domain name configured in the Domain Name System (DNS) and terminates Transport Layer Security (TLS) traffic. The gateway requires a TLS 1.2 or newer connection. Application Gateway resides within a virtual network that peers with the hub virtual network. Routes send backend traffic through Azure Firewall to the Blob Storage private endpoint.

1. The IoT client device that uses the IoT Hub SDK requests a shared access signature (SAS) URI for file uploads to IoT Hub. The IoT client device sends the request through the public internet.

1. IoT Hub handles this request for the device. It connects directly to the Blob Storage account via system-assigned managed identity authentication, which has *Storage Blob Data Contributor* permissions.

   A short-lived SAS token grants the device read-write permission on the requested blob in the blob container. IoT Hub generates the [device SAS URI using the Storage connection string](/azure/iot-hub/iot-hub-devguide-file-upload#iot-hub-storage-and-authentication-settings), independently of the hub's managed-identity authentication.

1. IoT Hub sends the public Blob Storage account URI and SAS token to the IoT client device, along with a correlation ID.

1. The IoT client device has logic to replace the public Blob Storage URI's hostname with a custom domain configured through a [device twin](/azure/iot-hub/iot-hub-devguide-device-twins). The IoT device uses a standard Blob Storage SDK to upload the file through the custom Blob Storage DNS. The device preserves the container, blob path, and SAS query string.

1. Application Gateway receives the HTTPS upload requests from the client device and sends them to the Blob Storage account through Azure Private Link.

1. When the file upload completes, the IoT client device uses the Azure IoT SDK to notify IoT Hub with the correlation ID, whether the upload succeeds or fails.

   The IoT client device updates the file upload status so that IoT Hub can trigger a file upload notification to back-end services if the notification is configured. The client device also releases resources associated with the file upload.

### Components

- [Application Gateway](/azure/well-architected/service-guides/azure-application-gateway) is a platform as a service (PaaS)-managed solution that you can use to build secure, scalable, and highly available front ends. In this architecture, Application Gateway handles the incoming internet HTTPS traffic, applies TLS termination, negotiates TLS with the Blob Storage account, and forwards traffic through a private network to the Blob Storage account.

- [Azure Firewall](/azure/well-architected/service-guides/azure-firewall) is a service for network security that provides protection for your Azure Virtual Network resources. In this architecture, Azure Firewall filters and routes traffic between the perimeter network and spoke networks.

- [IoT Hub](/azure/iot-hub/iot-concepts-and-iot-hub) is a PaaS-managed solution that acts as a central message hub for bidirectional communication between an IoT application and the devices that it manages. In this architecture, IoT Hub is the central endpoint that IoT client devices connect to for control and data plane operations.

- [Private Link](/azure/private-link/private-link-overview) is a service that provides private access to services that the Azure platform hosts while keeping your data on the Microsoft network. In this architecture, Private Link provides private communication between Application Gateway and the Blob Storage account.

- [Storage](/azure/well-architected/service-guides/azure-blob-storage) is a cloud storage solution that provides durable, highly available, and scalable cloud storage for modern data storage scenarios. It includes object, file, disk, queue, and table storage capabilities. In this architecture, devices use Blob Storage to upload files to the cloud via short-lived SAS tokens that IoT Hub provides.

- A [private DNS zone](/azure/dns/private-dns-overview) is a feature that provides reliable, enhanced-security DNS services to manage and resolve domain names in a virtual network without the need for a custom DNS solution. In this architecture, a private DNS zone provides a private DNS entry for Blob Storage so that the Storage blob endpoint translates to its private IP endpoint within the network.

- [Virtual Network](/azure/virtual-network/virtual-networks-overview) is a networking service that helps you create and manage virtual private networks in Azure. This service allows many types of Azure resources, such as Azure virtual machines (VMs), to communicate with each other, the internet, and on-premises networks with enhanced security. This architecture uses Virtual Network to build a private network topology, which avoids public endpoints for traffic from Application Gateway to Storage and Key Vault.

- [Azure Key Vault](/azure/key-vault/general/overview) is a key-management solution that provides secure storage for secrets, keys, and certificates. In this architecture, Key Vault stores the TLS certificate, such as a wildcard or custom-domain certificate, that Application Gateway presents on the custom-domain listener. Key Vault uses a [private endpoint](/azure/key-vault/general/private-link-service) for network access and Azure RBAC for authorization.

## Scenario details

For typical deployments, an Azure IoT client device needs to communicate directly with a Storage account to upload a file. If you disallow internet traffic on the Storage account, you block IoT client devices from uploading files directly over the internet. The IoT Hub file upload functionality generates a SAS token that has read-write permissions on a blob. The file upload itself doesn't pass through IoT Hub. An IoT client device uses the normal Blob Storage SDK for the actual upload.

In this scenario, communication between IoT Hub and the Storage account continues to pass through the public endpoint. Networking configurations for resource instances in Storage make this exception possible. You can disallow direct public internet access from devices to the Storage account and allow the selected IoT hub to connect through the Azure backbone. This network perimeter is paired with a Microsoft Entra ID-based identity perimeter that uses Azure RBAC to restrict the hub's data plane access.

Application Gateway acts as the entry point for requests that go to the private endpoint of the Storage account, which is configured as the only back end. Application Gateway uses a public IP address. You can configure a custom DNS provider to map an *A* record to the public IP address or a *CNAME* record to the Application Gateway DNS name.

If you have internal security requirements to use private endpoints for many Azure PaaS services, you can implement this scenario to provide shorter validation cycles to deploy your IoT solutions in production.

This solution uses IoT Hub and standard device SDKs. It isn't an Azure IoT Edge or Azure IoT Operations pattern. For edge scenarios enabled by Azure Arc, see [Azure IoT Operations](/azure/iot-operations/overview-iot-operations).

### Potential use cases

This architecture can apply to any scenario that uses devices that need to communicate with a Storage account that isn't exposed publicly to those devices.

For example, an industrial automation vendor provides managed connected edge controllers and sensors. These sensors need to communicate with the Azure cloud through the public internet, but the vendor's security team requires that you deny direct public internet access from devices to the Storage account. This architecture meets this requirement while retaining a separate Storage public-endpoint exception for IoT Hub.

### Alternatives

- If you don't require the hub-spoke network topology that uses Azure Firewall traffic inspection, you can implement a simplified networking topology to benefit from this approach. You might use a single virtual network that has distinct subnets to accommodate Application Gateway and private endpoints, linked to the private DNS zone. The Storage account and IoT Hub can use the same configurations as the original architecture.

  The benefits of a simplified architecture include reduced complexity and cost. If you don't have specific business or enterprise requirements for a hub-spoke topology, use the simplified architecture to block direct public internet access from devices to the Storage account. This approach also helps ensure that IoT applications that use the IoT Hub file upload functionality work correctly.

- If devices have VPN or ExpressRoute connectivity to Azure, they can use [IoT Hub private endpoints](/azure/iot-hub/virtual-network-support#ingress-connectivity-to-iot-hub-using-azure-private-link) and upload directly through a [Storage private endpoint](/azure/storage/common/storage-private-endpoints). With appropriate DNS and routing, this alternative avoids the public Application Gateway listener and device hostname substitution. IoT Hub's Storage connection still requires its public-endpoint exception.

- If private-connected clients still require a gateway, a [private-only Application Gateway v2 deployment](/azure/application-gateway/application-gateway-private-deployment) removes the public frontend IP requirement. [Application Gateway Private Link](/azure/application-gateway/private-link) is a separate option for exposing a gateway through private endpoints in consumer virtual networks. Private-only frontend configurations don't support Application Gateway Private Link. Neither option serves internet-only devices without a private connectivity path.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

- Use the [web application firewall (WAF) v2 SKU](/azure/web-application-firewall/ag/ag-overview) for the public listener and configure the managed OWASP Core Rule Set in the associated WAF policy.

  Configure [WAF request-body limits](/azure/web-application-firewall/ag/application-gateway-waf-request-size-limits) for the device SDK's upload request or block size. Raw blob PUT requests use the request-body limit, not the multipart file-upload limit.

- Storage [resource instance rules and trusted-service exceptions can remain effective even when public network access is disabled](/azure/storage/common/storage-network-security-limitations#general-guidelines-and-limitations).

#### Network configuration

To use a default route through Azure Firewall with Application Gateway, enable [Application Gateway network isolation](/azure/application-gateway/application-gateway-private-deployment#route-table-control) and configure the required subnet delegation.

Use HTTPS application rules in Azure Firewall to inspect traffic to the Blob Storage private endpoint. Application rules automatically perform source network address translation (SNAT) to maintain symmetric return traffic. If you use network rules instead, explicitly configure SNAT for traffic destined to the private endpoint. For more information, see [Inspect traffic destined to a private endpoint with Azure Firewall](/azure/private-link/inspect-traffic-with-azure-firewall).

Configure private DNS to resolve `<account>.blob.core.windows.net` to the private endpoint IP address. Use this Storage hostname for the [backend Host header and TLS server name](/azure/application-gateway/configuration-http-settings), configure an appropriate health probe, and preserve the blob path and SAS query string.

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
