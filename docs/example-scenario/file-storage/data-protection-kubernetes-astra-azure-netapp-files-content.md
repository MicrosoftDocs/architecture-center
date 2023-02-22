This article outlines a solution for managing and performing stateful backups of containerized applications and their resources. The solution uses NetApp Astra Control Service and is appropriate for stateful applications that run on Azure Kubernetes Service (AKS).

## Architecture

:::image type="content" source="./media/data-protection-kubernetes-astra-azure-netapp-files-architecture.svg" alt-text="Architecture diagram that shows how to deploy AKS with Astra Control Service when AKS and Azure NetApp Files are in separate virtual networks." border="false" lightbox="./media/data-protection-kubernetes-astra-azure-netapp-files-architecture.svg":::

*Download a [Visio file][Visio version of architecture diagram] of this architecture.*

### Dataflow

1. An Azure NetApp Files account is created on an Azure subscription, and capacity pools are defined. These pools map to service levels that the implementation needs, such as Standard, Premium, and Ultra.

1. One or more AKS clusters are deployed. The clusters need to be:

   - In a region where AKS and Azure NetApp Files are available. For regions where these products are available, see [Products available by region][Products available by region].
   - In a virtual network that has direct access to a subnet that's delegated for Azure NetApp Files. For more information, see [Guidelines for Azure NetApp Files network planning][Guidelines for Azure NetApp Files network planning - Subnets].

1. A user signs up for an Astra Control Service account. Astra Control Service uses a *service principal* that has contributor access to locate the AKS clusters. A service principal is an Azure service account. Astra Control Service uses Astra Trident to create Kubernetes `StorageClass` objects that map to the Azure NetApp Files capacity pools. The mapping takes into account the service level of the capacity pools. This step doesn't use Azure or Kubernetes role-based access control.

1. The user installs applications on the AKS clusters. Possible deployment methods include Helm charts, operators, and YAML manifests that are grouped by labels or namespaces. Astra Control Service provisions persistent volumes on the `StorageClass` objects.

1. Astra Control Service manages applications and their associated resources, such as pods, services, deployments, and `PersistentVolumeClaim` (PVC) objects. Users define applications by using one of these methods:

   - Confining them to a namespace
   - Using a custom Kubernetes label to group resources
   - Deploying them with Helm3 in a namespace

   Astra Control Service orchestrates [point-in-time snapshots][What volume snapshots are], [backup policies][Understand Azure NetApp Files backup], and [instant active clones][Restoring (cloning) an online snapshot to a new volume] to help protect application workloads. Astra Control Service achieves this protection by:

    - Creating Astra Control Service protection policies that specify a schedule and backup target. These policies make it possible to automatically back up applications.
    - Taking snapshots on demand for individual applications.
    - Making instantaneous backups or clones for individual applications.

   When disasters or app failures occur, backups and snapshots restore applications' state. Users can clone and migrate apps across namespaces and AKS clusters. The clusters can be in the same or separate regions.

### Components

- [AKS][AKS] is a fully managed Kubernetes service that makes it easy to deploy and manage containerized applications. AKS offers serverless Kubernetes technology, an integrated continuous integration and continuous delivery (CI/CD) experience, and enterprise-grade security and governance.
- [Azure NetApp Files][Azure NetApp Files service page] is an Azure storage service. This service provides enterprise-grade network file system (NFS) and server message block (SMB) file shares. Azure NetApp Files makes it easy to migrate and run complex, file-based applications with no code changes. This service is well suited for users with persistent volumes in Kubernetes environments.
- [Azure Virtual Network][Azure Virtual Network] is the fundamental building block for private networks in Azure. Through Virtual Network, Azure resources like virtual machines can securely communicate with each other, the internet, and on-premises networks.
- [Astra Control Service][NetApp Astra Control Service] is a fully managed application-aware data management service. Astra Control Service helps you manage, protect, and move data-rich Kubernetes workloads in public clouds and on-premises environments. This service provides data protection, disaster recovery, and migration for Kubernetes workloads. Astra Control Service uses the industry-leading [data management technology of Azure NetApp Files for snapshots, backups, cross-region replication, and cloning][How Azure NetApp Files snapshots work].

