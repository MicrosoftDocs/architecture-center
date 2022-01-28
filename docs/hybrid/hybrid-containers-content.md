

This reference architecture illustrates how developers can create, manage, and monitor deployed containers in the public cloud, across multiple clouds, and on-premises.

![The diagram illustrates a developer team that deploys its container images to a Microsoft Azure Container Registry. Subsequently, the container images are pulled and deployed to either an on-premises or cloud-based Kubernetes cluster. The containers are monitored using Azure Monitor and the container images are scanned and monitored using Azure Container Registry.][architectural-diagram]

*Download a [Visio file][architectural-diagram-visio-source] of this architecture.*

Typical uses for this architecture include:

- Web applications with internal and external components that deploy both to the public cloud and on-premises by using shared container images.
- Modern deployment testing cycles with quality analysis, testing, development, or staging that's hosted on-premises and in the public cloud.

## Architecture

- **[Microsoft Azure Container Registry (ACR)][azure-container-registry]**. ACR is a service that creates a managed registry. ACR builds, stores, and manages container images and can store containerized machine learning models.
- **[Azure Kubernetes Service (AKS)][azure-kubernetes-service]**. AKS is a managed service that offers a managed Kubernetes cluster with elastic scale-out functionality.
- **[Azure Container Instances][azure-container-instances]**. Azure Container Instances runs containers on-demand in a serverless Microsoft Azure environment. Azure Container Instances is a low-friction method of running containers that doesn't require a full Docker host or Kubernetes installation.
- **[Azure Cosmos DB][azure-cosmos-db]**. Azure Cosmos DB is a multiple model database that can serve data elastically at a massive scale. Azure Cosmos DB was designed for applications that are globally distributed in a multi-write model.
- **[Azure Key Vault][azure-key-vault]**. Azure Key Vault is a hardware-backed credential management service that has tight integration with Microsoft identity services and compute resources.
- **[Azure Policy][azure-policy]**. Azure Policy enforces standards and assesses compliance for targeted resources deployed to Azure.
- **[Azure Private Link][azure-private-link]**. Azure Private Link creates a private endpoint in your virtual network that you can use to communicate with Azure platform as a service (PaaS) without exposing your service to the public internet.
- **[Azure Monitor][azure-monitor]**. Azure Monitor is an all-encompassing suite of monitoring services for applications that deploy both in Azure and on-premises.
- **[Microsoft Defender for Cloud][azure-security-center]**. Microsoft Defender for Cloud is a unified security management and threat protection system for workloads across on-premises, multiple clouds, and Azure.
- **[On-premises Kubernetes cluster][kubernetes]**. In this architecture, a local Kubernetes cluster is used to run multiple containers on-premises.

## Recommendations

### Azure Container Registry

ACR is an enterprise container registry that can implement [common best practices][azure-container-registry-best-practices] by protecting images from unauthorized access, replicating images across multiple geographies, preventing unnecessary ingress/egress, and optimizing costs. Additionally, ACR supports [turnkey geo-replication][azure-container-registry-geo-replication] across multiple Azure regions, which helps you minimize latency between ACR, your container hosts, and your development team.

ACR includes a suite of tasks, referred to as [*ACR Tasks*][azure-container-registry-tasks], that can manage cloud-based container image building and maintenance across a variety of operating systems. ACR Tasks can be triggered manually, by a change to source control, by a change to the base container image, or on a fixed schedule. The following are scenarios in which you could use ACR Tasks:

- An Internet of Things (IoT) developer is building container images to run on ARM-based IoT devices. The developer might be using a Linux or macOS operating system to develop the software, but they will need to perform the build on an ARM platform.
- A software as a service (SaaS) development team is building software on Windows computers that will run their container images on Linux hosts. The team would like its build to be performed on a Linux host.
- An open source project maintainer is building a container image that augments a well-known operating system base image. The maintainer will likely want their container image to update every time the base image updates.

