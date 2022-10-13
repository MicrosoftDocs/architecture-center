This article describes the design and implementation of a blue-green deployment of Azure Kubernetes Service (AKS), which uses Azure Cloud managed services and native Kubernetes features. Adoption of this pattern improves operations and availability deploying changes, including upgrades, to AKS clusters.

The main benefits of the solution are:

- Minimized downtime during the deployment.
- Rollback strategy out of the box.
- Improved control and operations during the release and deployment of AKS changes and upgrades.
- Test for DR procedure.

The main reason why blue-green deployment is widely adopted in AKS and Kubernetes-based clusters is that it makes it possible to make operational changes, activate new AKS features, and apply changes to shared resources into the clusters without affecting running applications and workloads. Examples of changes are:

- Changing the Kubernetes version.
- Modify other Kubernetes resources and objects, like the ingress gateway, the service mesh, operators, network policies and so on.

The key principles and foundational aspects of the pattern are discussed in these articles:

- [What is infrastructure as code (IaC)?](/devops/deliver/what-is-infrastructure-as-code)
- [What is Mutable vs. Immutable Infrastructure?](https://www.hashicorp.com/resources/what-is-mutable-vs-immutable-infrastructure)
- [What is elastic computing or cloud elasticity?](https://azure.microsoft.com/overview/what-is-elastic-computing)
- [What is continuous delivery?](https://docs.microsoft.com/devops/deliver/what-is-continuous-delivery).

The Azure services that that you can use to implement these techniques listed in the [components](#components) section. The main ones are these:

- [AKS](https://azure.microsoft.com/services/kubernetes-service)
- [Azure Application Gateway](https://azure.microsoft.com/services/application-gateway)
- [Azure DNS](https://azure.microsoft.coms/products/dns)
  - Public DNS as optional, required only in case of public endpoints.
- Azure Front Door as optional, required in case of public endpoint with geo distribution of the traffic and acceleration.

From the perspective of automation and continuous integration and continuous delivery (CI/CD), the solution can be implemented in multiple ways. We suggest:

- [Bicep](/azure/azure-resource-manager/bicep/overview) or [Terraform](/azure/developer/terraform/overview) for IaC.
- [Azure Pipelines](https://azure.microsoft.com/products/devops/pipelines) or [Github Actions](https://docs.github.com/actions) for CI/CD

## Architecture

The following diagram shows the high-level architecture that describes the pattern and the related services. The [Workflow](#workflow) section describes in detail the steps for the implementing the pattern, including the sequence of events to properly switch the traffic, from a networking and app perspective, between the blue and green clusters.

To better explain the blue-green pattern, we need consider two main scenarios:

- The applications and APIs that are hosted in the cluster are public-facing.
- The applications and APIs that are hosted in the cluster are private-facing.

This is a logical separation that simplifies the description. There's also a hybrid scenario in which there's a mix of public and private applications and APIs in the cluster.

Here's a diagram of the public-facing scenario:

:::image type="content" source="images/blue-green-aks-deployment-diagram-public-architecture.png" lightbox="images/blue-green-aks-deployment-diagram-public-architecture.png" alt-text="Diagram of the public-facing architecture.":::

*Download a [Visio file](images/blue-green-diagrams.vsdx) of this architecture.*

In this case, Azure Front Door and Azure DNS are required to provide the routing mechanism that switches traffic between the blue and green clusters. For more information, see [Blue-green deployment with Azure Front Door](https://techcommunity.microsoft.com/t5/azure-architecture-blog/blue-green-deployment-with-azure-front-door/ba-p/1609178). by using Azure Front Door, it's possible to implement a full switch or a more controlled switch based on [weights](/azure/frontdoor/routing-methods). This technique is the most reliable and efficient in an Azure environment. if you want to use your own DNS and load balancer, then you need to be sure that they're configured to have a safe and reliable switch.

The application gateway that's dedicated to the public facing endpoints that are hosted in the AKS cluster is in line with the security pillar of the [Well-Architected Framework](azure/architecture/framework/security/design-network-connectivity), in particular regarding segmentation, connectivity, and application endpoints.

The following diagram shows the private-facing scenario:

:::image type="content" source="images/blue-green-aks-deployment-diagram-private-architecture.png" lightbox="images/blue-green-aks-deployment-diagram-private-architecture.png" alt-text="Diagram of the private-facing architecture.":::

*Download a [Visio file](images/blue-green-diagrams.vsdx) of this architecture.*

We need only an Azure DNS instance to implement the switching of traffic between the blue and green clusters by using A and CNAME records. For details, see the [Workflow](#workflow) section.

The Application Gateway are dedicated for the private endpoints, this follow the same consideration applied for the public facing Application Gateways.

An important point is that you have flexibility regarding the regions where you deploy the clusters. You can deploy the two clusters in separate regions or in the same region. The design and  operational principles are not affected by this choice. It only affects the situation where you require additional configurations at the networking level, such as:

- A dedicated virtual network and subnet for AKS and Application Gateway.
- Connection with backing services like Azure Monitor, Azure Container Registry, and Azure Key Vault.
- Azure Front Door visibility of the application gateway.

There are prerequisites of deploying into the same region:

- Virtual networks and subnets must be sized to host two clusters.
- The Azure subscription must provide sufficient capacity.

There are different approaches for the deployment of the ingress controller and external load balancers:

- You can have a single ingress controller with a dedicated external load balancer, like the reference implementation of this pattern, which is based on Application Gateway and [Application Gateway Ingress Controller (AGIC)]((/azure/application-gateway/ingress-controller-overview)). AGIC is a Kubernetes application that makes it possible to use the Application Gateway L7 load-balancer to expose cloud software to the internet. In certain scenarios, there are not only application endpoints in the AKS clusters, but also custom admin endpoints to perform operational tasks on the applications or configurations in the cluster, like updating configuration maps, secrets, network policies, and manifests. This scenario deploys a dedicated ingress controller.
- A single external load balancer associated to multiple ingress controllers that are deployed on the same cluster or on multiple clusters. This scenario is not covered in the reference implementation. In this scenario we recommend that you have separate application gateways for public facing endpoints and for private ones.

The overall architecture proposed and depicted in the article and in the diagrams is based on a standard ingress controller that's deployed as part of the AKS cluster, like NGINX and Envoy. In this reference implementation we use AGIC, which means that there's a direct connection between the application gateway and the AKS pods, but this doesn’t affect the overall blue-green pattern.



### Components

The following are the main components and Azure services that are used to deploy the blue-green pattern.

- [Application Gateway](https://azure.microsoft.com/services/application-gateway), the main responsibility is to act as gateway and Load balancer for the AKS clusters.
- [AKS](https://azure.microsoft.com/services/kubernetes-service), it's the core target service of the pattern.
- [Container Registry](https://azure.microsoft.com/services/container-registry), has the main role to store and distribute the artifacts in the AKS clusters, example of artifacts are: Container Images and HELM Charts.
- [Azure Monitor](https://azure.microsoft.com/services/monitor), is the core observability platform for AKS and strongly recommended given its native integration with AKS and its ability to provide logging, monitoring and alerting capabilities used to manage the different stages of this pattern.
- [KeyVault](https://azure.microsoft.com/services/key-vault), is recommended for securely managing secrets and certificates used by the Azure resources and the applications that depend on them.
- [Azure Front Door](https://azure.microsoft.com/services/frontdoor), is an optional component, that's needed in case of public endpoints and apps hosted on AKS and other azure compute services. It has the critical responsibility to manage the traffic switch between the blue and green clusters.
- [Public or Private DNS Zone](https://azure.microsoft.com/services/dns), has the main role to manage the hostnames that are part of the solution and also an active role in the switch of the traffic, in particular for the private endpoints.

### Workflow

This section provides the details for implementing the pattern.
It's important to highlight that this pattern is like a state machine, in which there are clear states and transitions. The blue and green clusters will be running at the same time, but only for a limited period of time, the main advantage of this is to optimize costs and operational efforts, more details in the section [Considerations](#considerations).

Here are the 5 stages of the pattern:

1. T0: Blue Cluster is On
2. T1: Green Cluster Deployment
3. T2: Sync Kubernetes State between Blue and Green clusters
4. T3: Traffic Switch to the green cluster
5. T4: Blue cluster is destroyed

This pattern is recursive, and blue and green clusters swap roles in different iteration of the pattern; meaning that in a specific iteration the blue cluster is the current active cluster and then the next iteration the green will be the current active cluster.

The triggers to transition to the multiple stages can be automated, this is usually the desired end state, but the starting point is quite often manual/semi-automatic. The triggers of the transitions are related to:

- specific workload metrics, SLO and SLA; they're mainly used in the T3 stage in order to validate the overall state of the AKS cluster before the switch of the traffic.
- Azure Platform metrics in order to have the proper dataset to evaluate the status/healthy of the workloads and AKS cluster. They're used in all the transitions of the pattern.

There's flexibility on the network discoverability of the clusters, and you have multiple options available:

- A DNS record dedicated to the blue and green clusters IP
  - aks-blue.contoso.com pointing to the private or public IP of the blue cluster
  - aks-green.contoso.com pointing to the private or public IP of the green cluster

  Then you can use these hostnames directly or as [backend pool](/azure/application-gateway/application-gateway-components) configuration in the application gateway that's on the top of each cluster.
- A DNS record dedicated to the blue-green cluster pointing to the App Gateway IP
  - aks-blue.contoso.com pointing to the private or public IP of the application gateway, that will have as backend pool the private/public IP of the blue cluster
  - aks-green.contoso.com pointing to the private or public IP of the application gateway, that will have as backend pool the private/public IP of the green cluster

#### T0: Blue Cluster is On

The initial stage of the pattern is to have the existing live cluster on, which is called the Blue Cluster. During this stage we are preparing the deployment of the new version of the cluster.

:::image type="content" source="images/blue-green-aks-deployment-diagram-blue-cluster-on.png" lightbox="images/blue-green-aks-deployment-diagram-blue-cluster-on.png" alt-text="Diagram of the T0 stage: the blue cluster is on.":::

The trigger condition for the [next stage](#t1-green-cluster-deployment) is the release of a new version of the cluster.

#### T1: Green Cluster Deployment

Now the deployment of the new version has started, and the new Green Cluster is deployed in parallel to the existing Blue Cluster. After the Green cluster is deployed, the live traffic is still routed to the Blue Cluster.

:::image type="content" source="images/blue-green-aks-deployment-diagram-green-cluster-deployment.png" lightbox="images/blue-green-aks-deployment-diagram-green-cluster-deployment.png" alt-text="Diagram of the T1 stage: green cluster deployment.":::

The trigger to move into the [T2 stage](#t2-sync-kubernetes-state-between-blue-and-green-cluster) is the validation of AKS at platform level, using native metrics available in Azure Monitor and CLI commands to check the health of the deployment; as reference can be used the [AKS Monitor page](https://docs.microsoft.com/azure/aks/monitor-aks), for more details [here](https://docs.microsoft.com/azure/aks/monitor-aks-reference) the full reference of the metrics and log available in Azure Monitor. The AKS monitoring can be split into different levels, as shown in the following diagram.

:::image type="content" source="images/blue-green-aks-deployment-diagram-aks-monitoring-levels.png" lightbox="images/blue-green-aks-deployment-diagram-aks-monitoring-levels.png" alt-text="Diagram of the AKS monitoring levels.":::

At this stage to evaluate the health of the cluster, is required to cover until partially the level 3. Regarding the level 1 you can leverage the native [multi cluster view](/azure/azure-monitor/containers/container-insights-analyze) of Azure monitor to validate the health, as shown here:

:::image type="content" source="images/blue-green-aks-deployment-screenshot-azure-monitor.png" lightbox="images/blue-green-aks-deployment-screenshot-azure-monitor.png" alt-text="Screenshot of the Azure Monitor monitoring clusters.":::

At level two we want to be sure the Kubernetes API Server and Kubelet is working properly, also in this case we can use the Kubelet Workbook in Azure Monitor, in detail the workbook provide two grids that show key node operating statistics:

- Overview by node grid summarizes total operation, total errors, and successful operations by percent and trend for each node.
- Overview by operation type summarizes for each operation the total operation, total errors, and successful operations by percent and trend.

The last level is dedicated to the Kubernetes objects and application deployed by default in AKS, like omsagent, kube-proxy and so on. In this you can use directly the Insight view of Azure Monitor for AKS to check the status of the deployments:

:::image type="content" source="images/blue-green-aks-deployment-screenshot-azure-monitor-insights-view.png" lightbox="images/blue-green-aks-deployment-screenshot-azure-monitor-insights-view.png" alt-text="Screenshot of the Azure Monitor Insights view.":::

As alternative you can use the new dedicated workbook documented [here](/azure/azure-monitor/containers/container-insights-deployment-hpa-metrics). Here's an example.

:::image type="content" source="images/blue-green-aks-deployment-screenshot-dedicated-workbook.png" lightbox="images/blue-green-aks-deployment-screenshot-dedicated-workbook.png" alt-text="Screenshot of a dedicated workbook.":::

#### T2: Sync Kubernetes State between Blue and Green cluster

At this stage there isn't a parity between the two clusters, meaning that **applications**, **operators** and **Kubernetes resources** are not yet deployed in the green cluster, or at least not all of them are applicable and deployed when the AKS cluster is provisioned. The ultimate goal of this stage is that at the end of the sync, the green cluster forward compatible with the blue one. This way, it's possible to validate the status of the new cluster before move to a state [Traffic Switch to the green cluster](#t3-traffic-switch-to-the-green-cluster).

There are multiple solutions/approaches to replicate/sync Kubernetes state on clusters:

- Redeployment via CI/CD, usually is enough to use the same CI/CD pipelines used for the normal deployment of the apps. Common tools are: Github Actions, Azure DevOps and Jenkins.
- GitOps with solutions promoted in CNCF, like [Flux](https://www.cncf.io/projects/flux) and [ArgoCD](https://www.cncf.io/projects/argo)
- Customized solution that stores the Kubernetes configs and resources in datastore; usually these solutions are based on Kubernetes manifests generators starting from metadata definition and then store the generated Kubernetes manifests into a datastore like CosmosDB; usually are bespoke solutions based on the application description framework in use.

:::image type="content" source="images/blue-green-aks-deployment-diagram-green-cluster-sync.png" lightbox="images/blue-green-aks-deployment-diagram-green-cluster-sync.png" alt-text="Diagram of the T2 stage: green cluster sync Kubernetes state.":::

Usually, during the sync, the deployment of new versions of applications is not permitted in the live cluster, this period of time starts with the sync and finishes when the switch to the green is completed; the solution to disable deployments in Kubernetes can vary based on the customer/user context, two possible solutions are: disable the deployment pipelines and/or disable the Kubernetes service account to execute deployment, it's possible to automate the last one via [OPA](https://www.openpolicyagent.org/docs/latest); currently is not possible to leverage on AKS native features because still in public preview. This period can be avoided with advanced mechanisms that manage the Kubernetes state in multiple clusters, but that's not part of this article.

When the sync is completed, a test/validation of the cluster is required, together with a validation of the application deployed on top of it. This includes:

- a check on the monitoring and logging platforms to validate the health of the cluster; you can consider what's described in the [T1 stage](#t1-green-cluster-deployment)
- Functional testing of the application based on the toolchain currently in use, moreover, is suggested to execute a load test session to compare the performance with the performance baseline of the applications, in this way you are sure that the cluster has the same performance of the previous one; also, in this case you can use your preferred tool or leverage [Azure Load Testing](https://azure.microsoft.com/services/load-testing).

Usually, the Green cluster is exposed on the App Gateway or External LB with an internal URL, that's not visible for external users.

This test/validation stage is used as a trigger for the [next state](#t3-traffic-switch-to-the-green-cluster) of the pattern.

#### T3: Traffic Switch to the green cluster

After the sync is complete and Green cluster is validated at platform and application level, then it's ready to be promoted as the primary cluster to start receiving the live traffic. The switch is performed at the networking level. Often the workloads are stateless. However, if the workloads are stateful then an additional solution must be implemented to maintain the state and caching during the switch, this is out of scope for this pattern, that's focused on the AKS deployment.

Here's a diagram that shows the target state after the switch is applied:

:::image type="content" source="images/blue-green-aks-deployment-diagram-green-cluster-traffic-switch.png" lightbox="images/blue-green-aks-deployment-diagram-green-cluster-traffic-switch.png" alt-text="Diagram of the T3 stage: green cluster traffic switch.":::

An important point to mention is that this pattern is based on a full switch, meaning 100% of the traffic is routed to the new cluster when the switch is applied, this is mainly related to the fact that the routing is applied at DNS level with a A or CNAME record assignment that's updated to point to the green cluster.,because as per reference implementation there's an application gateway per each cluster. As shared previously in the article, we need to split the description in two section: public facing applications and APIs and private facing applications and APIs.

Here an example of configuration for the private facing endpoints; the proposed solution is based on the usage A records, from a DNS and IP mapping perspective we have the following situation before the switch:

- A record aks.priv.contoso.com  private IP of the blue application gateway
- A record aks-blue.priv.contoso.com  private IP of the blue application gateway
- A record aks-green.priv.contoso.com  private IP of the green application gateway

When the switch is applied the configuration is the following:

- A record aks.priv.contoso.com  private IP of the green application gateway
- A record aks-blue.priv.contoso.com  private IP of the blue application gateway
- A record aks-green.priv.contoso.com  private IP of the green application gateway
The end users of the clusters will see the switch after the TTL and DNS propagation of the records.
Coming to the public facing endpoints, the recommended approach is based on Azure Front Door and Azure Public DNS zone. Here's an example of configuration:
- CNAME record official-aks.contoso.com A record of the autogenerated Azure Front Door Domain, see [here](/azure/frontdoor/front-door-custom-domain) for more details.
- A record aks.contoso.com  public IP of the blue application gateway
- Azure Front Door origin configuration configured to point the aks.contoso.com hostname, [here] the details for the [backend pools](/azure/frontdoor/origin?pivots=front-door-standard-premium) configuration
  - A record aks-blue.contoso.com  public IP of the blue application gateway
  - A record aks-green.contoso.com  public IP of the green application gateway
When the switch is applied the configuration is the following:
- CNAME record official-aks.contoso.com A record of the autogenerated Azure Front Door Domain.
- A record aks.contoso.com  public IP of the greenAs application gateway
- Azure Front Door origin configuration configured to point the aks.contoso.com hostname
  - A record aks-blue.contoso.com  public IP of the blue application gateway
  - A record aks-green.contoso.com  public IP of the green application gateway

Alternative switching, like canary releases, are possible with additional azure services like Azure Front Door or Traffic Manager, but not in the scope of the article, that's mainly focused on the blue-green deployment for AKS at infrastructure level with a standard traffic switch; as reference [here](https://techcommunity.microsoft.com/t5/azure-architecture-blog/blue-green-deployment-with-azure-front-door/ba-p/1609178) you can find an implementation of blue-green traffic switch at Azure Front Door level.

As described in the example, from a networking perspective this pattern is based on the definition of 4 hostnames:

- Official public facing hostname - the official public hostname used by the end users and consumers.
- Cluster hostname - the official hostname used by the consumers of the workloads hosted in the clusters
- Blue Cluster hostname - the dedicated host for the blue cluster
- Green Cluster hostname - the dedicated host for the green cluster

The cluster hostname is the one configured at the application gateway level to manage the ingress traffic, moreover the hostname is also part of the AKS Ingress configuration in order to manage the TLS properly. This host is used only for live transactions and requests.
If the Azure Front Door is also part of the deployment, it's not impacted by the switch because it manages only the official cluster hostname, indeed it provide the proper abstraction for the end-users of the application, that are not impacted by the switch between the blue and green cluster, because the DNS CNAME record points always to the Azure Front Door. In the Azure Front Door are never exposed the blue and green hostnames, because they're used only for internal validation and monitoring.

The Blue and Green cluster hostnames are mainly used fortest and validate the specific cluster, like mentioned in [Step 2](#t2-sync-kubernetes-state-between-blue-and-green-cluster)
 For the testing and validation purpose the hostnames are also exposed at application gateway level with dedicated endpoints and also at AKS ingress controller level to manage the TLS in the proper way.
At this stage the validation is based on the infra and app monitoring metrics and official SLO and SLA, when available. If the validation gate is satisfied then it's possible to move in the [last state](#t4-blue-cluster-is-destroyed) of the pattern.

#### T4: Blue cluster is destroyed

Switching the traffic brings the pattern in the final stage, in which there's still validation and monitoring happening to ensure the green cluster is working as expected with live traffic; it's always important to remember that the validation and monitoring cover both platform and application level.

After this validation is completed, then the blue cluster can be destroyed.
The destruction is a step that's strongly recommended in order to reduce costs and make the proper usage of the elasticity provided by Azure, in particular AKS.

:::image type="content" source="images/blue-green-aks-deployment-diagram-blue-cluster-destroyed.png" lightbox="images/blue-green-aks-deployment-diagram-blue-cluster-destroyed.png" alt-text="Diagram of the T4 stage: the blue cluster is destroyed.":::

### Alternatives

From a pattern perspective there are alternative scenarios to implement a more controlled switch between the cluster. This means that the core pattern remains the same, and the main change is on the traffic switch method. For example, it's possible to have a *canary release* with traffic rules based on:

- percentage of the incoming traffic
- http headers
- Cookies

Another alternative that has more impact on the blast radius of the deployment is to have a ring based deployments. Instead of just blue and green clusters, it's possible to have more clusters called rings. Each ring is large enough for the number of users that have access to the new version/config of the AKS. As for the blue-green pattern described, the rings can be removed to have the proper cost optimization and control.

There are two Azure Services listed in the [Components Section](#components), for which is possible to use also alternative products and/or OSS solutions. These two services are:

- [Application Gateway](https://azure.microsoft.com/services/application-gateway)
- [Container Registry](https://azure.microsoft.com/services/container-registry)

The intent of the article is not to provide a curated list of alternatives but to emphasize that's possible to adopt different components to achieve the same implementation of the pattern.
Just to give some examples, possible alternatives are:

- NGINX, HAProxy, etc.. instead of Application Gateway
- Harbor, etc.. instead of Container Registry

Another alternative is possible also at global traffic switch for public facing endpoints, in the suggested architecture are listed Azure Front Door and Azure DNS as suggested services, anyway based on the scenario and tech stack available is possible to use different load balancing services and DNS services.

## Considerations

The following considerations have their basis on the [Microsoft Azure Well-Architected Framework](/azure/architecture/framework) and [Cloud Adoption Framework](https://docs.microsoft.com/azure/cloud-adoption-framework).

One main consideration is that this pattern can be adopted in a full automated scenario, like a zero-touch deployment. Usually, the basic implementation has a manual trigger to activate the different steps described. Along the way and with the proper maturity and monitoring features, it's possible to automate also the triggers, that means that there are automated testing and specific metrics, SLA and SLO to automatize the triggers.

One important point in this architecture is to have dedicated hostnames for the blue-green clusters and also have a dedicated endpoints configuration on the Gateway/Load Balancer in front of the clusters. This is critical to improve the reliability and validity of the deployment of the new cluster. This way, the validation of the deployment happens with the same architecture and configurations of a standard production cluster.

An additional consideration is related to the scenario in which the AKS Clusters are shared resources for multiple applications, that are managed by different business units; in this case is not rare that the AKS platform itself is managed by a dedicated team, that owns the overall operation and lifecycle of the clusters; this usually is translated in dedicated endpoints in the AKS cluster for admin/ops purpose, in this case the suggested approach is to have a dedicated ingress controller in the AKS clusters to have the proper separation of concerns and reliability.

The blue-green pattern is also an enabler to implement and test BC/DR solutions for AKS and related workloads. In particular it provides the fundamentals aspects to manage multiple clusters, including when they're located in multiple regions.

This architecture also allows for **Cost Optimization**. The blue-green pattern is widely adopted in Azure due to the native elasticity provided by the cloud; this enables the implementation of the proper behaviors to optimize costs in term of operations and cloud consumption; the action that mainly contribute to the costs saving is the removal of the cluster that's no longer need after the deployment of the new version of the cluster.

It's important to highlight that a successful implementation of the pattern is related to the fact that the all the aspects like automation, monitoring and validation need to be applied not only at AKS Platform level, but also at the workloads/apps deployed on top of it; only with the end to tend coverage is it possible to really benefit from the value of the blue-green pattern.

### Reliability

The blue-green pattern has a direct and positive impact on the availability of AKS platform and workloads. In particular the pattern improves the availability during the deployment of the AKS platform changes, in particular downtime is near to zero, though it can be affected by how user sessions are managed. Moreover, the blue-green pattern also provides coverage for reliability during the deployment because by default there's the option to rollback in the previous version of the AKS cluster if something goes wrong in the new cluster version.
Here more detail about the resiliency and availability pillar defined in the [Well Architected Framework](/azure/architecture/framework/resiliency/overview).

### Cost optimization

As described before, one of the main advantages of the blue-green deployment is to maintain a control and optimization of the costs without impacting the resiliency, availability, continuous delivery of the workloads and apps. This is achieved with the automated destruction of the old cluster after that the switch is completed and validated. Another important point to mention is that, to continue to have the same cost baseline, the two clusters are usually hosted in the same subnet. This way, all the network connections and access to the resources/services are the same, that means that all the azure services and resources remain the same during the blue-green deployment.
If we quantify the azure costs to implement this pattern, we do double the costs of the AKS services during the time of the blue-green deployment, but that usually only lasts for a few hours; This also explains the large adoption of this pattern.
If you are curious and want to have more insight about cost optimization you check the [WAF cost optimization pillar](/azure/architecture/framework/cost/overview).

### Operational excellence

Automation, continuous delivery and resilient deployment are fundamental capabilities for modern applications and products. As described in the [Architecture](#architecture), the blue-green pattern brings natively all these capabilities when properly implemented.
One of the key aspects of the Continuous Delivery is to be able to iteratively deliver increments of platform and workloads; with the blue-green pattern for AKS, you can unlock the continuous delivery at the platform level providing a controlled and safe experience.
Resiliency during the deployment is one of the main benefits of the pattern, because natively there's the fallback option of the previous cluster.
Moreover, the adoption of the pattern has a clear advantage on the business continuity testing, because the blue-green pattern introduces the proper level of automation to reduce the effort related to business continuity strategy.
As highlighted in the [workflow](#workflow) steps, the triggers and validation of the blue-green deployment are an extra effort in term of automation and operation to properly manage the deployment. More specifically, it's required to have the proper monitoring and logging in place to capture metrics and events at infra and apps level to determine the health of the deployment. For the platform it's possible to leverage the native Azure monitoring capabilities. For the apps, they need to be designed based on each app context.
The key benefits mentioned previously are discussed in more detail in the [Well Architected Framework](/azure/architecture/framework/devops/overview).

## Potential use cases

This solution describes a generalized architecture pattern that can be used for many different scenarios and industries, like financial services and healthcare, in which application and workload availability is critical. It can be applied in any AKS deployment.

The blue-green deployment pattern for AKS applies to every scenario that requires safe and reliable deployment of the AKS cluster. Some examples are:

- Upgrading the Kubernetes version.
- Upgrading Kubernetes platform components like ingress gateway, service mesh, operators, network policies and so on.
- Rolling back to the previous version of AKS cluster that's still deployed,
without affecting the workloads that are running in the cluster.

## Deploy this scenario

An implemented example and template is available at [AKS Landing Zone Accelerator](AKS-Landing-Zone-Accelerator/Scenarios/BlueGreen-Deployment-for-AKS at main · Azure/AKS-Landing-Zone-Accelerator (github.com)).
The reference implementation is based on the AGIC native add-on for AKS, this means that each cluster has it own application gateway, that means also that the traffic switch is performed via DNS, in particular via CNAME configuration

## Contributors

Principal authors:

- [Vincenzo Morra](https://www.linkedin.com/in/vincenzo-morra-29658a20/?locale=en_US) | SAO Incubation Architect

Other contributors:

- [Scott Simock](https://www.linkedin.com/in/scottsimock) | Cloud Solution Architect
- [Oscar L Pla Alvarez] | Domain Solution Architect

## Next steps

- [IaC](https://docs.microsoft.com/devops/deliver/what-is-infrastructure-as-code)
- [BlueGreen Martin Fowler Article](https://martinfowler.com/bliki/BlueGreenDeployment.html)
- [AKS documentation](https://azure.microsoft.com/services/kubernetes-service)
- [Application Gateway](https://azure.microsoft.com/services/application-gateway)
- [Azure Monitor](https://azure.microsoft.com/services/monitor)

Examples:

- [AKS Landing Zone Accelerator for Blue Green](AKS-Landing-Zone-Accelerator/Scenarios/BlueGreen-Deployment-for-AKS at main · Azure/AKS-Landing-Zone-Accelerator (github.com))

## Related resources

This solution is a generalized architecture pattern, which can be used for many different scenarios and industries. See the following example solutions that build off of this core architecture:

- [AKS baseline for multiregion clusters](/azure/architecture/reference-architectures/containers/aks-multi-region/aks-multi-cluster)
- [AKS Landing Zone Accelerator for Blue Green](AKS-Landing-Zone-Accelerator/Scenarios/BlueGreen-Deployment-for-AKS at main · Azure/AKS-Landing-Zone-Accelerator (github.com))
- [Mission Critical Workloads Pattern](https://docs.microsoft.com/azure/architecture/framework/mission-critical/mission-critical-architecture-pattern)
- [Multi Region WebApp](https://docs.microsoft.com/azure/architecture/example-scenario/sql-failover/app-service-private-sql-multi-region)
