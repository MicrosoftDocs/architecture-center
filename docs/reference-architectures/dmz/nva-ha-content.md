

This article shows several options for how to deploy a set of network virtual appliances (NVAs) for high availability in Azure. An NVA is typically used to control the flow of traffic between network segments classified with different security levels, for example in a De-Militarized Zone (DMZ) Virtual Network where virtual machines need to communicate with other systems through the public Internet. To learn about implementing a DMZ in Azure, see [Microsoft cloud services and network security][cloud-security].

There are a number of design patterns where NVAs are used to inspect traffic between different security zones, for example:

- To inspect egress traffic from virtual machines to the Internet and prevent data exfiltration
- To inspect ingress traffic from the Internet to virtual machines and prevent malicious attacks
- To filter traffic between virtual machines in Azure, to prevent lateral moves of compromised systems
- To filter traffic between on-premises systems and Azure virtual machines, if they are considered to belong to different security levels (for example if Azure hosts the DMZ, and onprem the internal applications).

**Prerequisites:** This article assumes a basic understanding of Azure networking, [Azure load balancers][lb-overview], and [user-defined routes][udr-overview] (UDRs).

The first question to be answered is why High Availability for Network Virtual Appliances is required. The reason is because these devices control the communication between network segments, so if they are not available, network traffic cannot flow and applications will stop working. Scheduled and unscheduled outages can and will occasionally bring down NVA instances (as any other virtual machine in Azure or any other cloud), even if those NVAs are configured with Premium Managed Disks to provide single-instance SLA in Azure. Hence, highly available applications will require at least a second NVA that can ensure connectivity.

## HA architectures overview

The following architectures describe the resources and configuration necessary for highly available NVAs:

| Solution | Benefits | Considerations |
| --- | --- | --- | --- |
| [Load Balancer][load-balancer] | Supports scale out NVAs. Best failover time | The NVA needs to provide a port for the health probes, especially for active/standby deployments. Doesn't guarantee symmetric flows for flows to/from Internet |
| [Changing PIP/UDR][pip-udr] | No special feature required by the NVA. Guarantees symmetric traffic | Only for active/passive designs. Convergence time of 1-2 minutes |

## Load Balancer Standard and HA ports

You can use an Azure Standard Load Balancer with HA ports for applications that require load balancing of large numbers of ports. A single load-balancing rule replaces multiple individual load-balancing rules, one for each port.

![[HAPortsArch]][HAPortsArch]

### Deploy the HA Ports architecture

Support for HA Ports and deployment options will vary by NVA partner vendor. Refer to the [Load Balancer Standard & HA ports](/azure/load-balancer/load-balancer-ha-ports-overview) documentation and specific NVA documentation for support, limitations, and deployment details.

## Ingress with layer 7 NVAs

The following figure shows a high availability architecture that implements an ingress DMZ behind an internet-facing load balancer. This architecture is designed to provide connectivity to Azure workloads for layer 7 traffic, such as HTTP or HTTPS:

![[1]][1]

The benefit of this architecture is that all NVAs are active, and if one fails the load balancer directs network traffic to the other NVA. Both NVAs route traffic to the internal load balancer so as long as one NVA is active, traffic continues to flow. The NVAs are required to terminate SSL traffic intended for the web tier VMs. These NVAs cannot be extended to handle on-premises traffic because on-premises traffic requires another dedicated set of NVAs with their own network routes.

### Deploy the Layer 7 Ingress architecture

#### [Azure CLI](#tab/cli)

Use the following command to create a resource group for the deployment. Click the **Try it** button to use an embedded shell.

```azurecli-interactive
az group create --name ha-nva-l7i --location eastus
```

Run the following command to deploy the Layer 7 Ingress example architecture.

```azurecli-interactive
az deployment group create --resource-group ha-nva-l7i \
    --template-uri https://raw.githubusercontent.com/mspnp/samples/master/solutions/ha-nva/azuredeploy.json \
    --parameters deployIngressAppGatewayWebLoadBalancer=true deployEgressLoadBalancerNva=false
```

#### [PowerShell](#tab/powershell)

Use the following command to create a resource group for the deployment. Click the **Try it** button to use an embedded shell.

```azurepowershell-interactive
New-AzResourceGroup -Name ha-nva-l7i -Location eastus
```

Run the following command to deploy the Layer 7 Ingress example architecture.

```azurepowershell-interactive
New-AzResourceGroupDeployment -ResourceGroupName ha-nva-l7i `
    -TemplateUri https://raw.githubusercontent.com/mspnp/samples/master/solutions/ha-nva/azuredeploy.json `
    -deployIngressAppGatewayWebLoadBalancer $true -deployEgressLoadBalancerNva $false
