This reference architecture illustrates how developers can create, manage, and monitor deployed containers in the public cloud, across multiple clouds, and on-premises.

## Architecture

[ ![The diagram illustrates a developer team that deploys its container images to a Microsoft Azure Container Registry. Subsequently, the container images are pulled and deployed to either an on-premises or cloud-based Kubernetes cluster. The containers are monitored using Azure Monitor and the container images are scanned and monitored using Azure Container Registry.](./images/hybrid-containers.svg)](./images/hybrid-containers.svg#lightbox)

*Download a [Visio file][architectural-diagram-visio-source] of this architecture.*

### Components

- [Azure Container Registry](https://azure.microsoft.com/products/container-registry) is a service that creates a managed registry. It builds, stores, and manages container images and can store containerized machine learning models.
- [Azure Kubernetes Service (AKS)](https://azure.microsoft.com/products/kubernetes-service) is a managed service that offers a managed Kubernetes cluster with elastic scale-out functionality. In this architecture, a local Kubernetes cluster is used to run multiple containers on-premises.
- [Azure Container Instances](https://azure.microsoft.com/products/container-instances) runs containers on-demand in a serverless Azure environment. Azure Container Instances is a low-friction method of running containers that doesn't require a full Docker host or Kubernetes installation.
- [Azure Cosmos DB](https://azure.microsoft.com/products/cosmos-db) is a multiple model database that can serve data elastically at a massive scale. It was designed for applications that are globally distributed in a multi-write model.
- [Azure Key Vault](https://azure.microsoft.com/products/key-vault) is a hardware-backed credential management service that has tight integration with Microsoft identity services and compute resources.
- [Azure Policy](https://azure.microsoft.com/products/azure-policy) enforces standards and assesses compliance for targeted resources that are deployed to Azure.
- [Azure Private Link](https://azure.microsoft.com/products/private-link) creates a private endpoint in your virtual network that you can use to communicate with Azure platform as a service (PaaS) without exposing your service to the public internet.
- [Azure Monitor](https://azure.microsoft.com/products/monitor) is an all-encompassing suite of monitoring services for applications that deploy in Azure or on-premises.
- [Microsoft Defender for Cloud](https://azure.microsoft.com/products/defender-for-cloud) is a unified security management and threat protection system for workloads across on-premises, multiple clouds, and Azure.

## Scenario details

### Potential use cases

Typical uses for this architecture include:

- Web applications that have internal and external components that deploy both to the public cloud and on-premises by using shared container images.
- Modern deployment testing cycles with quality analysis, testing, development, or staging that's hosted on-premises and in the public cloud.

## Recommendations

### Azure Container Registry

Azure Container Registry is an enterprise container registry that can implement [common best practices][azure-container-registry-best-practices] by protecting images from unauthorized access, replicating images across multiple geographies, preventing unnecessary ingress/egress, and optimizing costs. It supports [turnkey geo-replication][azure-container-registry-geo-replication] across multiple Azure regions, which helps you minimize latency between Azure Container Registry, your container hosts, and your development team.

Azure Container Registry includes a suite of tasks, referred to as [*ACR Tasks*][azure-container-registry-tasks], that can manage cloud-based container image building and maintenance across a variety of operating systems. ACR Tasks can be triggered manually, by a change to source control, by a change to the base container image, or on a fixed schedule. The following are scenarios in which you could use ACR Tasks:

- An Internet of Things (IoT) developer is building container images to run on ARM-based IoT devices. The developer might be using a Linux or macOS operating system to develop the software, but needs to perform the build on an ARM platform.
- A software as a service (SaaS) development team builds software on Windows computers that run container images on Linux hosts. The team wants its builds to be done on a Linux host.
- An open source project maintainer is building a container image that augments a well-known operating system base image. The maintainer wants the container image to update every time that the base image updates.

> [!NOTE]
> ACR Tasks can standardize the build environment and perform continuous integration of your container images.

### Azure Container Instances

Azure Container Instances is a low-friction, serverless compute environment for containerized applications. It's an excellent choice for container deployment because of its low management overhead and quick startup times. Container images that are stored in Azure Container Registry can [deploy directly to Azure Container Instances container groups][azure-container-instances-deploy-acr].

In this architecture, Azure Container Instances container groups are used as *virtual nodes* for an [Azure Kubernetes Service][azure-kubernetes-service] cluster. AKS uses [virtual nodes][azure-kubernetes-service-virtual-nodes] to register a virtual pod with unlimited capacity and the ability to dispatch pods by using Azure Container Instances container groups. This is ideal when you want fast provisioning of individual pods and only want to pay for the execution time per second.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

- Modern applications typically include a website, one or more HTTP APIs, and a connection to a data store. Applications within a container image should be stateless for maximum horizontal scale and availability. Data should be stored in a separate service that has similar availability. For guidance on designing an application that can scale to thousands of nodes, see the [performance efficiency section][azure-well-architected-framework-performance] of the [Azure Well-Architected Framework][azure-well-architected-framework].
- AKS has a [reference architecture baseline][azure-kubernetes-service-baseline] that defines each of the Well-Architected Framework categories and recommends an implementation that's in line with the category.
- To reduce the impact of large pulls of container images, deploy Azure Container Registry in a region that's closest to the development team and to the production compute services. Consider a geo-replicated Azure Container Registry deployment for distributed teams and distributed production containers.
- [Azure Cosmos DB][azure-cosmos-db] is a database service that supports [turnkey global distribution][azure-cosmos-db-global-distribution] and supports [automatic failover][azure-cosmos-db-automatic-failover] across multiple regions. Azure Cosmos DB also has the ability to enable [multiple region writes][azure-cosmos-db-multi-write] and dynamically [add or remove regions][azure-cosmos-db-add-regions].

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

Use [Azure Private Link][azure-private-link] to communicate to and across services in your virtual network. By doing this, you route traffic through specific subnets to reach the individual Azure services directly and protect your data from inadvertent exposure to the public internet.

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

- Use the [Azure pricing calculator][azure-pricing-calculator] to estimate costs.
- If your development team and production instances are in a single region, consider placing the Container Registry resource in the same region. By doing this, you minimize container push and pull latency and avoid the higher costs of the [Premium Azure Container Registry service tier][azure-container-registry-skus].
- Configuring Azure Container Registry to use an [Azure Virtual Network][azure-virtual-network] through an [Azure Private Link][azure-private-link] service endpoint requires that the Azure Container Registry instance is deployed in the Premium tier.
- AKS offers free cluster management. You're only billed for the compute, storage, and networking resources that AKS uses to host nodes. See [Azure Virtual Machine][azure-virtual-machines-pricing] or [Azure Container Instances][azure-container-instances-pricing] pricing to review pricing for each compute service.
- If you require a specific uptime service-level agreement (SLA), you can enable the [uptime SLA optional feature][azure-kubernetes-service-uptime-sla] of AKS.
- Azure Container Instances resources are billed by the second, based on an allocation of virtual CPU and memory resources to the container group. Allocating unnecessary compute resources can significantly increase the costs of running this architecture solution. Cost monitoring and optimization is a continuous process that should be conducted at regular intervals throughout the lifetime of your deployment. For more information on minimizing Azure Container Instances operational costs, see the [cost optimization section][azure-well-architected-framework-performance] of the [Azure Well-Architected Framework][azure-well-architected-framework].

### Operational Excellence

Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Overview of the operational excellence pillar](/azure/architecture/framework/devops/overview).

#### Manageability

- Consider using [Azure Resource Manager templates][azure-container-instances-arm-templates] to deploy Azure Container Instance container groups in a repeatable fashion for multiple region deployments and large-scale orchestration. You can similarly use Azure Resource Manager templates to deploy [Azure Kubernetes Service][azure-kubernetes-service-arm-templates], [Azure Key Vault][azure-key-vault-arm-templates], and [Azure Cosmos DB][azure-cosmos-db-arm-templates].
- Consider using [Azure role-based access control (Azure RBAC)][azure-role-based-access-control] to prevent users from accidentally creating or deleting container instances without permission.
- Use Azure Monitor to [monitor metrics and logs for both on-premises and remote containers][azure-monitor-containers], [analyze the data using queries][azure-monitor-containers-analyze], and [create alerts for abnormal situations][azure-monitor-containers-alert].
- Use Azure Policy to [implement enforcement of a set of rules][azure-policy-kubernetes] for clusters and pods that are deployed to Kubernetes Service or an Azure Arc-enabled Kubernetes cluster.

#### DevOps

- [Use ACR Tasks][azure-container-registry-tasks-tutorial] to automate the build of container images on a schedule or when changes are made to the source code.
- Consider using ACR Tasks to automatically [update container images as base images are patched and updated][azure-container-registry-tasks-base-update].
- The AKS team has developed [GitHub actions][azure-kubernetes-service-gitops] that can assist with implementing GitOps and can facilitate deployments from Azure Container Registry to AKS clusters.
- If your Kubernetes cluster is [attached to Azure Arc][azure-arc-kubernetes], you can [manage your Kubernetes cluster by using GitOps][azure-arc-kubernetes-gitops]. To review best practices for connecting a hybrid Kubernetes cluster to Azure Arc, see the [Azure Arc hybrid management and deployment for Kubernetes clusters][reference-architecture-azure-arc-kubernetes-enabled] reference architecture.

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview).

- Customer-facing containerized web applications benefit from variable scales. You can use services such as Azure Container Instances and AKS to dynamically scale out to meet anticipated or measured demand. You can also use services such as [Azure Functions][azure-functions] and [Azure App Service][azure-app-service] to run container images at scale.
- Internal application usage is more predictable and can run on an existing Kubernetes cluster. If you're interested in deploying Azure-managed services on-premises, consider:
  - [Connecting a Kubernetes cluster to Azure Arc][azure-arc-kubernetes-connect].
  - [Deploying Functions or App Service in Azure Stack Hub][azure-stack-hub-azure-app-service].
- [Azure Cosmos DB][azure-cosmos-db] automatically scales service resources to meet the storage needs of your application in an elastic manner. For throughput, you can choose to [pre-provision throughput][azure-cosmos-db-provisioned-throughput] or [operate Azure Cosmos DB as a serverless service][azure-cosmos-db-serverless]. If your workload has variable or unpredictable demands, you can also choose to provision your throughput [using autoscale][azure-cosmos-db-autoscale].
- Modern applications typically include a website, one or more HTTP APIs, and a connection to a data store. Applications within a container image should be stateless for maximum horizontal scale and availability. Data should be stored in a separate service that has similar availability. For guidance on designing an application that can scale to thousands of nodes, see the [performance efficiency section][azure-well-architected-framework-performance] of the [Azure Well-Architected Framework][azure-well-architected-framework].
- AKS has a [reference architecture baseline][azure-kubernetes-service-baseline] that defines each of the Well-Architected Framework categories and recommends an implementation that's in line with the category.
- To reduce the impact of large pulls of container images, deploy Azure Container Registry in a region that's closest to the development team and to the production compute services. Consider a geo-replicated Azure Container Registry deployment for distributed teams and distributed production containers.
- [Azure Cosmos DB][azure-cosmos-db] is a database service that supports [turnkey global distribution][azure-cosmos-db-global-distribution] and supports [automatic failover][azure-cosmos-db-automatic-failover] across multiple regions. Azure Cosmos DB also has the ability to enable [multiple region writes][azure-cosmos-db-multi-write] and dynamically [add or remove regions][azure-cosmos-db-add-regions].

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Pieter de Bruin](https://www.linkedin.com/in/pieterjmdebruin) | Senior Program Manager

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Azure Container Registry documentation][azure-container-registry]
- [Azure Kubernetes Service documentation][azure-kubernetes-service]
- [Azure Policy documentation][azure-policy]
- [Azure Monitor documentation][azure-monitor]
- [Azure Container Instances documentation][azure-container-instances]
- [Azure Cosmos DB documentation][azure-cosmos-db]
- [Azure Key Vault documentation][azure-key-vault]
- [Azure Private Link documentation][azure-private-link]
- [Microsoft Defender for Cloud documentation][azure-security-center]
- [Kubernetes documentation][kubernetes]

## Related resources

Related hybrid guidance:

- [Hybrid architecture design](hybrid-start-here.md)
- [Azure hybrid options](../guide/technology-choices/hybrid-considerations.yml)
- [Hybrid app design considerations](/hybrid/app-solutions/overview-app-design-considerations)
- [Deploy a hybrid app with on-premises data that scales cross-cloud](deployments/solution-deployment-guide-cross-cloud-scaling-onprem-data.md)

Related architectures:

- [Enterprise infrastructure as code using Bicep and Azure Container Registry](../guide/azure-resource-manager/advanced-templates/enterprise-infrastructure-bicep-container-registry.yml)
- [Baseline architecture for an Azure Kubernetes Service (AKS) cluster](../reference-architectures/containers/aks/baseline-aks.yml)
- [Microservices architecture on Azure Kubernetes Service](../reference-architectures/containers/aks-microservices/aks-microservices.yml)
- [Advanced Azure Kubernetes Service (AKS) microservices architecture](../reference-architectures/containers/aks-microservices/aks-microservices-advanced.yml)
- [GitOps for Azure Kubernetes Service](../example-scenario/gitops-aks/gitops-blueprint-aks.yml)
- [Monitor a microservices architecture in Azure Kubernetes Service (AKS)](../microservices/logging-monitoring.yml)
- [Enterprise monitoring with Azure Monitor](../example-scenario/monitoring/enterprise-monitoring.yml)

[architectural-diagram-visio-source]: https://arch-center.azureedge.net/hybrid-containers.vsdx
[azure-app-service]: /azure/app-service/
[azure-arc-kubernetes]: /azure/azure-arc/kubernetes/
[azure-arc-kubernetes-connect]: /azure/azure-arc/kubernetes/connect-cluster
[azure-arc-kubernetes-gitops]: /azure/azure-arc/kubernetes/use-gitops-connected-cluster
[azure-container-instances]: /azure/container-instances/
[azure-container-instances-arm-templates]: /azure/templates/microsoft.containerinstance/containergroups
[azure-container-instances-deploy-acr]: /azure/container-instances/container-instances-tutorial-prepare-app
[azure-container-instances-pricing]: https://azure.microsoft.com/pricing/details/container-instances/
[azure-container-registry]: /azure/container-registry/
[azure-container-registry-best-practices]: /azure/container-registry/container-registry-best-practices
[azure-container-registry-geo-replication]: /azure/container-registry/container-registry-geo-replication
[azure-container-registry-skus]: /azure/container-registry/container-registry-skus
[azure-container-registry-tasks]: /azure/container-registry/container-registry-tasks-overview
[azure-container-registry-tasks-base-update]: /azure/container-registry/container-registry-tasks-base-images
[azure-container-registry-tasks-tutorial]: /azure/container-registry/container-registry-tutorial-quick-task
[azure-cosmos-db]: /azure/cosmos-db/
[azure-cosmos-db-add-regions]: /azure/cosmos-db/how-to-manage-database-account#addremove-regions-from-your-database-account
[azure-cosmos-db-arm-templates]: /azure/cosmos-db/resource-manager-samples
[azure-cosmos-db-automatic-failover]: /azure/cosmos-db/how-to-manage-database-account#automatic-failover
[azure-cosmos-db-autoscale]: /azure/cosmos-db/provision-throughput-autoscale
[azure-cosmos-db-global-distribution]: /azure/cosmos-db/global-dist-under-the-hood
[azure-cosmos-db-multi-write]: /azure/cosmos-db/how-to-manage-database-account#configure-multiple-write-regions
[azure-cosmos-db-provisioned-throughput]: /azure/cosmos-db/set-throughput
[azure-cosmos-db-serverless]: /azure/cosmos-db/throughput-serverless
[azure-functions]: /azure/azure-functions/
[azure-key-vault]: /azure/key-vault/
[azure-key-vault-arm-templates]: /azure/key-vault/secrets/quick-create-template
[azure-kubernetes-service]: /azure/aks/
[azure-kubernetes-service-arm-templates]: /azure/aks/kubernetes-walkthrough-rm-template
[azure-kubernetes-service-baseline]: ../reference-architectures/containers/aks/baseline-aks.yml
[azure-kubernetes-service-gitops]: /azure/aks/kubernetes-action
[azure-kubernetes-service-uptime-sla]: /azure/aks/uptime-sla
[azure-kubernetes-service-virtual-nodes]: /azure/aks/virtual-nodes-portal
[azure-monitor]: /azure/azure-monitor/
[azure-monitor-containers]: /azure/azure-monitor/insights/container-insights-overview
[azure-monitor-containers-analyze]: /azure/azure-monitor/insights/container-insights-log-search
[azure-monitor-containers-alert]: /azure/azure-monitor/insights/container-insights-log-alerts
[azure-policy]: /azure/governance/policy/
[azure-policy-kubernetes]: /azure/governance/policy/concepts/policy-for-kubernetes
[azure-pricing-calculator]: https://azure.microsoft.com/pricing/calculator/
[azure-private-link]: /azure/private-link/
[azure-role-based-access-control]: /azure/role-based-access-control/
[azure-security-center]: /azure/security-center/
[azure-stack-hub-azure-app-service]: /azure-stack/operator/azure-stack-app-service-deploy
[azure-virtual-machines-pricing]: https://azure.microsoft.com/pricing/details/virtual-machines/
[azure-virtual-network]: /azure/virtual-network/
[azure-well-architected-framework]: /azure/architecture/framework
[azure-well-architected-framework-performance]: /azure/architecture/framework/#performance-efficiency
[kubernetes]: https://kubernetes.io
[reference-architecture-azure-arc-kubernetes-enabled]: arc-hybrid-kubernetes.yml