### Alternatives

You can use a custom multi-pronged approach to separately back up or replicate persistent volumes, Kubernetes resources, and other configuration state resources that you need when you restore an application. But this approach can be:

- Cumbersome.
- Difficult to make compatible with all apps.
- Difficult to scale across the multiple apps and environments that a typical enterprise has.

In certain environments, you can reduce costs by avoiding cross-peered virtual network traffic. To eliminate this traffic, simplify the solution. Specifically, bring the AKS clusters and the subnet that you delegate for Azure NetApp Files into the same virtual network, as this diagram illustrates:

:::image type="content" source="./media/data-protection-kubernetes-astra-azure-netapp-files-single.svg" alt-text="Architecture diagram that shows how to use AKS with Astra Control Service in a single virtual network." border="false" lightbox="./media/data-protection-kubernetes-astra-azure-netapp-files-single.svg":::

*Download a [Visio file][Visio version of architecture diagram that uses a single virtual network] of this architecture.*

## Scenario details

With containerized applications, it can be challenging to protect data and perform stateful backups. When you deploy business-critical workloads on Kubernetes, application backup and recovery should be:

- Simple. Establishing data protection policies and on-demand backups should be intuitive. These policies and backups shouldn't be dependent on the details of the underlying infrastructure.
- Portable. To make cross-region mobility possible for applications, multiple Kubernetes clusters should be able to consume the backups.
- Application-aware. Your solution should protect the entire application, including standard Kubernetes resources like secrets, `ConfigMap` objects, and persistent volumes. You also need to protect custom Kubernetes resources. When possible, backup and recovery procedures should quiesce the application. This practice prevents the loss of in-flight data during backups.

[NetApp Astra Control Service][NetApp Astra Control Service] is a solution for performing stateful backups that helps you meet these goals. Astra Control Service offers data protection, disaster recovery, and application mobility capabilities. It provides stateful AKS workloads with a rich set of storage and application-aware data management services. The data protection technology of Azure NetApp Files underlies these services.

### Potential use cases

This solution applies to systems that run stateful applications:

- Continuous integration (CI) systems such as Jenkins
- Database workloads like MySQL, MongoDB, and PostgreSQL
- AI and machine-learning components such as TensorFlow and PyTorch
- Elasticsearch deployments
- Kafka applications
- Source code management platforms like GitLab

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

When you deploy an AKS cluster, you deploy it in a single region. To protect application workloads, it's best to deploy the workloads across [multiple AKS clusters that span multiple regions][AKS baseline for multiregion clusters]. Factors that affect deployment include [AKS region availability][Region availability] and Azure [paired regions][Cross-region replication in Azure: Business continuity and disaster recovery]. When you deploy clusters across multiple availability zones, you distribute nodes across multiple zones within a single region. This distribution of AKS cluster resources improves cluster availability because the clusters are resilient to the failure of a specific zone.

Azure NetApp Files is highly available by design. It's built on a highly available bare-metal fleet of all flash storage systems. For this service's availability guarantee, see [SLA for Azure NetApp Files][SLA for Azure NetApp Files].

Azure NetApp Files supports cross-region replication for disaster recovery. You can replicate volumes between Azure region pairs continuously. For more information about cross-region replication, see these resources:

- For general information, see [Cross-region replication of Azure NetApp Files volumes][Cross-region replication of Azure NetApp Files volumes].
- For requirements for cross-region replication, see [Manage disaster recovery using cross-region replication][Manage disaster recovery using cross-region replication].
- For information about configuring cross-region replication, see [Create volume replication for Azure NetApp Files][Create volume replication for Azure NetApp Files].

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

Use the [Azure Pricing calculator][Azure Pricing calculator] to estimate the cost of the following components:

