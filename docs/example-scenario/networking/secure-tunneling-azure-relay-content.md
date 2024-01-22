You can use secure tunneling with Azure Relay to establish enhanced-security bidirectional TCP connections to edge devices without making significant changes to your firewall or to network configuration on the edge. This article shows you how.

## Architecture

:::image type="content" source="./media/secure-tunneling-azure-relay.png" alt-text="Architecture diagram that demonstrates how to use secure tunneling with Azure Relay." border="false" lightbox="./media/secure-tunneling-azure-relay.png":::

*Download a [PowerPoint file](https://arch-center.azureedge.net/secure-tunneling-azure-relay.pptx) of this architecture.*

### Workflow

The following workflow describes how you can use an Azure Functions orchestrator to create a connection through Azure Relay to a device in a private network:

1. A user triggers a function app that acts as an orchestrator to initiate a connection with a device that's specified in the request payload.
2. The orchestrator invokes a [direct method](/azure/iot-hub/iot-hub-devguide-direct-methods) on a device via an IoT hub. You can use direct methods to issue synchronous request/response calls to devices that are connected to Azure IoT Hub.
3. The [device receives the direct method](/azure/iot-hub/iot-hub-devguide-direct-methods#method-lifecycle). *Note that direct methods don't require the device to expose any ports.*
4. The device opens a connection to Azure Relay via an [Azure Relay bridge](https://github.com/Azure/azure-relay-bridge) that's running on the device and sends a response to indicate a successful connection. The device is now listening to an Azure Relay hybrid connection that forwards commands sent to Azure Relay to the device.
5. After the orchestrator receives the *success* response, it provisions and/or starts an Azure Container Instances instance with an image that contains and runs [Azure Relay Bridge (azbridge)](https://github.com/Azure/azure-relay-bridge).
6. `azbridge` uses a local forwarder to listen on a configured IP address and port on the container instance and forward all incoming TCP connections to a remote forwarder via Azure Relay.

The following workflow describes how a user can access a control plane on a remote device by using the established relay connection:

1. The user issues a command to the FQDN of a running Azure container instance.
2. The local forwarder forwards the connection to Azure Relay.
3. The connection is forwarded to the device via the listener that's configured in Azure Relay.

### Components

- [Azure Relay](/azure/azure-relay/relay-what-is-it) enables you to expose services that run in your corporate network to the public cloud via an enhanced-security connection. You don't need to open a port on your firewall or make intrusive changes to your corporate network infrastructure.
- [IoT Hub](https://azure.microsoft.com/products/iot-hub/) serves as a central message hub for communication between an IoT application and its attached devices.
- [Azure Container Registry](https://azure.microsoft.com/products/container-registry/) enables you to build, store, and manage container images and artifacts in a private registry for all types of container deployments.
- [Container Instances](https://azure.microsoft.com/products/container-instances/) provides a fast and easy way to run a container on Azure.
- [Azure Functions](https://azure.microsoft.com/products/functions/) is a serverless solution that enables you to write less code, maintain less infrastructure, and save money.

### Alternatives

- You can use a custom WebSocket bidirectional connection from the cloud to edge devices. However, this type of connection might require more overhead and an always-on connection.
- You can use [Azure Container Apps](/azure/container-apps/overview) instead of Container Instances to provide services like [authentication and authorization](/azure/container-apps/authentication) that you would otherwise need to implement. Before you make your choice, be sure to understand the cost implications of using Container Apps rather than Container Instances.

## Scenario details

When devices are installed at remote locations and protected by firewalls, users who need to access them for troubleshooting or other operational tasks often need to be present onsite or connected to the same local network as the device.

You can use secure tunneling to establish enhanced-security bidirectional connections to edge devices without making significant changes to the firewall or to network configuration on the edge.

### Potential use cases

- **Remotely accessing sensor devices in hospitals.** A technician at a medical device company needs to access sensor devices on demand to troubleshoot and resolve problems. The devices are located hundreds of miles away behind a hospital's firewall. The technician can access the devices remotely, via an enhanced security connection, reducing resolution time and operational costs.
- **Smart buildings.** System integrators for a smart building need to access the local web servers on remote devices over the public internet to configure device settings to improve operational efficiency. The connection needs to be highly secure. 

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

- This example workload doesn't address authentication or authorization for the Azure Functions orchestrator or for the container instance. You need to address these concerns in your production implementation.
- For information about security in Container Registry, see the [Azure security baseline for Container Registry](/security/benchmark/azure/baselines/container-registry-security-baseline).
- Azure Relay is designed to be an enhanced-security service. This example provides a minimal architecture, but you can extend it by implementing Azure Relay security recommendations, like private endpoints and an IP firewall. For more information, see [Network security for Azure Relay](/azure/azure-relay/network-security?source=recommendations).

### Cost optimization

Cost optimization is about reducing unnecessary expenses and improving operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

- Secure tunneling in Azure is ephemeral. You can easily deploy your environment with the required resources. You can remove the solution just as easily.
- To estimate the cost of implementing this solution, use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator/).

## Deploy this scenario

For a sample that deploys this architecture with a simulated device, see [Secure Tunneling with Azure Relay](https://github.com/Azure-Samples/secure-tunneling-azure-relay). The sample enables communication between users and the device via HTTP, but it can support any protocol that's located above the TCP stack, like SSH or RDP.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Ola Sowemimo](https://www.linkedin.com/in/ola-sowemimo-54776361/) | Senior Software Engineer

Other contributors:

- [Mick Alberts](https://www.linkedin.com/in/mick-alberts-a24a1414/) | Technical Writer
- [Lila Molyva](https://www.linkedin.com/in/lila-molyva-172863112/) | Senior Software Engineer

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [What is Azure Relay?](/azure/azure-relay/relay-what-is-it)
- [IoT concepts and Azure IoT Hub](/azure/iot-hub/iot-concepts-and-iot-hub)
- [Azure Container Registry](/azure/container-registry/container-registry-intro)
- [Azure Container Instances](/azure/container-instances/container-instances-overview)
- [Azure Functions](/azure/azure-functions/functions-overview)

## Related resources

- [Security design principles](/azure/well-architected/security/security-principles)
- [Choose an IoT solution on Azure](../../example-scenario/iot/iot-central-iot-hub-cheat-sheet.yml)
- [IoT conceptual overview](../../example-scenario/iot/introduction-to-solutions.yml)