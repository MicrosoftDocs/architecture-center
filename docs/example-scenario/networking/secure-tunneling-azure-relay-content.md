Secure Tunneling with Azure Relay enables users to establish secure, bidirectional TCP connections to edge devices, without making significant changes to the firewall or network configuration on the edge. This example scenario shows how to implement secure tunneling with Azure Relay using a simulated device.

## Architecture

:::image type="content" source="./media/secure-tunneling-azure-relay.svg" alt-text="Architecture diagram that shows the connection flow using an orchestrator to create a relay connection to an IoT Device and a command flow." border="false" lightbox="./media/secure-tunneling-azure-relay.svg":::

Download a [Visio file](https://arch-center.azureedge.net/iot-secure-tunneling.vsdx) of this architecture.

### Workflow

The following workflow describes how an Azure Function orchestrator can be used to create a connection through Azure Relay to a device in a private network:

1. The user triggers an Azure Function that acts as an orchestrator to initiate a connection with a device specified in the request payload.
2. The orchestrator invokes a [direct method](/azure/iot-hub/iot-hub-devguide-direct-methods) on a device via the IoT Hub. Direct methods are a means to issue synchronous, request-response calls to devices connected to IoT hub.
3. The [device receives the direct method](/azure/iot-hub/iot-hub-devguide-direct-methods#method-lifecycle). It's important to understand that direct methods don't require the device to have any ports exposed.
4. The target device opens a connection to Azure Relay via the [Azure Relay Bridge](https://github.com/Azure/azure-relay-bridge) that is running on the device and sends a response indicating success. The device is now listening to an Azure Relay Hybrid Connection and forwards commands sent to Azure Relay to the device.
5. After receiving the success response, the orchestrator provisions and/or starts an ACI instance with an image that contains and runs [Azure Relay Bridge (azbridge)](https://github.com/Azure/azure-relay-bridge).
6. `azbridge` uses a local forwarder to listen on a configured IP address and port on the container instance and forward all incoming TCP connections to a remote forwarder through Azure Relay.

The following workflow describes how a user can access a control plane on a remote device through the established relay connection:

1. The user issues a command to the fully qualified domain name (FQDN) of a running Azure Container Instance.
2. The local forwarder forwards the connection to Azure Relay.
3. The connection is forwarded to the device via the listener configured in Azure Relay.

### Components

- [Azure Relay](/azure/azure-relay/relay-what-is-it) enables you to securely expose services that run in your corporate network to the public cloud without opening a port on your firewall, or intrusive changes to your corporate network infrastructure.
- [Azure IoT Hub](/azure/iot-hub/iot-concepts-and-iot-hub) acts as a central message hub for communication between an IoT application and its attached devices.
- [Azure Container Registry](/azure/container-registry/container-registry-intro) allows you to build, store, and manage container images and artifacts in a private registry for all types of container deployments.
- [Azure Container Instance](/azure/container-instances/container-instances-overview) offers the fastest and simplest way to run a container in Azure.
- [Azure Functions](https://azure.microsoft.com/services/sql-database) is a serverless solution that allows you to write less code, maintain less infrastructure, and save on costs in Azure.

### Alternatives

- You can use a custom WebSocket bidirectional connection from cloud to edge devices. However, a custom WebSocket bidirectional connection may require more overhead and an "always on" connection.
- [Azure Container Apps](/azure/container-apps/overview) could be used in place of Azure Container Instance to provide services such as [authentication and authorization](/azure/container-apps/authentication) that would otherwise have to be implemented. You have to understand the cost implications of using Azure Container Apps vs. Azure Container Instance.

## Scenario details

When devices are installed at remote locations and protected by firewalls, the users who need to access them for troubleshooting or other operational tasks often need to be present on-site or connected to the same local network as the device.

Secure Tunneling enables users to establish secure, bidirectional connections to edge devices, without making significant changes to the firewall or network configuration on the edge.

### Potential use cases

- Remotely accessing Sensor Devices in Hospitals
  - A technician at a medical device company needs to securely access their sensor devices on demand, located hundreds of miles away behind a hospital’s firewall to troubleshoot and resolve an issue. Instead of having the technician travel to the hospital to respond to the incident, increasing resolution time and operational costs
- Smart building
  - System integrators in smart building scenario need to securely access the local web servers built in the remote devices over public internet to configure the device settings improving their operational efficiencies.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

- This example workload doesn't address authentication and authorization to the Azure Function orchestrator or to the Container Instance. You need to address this in your production implementation.
- For Azure Container Register, refer to the [Azure security baseline for Container Registry](/security/benchmark/azure/baselines/container-registry-security-baseline).
- Azure Relay is designed to be security conscious with the possibility of introducing private endpoints and an IP firewall. The sample example is a minimal architecture but can be extended to use the Azure Relay service recommendations. For more information, see [Network security for Azure Relay](/azure/azure-relay/network-security?source=recommendations).

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

- The Secure Tunneling with Azure environment is ephemeral. You can easily deploy the environment with the required resources for the event, then tear it down as easily.
- To estimate the cost of implementing this solution, use the [Azure Pricing Calculator](https://azure.com/e/bb4e865667354736a27887f0695a273e).

## Deploy this scenario

There's a sample deployment with a simulated device of the Secure Tunneling with Azure Relay on [GitHub](https://github.com/Azure-Samples/secure-tunneling-azure-relay). This sample enables communication between the user and device using HTTP but any protocol that sits above the TCP stack, such as SSH or RDP, can be supported.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Ola Sowemimo](https://www.linkedin.com/in/ola-sowemimo-54776361/) | Senior Software Engineer

Other contributors:

- [Lila Molyva](https://www.linkedin.com/in/lila-molyva-172863112/) | Senior Software Engineer

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

* [Explore the Azure Relay Bridge CLI tool](/azure/azure-relay/relay-what-is-it)
* [Explore Azure IoT Hub deeper and other Messaging Services as a connection request option](/azure/iot-hub/iot-concepts-and-iot-hub)