- AKS
- Azure NetApp Files
- Virtual Network

For Astra Control Service pricing plans, see [Pricing][NetApp BlueXP pricing]. By adopting Astra Control Service, you can focus on your application instead of spending time and resources building custom solutions that don't scale. Astra Control Service is available on [Azure Marketplace][NetApp Astra Control Service].

To run detailed bandwidth and pricing calculations, use the [Azure NetApp Files Performance Calculator][Azure NetApp Files Performance Calculator]. Basic and advanced calculators are available.

### Operational excellence

Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Overview of the operational excellence pillar](/azure/architecture/framework/devops/overview).

When you work with the Kubernetes control plane, it's important to monitor your infrastructure and platform layer. Astra Control Service provides a unified control plane that you can use to define and manage application protection policies across multiple AKS clusters. A [dashboard][View a summary of app and cluster health] provides a way for you to continuously handle workloads across regions. Astra Trident also provides a rich set of [Prometheus metrics][Monitor Astra Trident] that you can use to monitor provisioned storage.

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview).

AKS clusters can add extra worker nodes to increase scalability. To scale your solution, you can add node pools or scale existing node pools. These steps increase the number of nodes in your cluster, the total number of cores, and the memory that's available for your containerized applications.

In each virtual network, you can only delegate one subnet for Azure NetApp Files.

When you use a basic configuration for Azure NetApp Files network features, there's a limit of 1,000 IP addresses per virtual network. The standard network features configuration doesn't limit the number of IP addresses.  For more information, see [Configurable network features][Configurable network features]. For a complete list of resource limits for Azure NetApp Files, see [Resource limits for Azure NetApp Files][Resource limits for Azure NetApp Files].

Azure NetApp Files offers multiple performance tiers. When you use Astra Control Service to discover AKS clusters, the onboarding process creates curated `StorageClass` objects that map to the Standard, Premium, and Ultra service tiers. When users deploy applications, they choose a storage tier that suits their requirements. Multiple capacity pools can coexist. Provisioned volumes have a performance guarantee that corresponds to the service tier. For a list of service levels that Azure NetApp Files supports, see [Service levels for Azure NetApp Files][Service levels for Azure NetApp Files].

## Deploy this scenario

To implement this solution, you need an Azure account. [Create an account for free][Create an Azure account for free].

To deploy this scenario, follow these steps:

1. [Register the resource provider][Register the resource provider] that makes it possible to use Azure NetApp Files.
1. Review the [Requirements for using Astra Control Service with AKS][Requirements for using Astra Control Service with AKS].
1. Use the Azure portal to [create a NetApp account][Create a NetApp account].
1. [Set up capacity pools][Set up a capacity pool] on the Azure NetApp Files account.
1. [Delegate a subnet][Delegate a subnet to Azure NetApp Files] for Azure NetApp Files.
1. Create a [service principal][Create an Azure service principal] for Astra Control Service to use to discover AKS clusters and perform backup, restore, and data management operations.
1. [Register for Astra Control Service][Register for an Astra Control Service account] by creating a NetApp Cloud Central account.
1. [Add AKS clusters to Astra Control Service][Start managing Kubernetes clusters from Astra Control Service] to start managing applications.
1. [Detect applications][Start managing apps] in Astra Control Service. The way you discover and manage applications depends on the way you deploy and identify them. Typical identification strategies include grouping application objects in a dedicated namespace, assigning labels to objects that make up an application, and using Helm charts. Astra Control Service supports all three strategies.
1. [Establish protection policies][Protect apps with snapshots and backups] to back up and restore applications. Before you define protection policies, clearly identify your workloads. A prerequisite is that Astra Control Service can uniquely detect each application. For more information, see [Start managing apps][Manage apps].

For steps that you can take to help protect applications, see [Disaster Recovery of AKS Workloads with Astra Control Service and Azure NetApp Files][Disaster Recovery of AKS workloads with Astra Control Service and Azure NetApp Files].