```

#### [Azure portal](#tab/portal)

Use the following button to deploy the reference using the Azure portal.

[![Deploy to Azure](../../_images/deploy-to-azure.svg)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fmspnp%2Fsamples%2Fmaster%2Fsolutions%2Fha-nva%2Fazuredeploy.json)

To deploy the **ingress-only** configuration, set the values of the following parameters:

```plaintext
deployIngressAppGatewayWebLoadBalancer=true
deployEgressLoadBalancerNva=false
```

---

For detailed information and additional deployment options, see the Azure Resource Manager templates (ARM templates) used to deploy this solution.

> [!div class="nextstepaction"]
> [Ingress/Egress with layer 7 NVAs ARM Template][ha-nva-l7-sample]

## Egress with layer 7 NVAs

The previous architecture can be expanded to provide an egress DMZ for requests originating in the Azure workload. The following architecture is designed to provide high availability of the NVAs in the DMZ for layer 7 traffic, such as HTTP or HTTPS:

![[2]][2]

In this architecture, all traffic originating in Azure is directed to an internal load balancer via OS proxy configuration. The load balancer distributes outgoing requests between a set of NVAs. These NVAs direct traffic to the Internet using their individual public IP addresses.

### Deploy the Layer 7 Egress architecture

#### [Azure CLI](#tab/cli)

Use the following command to create a resource group for the deployment. Click the **Try it** button to use an embedded shell.

```azurecli-interactive
az group create --name ha-nva-l7e --location eastus
```

Run the following command to deploy the Layer 7 Egress example architecture.

```azurecli-interactive
az deployment group create --resource-group ha-nva-l7e \
    --template-uri https://raw.githubusercontent.com/mspnp/samples/master/solutions/ha-nva/azuredeploy.json \
    --parameters deployIngressAppGatewayWebLoadBalancer=false deployEgressLoadBalancerNva=true
```

#### [PowerShell](#tab/powershell)

Use the following command to create a resource group for the deployment. Click the **Try it** button to use an embedded shell.

```azurepowershell-interactive
New-AzResourceGroup -Name ha-nva-l7e -Location eastus
```

Run the following command to deploy the Layer 7 Egress example architecture.

```azurepowershell-interactive
New-AzResourceGroupDeployment -ResourceGroupName ha-nva-l7e `
    -TemplateUri https://raw.githubusercontent.com/mspnp/samples/master/solutions/ha-nva/azuredeploy.json `
    -deployIngressAppGatewayWebLoadBalancer $false -deployEgressLoadBalancerNva $true
```

#### [Azure portal](#tab/portal)

Use the following button to deploy the reference using the Azure portal.

[![Deploy to Azure](../../_images/deploy-to-azure.svg)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fmspnp%2Fsamples%2Fmaster%2Fsolutions%2Fha-nva/layer-7-egress%2Fazuredeploy.json)

To deploy the **egress-only** configuration, set the values of the following parameters:

```plaintext
deployIngressAppGatewayWebLoadBalancer=false
deployEgressLoadBalancerNva=true
```

---

For detailed information and additional deployment options, see the Azure Resource Manager templates (ARM templates) used to deploy this solution.

> [!div class="nextstepaction"]
> [Ingress/Egress with layer 7 NVAs ARM Template][ha-nva-l7-sample]

## Ingress/Egress with layer 7 NVAs

In the two previous architectures, there was a separate DMZ for ingress and egress. The following architecture demonstrates how to create a DMZ that can be used for both ingress and egress for layer 7 traffic, such as HTTP or HTTPS:

![[3]][3]

In this architecture, the NVAs process incoming requests from the application gateway. The NVAs also process outgoing requests from the workload VMs in the back-end pool of the load balancer. Because incoming traffic is routed with an application gateway and outgoing traffic is routed with a load balancer, the NVAs are responsible for maintaining session affinity. That is, the application gateway maintains a mapping of inbound and outbound requests so it can forward the correct response to the original requestor. However, the internal load balancer does not have access to the application gateway mappings, and uses its own logic to send responses to the NVAs. It's possible the load balancer could send a response to an NVA that did not initially receive the request from the application gateway. In this case, the NVAs must communicate and transfer the response between them so the correct NVA can forward the response to the application gateway.

> [!NOTE]
> You can also solve the asymmetric routing issue by ensuring the NVAs perform inbound source network address translation (SNAT). This would replace the original source IP of the requestor to one of the IP addresses of the NVA used on the inbound flow. This ensures that you can use multiple NVAs at a time, while preserving the route symmetry.

### Deploy the Layer 7 Ingress/Egress architecture

#### [Azure CLI](#tab/cli)

Use the following command to create a resource group for the deployment. Click the **Try it** button to use an embedded shell.

```azurecli-interactive
az group create --name ha-nva-l7ie --location eastus
```

Run the following command to deploy the Layer 7 Ingress/Egress example architecture.

```azurecli-interactive
az deployment group create --resource-group ha-nva-l7ie \
    --template-uri https://raw.githubusercontent.com/mspnp/samples/master/solutions/ha-nva/azuredeploy.json