> [!NOTE]
> ACR Tasks can standardize the build environment and perform continuous integration of your container images.

### Azure Container Instances

Azure Container Instances is a low-friction, serverless compute environment for containerized applications. Azure Container Instances is an excellent choice for container deployment because of its low management overhead and quick startup times. Container images that are stored in ACR can [deploy directly to Azure Container Instances container groups][azure-container-instances-deploy-acr].

In this reference, Azure Container Instances container groups are utilized as *virtual nodes* for an [Azure Kubernetes Service][azure-kubernetes-service] cluster. AKS uses [virtual nodes][azure-kubernetes-service-virtual-nodes] to register a virtual pod with unlimited capacity and the ability to dispatch pods by using Azure Container Instances container groups. This is ideal for scenarios where you want very fast provisioning of individual pods and only want to pay for the execution time per second.

## Scalability considerations

- Customer-facing containerized web applications benefit from variable scales. You can use services such as Azure Container Instances and AKS to dynamically scale out to meet anticipated or measured demand. Additionally, you can use services such as [Azure Functions][azure-functions] and [Azure App Service][azure-app-service] to run container images at scale.
- Internal application usage is more predictable and can run on an existing Kubernetes cluster. If you're interested in deploying Azure-managed services on-premises, consider:
  - [Connecting a Kubernetes cluster to Azure Arc][azure-arc-kubernetes-connect].
  - [Deploying Functions or App Service in Azure Stack Hub][azure-stack-hub-azure-app-service].
- [Azure Cosmos DB][azure-cosmos-db] automatically scales service resources to meet the storage needs of your application in an elastic manner. For throughput, you can choose to [pre-provision throughput][azure-cosmos-db-provisioned-throughput] or [operate Azure Cosmos DB as a serverless service][azure-cosmos-db-serverless]. If your workload has variable or unpredictable demands, you can also choose to provision your throughput [using autoscale][azure-cosmos-db-autoscale].

## Availability considerations

- Modern applications typically include a website, one or more HTTP APIs, and some connection to a data store. Applications within a container image should be designed to be stateless for maximum horizontal scale and availability. Any data should be stored in a separate service that has similar availability. For guidance on designing an application that can scale to thousands of nodes, refer to the [performance efficiency section][azure-well-architected-framework-performance] of the [Azure Well-Architected Framework][azure-well-architected-framework].
- AKS has a [reference architecture baseline][azure-kubernetes-service-baseline] that defines each of the Well-Architected Framework categories and recommends an implementation in line with the category.
- To reduce the impact of large pulls of container images, deploy ACR in a region that's closest to the development team and the production compute services. Consider a geo-replicated ACR deployment for distributed teams and distributed production containers.
- [Azure Cosmos DB][azure-cosmos-db] is a database service that supports [turnkey global distribution][azure-cosmos-db-global-distribution] and supports [automatic failover][azure-cosmos-db-automatic-failover] across multiple regions. Azure Cosmos DB also has the ability to enable [multiple region writes][azure-cosmos-db-multi-write] and dynamically [add or remove regions][azure-cosmos-db-add-regions].

## Manageability considerations

- Consider using [Azure Resource Manager templates][azure-container-instances-arm-templates] to deploy Azure Container Instance container groups in a repeatable fashion for multiple region deployments and large-scale orchestration. You can similarly use Azure Resource Manager templates to deploy [Azure Kubernetes Service][azure-kubernetes-service-arm-templates], [Azure Key Vault][azure-key-vault-arm-templates], and [Azure Cosmos DB][azure-cosmos-db-arm-templates].
- Consider utilizing [Azure role-based access control (Azure RBAC)][azure-role-based-access-control] to prevent users from accidentally creating or deleting container instances without permission.
- Use Azure Monitor to [monitor metrics and logs for both on-premises and remote containers][azure-monitor-containers], [analyze the data using queries][azure-monitor-containers-analyze], and [create alerts for abnormal situations][azure-monitor-containers-alert].
- Use Azure Policy to [implement enforcement of a set of rules][azure-policy-kubernetes] for clusters and pods deployed to Kubernetes Service or an Azure Arc-enabled Kubernetes cluster.