For detailed information about Astra Control Service, see [Astra Control Service documentation][Astra Control Service documentation].

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributor.*

Principal author:

- [Arnt de Gier](https://www.linkedin.com/in/arntdegier) | Technical Marketing Engineer

## Next steps

- For information about using AKS to deploy a cluster, see [Tutorial: Deploy an Azure Kubernetes Service (AKS) cluster][Tutorial: Deploy an Azure Kubernetes Service (AKS) cluster].
- To get started with Azure NetApp Files, see [Quickstart: Set up Azure NetApp Files and create an NFS volume][Quickstart: Set up Azure NetApp Files and create an NFS volume].
- To learn more about Astra Control Service, see [Astra Control Service documentation][Astra Control Service documentation].
- For an in-depth explanation of using Astra Control Service for disaster recovery, see [Disaster Recovery of AKS workloads with Astra Control Service and Azure NetApp Files][Disaster Recovery of AKS workloads with Astra Control Service and Azure NetApp Files].
- For information about running multiple instances of an AKS cluster across multiple regions, see [AKS baseline for multiregion clusters][AKS baseline for multiregion clusters].
- For general information about solution components, see these resources:

  - [What is Azure Kubernetes Service?][Azure Kubernetes Service (AKS)]
  - [What is Azure NetApp Files][What is Azure NetApp Files]
  - [NetApp Astra Control Service][NetApp Astra Control Service]

## Related resources

- [Enterprise file shares with disaster recovery][Enterprise file shares with disaster recovery]
- [Magento e-commerce platform in Azure Kubernetes Service][Magento e-commerce platform in Azure Kubernetes Service]
- [Baseline architecture for an Azure Kubernetes Service (AKS) cluster][Baseline architecture for an Azure Kubernetes Service (AKS) cluster]

[AKS]: https://azure.microsoft.com/products/kubernetes-service
[AKS baseline for multiregion clusters]: ../../reference-architectures/containers/aks-multi-region/aks-multi-cluster.yml
[Astra Control Service documentation]: https://docs.netapp.com/us-en/astra-control-service/index.html
[Azure Kubernetes Service (AKS)]: /azure/aks/intro-kubernetes
[Azure NetApp Files Performance Calculator]: https://bluexp.netapp.com/azure-netapp-files/sizer
[Azure NetApp Files service page]: https://azure.microsoft.com/products/netapp
[Azure Pricing calculator]: https://azure.microsoft.com/pricing/calculator
[Azure Virtual Network]: https://azure.microsoft.com/products/virtual-network
[Baseline architecture for an Azure Kubernetes Service (AKS) cluster]: ../../reference-architectures/containers/aks/baseline-aks.yml
[Configurable network features]: /azure/azure-netapp-files/azure-netapp-files-network-topologies#configurable-network-features
[Create an Azure account for free]: https://azure.microsoft.com/free/?WT.mc_id=A261C142F
[Create an Azure service principal]: https://docs.netapp.com/us-en/astra-control-service/get-started/set-up-microsoft-azure-with-anf.html#create-an-azure-service-principal-2
[Create a NetApp account]: /azure/azure-netapp-files/azure-netapp-files-create-netapp-account
[Create volume replication for Azure NetApp Files]: /azure/azure-netapp-files/cross-region-replication-create-peering
[Cross-region replication in Azure: Business continuity and disaster recovery]: /azure/reliability/cross-region-replication-azure
[Cross-region replication of Azure NetApp Files volumes]: /azure/azure-netapp-files/cross-region-replication-introduction
[Delegate a subnet to Azure NetApp Files]: https://docs.netapp.com/us-en/astra-control-service/get-started/set-up-microsoft-azure-with-anf.html#delegate-a-subnet-to-azure-netapp-files-2
[Disaster Recovery of AKS workloads with Astra Control Service and Azure NetApp Files]: https://techcommunity.microsoft.com/t5/azure-architecture-blog/disaster-recovery-of-aks-workloads-with-astra-control-service/ba-p/2948089
[Enterprise file shares with disaster recovery]: ./enterprise-file-shares-disaster-recovery.yml
[Guidelines for Azure NetApp Files network planning - Subnets]: /azure/azure-netapp-files/azure-netapp-files-network-topologies#subnets
[How Azure NetApp Files snapshots work]: /azure/azure-netapp-files/snapshots-introduction
[Magento e-commerce platform in Azure Kubernetes Service]: ../magento/magento-azure.yml
[Manage apps]: https://docs.netapp.com/us-en/astra-control-service/use/manage-apps.html#manage-apps
[Start managing apps]: https://docs.netapp.com/us-en/astra-control-service/use/manage-apps.html
[Manage disaster recovery using cross-region replication]: /azure/azure-netapp-files/cross-region-replication-manage-disaster-recovery
[Monitor Astra Trident]: https://docs.netapp.com/us-en/trident/trident-use/monitor-trident.html
[NetApp Astra Control Service]: https://azuremarketplace.microsoft.com/marketplace/apps/netapp.netapp-astra-acs
[NetApp BlueXP pricing]: https://bluexp.netapp.com/pricing
[Products available by region]: https://azure.microsoft.com/global-infrastructure/services/?products=kubernetes-service%2Cnetapp&regions=all
[Protect apps with snapshots and backups]: https://docs.netapp.com/us-en/astra-control-service/use/protect-apps.html
[Quickstart: Set up Azure NetApp Files and create an NFS volume]: /azure/azure-netapp-files/azure-netapp-files-quickstart-set-up-account-create-volumes
[Region availability]: /azure/aks/quotas-skus-regions#region-availability
[Register for an Astra Control Service account]: https://docs.netapp.com/us-en/astra-control-service/get-started/register.html
[Register the resource provider]: /azure/azure-netapp-files/azure-netapp-files-register
[Requirements for using Astra Control Service with AKS]: https://docs.netapp.com/us-en/astra-control-service/get-started/set-up-microsoft-azure-with-anf.html#azure-kubernetes-service-cluster-requirements
[Resource limits for Azure NetApp Files]: /azure/azure-netapp-files/azure-netapp-files-resource-limits
[Restoring (cloning) an online snapshot to a new volume]: /azure/azure-netapp-files/snapshots-introduction#restoring-cloning-an-online-snapshot-to-a-new-volume
[Service levels for Azure NetApp Files]: /azure/azure-netapp-files/azure-netapp-files-service-levels
[Set up a capacity pool]: https://docs.netapp.com/us-en/astra-control-service/get-started/set-up-microsoft-azure-with-anf.html#set-up-a-capacity-pool
[SLA for Azure NetApp Files]: https://www.microsoft.com/licensing/docs/view/Service-Level-Agreements-SLA-for-Online-Services
[Start managing Kubernetes clusters from Astra Control Service]: https://docs.netapp.com/us-en/astra-control-service/get-started/add-first-cluster.html
[Tutorial: Deploy an Azure Kubernetes Service (AKS) cluster]: /azure/aks/tutorial-kubernetes-deploy-cluster
[Understand Azure NetApp Files backup]: /azure/azure-netapp-files/backup-introduction
[View a summary of app and cluster health]: https://docs.netapp.com/us-en/astra-control-service/use/view-dashboard.html
[Visio version of architecture diagram]: https://arch-center.azureedge.net/data-protection-kubernetes-astra-azure-netapp-files.vsdx
[Visio version of architecture diagram that uses a single virtual network]: https://arch-center.azureedge.net/data-protection-kubernetes-astra-azure-netapp-files-single.vsdx
[What is Azure NetApp Files]: /azure/azure-netapp-files/azure-netapp-files-introduction
[What volume snapshots are]: /azure/azure-netapp-files/snapshots-introduction#what-volume-snapshots-are
