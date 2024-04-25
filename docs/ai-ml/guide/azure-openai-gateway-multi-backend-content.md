Workload architectures that involve Azure OpenAI could be as simple as one or more client applications consuming a single Azure OpenAI model deployment directly, but not all workloads can be designed with such simplicity. There's a multitude of scenarios in which one or more clients need to access one or more models on an Azure OpenAI instance or one or more instances of Azure OpenAI to achieve the requirements of the workload. In those situations, introducing a gateway in front of Azure OpenAI could be beneficial to the workload's design.

Multiple Azure OpenAI backends are included in workload architecture to solve specific workload requirements. They can be classified in four key topologies. The usage of a gateway isn't necessary just because your architecture uses this topology, but instead should be based on if the workload would benefit from introducing the component into the architecture.

- [Multiple model deployments in a single Azure OpenAI instance](#multiple-model-deployments-in-a-single-azure-openai-instance)
- [Multiple Azure OpenAI instances in a single region and single subscription](#multiple-azure-openai-instances-in-a-single-region-and-single-subscription)
- [Multiple Azure OpenAI instances in a single region across multiple subscriptions](#multiple-azure-openai-instances-in-a-single-region-across-multiple-subscriptions)
- [Multiple Azure OpenAI instances across multiple regions](#multiple-azure-openai-instances-across-multiple-regions)

> [!TIP]
> Unless otherwise stated, the guidance that follows is suitable for both Azure API Management-based gateways or custom code gateways. The architecture diagrams will represent the gateway component generically in most situations to illustrate this.

## Multiple model deployments in a single Azure OpenAI instance

:::image type="complex" source="_images/multiple-models-single-instance-before.svg" alt-text="Architecture diagram of a scenario with clients connecting to more than one model deployment in Azure OpenAI." lightbox="_images/multiple-models-single-instance-before.svg":::
   A diagram showing two clients labeled A and B directly interfacing with an Azure OpenAI instance in a resource group named rg-aoai-eastus. The Azure OpenAI instance has four model deployments. Client A has a solid arrow to a gpt-4 model and a gpt-35-turbo model. Client B has solid lines to a different gpt-35-turbo model and has a dashed arrow pointing to yet another gpt-35-turbo deployment.
:::image-end:::

In this topology, your architecture includes a single Azure OpenAI instance but contains more than one concurrently deployed model. The single instance could have any number of hosted deployments, which could:

- be a different model (`gpt-35-turbo`, `gpt-4`, custom fine-tuned) to support different capabilities
- be a different model version (`0613`, `1106`, custom fine-tuned) to support workload evolution or blue/green deployments
- have a different quota assigned (30K Tokens Per Minute (TPM), 60K TPM) to support consumption throttling across multiple clients

### Introduce a gateway for multiple model deployments

:::image type="complex" source="_images/multiple-models-single-instance-after.svg" alt-text="Architecture diagram of a scenario with clients connecting to more than one model deployment in Azure OpenAI but through a gateway." lightbox="_images/multiple-models-single-instance-after.svg":::
   A diagram showing two clients labeled A and B directly interfacing with a gateway. The gateway has an arrow pointing to a private endpoint, which has four arrows leading from there into an Azure OpenAI instance in a resource group named rg-aoai-eastus. Three of the arrows are solid and point to three different model deployments labeled gpt-4, gpt-35-turbo, and other labeled gpt-35-turbo. One of the arrows is dashed and is pointing to yet another gpt-35-turbo deployment.
:::image-end:::

Introducing a gateway into this topology is primarily to abstract clients away from self-selecting a specific model instance among the available deployments on the instance. A gateway allows server-side control to direct a client request to a specific model without needing to redeploy client code or change client configuration.

A gateway is especially beneficial when you don't control the client code, or client configuration deployment is more complex or risky than making gateway routing configuration changes. You might change which model a client is pointing to based on a blue/green rollout strategy of your model versions, such as in rolling out a new fine-tuned model or going from version *X* to *X+1* of the same model.

The gateway can also be used as a single API point of entry that allows the gateway to identify the client and then make a specific choice, based on that client's presented authentication (identity) or other information in the HTTP request, about which model deployment is used to serve the prompt. For example, in a multitenant solution, tenants might be limited to specific throughput, and the implementation of the architecture is a model deployment per tenant with specific quota. In this case, the routing to the tenant's model would be the responsibility of the gateway based on information found in the HTTP request.

> [!TIP]
> Because API keys and Azure role-based access control (RBAC) are applied at the Azure OpenAI instance level, not the model deployment level, adding a gateway in this scenario allows you to shift security to the gateway. The gateway then provides additional segmentation between concurrently deployed models that would be otherwise not possible to control through Azure OpenAI's identity and access management (IAM) or IP firewall.

Using a gateway in this topology allows client-based usage tracking. Unless clients are using distinct Microsoft Entra service principles, the access logs for Azure OpenAI wouldn't be able to distinguish multiple clients. Having a gateway in front of the deployment gives your workload an opportunity to track usage per client across various available model deployments to support chargeback or showback models.

#### Tips for the multiple model deployments topology

- While the gateway is in a position to completely change which model is being used, for example `gpt-35-turbo` to `gpt-4`, that change would likely be considered a breaking change to the client. Don't let new functional capabilities of the gateway distract from always executing [safe deployment practices](#safe-deployment-practices) for this workload.

- This topology is typically straight forward enough to implement through Azure API Management policy instead of a custom code solution.

- Your clients might benefit from maintaining API compatibility with the Azure OpenAI API to support native SDKs usage with publish Azure OpenAI APIs specifications. This is a larger concern when your team isn't authoring all of your workload clients' code. When deciding designing the HTTP API for the gateway, consider the benefits of maintaining Azure OpenAI HTTP API compatibility.

- While this topology technically supports pass-through client credentials (access tokens or API key) for the Azure OpenAI instance, more commonly credential termination and re-establishment is expected. This way the client is authorized at the gateway, and then the gateway is authorized (through Azure role-based access control) to the Azure OpenAI instance.

- If the gateway is designed to use pass-through credentials, ensure clients can't bypass the gateway or any model restrictions based on the client.

- Deploy your gateway in the same region as the Azure OpenAI instance.

- Deploy the gateway into a dedicated resource group in the subscription, separate from the Azure OpenAI instance. Having it isolated from the backends can help drive an [APIOps](https://github.com/Azure/apiops) approach through separations of concern.

- Deploy the gateway into a virtual network that contains a subnet for the Azure OpenAI instance's Private Link private endpoint. Apply network security group (NSG) rules to that subnet to only allow the gateway access to that private endpoint. All other data plane access to the Azure OpenAI instances should be disallowed.

### Reasons to avoid a gateway for multiple model deployments

If controlling your clients' configuration is as easy as or easier than controlling the routing at the gateway level, the additional reliability, security, cost, maintenance, and performance impact of the gateway might not be worth the additional architectural component.

Also some workload scenarios could benefit from going from a multiple model deployment approach to a multiple Azure OpenAI instance deployment approach. For example, consider using multiple Azure OpenAI instances if you have multiple clients and they should be using different RBAC or access keys to access their model. Using multiple deployments in a single Azure OpenAI instance and handling logical identity segmentation at the gateway level is possible, but might be excessive when a physical RBAC segmentation approach is available by using distinct Azure OpenAI instances.

## Multiple Azure OpenAI instances in a single region and single subscription

:::image type="complex" source="_images/multiple-instances-single-region-before.svg" alt-text="Architecture diagram of a scenario with clients connecting to more than one Azure OpenAI instance in a single region." lightbox="_images/multiple-instances-single-region-before.svg":::
   A diagram showing two clients labeled A and B directly interfacing three Azure OpenAI instances, each with one model all labeled gpt-4. All Azure OpenAI instances are in a resource group named rg-aoai-eastus. Client A has a solid arrow connecting it to gpt-4 in a Client A instance that says PTU. Client A has a dashed arrow connecting it to gpt-4 in a Client A instance that says consumption spillover. Client B has a solid arrow connecting it to gpt-4 in a Client B instance that says PTU.
:::image-end:::

In this topology, your architecture includes multiple Azure OpenAI instances all colocated within a single Azure subscription. Multiple Azure OpenAI instances are used to support:

- security segmentation boundaries, such as key or RBAC per client
- an easy chargeback model against different clients
- a failover strategy for Azure OpenAI service availability, such as a platform outage impacting a specific instance, a networking misconfiguration, or an accidentally deleted deployment
- a failover strategy for Azure OpenAI quota availability, such as pairing both a PTU-based instance and a consumption-based instance for spillover.

### Introduce a gateway for multiple instances in a single region and subscription

:::image type="complex" source="_images/multiple-instances-single-region-after.svg" alt-text="Architecture diagram of a scenario with clients connecting to more than one Azure OpenAI instance in a single region through a gateway." lightbox="_images/multiple-instances-single-region-after.svg":::
   A diagram showing two clients labeled A and B directly interfacing with a gateway. The gateway has three arrows coming from it pointing to private endpoints. Two arrows are solid, one is dashed. Each private endpoint connects to a distinct Azure OpenAI instance with a gpt-4 model in each. The instances are labeled Client A (PTU), Client A (Consumption), Client B (PTU).
:::image-end:::

A model could be rendered unavailable to a client due to Azure OpenAI unavailability or due to Azure OpenAI's API rejecting requests due to throttling. A model could also be unavailable due to a fault of workload operations such as network misconfiguration or a model deployment being accidentally deleted. Without a gateway, the failover logic and configuration of active and passive endpoints would need to be added to all of your clients. Introducing a gateway into this topology abstracts clients away from having to design failover logic by moving the logic into the gateway itself. In this way, the responsibility for retry and circuit breaking logic is server side. No matter if you own the client code or not, this shift can increase reliability of the workload.

With the gateway involved in this way, the gateway could also opt to treat all backends as active-active deployments and not just use them in active-passive failovers. This approach would be most effective when all instances are PTU-based, as consumption-based quotas are subscription-level not Azure OpenAI instance level and load balancing against consumption-based instances generally doesn't achieve additional throughput.

One option a workload team has when provisioning Azure OpenAI is deciding if the billing and throughput model is PTU-based or consumption-based. A cost optimization strategy to avoid waste through unused PTU is to slightly under provision the PTU instance and also deploy a consumption-based instance along side. The goal with this topology is to have clients first consume all available PTU and then "burst" over to the consumption-based deployment for overages. This is effectively a form of planned failover, and benefits for the same reason as mentioned in the opening paragraph of this section; keeping this complexity out of client code.

When a gateway is involved, it is in a unique position to capture details about all of the model deployments clients are interacting with. While every instance of Azure OpenAI can capture its own telemetry, doing so within the gateway allows the workload team to publish telemetry and error responses across all consumed models to a single store to make unified dashboarding and alerting easier.

#### Tips for the multiple instances in a single region and subscription topology

- For supporting failover scenarios at the gateway, ensure the gateway is using the `Retry-After` information available in the HTTP response from Azure OpenAI. That authoritative information should be used to control your circuit-breaker implementation. Do not continuously hit an endpoint that returns a `429 Too Many Requests`; always break a circuit for that model instance.

- Attempting to predict throttling events before they happen by tracking model consumption through prior requests is possible in the gateway, but is fraught with edge cases. In most cases, it's best to not attempt to predict, but use HTTP response codes to drive future routing decisions.

- When round-robining or failing over to a different endpoint (including PTU spilling over into consumption), always make sure those endpoints are using the same model at the same version. For example, don't fail over from `gpt-4` to `gpt-35-turbo` or from version *X* to version *X+1* or load balance between them. This version change can cause unexpected behavior in the clients.

- Load balancing and failover logic are implementable within Azure API Management policies. You might be able to provide a more sophisticated approach using a code-based gateway solution, but API Management is usually sufficient for this use case.

- Deploy your gateway in the same region as the Azure OpenAI instance.

- Deploy the gateway into a dedicated resource group in the subscription, separate from the Azure OpenAI instances. Having the gateway isolated from the backends can help drive an [APIOps](https://github.com/Azure/apiops) approach through separations of concern.

- Colocate all Azure OpenAI instance Private Link private endpoints into a single subnet on the gateway's virtual network. Apply NSG rules to that subnet to only allow the gateway access to those private endpoints. All other data plane access to the Azure OpenAI instances should be disallowed.

- To simplify the logic in your gateway routing code, it's recommended to use the same model deployment name to minimize the difference between the HTTP routes. For example, the model name `gpt4-v1` can be used on all load-balanced or spillover instances can be used regardless if it's consumption based or PTU based.

### Reasons to avoid a gateway for multiple instances in a single region and subscription

A gateway itself doesn't improve the ability to chargeback models against different clients for this specific topology. In this topology, clients could be granted access to their own dedicated Azure OpenAI instances, which would support your workload team's ability to perform chargeback or showback. Because clients can be directed to use their own Azure OpenAI instances, unique identity and network perimeters also come with that model, and a gateway wouldn't need to be introduced specifically for segmentation.

If you have a few clients in which you control the code of and the clients are easily updatable, the logic that you'd have to build into the gateway could also be added directly into the code. Consider using this approach for failover or load balancing primarily when you don't own the client code or the complexity is inappropriate for the clients to handle.

## Multiple Azure OpenAI instances in a single region across multiple subscriptions

In this topology, your architecture includes multiple Azure OpenAI instances spread across two or more Azure subscriptions. The primary reason for this to obtain additional quota, since subscription boundary is a factor in available consumption-based quota. This additional quota can be used to support highly concurrent consumption.

:::image type="complex" source="_images/multiple-subscriptions-before.svg" alt-text="Architecture diagram of a scenario one client connecting to two Azure OpenAI instances, one per region." lightbox="_images/multiple-subscriptions-before.svg":::
   A diagram showing a client with a solid arrow pointing to a gpt-35-turbo (consumption) deployment in an Azure OpenAI instance labeled Primary. This primary instance is in a box labeled Workload subscription A. The client also has a dashed arrow pointing to a gpt-35-turbo (consumption) deployment in an Azure OpenAI instance labeled Secondary. This secondary instance is in a box labeled Workload subscription B. In both subscriptions the resource group containing the Azure OpenAI instances is called rg-aoai-eastus.
:::image-end:::

### Introduce a gateway for multiple instances in a single region and multiple subscriptions

The same reasons that are covered in [Introduce a gateway for multiple instances in a single region and subscription](#introduce-a-gateway-for-multiple-instances-in-a-single-region-and-subscription) apply to this topology.

In addition to those, adding a gateway here also supports a centralized team providing an "Azure OpenAI as a Service" model for their organization. Due to consumption-based quota being subscription-bound, a centralized team that provides Azure OpenAI services using the consumption based model will likely find themselves spread across multiple subscriptions to obtain additional quota. The gateway logic still remains largely the same.

:::image type="complex" source="_images/multiple-subscriptions-after.svg" alt-text="Architecture diagram of a scenario one client connecting to two Azure OpenAI instances, one per region, indirectly through a gateway." lightbox="_images/multiple-subscriptions-after.svg":::
   A diagram showing a client with a solid arrow pointing to a gateway. The gateway in a resource group called rg-gateway-eastus which is contained in a box labeled Workload gateway subscription. The gateway is connected to two private endpoints in the same resource group as the gateway. One private endpoint points to a gpt-35-turbo (consumption) deployment in an Azure OpenAI instance labeled Primary. This primary instance is in a box labeled Workload subscription A. The second private endpoint is a dashed arrow pointing to a gpt-35-turbo (consumption) deployment in an Azure OpenAI instance labeled Secondary. This secondary instance is in a box labeled Workload subscription B. The resource group containing the Azure OpenAI instances is called rg-aoai-eastus in both cases.
:::image-end:::

#### Tips for the multiple instances in a single region and multiple subscriptions topology

- Ideally the subscriptions should all be backed with the same Microsoft Entra ID tenant to support consistency in Azure role-based access control (RBAC) and Azure Policy.

- Deploy your gateway in the same region as the Azure OpenAI instance.

- Deploy the gateway into a dedicated subscription, separate from the Azure OpenAI instances. This helps enforce a consistency in addressing the Azure OpenAI instances and provides a logical segmentation of duties between Azure OpenAI deployments and their routing.

- When routing requests from your gateway across subscriptions, you'll need to ensure private endpoints are reachable. This means that you'll use transitive routing through a hub to private endpoints for the backends in their respective spokes. Or you might be able to expose private endpoints for the Azure OpenAI services directly in the gateway subscription using [Private Link connections across subscriptions](/azure/private-link/how-to-approve-private-link-cross-subscription). Cross-subscription private link connections would be preferred if supported by your organization and situation.

### Reasons to avoid a gateway for multiple instances in a single region and multiple subscriptions

All of the contraindications in [Reasons to avoid a gateway for multiple instances in a single region and subscription](#reasons-to-avoid-a-gateway-for-multiple-instances-in-a-single-region-and-subscription) apply to this topology.

## Multiple Azure OpenAI instances across multiple regions

:::image type="complex" source="_images/multiple-regions-before.svg" alt-text="Three architecture diagram clients connecting to Azure OpenAI instances  in different regions." lightbox="_images/multiple-regions-before.svg":::
   Three architecture diagrams in one image. In the upper left it shows a client connected to an Azure OpenAI instance in West US and one in East US implying an active-active load balancing situation. Both instances have a gpt-4 (consumption) deployment. In the upper right it's the same situation, only it's implied that the West US instance is passive. The gpt-4 instance in East US has the label PTU while the gpt-4 instance in West US has the label Consumption. In the bottom middle there are two regions depicted, East US and Germany West Central. A US Client is shown connected to a PTU gpt-4 model in East US. A Germany client is shown connected to a PTU gpt-model in Germany West Central.
:::image-end:::

In this topology, your workload's architecture includes multiple Azure OpenAI instances spread across two or more Azure regions. Multiple regions support:

- a failover strategy for service availability, such as using [cross-region pairs](/azure/reliability/cross-region-replication-azure#azure-paired-regions)
- a data residency & compliance design
- mixed model availability, some regions have different models and different quotas available for the models

While not technically different Azure regions, this topology is also generally applicable when you have an AI model exposed in a cross-premsise situation such as on-premises or in another cloud.

### Introduce a gateway for multiple instances in multiple regions

For business-critical architectures that must survive complete regional outage, a global, unified gateway helps eliminate failover logic from client code. This requires that the gateway itself remains unaffected by a regional outage.

Load-balacing across regions isn't typical, but could be used strategically to combine available quota in consumption-based deployments across regions. This scenario doesn't require that the gateway itself remains unaffected by a regional outage, but it's encouraged for maximum workload reliability.

#### Use Azure API Management (Single-region deployment)

:::image type="complex" source="_images/multiple-regions-api-management-single-after.svg" alt-text="An architecture diagram of a client connecting to an Azure OpenAI instance in both West US and East US." lightbox="_images/multiple-regions-api-management-single-after.svg":::
   An architecture diagram that shows a client connecting to an API Management instance. That API Management instance is in a resource group called rg-gateway which is identified as being in West US. That API Management instance connects to two Private Endpoints. One private endpoint is in a resource group called rg-aoai-westus in the West US region. The other private endpoint is in a resource group called rg-aoai-eastus in the East US region.  The rg-aoai-westus and rg-aoai-east resource group also contain their own Azure OpenAI instances, both labeled Active with a gpt-4 consumption deployment each.
:::image-end:::

In this topology, Azure API Management is used specifically for the gateway technology. API Management is deployed into a single region and from that gateway instance you perform active-active load balancing across regions. The policies in your gateway will reference all Azure OpenAI instances. The gateway requires network line of sight to each backend across regions, either through cross-region virtual network peering or private endpoints. Be aware that calls from this gateway to an Azure OpenAI instances in another region will incur additional network latency and egress charges.

Your gateway must honor throttling and availability signals from the Azure OpenAI instances and remove faulted backends from the pool until safe to readd the faulted or throttled Azure OpenAI instance. Retry the current request against another backend instance in the pool upon fault, before falling back to returning a gateway error. The gateway's health check should signal unhealthy when no backend Azure OpenAI instances are available.

> [!NOTE]
> This gateway will be introduce a global single point of regional failure in your architecture as any service outage on your gateway instances will render all regions inaccessible. Don't use this topology for business-critical workloads or where client-based load balancing is sufficient.

This model lends itself well to consumption-based billing in Azure OpenAI as predicting PTU allocation might prove too challenging. Generally speaking, the utility of this specific architecture is fairly limited.

This approach can't be used in scenarios involving data sovereignty compliance if either Azure OpenAI region spans a geopolitical boundary.

##### Active-passive variant

This model can also be used to provide an active-passive approach to specifically handle regional failure of just Azure OpenAI. In this mode, traffic normally flows from the gateway to the Azure OpenAI instance in the same region as the API management service. That instance of Azure OpenAI could be PTU based to handle all expected traffic flow without regional failures occurring. In the case of a regional failure of just Azure OpenAI, the gateway can redirect traffic to another region with Azure OpenAI already deployed, but in consumption mode. In this way, you can combine PTU + consumption as a regional failover target instead of spillover.

#### Use Azure API Management (Multi-region deployment)

:::image type="complex" source="_images/multiple-regions-api-management-multiple-after.svg" alt-text="An architecture diagram of a client connecting to an Azure OpenAI instance in both West US and East US through gateways located each region." lightbox="_images/multiple-regions-api-management-multiple-after.svg":::
   An architecture diagram that shows a client connecting to two API Management gateways with a note that says "Built-in API Management FQDN (uses performance based routing)." The API Management instance is in a resource group called rg-gateway-westus but has a gateway in both West US and East US, in an active-active topology. Each gateway has an arrow pointing to a single Private Endpoint each. Each private endpoint points to a single Azure OpenAI instance each in the same region. Each Azure OpenAI instance has a gpt-4 (PTU) model deployed.
:::image-end:::

To improve on the reliability of the prior Azure API Management-based architecture, API Management supports deploying an [instance to multiple Azure regions](/azure/api-management/api-management-howto-deploy-multi-region). This gives you a single control plane, through a single API Management instance, but replicated gateways in the regions of your choice. In this topology, you deploy gateway components into each region containing Azure OpenAI instances; this provides an active-active gateway architecture.

Policies (routing and request handling logic) are replicated to each individual gateway. All policy logic must have conditional logic in the policy to ensure you're calling Azure OpenAI instances in the same region as the current gateway. For more information, see [Route API calls to regional backend services](/azure/api-management/api-management-howto-deploy-multi-region#-route-api-calls-to-regional-backend-services). The gateway component then requires network line of sight only to Azure OpenAI instances in its own region, usually through private endpoints.

> [!NOTE]
> This topology doesn't have a global point of failure of a traffic handling perspective, but the architecture partially suffers from a single point of failure in that the Azure API Management control plane is only in a single region. Evaluate if the control plane limitation might violate your business or mission-critical standards.

API Management offers out of the box global FQDN routing based on lowest latency. It's recommended to use this built-in, performance based functionality for active-active gateway deployments. This built-in functionality helps address both performance and handles a regional gateway outage. Using the built-in global router also supports disaster recovery drilling as regions can be simulated down through disabling individual gateways. Ensure clients respect the TTL on the FQDN and have appropriate sufficient retry logic to handle a recent DNS failover.

If you need to introduce a web application firewall (WAF) into this architecture, you can still use the built-in FQDN routing solution as the backend origin for your global router, delegating failover to API Management instead of your global router. Alternatively, you could use the endpoints per regional gateway FQDNs as the backend pool members. In that latter architecture, use the built-in `/status-0123456789abcdef` endpoint on each regional gateway or another custom health API endpoint to support regional failover. If unsure, start with the single origin backend FQDN approach.

This architecture works best if you can treat regions as either fully available or fully unavailable. This means that if either the API Management gateway or Azure OpenAI instance is unavailable, you want client traffic to no longer be routed to the API Management gateway in that region. Unless another provision is made, if the regional gateway still accepts traffic while Azure OpenAI is unavailable, the error must be propagated to the client. To avoid the client error, see an improved approach in [Active-active gateway + active-passive Azure OpenAI variant](#active-active-gateway--active-passive-azure-openai-variant).

If a region is experiencing an API Management gateway outage or is flagged as unhealthy, be aware that the remaining available regions need to absorb 100% of the traffic from those other regions. This means you need to over-provision PTU based Azure OpenAI instances to handle the new burst of traffic. Use the [Azure OpenAI Capacity calculator](https://oai.azure.com/portal/calculator) for capacity planning.

Insure the resource group containing Azure API Management is the same location as the API Management instance itself to reduce the blast radius of a related regional outage impacting your ability to access the resource provider for your gateways.

This approach can't be used in scenarios involving data residency compliance if either gateway region spans a geopolitical boundary.

##### Active-active gateway + active-passive Azure OpenAI variant

:::image type="complex" source="_images/multiple-regions-api-management-multiple--active-active-and-active-passive-after.svg" alt-text="An architecture diagram of a client connecting to an Azure OpenAI instance in both West US and East US through gateways located each region which can talk to instances in other regions." lightbox="_images/multiple-regions-api-management-multiple--active-active-and-active-passive-after.svg":::
   An architecture diagram that shows a client connecting to two API Management gateways with a note that says "Built-in API Management FQDN (uses performance based routing)." The API Management instance is in a resource group called rg-gateway-westus but has a gateway in both West US and East US, in an active-active topology. Each gateway has an arrow pointing to an active Private Endpoint in the same region and a dashed arrow pointing to a passive Private Endpoint in the other region. There are only two private endpoints, so the active endpoint is the other gateway's passive endpoint. The Private Endpoint each point to an active gpt-4 (PTU) model in an Azure OpenAI instance in their own region. The Private Endpoint also points to a passive gpt-4 (consumption) model in its own region.
:::image-end:::

The previous section primarily addresses availability of the gateway by providing an active-active gateway topology. This topology combines both an active-active API gateway and a cost-effective active-passive Azure OpenAI topology. Adding active-passive logic to the gateway to fail over to a consumption-based Azure OpenAI deployment in another region can significantly increase the reliability of the workload. This model still allows clients to use API Management's built-in FQDN routing solution for performance based routing.

This active-active + active-passive approach can't be used in scenarios involving data residency compliance if either region spans a geopolitical boundary.

#### Use a custom coded gateway

:::image type="complex" source="_images/multiple-regions-custom-active-active-and-active-passive-after.svg" alt-text="An architecture diagram of a client connecting to an Azure OpenAI instance in both West US and East US through a global load balancer and custom gateways located each region which can talk to instances in other regions." lightbox="_images/multiple-regions-custom-active-active-and-active-passive-after.svg":::
   An architecture diagram that shows a client connecting to two Gateway compute instances with the Azure Container Apps icon, but through Azure Front Door or through DNS and Traffic Manager. The two gateway instances are each in their own resource groups called rg-gateway-westus and rg-gateway-eastus in the West US and East US region respectively. Each gateway has an arrow pointing to an active Private Endpoint in the same region and a dashed arrow pointing to a passive Private Endpoint in the other region. There are only two private endpoints, so the active endpoint is the other gateway's passive endpoint. The Private Endpoint each point to an active gpt-4 (PTU) model in an Azure OpenAI instance in their own region. The Private Endpoint also points to a passive gpt-4 (consumption) model in its own region.
:::image-end:::

If your per-gateway routing rules are too complex for your team to consider tenable as API Management policies, you'll need to deploy and manage your own solution. This architecture must be a multi-region deployment of your gateway, with one highly available scale-unit per region. You'll then need to front those deployments with Azure Front Door (Anycast) or Traffic Manager (DNS), typically using latency based routing and appropriate health checks of gateway availability.

Use Azure Front Door if you require a WAF and public Internet access. Use Traffic Manager if you don't need a WAF and DNS TTL is sufficient. When fronting your gateway instances with Azure Front Door (or any reverse proxy), ensure that gateway can't be bypassed. Make the gateway instances available only via private endpoint when using Azure Front Door and add validation of the `X_AZURE_FDID` HTTP header in your gateway implementation.

Place per-region resources that are used in your custom gateway in per-region resource groups. This reduces the blast radius of a related regional outage impacting your ability to access the resource provider for your gateway resources in that region.

You can also consider fronting your gateway logic implementation with API Management itself, for the other benefits of API Management such as TLS, authentication, health check, or round-robin load balancing. This shifts common "API concerns" out of custom code in your gateway, leaving your gateway to specifically address Azure OpenAI instance and model deployment routing.

For data residency compliance, ensure each geopolitical boundary has its own isolated deployment of this architecture and clients can only reach their authorized endpoint.

### Reasons to avoid a gateway for multiple instances in multiple regions

Don't implement a unified gateway across geopolitical regions when data residency & compliance is required; this would violate the data residency requirements. Use individually addressable gateways per region and follow the guidance in one of the prior sections.

If clients aren't expected to fail over between regions and you have the ability to give clients a specific gateway to use, then instead use multiple gateways, one per region and follow the guidance in one of the prior sections. Don't tie the availability of other regions to the region containing your gateway as a single point of failure.

Don't implement a unified gateway if your model isn't available in all regions. Clients need to be consistently routed to same model and same model version. For multi-region load-balanced and failover gateways you need to pick a common model and model version that is available across all involved regions. Refer to [model availability](/azure/ai-services/openai/concepts/models#standard-deployment-model-availability) to learn more. If you can't standardize on model and model version, the benefit of the gateway is limited.

## General recommendations

No matter which topology your workload needs there are a few cross-cutting recommendations to consider when building your gateway solution.

### Stateful interactions

When clients are using Azure OpenAI's stateful features (such as the Assistant API), you'll need to add an affordance into your gateway to pin a client to a specific backend duration that interaction. This can be accomplished with instance data being stored in cookie. This might mean it's better to return an Azure OpenAI API response like a `429` to a pinned client instead of redirecting them to a new Azure OpenAI instance. This allows the client to explicitly handle sudden unavailability vs hiding it and being routed to a model instance that has no history.

### Gateway health checks

There are two health check perspectives that need to be address, regardless of topology.

If your gateway is built around round-robining or strictly performing service availability failover, you'll want a way to take an Azure OpenAI instance (or model) out of availability status. Azure OpenAI doesn't provide any sort of health check endpoint to preemptively know if it's available to handle requests. You could send synthetic transitions through, but that will consume model capacity. Unless you have another reliable signal source for Azure OpenAI instance and model availability, your gateway likely should assume the Azure OpenAI instance is up and then handle `429`, `500`, `503` HTTP status codes as a signal to circuit-break for future requests on that instance or model for a period of time. For throttling situations, always honor the data in the `Retry-After` header found in Azure OpenAI API responses for `429`s in your circuit breaking logic. If you're Azure API Management, evaluate using the [built-in circuit breaker](/azure/api-management/backends?tabs=bicep#circuit-breaker-preview) functionality.

Your clients or your workload operations team might wish to have a health check exposed on your gateway itself for their own routing or introspection purposes. If you use API Management, the default `/status-0123456789abcdef` might not be detailed enough as it mostly addresses the API Management gateway instance, not your backends. Consider adding a dedicated health check API that can return meaningful data to clients or observability systems on the availability of the gateway or specific routes in the gateway.

### Safe deployment practices

All of these gateway implementations allow you to orchestrate blue/green deployments of updated models. Azure OpenAI models are updated with new model versions or even new models. After testing the impact of a change in preproduction, evaluate if production clients should be "cut over" to the new model version or instead shift traffic. The gateway pattern described above allows the backend to have both models concurrently deployed and gives the power to the gateway to redirect traffic based on the workload team's safe deployment practice of incremental rollout.

Even if you don't use blue/green deployments, your workload's APIOps approach needs to be defined and sufficiently automated commiserate with the rate of change of your backend instance and model deployments.

### Just enough implementation

Many of the scenarios introduced in this article are to increase the potential service-level object (SLO) of your workload by reducing client complexity and implementing reliable self-preservation techniques. Others improve the security of the workload by moving access controls to specific models away from Azure OpenAI. Be sure that the introduction of the gateway doesn't end up working counter to these goals. Understand the risks of becoming a new single point of failure either through service faults or human-caused configuration issues in the gateway, complex routing logic, or the risks of exposing more models to unauthorized clients than would be intended.

### Data sovereignty

The various active-active and active-passive approaches need to be evaluated from a data residency compliance perspective for your workload. Many of these patterns would be applicable for your workload's architecture if the regions involved always staying withing the geopolitical boundary. To support this, you need to treat geopolitical boundaries as isolated stamps and apply the active-active or active-passive handling exclusively within that stamp.

In particular, any performance based routing needs to be highly scrutinized for data sovereignty compliance. Clients can't be serviced by another geography and remain compliant. All gateway architectures involving data residency must enforce that clients use only endpoints in their geopolitical region. The clients must be blocked from using other gateway endpoints and the gateway itself doesn't violate the client's trust by making a cross-geopolitical request. The most reliable way to implement this segmentation is to build your architecture around a fully independent, highly available gateway per geopolitical region.

### Azure OpenAI authorization

The gateway needs to authenticate with all Azure OpenAI instances that it interfaces with. Unless you designed the gateway to do pass-through authentication, which is rare, the gateway should use a managed identity for its credentials. This means that each Azure OpenAI instance will need to configure least-priviledged role-based access control for the gateways' managed identities. For active-active and failover architectures, ensure the gateway's identity is permissioned equivalently across all involved Azure OpenAI instances.

### Azure Policy

Consistency between model deployments and Azure OpenAI instances is important in active-active or active-passive situations. Use Azure Policies to help enforce consistency between the various Azure OpenAI instances or model deployments. If the [built-in policies](/azure/governance/policy/samples/built-in-policies#azure-ai-services) for Azure OpenAI aren't sufficient to ensure consistency between them, consider creating or using [community created](https://github.com/Azure/Community-Policy/tree/main/policyDefinitions/Cognitive%20Services) custom policies.

### Gateway redundancy

While not specific to multiple-backends, each region's gateway implementation should always be built with redundancy and be highly available within the scale unit. Prefer regions with availability zones and ensure your gateway is spread across them. Deploy multiple instances of the gateway so that single point of failure is limited to complete regional outage, not due to the fault of a single compute instance in your gateway. For API Management, deploy two or more units across two or more zones. For custom code implementations deploy at least three instances with best effort distribution across availability zones.

## Gateway implementations

Azure doesn't offer a turn-key solution nor reference architecture for building such a gateway. As mentioned in the [introduction article](./azure-openai-gateway-guide.yml#implementation-options), your workload team needs to build and operate this gateway. What follows are some example of community-supported sample implementations covering some of the previously mentioned use cases. Consider referencing these GitHub samples when you build your own proof of concept.

| Implementation       | Example |
| :------------------- | :------ |
| Azure API Management | [Smart load balancing for Azure OpenAI using Azure API Management](https://github.com/Azure-Samples/openai-apim-lb) - This GitHub repo contains sample policy code and instructions to deploy into your subscription.<br><br>[Scaling Azure OpenAI using Azure API Management](https://github.com/Azure/aoai-apim/) - This GitHub repo contains sample policy code and instructions for PTU and consumption spillover.<br/><br/>There are also some community supported [Azure OpenAI API Management policies](https://github.com/CrewAakash/aoai-apim-policies) available. |
| Custom code          | [Smart load balancing for Azure OpenAI using Azure Container Apps](https://github.com/Azure-Samples/openai-aca-lb)<br/><br/>This GitHub repo contains sample C# code and instructions to build the container and deploy into your subscription. |

## Next step

Having a gateway implementation gives your workload many potential benefits, not just the tactical multi-backend routing benefit presented in this article.

Learn about the additional [key challenges](./azure-openai-gateway-guide.yml#key-challenges) a gateway can solve.
