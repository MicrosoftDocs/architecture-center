---
title: Use a Gateway in Front of Multiple Azure OpenAI Deployments or Instances
description: Learn how to add a gateway in front of multiple Azure OpenAI model deployments or instances.
author: claytonsiemens77
ms.author: pnp
ms.date: 05/06/2026
ms.topic: concept-article
ms.subservice: architecture-guide
---

# Use a gateway in front of multiple Azure OpenAI deployments or instances

Workload architectures that use a hosted model platform (for example, Microsoft Foundry) can be as simple as one or more client applications calling a single model endpoint directly. Some workloads, however, require multiple clients, multiple model deployments, or multiple model-host instances. In those cases, a gateway can act as a programmable routing layer in front of your model back ends.

Multiple instances or model deployments solve specific requirements in a workload architecture. They can be classified in four key topologies:

- [Multiple model deployments in a single instance](#multiple-model-deployments-in-a-single-instance)
- [Multiple instances in a single region and single subscription](#multiple-instances-in-a-single-region-and-a-single-subscription)
- [Multiple instances in a single region across multiple subscriptions](#multiple-instances-in-a-single-region-across-multiple-subscriptions)
- [Multiple instances across multiple regions](#multiple-instances-across-multiple-regions)

These topologies don't automatically require a gateway. The decision depends on whether you benefit from centralized routing control, reliability controls, security segmentation, observability, and quota governance at the gateway layer.

> [!TIP]
> Unless otherwise stated, the following guidance is suitable for gateways that are based on Azure API Management and custom code gateways. The architecture diagrams represent the gateway component generically in most situations to illustrate this.

## Multiple model deployments in a single instance

:::image type="complex" source="_images/multiple-models-single-instance-before.svg" alt-text="Architecture diagram of a scenario in which clients connect to more than one model deployment in the model host." lightbox="_images/multiple-models-single-instance-before.svg":::
   A diagram showing two clients labeled A and B directly interfacing with an instance in a resource group named rg-foundry-eastus. The instance has four model deployments. Client A has two solid lines pointing to two Foundry models. Client B has a solid line pointing to a Foundry model and a dashed line pointing to another Foundry model deployment.
:::image-end:::

### Topology details for multiple model deployments

- **Model deployments:** multiple
- **Instances:** one
- **Subscriptions:** one
- **Regions:** one

### Topology use cases for multiple model deployments

A topology that includes a single instance but contains more than one concurrently deployed model supports the following use cases:

- Expose different model capabilities (for example, a general-purpose model, a higher-capability model, and custom fine-tuned variants) behind one host.

- Expose different model versions to support workload evolution, regression testing, or blue-green rollouts.

- Expose different quotas / rate limits per deployment to throttle consumption across multiple clients (for example, assigning distinct TPM limits per deployment where supported).

### Introduce a gateway for multiple model deployments

:::image type="complex" source="_images/multiple-models-single-instance-after.svg" alt-text="Architecture diagram of a scenario that shows clients connecting to more than one model deployment in the model host through a gateway." lightbox="_images/multiple-models-single-instance-after.svg":::
   A diagram that shows two clients labeled A and B directly interfacing with a gateway. The gateway has an arrow that points to a private endpoint, which has four arrows that lead to an instance in a resource group named rg-foundry-eastus. Three of the arrows are solid and point to three different model deployments labeled Foundry model. One of the arrows is dashed and points to another Foundry model deployment.
:::image-end:::

The introduction of a gateway into this topology is primarily meant to abstract clients away from self-selecting a specific model instance among the available deployments on the instance. A gateway allows server-side control to direct a client request to a specific model without needing to redeploy client code or change client configuration.

A gateway is especially beneficial when you don't control the client code. It's also beneficial when deploying client configuration is more complex or risky than deploying changes to a gateway routing configuration. You might change which model a client points to based on a blue-green rollout strategy of your model versions, such as rolling out a new fine-tuned model or going from version *X* to *X+1* of the same model.

The gateway can also be used as a single API point of entry that enables the gateway to identify the client. It can then determine which model deployment is used to serve the prompt based on that client's identity or other information in the HTTP request. For example, in a multitenant solution, tenants might be limited to specific throughput, and the implementation of the architecture is a model deployment per tenant with specific quotas. In this case, the routing to the tenant's model is the responsibility of the gateway based on information in the HTTP request.

> [!TIP]
> Because API keys and Azure role-based access control (Azure RBAC) are applied at the model-host instance level and not the model deployment level, adding a gateway in this scenario lets you shift security to the gateway. The gateway then provides additional segmentation between concurrently deployed models that wouldn't otherwise be possible to control through the host's identity and access management (IAM) or IP firewall.

Using a gateway in this topology enables client-based usage tracking. Unless clients are using distinct Microsoft Entra service principals, the access logs for the model host can't distinguish among multiple clients. Placing a gateway in front of the deployment gives your workload an opportunity to track usage per client across various available model deployments to support chargeback or showback models.

#### Tips for the multiple model deployments topology

- Although the gateway is in a position to completely change which model is being used, that change would probably be considered a breaking change to the client. Don't let new functional capabilities of the gateway distract you from always performing [safe deployment practices](#safe-deployment-practices) for the workload.

- This topology is typically straightforward enough to implement via API Management policy instead of a custom code solution.

- Maintain API compatibility when you need to support SDKs. If client applications rely on published OpenAI-style APIs/SDKs, design the gateway API so that clients can continue using those SDKs without custom adapters.

- Although this topology technically supports pass-through client credentials (access tokens or API key) for the model-host instance, strongly consider implementing credential termination and reestablishment. In this configuration, the client is authorized at the gateway, and then the gateway is authorized via Azure RBAC to that instance.

- If the gateway is designed to use pass-through credentials, make sure that clients can't bypass the gateway or any model restrictions based on the client.

- Colocate the gateway in the same region as the model host and restrict back-end network paths when possible so that the model endpoints are reachable only through the gateway. Isolating the subscription from the back ends can help drive an [APIOps](https://github.com/Azure/apiops) approach through separations of concern.

- Deploy the gateway into a virtual network that contains a subnet for the instance's Azure Private Link private endpoint. Apply network security group (NSG) rules to that subnet to allow only the gateway access to that private endpoint. Disallow all other data plane access to the model-host instances.

### Reasons to avoid a gateway for multiple model deployments

If controlling your clients' configuration is as easy as or easier than controlling the routing at the gateway level, the added reliability, security, cost, maintenance, and performance impact of the gateway might not justify the added architectural component.

Also consider whether you actually need separate deployments in one host, versus separate host instances, to get stronger physical segmentation (identity, network boundary, billing separation) without complex routing logic.

### Chat-based workloads and stateful interactions

Some workloads use chat-based interactions through chat completions and assistants APIs, which introduce stateful behavior across multiple requests. In these cases, a gateway might need to maintain session affinity (sometimes referred to as *stickiness*) so that all requests that belong to an active conversation are routed to the same back end deployment while the conversation is in progress.

### Provisioned capacity and priority processing

The platform might support provisioned throughput units, which represent reserved model capacity for predictable throughput. Some workloads might combine provisioned capacity with standard capacity to absorb bursts. Priority processing features can reduce request latency within a single deployment. However, they don't increase overall quota and shouldn't be considered a replacement for multi-backend or multi-instance designs that address high availability, resilience, or multitenant isolation.

## Multiple instances in a single region and a single subscription

:::image type="complex" source="_images/multiple-instances-single-region-before.svg" alt-text="Architecture diagram of a scenario in which clients connect to more than one model-host instance in a single region." lightbox="_images/multiple-instances-single-region-before.svg":::
   A diagram showing two clients labeled A and B directly interfacing with three instances, each with one model Foundry model. All instances are in a resource group named rg-foundry-eastus. Client A has a solid arrow connecting it to a Foundry model in a Client A instance that says provisioned primary. Client A has a dashed arrow connecting it to a Foundry model in a Client A instance that says standard spillover. Client B has a solid arrow connecting it to a Foundry model in a Client B instance that says provisioned.
:::image-end:::

To authenticate the gateway itself, use a managed identity. When the gateway runs on API Management or another Azure service, assign it a managed identity and grant that identity the appropriate Azure RBAC role on each instance that it needs to access. This approach avoids passing client API keys to back-end services, enables least-privilege access, and simplifies credential management and rotation.

The gateway should honor throttling behavior and `Retry-After` headers. API Management provides built-in circuit breaker capabilities that can automatically respect `Retry-After` values returned for HTTP 429 responses.

API Management also provides an llm-token-limit policy that enables you to enforce token-per-minute quotas per client or subscription at the gateway level. These built-in policies can reduce the need for custom retry, throttling, and protection logic in gateway code and help prevent back-end throttling.

### Topology details for multiple instances in a single region and a single subscription

- **Model deployments:** one or more
- **Instances:** multiple
- **Subscriptions:** one
- **Regions:** one

### Topology use cases for multiple instances in a single region and a single subscription

A topology that includes multiple instances in a single region and a single subscription supports the following use cases:

- Enables security segmentation boundaries, such as key or Azure RBAC per client

- Enables an easy chargeback model for different clients

- Enables a failover strategy to maintain availability, for example, in case of a platform outage that affects a specific instance, a networking misconfiguration, or an accidentally deleted deployment

- Enables a failover strategy for quota availability, such as pairing both a provisioned instance and a standard instance for spillover

### Introduce a gateway for multiple instances in a single region and a single subscription

:::image type="complex" source="_images/multiple-instances-single-region-after.svg" alt-text="Architecture diagram of a scenario with clients connecting to more than one model-host instance in a single region through a gateway." lightbox="_images/multiple-instances-single-region-after.svg":::
   A diagram showing two clients labeled A and B directly interfacing with a gateway. Three arrows point from the gateway to private endpoints. Two arrows are solid and one is dashed. Each private endpoint connects to a distinct instance that contains a Foundry model. The instances are labeled Client A (provisioned primary), Client A (standard spillover), and Client B (provisioned).
:::image-end:::

A model might not be accessible to a client for several reasons. These reasons include disruptions, throttling requests, or issues related to workload operations like network misconfiguration or an inadvertent deletion of a model deployment. To address these challenges, you should implement retry and circuit breaking logic.

This logic could be implemented in clients or server-side in a gateway. Implementing the logic in a gateway abstracts the logic away from clients, avoiding repeated code and resulting in a single place to test the logic. Regardless of whether you own the client code, this shift can increase reliability of the workload.

Using a gateway with multiple instances in a single region and subscription lets you treat all back ends as active-active deployments and not just use them in active-passive failovers. You can deploy the same provisioned model across multiple instances and use the gateway to load balance among them.

> [!NOTE]
> Standard quotas are subscription level, not instance level. Load balancing against standard instances in the same subscription doesn't achieve additional throughput.

One option a workload team has when provisioning is deciding whether the billing and throughput model is provisioned or standard. A cost optimization strategy to avoid waste through unused provisioned capacity is to slightly underprovision the provisioned instance and also deploy a standard instance alongside it. The goal with this topology is to have clients first consume all available pre-allocated throughput and then "burst" over to the standard deployment for overages. This form of planned failover benefits for the reason mentioned in the opening paragraph of this section: keeping this complexity out of client code.

When a gateway is involved, it's in a unique position to capture details about all of the model deployments clients are interacting with. Although every instance can capture its own telemetry, doing so within the gateway lets the workload team publish telemetry and error responses across all consumed models to a single store. This configuration makes unified dashboarding and alerting easier.

#### Tips for the multiple instances in a single region and single subscription topology

- Ensure that the gateway is using the `Retry-After` information available in HTTP responses from the back-end service when you implement failover scenarios at the gateway. Use that authoritative information to control your circuit-breaker implementation. Don't continuously hit an endpoint that returns `429 Too Many Requests`. Instead, break the circuit for that model instance.

- Attempting to predict throttling events before they happen by tracking model consumption through prior requests is possible in the gateway, but doing so is fraught with edge cases. In most cases, it's best not to try to predict, but to use HTTP response codes to drive future routing decisions.

- When you use a round-robin strategy or fail over to a different endpoint, including provisioned spilling over into standard deployments, always make sure those endpoints are using the same model at the same version. For example, don't fail over from version *X* to version *X+1* or load balance between them. This version change can cause unexpected behavior in the clients.

- You can implement load balancing and failover logic in API Management policies. You might be able to implement a more sophisticated approach by using a code-based gateway solution, but API Management is sufficient for this use case.

- Deploy the gateway in the same region as the model instance.

- Deploy the gateway into a dedicated resource group in the subscription that's separate from the model instances. Isolating the gateway from the back ends can help drive an [APIOps](https://github.com/Azure/apiops) approach via separation of concerns.

- Colocate all instance Private Link private endpoints into a single subnet on the gateway's virtual network. Apply NSG rules to that subnet to allow only the gateway access to those private endpoints. All other data plane access to the instances should be disallowed.

- To simplify the logic in your gateway routing code, use the same model deployment name to minimize the difference between the HTTP routes. For example, the model name can be used on all load-balanced or spillover instances, whether they're standard or provisioned.

### Reasons to avoid a gateway for multiple instances in a single region and single subscription

A gateway itself doesn't improve the ability to chargeback models against different clients for this specific topology. In this topology, clients can be granted access to their own dedicated instances, which supports your workload team's ability to manage chargeback or showback. This model supports unique identity and network perimeters, so a gateway doesn't need to be introduced specifically for segmentation.

If you have a few clients in the area, and you control the code, and the clients are easy to update, the logic that you'd have to build into the gateway can be added directly into the code. Consider using the gateway approach for failover or load balancing primarily when you don't own the client code or  when the clients can't handle the added complexity.

If you're using a gateway specifically to address capacity constraints, evaluate whether data zone-based capacity features are sufficient for your workload.

## Multiple instances in a single region across multiple subscriptions

:::image type="complex" source="_images/multiple-subscriptions-before.svg" alt-text="Architecture diagram of a scenario in which one client connects to two model-host instances in the same region across two subscriptions." lightbox="_images/multiple-subscriptions-before.svg":::
   A diagram that shows a client with a solid arrow that points to a Foundry model deployment in a primary instance. This primary instance is in a box labeled Workload subscription A. The client also has a solid arrow that points to a Foundry model deployment in a secondary instance. This secondary instance is in a box labeled Workload subscription B. In both subscriptions, the resource group containing the instances is called rg-foundry-eastus.
:::image-end:::
When multiple subscriptions are used to distribute standard quota, a gateway can abstract subscription boundaries from clients while routing traffic based on availability or capacity. Keep in mind that standard quotas remain scoped to the subscription, so capacity doesn't aggregate automatically unless separate subscriptions are used.

### Global and Data Zone deployments

With Global deployments, request processing might occur in any Azure region where capacity is available, but data at rest remains within the deployment's region. Data Zone deployments restrict processing to a defined geographic zone, such as EU-only regions. If your workload requires strict data residency with no cross-border processing, a single global gateway that routes traffic across regions isn't appropriate. In such cases, deploy separate gateways per region or geography to ensure compliance with regulatory requirements.

### Topology details for multiple instances in a single region across multiple subscriptions

- **Model deployments:** one or more
- **Instances:** multiple
- **Subscriptions:** multiple
- **Regions:** one

### Topology use cases for multiple instances in a single region across multiple subscriptions

A topology that includes multiple instances in a single region across multiple subscriptions supports the following use cases:

- Any of the [use cases listed for multiple instances in a single region and a single subscription](#topology-use-cases-for-multiple-instances-in-a-single-region-and-a-single-subscription).

- A use case in which you want to obtain more quota in a standard deployment and you must constrain the use of models to a single, specific region.

  > [!NOTE]
   > If you don't need to constrain the use of models to a specific region, use [Global](/azure/foundry/foundry-models/concepts/deployment-types#global-deployments) or [Data Zone](/azure/foundry/foundry-models/concepts/deployment-types#data-zone-deployments) deployments that use the Azure global infrastructure to dynamically route inferencing requests to datacenters that have the available capacity.

### Introduce a gateway for multiple instances in a single region and multiple subscriptions

The same reasons for [introducing a gateway for multiple instances in a single region and subscription](#introduce-a-gateway-for-multiple-instances-in-a-single-region-and-a-single-subscription) apply to this topology.

In addition to those reasons, adding a gateway in this topology also supports a centralized team providing an AI-as-a-service model for their organization. Because quota in a standard deployment is subscription-bound, a centralized team that provides shared AI services that use the standard deployment must deploy instances across multiple subscriptions to obtain the required quota. The gateway logic still remains mostly the same.

:::image type="complex" source="_images/multiple-subscriptions-after.svg" alt-text="Architecture diagram of a scenario in which one client connects to two instances, one per region, indirectly through a gateway." lightbox="_images/multiple-subscriptions-after.svg":::
   A diagram that shows a client with a solid arrow pointing to a gateway. The gateway is in a resource group called rg-gateway-eastus that's contained in a box labeled Workload gateway subscription. The gateway is connected to two private endpoints that are in the same resource group as the gateway. One private endpoint points to a Foundry model deployment in a primary instance. This primary instance is in a box labeled Workload subscription A. The second private endpoint has a dashed arrow pointing to a Foundry model deployment in a secondary instance. This secondary instance is in a box labeled Workload subscription B. The resource group containing the instances is called rg-foundry-eastus in both cases.
:::image-end:::

#### Tips for the multiple instances in a single region and multiple subscriptions topology

- Ideally, back all the subscriptions with the same Microsoft Entra tenant to support consistency in Azure RBAC and Azure Policy.

- Deploy your gateway in the same region as the model-host instance.

- Deploy the gateway into a dedicated subscription that's separate from the instances. This configuration helps enforce consistency in addressing the instances and provides a logical segmentation of duties between model deployments and their routing.

- When you route requests from your gateway across subscriptions, make sure that private endpoints are reachable. You can use transitive routing through a hub to private endpoints for the back ends in their respective spokes. You might be able to expose private endpoints for the AI service directly in the gateway subscription by using [Private Link connections across subscriptions](/azure/private-link/how-to-approve-private-link-cross-subscription). Cross-subscription Private Link connections are preferred if your architecture and organization support this approach.

### Reasons to avoid a gateway for multiple instances in a single region and multiple subscriptions

All of the [reasons to avoid a gateway for multiple instances in a single region and subscription](#reasons-to-avoid-a-gateway-for-multiple-instances-in-a-single-region-and-single-subscription) apply to this topology.

## Multiple instances across multiple regions

:::image type="complex" source="_images/multiple-regions-before.svg" alt-text="Diagram that contains three architecture diagrams that show clients connecting to model-host instances in different regions." lightbox="_images/multiple-regions-before.svg":::
   Image that shows three architecture diagrams. The first diagram shows a client connected to an instance in West US and another client in East US, indicating an active-active load balancing scenario. Both instances have a Foundry model deployment. The second diagram shows the same scenario, only it indicates that the West US instance is passive. The Foundry model instance in East US has the label Primary, and the Foundry model instance in West US has the label Secondary. The third diagram shows two regions, East US and Germany West Central. A US client connects to a provisioned Foundry model in East US. A Germany client connects to a provisioned Foundry model in Germany West Central.
:::image-end:::

### Topology details for multiple instances across multiple regions

- **Model deployments:** multiple
- **Instances:** multiple
- **Subscriptions:** one or more
- **Regions:** multiple

### Topology use cases for multiple instances across multiple regions

A topology that includes multiple instances spread across two or more Azure regions supports the following use cases:

- Supports all of the [use cases listed for multiple instances in a single region across multiple subscriptions](#topology-use-cases-for-multiple-instances-in-a-single-region-across-multiple-subscriptions).

- Enables a failover strategy for service availability, such as using [cross-region pairs](/azure/reliability/cross-region-replication-azure#azure-paired-regions).

- Enables a data residency and compliance design.

- Enables mixed-model availability. Some regions have different models and different quotas available for the models.

 This topology is also applicable when you have an AI model exposed in a cross-premises scenario, such as on-premises or in another cloud. However, this scenario doesn't use different Azure regions.

### Introduce a gateway for multiple instances in multiple regions

For business-critical architectures that must survive a complete regional outage, a global, unified gateway helps eliminate failover logic from client code. This implementation requires that the gateway remain unaffected by a regional outage.

#### Use API Management (single-region deployment)

:::image type="complex" source="_images/multiple-regions-api-management-single-after.svg" alt-text="Architecture diagram of a client connecting to model-host instances in both West US and East US." lightbox="_images/multiple-regions-api-management-single-after.svg":::
   Architecture diagram that shows a client connecting to an API Management instance. That API Management instance is in a resource group called rg-gateway that's in West US. The API Management instance connects to two private endpoints. One private endpoint is in a resource group called rg-aoai-westus in the West US region. The other private endpoint is in a resource group called rg-aoai-eastus in the East US region. The rg-aoai-westus and rg-aoai-east resource groups also contain Azure OpenAI instances, both labeled Active, and each contains a gpt-4 standard deployment.
:::image-end:::

In this topology, API Management is used specifically for the gateway technology. API Management is deployed into a single region. From that gateway instance, you use active-active load balancing across regions. The policies in your gateway reference all of your model-host instances. The gateway requires network line of sight to each back end across regions, either through cross-region virtual network peering or private endpoints. Calls from this gateway to an instance in another region incur more network latency and egress charges.

Your gateway must honor throttling and availability signals from the back-end instances and remove faulted back ends from the pool until it's safe to add the faulted or throttled instance back. The gateway should retry the current request against another back-end instance in the pool when a fault occurs, before falling back to returning a gateway error. The gateway's health check should signal unhealthy when no back-end instances are available.

> [!NOTE]
> This gateway introduces a global single point of regional failure in your architecture because any service outage on your gateway instances renders all regions inaccessible. Don't use this topology for business-critical workloads or where client-based load balancing is sufficient.

Because this topology introduces a single point of failure (the gateway), the utility of this specific architecture is limited to protecting you against regional model endpoint outages.

> [!WARNING]
> This approach can't be used in scenarios that involve data sovereignty compliance if either region spans a geopolitical boundary.

##### Active-passive variant

This model can also be used to provide an active-passive approach to specifically handle regional failure of only the model host. In this mode, traffic normally flows from the gateway to the instance in the same region as the API Management service. That instance handles all expected traffic flow when there's not a regional failure. It can be provisioned or standard, depending on your preferred billing model. If a regional failure affects only that service, the gateway can redirect traffic to another region where the model is already deployed in a standard deployment.

#### Use API Management (multi-region deployment)

:::image type="complex" source="_images/multiple-regions-api-management-multiple-after.svg" alt-text="Architecture diagram of a client connecting to model-host instances in both West US and East US through gateways located in each region." lightbox="_images/multiple-regions-api-management-multiple-after.svg":::
   An architecture diagram that shows a client connecting to two API Management gateways with a note that says "Built-in API Management FQDN (uses performance-based routing)." The API Management instance is in a resource group called rg-gateway-westus but has a gateway in both West US and East US, in an active-active topology. Each gateway has an arrow that points to its own single private endpoint. Each private endpoint points to a single instance in its own region. A Foundry model is deployed for each instance.
:::image-end:::

API Management supports deploying an [instance to multiple Azure regions](/azure/api-management/api-management-howto-deploy-multi-region), which can improve the reliability of the previous API Management-based architecture. This deployment option gives you a single control plane through a single API Management instance but provides replicated gateways in the regions of your choice. In this topology, you deploy gateway components into each region containing model-host instances that provide an active-active gateway architecture.

Policies such as routing and request handling logic are replicated to each individual gateway. All policy logic must have conditional logic in the policy to ensure that you call instances in the same region as the current gateway. For more information, see [Route API calls to regional back-end services](/azure/api-management/api-management-howto-deploy-multi-region#route-api-calls-to-regional-backend-services). The gateway component then requires network line of sight only to instances in its own region, usually through private endpoints.

> [!NOTE]
> This topology doesn't have a global point of failure from a traffic handling perspective. However, the architecture has a partial single point of failure in that the API Management control plane is only in a single region. Evaluate whether the control plane limitation might violate your business or mission-critical standards.

API Management offers out-of-the-box global fully qualified domain name (FQDN) routing based on lowest latency. Use this built-in performance-based functionality for active-active gateway deployments. This built-in functionality helps address performance and handles a regional gateway outage. The built-in global router also supports disaster recovery testing because you can simulate regions down to disabling individual gateways. Make sure that clients respect the Time to Live (TTL) on the FQDN and have appropriate retry logic to handle a recent DNS failover.

If you need to introduce a web application firewall into this architecture, you can still use the built-in FQDN routing solution as the back-end origin for your global router that implements a web application firewall. The global router delegates failover responsibility to API Management. Alternatively, you can use the regional gateway FQDNs as the back-end pool members. In the latter architecture, use the built-in `/status-0123456789abcdef` endpoint on each regional gateway or another custom health API endpoint to support regional failover. If you're not sure which approach to take, start with the single-origin back-end FQDN approach.

This architecture is most effective when you treat regions as either fully available or fully unavailable. In other words, if either the API Management gateway or a back-end instance is unavailable, you don't want client traffic to be routed to the API Management gateway in that region. Unless another provision is made, if the regional gateway continues to accept traffic while the back end is unavailable, the error must be propagated to the client. To avoid the client error, see an improved approach in [Active-active gateway plus active-passive variant](#active-active-gateway-plus-active-passive-variant).

If a region is experiencing an API Management gateway outage or is flagged as unhealthy, the remaining available regions need to absorb 100% of the traffic from those other regions. You therefore need to overprovision provisioned model-host instances to handle the new burst of traffic or use an [active-passive approach for failover](#active-active-gateway-plus-active-passive-variant). Use the capacity calculator at the service level for capacity planning.

Ensure that the resource group that contains API Management is the same location as the API Management instance itself to reduce the likelihood of the blast radius of a related regional outage affecting your ability to access the resource provider for your gateways.

> [!WARNING]
> This approach can't be used in scenarios that involve data residency compliance if either gateway region spans a geopolitical boundary.

##### Active-active gateway plus active-passive variant

:::image type="complex" source="_images/multiple-regions-api-management-multiple-active-active-and-active-passive-after.svg" alt-text="Architecture diagram that shows a client connecting to model-host instances in both West US and East US through gateways located in  West US. The gateways can communicate with instances in both regions." lightbox="_images/multiple-regions-api-management-multiple-active-active-and-active-passive-after.svg":::
   Architecture diagram that shows a client connecting to two API Management gateways with a note that says "Built-in API Management FQDN (uses performance-based routing)." The API Management instance is in a resource group called rg-gateway-westus but has a gateway in both West US and East US, in an active-active topology. Each gateway has a dashed line that points to an endpoint in the other region. There are only two private endpoints, so each active endpoint is the other gateway's passive endpoint. The private endpoints each point to an active Foundry model in an instance in its own region. The private endpoints also point to a passive Foundry model in their own region.
:::image-end:::

The previous section addresses the availability of the gateway by providing an active-active gateway topology. This topology combines the active-active gateway with a cost-effective active-passive model-host topology. Adding active-passive logic to the gateway to fail over to a standard deployment from a provisioned deployment can significantly increase the reliability of the workload. This model still allows clients to use the API Management built-in FQDN routing solution for performance-based routing.

> [!WARNING]
> This active-active plus active-passive approach can't be used in scenarios that involve data residency compliance if either region spans a geopolitical boundary.

#### Use a custom-coded gateway

:::image type="complex" source="_images/multiple-regions-custom-active-active-and-active-passive-after.svg" alt-text="Architecture diagram of a client connecting to model-host instances in both West US and East US through a global load balancer. Custom gateways in each region can communicate with instances in the other region." lightbox="_images/multiple-regions-custom-active-active-and-active-passive-after.svg":::
   An architecture diagram that shows a client connecting to two gateway compute instances, each labeled with the Azure Container Apps icon, after first passing through Azure Front Door or through DNS and Azure Traffic Manager. The two gateway instances are each in their own resource groups called rg-gateway-westus and rg-gateway-eastus in the West US and East US region respectively. Each gateway has an arrow that points to an active private endpoint in the same region and a dashed arrow that points to a passive private endpoint in the other region. There are only two private endpoints, so each active endpoint is the other gateway's passive endpoint. Each private endpoint points to an active Foundry model in an instance in its own region. The private endpoint also points to a passive Foundry model in its own region.
:::image-end:::

If your per-gateway routing rules are too complex for your team to consider reasonable as API Management policies, you need to deploy and manage your own solution. This architecture must be a multi-region deployment of your gateway, with one highly available scale unit per region. You need to front those deployments with [Azure Front Door](/azure/frontdoor/) or [Azure Traffic Manager](/azure/traffic-manager/traffic-manager-overview), typically by using latency-based routing and appropriate health checks for gateway availability.

Use Azure Front Door if you require a web application firewall and public internet access. Use Traffic Manager if you don't need a web application firewall and DNS TTL is sufficient. When fronting your gateway instances with Azure Front Door (or any reverse proxy), ensure that the gateway can't be bypassed. Make the gateway instances available only through private endpoint when you use Azure Front Door, and add validation of the `X_AZURE_FDID` HTTP header in your gateway implementation.

Place per-region resources that are used in your custom gateway in per-region resource groups. Doing so reduces the likelihood of a blast radius of a related regional outage affecting your ability to access the resource provider for your gateway resources in that region.

You can also consider fronting your gateway logic implementation with API Management to get the other benefits of API Management. These benefits include TLS, authentication, health check, and round-robin load balancing. This configuration shifts common API concerns out of custom code in your gateway and lets your gateway specifically address model instance and deployment routing.

For data residency compliance, make sure that each geopolitical boundary has its own isolated deployment of this architecture and that clients can only reach their authorized endpoint.

### Reasons to avoid a gateway for multiple instances in multiple regions

Don't implement a unified gateway across geopolitical regions when data residency and compliance is required. Doing so would violate the data residency requirements. Use individually addressable gateways per region, and follow the guidance in one of the previous sections.

Don't implement a unified gateway solely to increase quota. Use [Global Standard](/azure/ai-foundry/foundry-models/concepts/deployment-types#global-standard) deployments that use Azure's global infrastructure to dynamically route requests to datacenters that have the best capacity for each request.

If clients aren't expected to fail over between regions and you can assign each client to a specific, instead use multiple gateways, one per region, and follow the guidance in one of the previous sections. Don't tie the availability of other regions to the region that contains your gateway as a single point of failure.

Don't implement a unified gateway if your model and version isn't available in all regions exposed by the gateway. Clients need to be routed to the same model and the same model version. For multi-region load-balanced and failover gateways, you need to pick a common model and model version that's available across all affected regions. For more information, see [Model availability](/azure/ai-foundry/foundry-models/concepts/models-sold-directly-by-azure#model-summary-table-and-region-availability). If you can't standardize on model and model version, the benefit of the gateway is limited.

## General recommendations

No matter which topology your workload needs, there are a few cross-cutting recommendations to consider when you build your gateway solution.

### Stateful interactions

When clients use stateful features, such as the Assistants API, you need to configure your gateway to pin a client to a specific back end during that interaction. You can accomplish this configuration by storing instance data in a cookie. In these scenarios, consider returning an API response like a `429` to a pinned client instead of redirecting it to a different back-end instance. Doing so allows the client to explicitly handle sudden unavailability rather than hiding it and being routed to a model instance that has no history.

### Gateway health checks

There are two health check perspectives to consider, regardless of topology.

If your gateway is built around round-robining or strictly performing service-availability failover, you should have a way to take a back-end instance (or model) out of availability status. Many AI services don't provide a dedicated health check endpoint to preemptively determine whether instances are available to handle requests. You can send synthetic transactions through, but doing so consumes model capacity. Unless you have another reliable signal source for instance and model availability, your gateway should probably assume that the back-end instance is available and handle `429`, `500`, and `503` HTTP status codes as a signal to circuit-break for future requests on that instance or model for a period of time. For throttling situations, always honor the data in the `Retry-After` located found in API responses for `429` response codes in your circuit breaking logic. If you're using API Management, evaluate using the [built-in circuit breaker](/azure/api-management/backends?tabs=bicep#circuit-breaker) functionality.

Your clients or your workload operations team might want to have a health check exposed on your gateway for their own routing or introspection purposes. If you use API Management, the default `/status-0123456789abcdef` might not be detailed enough because it mostly addresses the API Management gateway instance, not your back ends. Consider adding a dedicated health check API that can return meaningful data to clients or observability systems on the availability of the gateway or specific routes in the gateway.

### Safe deployment practices

You can use gateway implementations to orchestrate blue-green deployments of updated models. Hosted models are updated with new model versions and new models, and you might have new fine-tuned models.

After testing the effects of a change in preproduction, evaluate whether production clients should be cut over to the new model version or instead shift traffic. The gateway pattern described earlier allows the back end to deploy both models concurrently. Deploying models concurrently enables the gateway to redirect traffic based on the workload team's safe deployment practice of incremental rollout.

Even if you don't use blue-green deployments, your workload's APIOps approach needs to be defined and sufficiently automated commensurate with the rate of change of your back-end instance and model deployments.

### Just enough implementation

Many of the scenarios introduced in this article help increase the potential service-level objective (SLO) of your workload by reducing client complexity and implementing reliable self-preservation techniques. Others improve workload security by moving access controls to specific models away from the underlying AI service. Be sure that introducing the gateway doesn't work counter to these goals. Understand the risks of adding a new single point of failure, whether through service faults or human-caused configuration problems in the gateway, complex routing logic, or the risks of exposing more models to unauthorized clients than is intended.

### Data sovereignty

You need to evaluate various active-active and active-passive approaches from a data-residency compliance perspective for your workload. Many of these patterns are applicable for your workload's architecture if the regions involved remain within the geopolitical boundary. To support this scenario, you need to treat geopolitical boundaries as isolated stamps and apply the active-active or active-passive handling exclusively within that stamp.

In particular, any performance-based routing needs to be highly scrutinized for data sovereignty compliance. In data sovereignty scenarios, you can't service clients in another geography and remain compliant. All gateway architectures that involve data residency must enforce that clients only use endpoints in their geopolitical region. The clients must be blocked from using other gateway endpoints, and the gateway itself shouldn't violate the client's trust by making a cross-geopolitical request. The most reliable way to implement this segmentation is to build your architecture around a fully independent, highly available gateway per geopolitical region.

When considering whether to take advantage of increased capacity by using [Global](/azure/ai-foundry/foundry-models/concepts/deployment-types#global-standard) or [Data Zone](/azure/ai-foundry/foundry-models/concepts/deployment-types#data-zone-standard) deployments, you need to understand how these deployments affect data residency. Data stored at rest remains in the designated Azure geography for both Global and Data Zone deployments. That data might be transmitted and processed for inferencing in any hosting location for Global deployments, or in any hosting location within the Microsoft-specified data zone for Data Zone deployments.

### Service authorization

The gateway needs to authenticate with all model-host instances that it interfaces with. Unless you designed the gateway to do pass-through authentication, the gateway should use a managed identity for its credentials. So each instance needs to configure least-privileged Azure RBAC for the gateways' managed identities. For active-active and failover architectures, make sure the gateway's identity has equivalent permissions across all involved instances.

### Azure Policy

Consistency between model deployments and instances is important in both active-active and active-passive situations. Use Azure Policy to help enforce consistency between the various instances or model deployments. If the [built-in policies](/azure/governance/policy/samples/built-in-policies#azure-ai-services) for AI services aren't sufficient to ensure consistency between them, consider creating or using [community created](https://github.com/Azure/Community-Policy/tree/main/policyDefinitions/Cognitive%20Services) custom policies.

### Gateway redundancy

Although this consideration isn't specific to multiple back ends, each region's gateway implementation should always be built with redundancy and be highly available within the scale unit. Choose regions that have availability zones and make sure your gateway is spread across them. Deploy multiple instances of the gateway so that single point of failure is limited to a complete regional outage and not the fault of a single compute instance in your gateway. For API Management, deploy two or more units across two or more zones. For custom code implementations, deploy at least three instances with best effort distribution across availability zones.

## Gateway implementations

Azure doesn't provide a complete turnkey solution or reference architecture for building a gateway that's focused on routing traffic across multiple back ends. However, API Management is preferred because the service provides a PaaS-based solution that uses built in features such as back-end pools, circuit-breaking policies, and custom policies if needed. To evaluate what's available in that service for your workload's multi-backend needs, see [AI gateway in Azure API Management](/azure/api-management/genai-gateway-capabilities).

Whether you use API Management or build a custom solution, as mentioned in the [introduction article](./azure-openai-gateway-guide.yml#implementation-options), your workload team must build and operate the gateway. The following examples cover some of the previously mentioned use cases. Consider referring to these samples when you build your own proof of concept with API Management or custom code.

- **API Management**
  - [Smart load balancing using Azure API Management](https://github.com/Azure-Samples/openai-apim-lb) contains sample policy code and instructions.
  - [Scaling with Azure API Management](https://github.com/Azure/aoai-apim/) contains sample policy code and instructions for provisioned and standard spillover.
  - The [GenAI gateway toolkit](https://github.com/Azure-Samples/apim-genai-gateway-toolkit) contains example API Management policies together with a load-testing setup for testing the behavior of the policies.
- **Custom code** 
  - [Smart load balancing using Azure Container Apps](https://github.com/Azure-Samples/openai-aca-lb) contains sample C# code and instructions for building the container and deploying it into your subscription.

## Multi-backend routing for other models

The gateway pattern isn't limited to a single provider. A gateway can unify access to different AI back ends, such as self-hosted models or non-Microsoft AI services that expose OpenAI-compatible APIs.
This approach allows a single, consistent API surface for client applications while enabling flexible routing based on use case, cost, or performance characteristics.

## API Management enhancements for AI gateways

API Management has specialized capabilities for generative AI workloads. These capabilities include token-based rate limiting, semantic response caching, built-in back-end load balancing and circuit breaking, and simplified onboarding of OpenAI-compatible endpoints.

By using these built-in capabilities, you can significantly reduce the amount of custom gateway logic required and improve the reliability and governability of solutions that route traffic to multiple model deployments or other AI back ends.

## Next steps

Having a gateway implementation for your workload provides benefits beyond the tactical multiple-backend routing benefit described in this article. To learn about the other challenges a gateway can solve, see [Key challenges](./azure-openai-gateway-guide.yml#key-challenges).

## Related resources

- [AI workloads on Azure](/azure/well-architected/ai/get-started)
- [API gateway in Azure API Management](/azure/api-management/api-management-gateways-overview)