## DevOps considerations

- [Use ACR Tasks][azure-container-registry-tasks-tutorial] to automate the build of container images on a schedule or when changes are made to the source code. Additionally, consider using ACR Tasks to automatically [update container images as base images are patched and updated][azure-container-registry-tasks-base-update].
- The AKS team has developed [GitHub actions][azure-kubernetes-service-gitops] that can assist with implementing GitOps and facilitate deployments from ACR to AKS clusters.
- If your Kubernetes cluster is [attached to Azure Arc][azure-arc-kubernetes], you can [manage your Kubernetes cluster using GitOps][azure-arc-kubernetes-gitops]. To review best practices for connecting a hybrid Kubernetes cluster to Azure Arc, refer to the [Azure Arc hybrid management and deployment for Kubernetes clusters][reference-architecture-azure-arc-kubernetes-enabled] reference architecture.

## Security considerations

- Use [Azure Private Link][azure-private-link] to communicate to and across services in your virtual network. This will route traffic through specific subnets to reach the individual Azure services directly and protect your data from inadvertent exposure to the public internet.

## Cost considerations

- Use the [Azure pricing calculator][azure-pricing-calculator] to estimate costs.
- If your development team and production instances are in a single region, consider placing the Container Registry resource in the same region. This will allow you to minimize container push and pull latency and avoid the additional costs associated with the [Premium Azure Container Registry service tier][azure-container-registry-skus].
- Configuring ACR to use an [Azure Virtual Network][azure-virtual-network] through an [Azure Private Link][azure-private-link] service endpoint requires the ACR instance to be deployed in the Premium tier.
- AKS offers free cluster management. Billing is isolated to the compute, storage, and networking resources used by AKS to host nodes. Refer to [Azure Virtual Machine][azure-virtual-machines-pricing] or [Azure Container Instances][azure-container-instances-pricing] pricing to review specific pricing details for each compute service.
- If you require a specific uptime service-level agreement (SLA), you can enable the [uptime SLA optional feature][azure-kubernetes-service-uptime-sla] of AKS.
- Azure Container Instances resources are billed per second, based on an allocation of virtual CPU and memory resources, to the container group. Allocating unnecessary compute resources can exponentially increase the costs required to run this architecture solution. Cost monitoring and optimization is a continuous process that should be conducted at regular intervals throughout the lifetime of your deployment. For further guidance on minimizing Azure Container Instances operational costs, refer to the [cost optimization section][azure-well-architected-framework-performance] of the [Azure Well-Architected Framework][azure-well-architected-framework].

## Next steps

- [Learn more about Azure Container Registry][azure-container-registry]
- [Learn more about Azure Kubernetes Service][azure-kubernetes-service]
- [Learn more about Azure Policy][azure-policy]
- [Learn more about Azure Monitor][azure-monitor]

[architectural-diagram]: ./images/hybrid-containers.png
[architectural-diagram-visio-source]: https://arch-center.azureedge.net/hybrid-containers.vsdx
[azure-app-service]: /azure/app-service/
[azure-arc-kubernetes]: /azure/azure-arc/kubernetes/
[azure-arc-kubernetes-connect]: /azure/azure-arc/kubernetes/connect-cluster
[azure-arc-kubernetes-gitops]: /azure/azure-arc/kubernetes/use-gitops-connected-cluster
[azure-arc-server]: /azure/azure-arc/servers/agent-overview
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
[azure-kubernetes-service-baseline]: ../reference-architectures/containers/aks/secure-baseline-aks.yml
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
[azure-well-architected-framework-cost]: /azure/architecture/framework/cost/overview
[kubernetes]: https://kubernetes.io
[reference-architecture-azure-arc-kubernetes-enabled]: arc-hybrid-kubernetes.yml