```

#### [PowerShell](#tab/powershell)

Use the following command to create a resource group for the deployment. Click the **Try it** button to use an embedded shell.

```azurepowershell-interactive
New-AzResourceGroup -Name ha-nva-l7ie -Location eastus
```

Run the following command to deploy the Layer 7 Ingress/Egress example architecture.

```azurepowershell-interactive
New-AzResourceGroupDeployment -ResourceGroupName ha-nva-l7ie `
    -TemplateUri https://raw.githubusercontent.com/mspnp/samples/master/solutions/ha-nva/azuredeploy.json
```

#### [Azure portal](#tab/portal)

Use the following button to deploy the reference using the Azure portal.

[![Deploy to Azure](../../_images/deploy-to-azure.svg)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fmspnp%2Fsamples%2Fmaster%2Fsolutions%2Fha-nva/layer-7-ingress-egress%2Fazuredeploy.json)

To deploy the **ingress-egress** configuration, set the values of the following parameters:

```plaintext
deployIngressAppGatewayWebLoadBalancer=true
deployEgressLoadBalancerNva=true
```

---

For detailed information and additional deployment options, see the Azure Resource Manager templates (ARM templates) used to deploy this solution.

> [!div class="nextstepaction"]
> [Ingress/Egress with layer 7 NVAs ARM Template][ha-nva-l7-sample]

## PIP-UDR switch with layer 4 NVAs without SNAT

This architecture uses two Azure virtual machines to host the NVA firewall in an active-passive configuration that supports automated failover but does not require Source Network Address Translation (SNAT).

![[5]][5]

This solution is designed for Azure customers who cannot configure SNAT for inbound requests on their NVA firewalls. SNAT hides the original source client IP address. If you need to log the original IPs or used them within other layered security components behind your NVAs, this solution offers a basic approach.

The failover of UDR table entries is automated by a next-hop address set to the IP address of an interface on the active NVA firewall virtual machine. The automated failover logic is hosted in a function app that you create using [Azure Functions](/azure/azure-functions/). The failover code runs as a serverless function inside Azure Functions. Deployment is convenient, cost-effective, and easy to maintain and customize. In addition, the function app is hosted within Azure Functions, so it has no dependencies on the virtual network. If changes to the virtual network impact the NVA firewalls, the function app continues to run independently. Testing is more accurate as well, because it takes place outside the virtual network using the same route as the inbound client requests.

To check the availability of the NVA firewall, the function app code probes it in one of two ways:

- By monitoring the state of the Azure virtual machines hosting the NVA firewall.

- By testing whether there is an open port through the firewall to the back-end web server. For this option, the NVA must expose a socket via PIP for the function app code to test.

You choose the type of probe you want to use when you configure the function app.

### Deploy the PIP-UDR switch with layer 4 NVAs without SNAT architecture

This deployment requires several deployment steps and manual configuration. For details see the [GitHub repository][ha-nva-fo].

## Next steps

- Learn how to [implement a DMZ between Azure and your on-premises datacenter][dmz-on-premises] using Azure Firewall.
- [Troubleshoot network virtual appliance issues in Azure](/azure/virtual-network/virtual-network-troubleshoot-nva)

<!-- links -->

[cloud-security]: /azure/best-practices-network-security
[dmz-on-premises]: ./secure-vnet-dmz.yml
[load-balancer-standard-ha-ports]: #load-balancer-standard-and-ha-ports
[egress-with-layer-7]: #egress-with-layer-7-nvas
[ingress-with-layer-7]: #ingress-with-layer-7-nvas
[ingress-egress-with-layer-7]: #ingressegress-with-layer-7-nvas
[lb-overview]: /azure/load-balancer/load-balancer-overview
[nva-scenario]: /azure/virtual-network/virtual-network-scenario-udr-gw-nva
[pip-udr-without-snat]: #pip-udr-switch-with-layer-4-nvas-without-snat
[udr-overview]: /azure/virtual-network/virtual-networks-udr-overview
[ha-nva-fo]: https://aka.ms/ha-nva-fo
[ha-nva-l7-sample]: https://github.com/mspnp/samples/tree/master/solutions/ha-nva

<!-- images -->

[0]: ./images/nva-ha/single-nva.png "Single NVA architecture"
[HAPortsArch]: ./images/nva-ha/nva-ha.png "Diagram of hub-and-spoke virtual network, with NVAs deployed in HA mode"
[1]: ./images/nva-ha/l7-ingress.png "Layer 7 ingress architecture with load balancer"
[2]: ./images/nva-ha/l7-egress.png "Layer 7 egress architecture with load balancer"
[3]: ./images/nva-ha/l7-ingress-egress.png "Layer 7 ingress egress"
[5]: ./images/nva-ha/pip-udr-without-snat.png "PIP-UDR with layer 4 NVAs without SNAT architecture"
