This article describes a container solution that hosts a large, storage-intensive installation of WordPress on Azure. The solution maximizes scalability and security. Key components include [Azure Front Door](/azure/frontdoor/front-door-overview), [Azure Kubernetes Service (AKS)](/azure/aks/what-is-aks), and [Azure NetApp Files](/azure/azure-netapp-files/azure-netapp-files-introduction).

## Architecture

:::image type="complex" source="media/wordpress-aks-azure-netapp-files.svg" alt-text="Architecture diagram of an AKS WordPress deployment. Azure NetApp Files stores static content. Private endpoints provide access to other services." lightbox="media/wordpress-aks-azure-netapp-files.svg" border="false":::
   The diagram shows a WordPress deployment architecture within Microsoft Azure, organized inside a virtual network outlined by a dashed border. On the left, the public internet connects to Azure Front Door, which includes Azure Web Application Firewall. Azure Front Door routes traffic to an internal load balancer, which distributes incoming requests to components inside the virtual network. Within the network, multiple subnets are protected by network security groups (NSGs). The central component is AKS. Traffic flows through an ingress controller into the WordPress pods. These pods access secrets through a Container Storage Interface (CSI) connected to a secure store. Another subnet contains Azure NetApp Files and is protected by its own NSG. On the right side, four services connect to the virtual network via private endpoints: Azure Container Registry, Azure Key Vault, Azure Database for MySQL – Flexible Server, and Azure Managed Redis. Each service communicates securely within the network without direct internet exposure.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/azure-wordpress-container.vsdx) of this architecture.*

> [!NOTE]
> You can extend this solution by implementing tips and recommendations that apply to any WordPress hosting method. For general tips about how to deploy a WordPress installation, see [WordPress on Azure](../../guide/infrastructure/wordpress-overview.yml).

### Dataflow

The following dataflow corresponds to the previous diagram:

1. Users access the front-end website through Azure Front Door with Azure Web Application Firewall enabled.

1. Azure Front Door uses an internal instance of Azure Load Balancer as the origin. The internal load balancer is a hidden component of AKS. Azure Front Door retrieves any data that isn't cached.
1. The internal load balancer distributes ingress traffic to pods within AKS.
1. Azure Key Vault stores secrets, including the private key, which is an X.509 certificate.
1. The WordPress application uses a private endpoint to access a Flexible Server instance of Azure Database for MySQL. The WordPress application retrieves dynamic information from this managed database service.
1. All static content is hosted in Azure NetApp Files. The solution uses the Astra Trident Container Storage Interface (CSI) driver with the Network File System (NFS) protocol.

### Components

- [AKS](/azure/well-architected/service-guides/azure-kubernetes-service) is a managed Kubernetes service that you can use to deploy, manage, and scale containerized applications. In this architecture, AKS hosts the WordPress containers and provides the orchestration platform that runs the containerized WordPress application to ensure high availability and scalability.

- [Azure Managed Redis](/azure/redis/overview) is a managed in-memory data store and caching service. In this architecture, Azure Managed Redis hosts a key-value cache that all pods share. WordPress performance optimization plug-ins use the cache to improve response times.

- [Azure Database for MySQL - Flexible Server](/azure/well-architected/service-guides/azure-db-mysql-cost-optimization) is a managed relational database service based on the open-source MySQL database engine. In this architecture, this database stores WordPress data.

- [Azure DDoS Protection](/azure/ddos-protection/ddos-protection-overview) is a network security service that provides enhanced distributed denial-of-service (DDoS) mitigation features. In this architecture, DDoS Protection helps defend against DDoS attacks when combined with application-design best practices and enabled on the perimeter network.

- [Azure Front Door](/azure/well-architected/service-guides/azure-front-door) is a modern cloud content delivery network and global load balancer. In this architecture, Azure Front Door is the public entry point into the WordPress deployment.

- [Azure NetApp Files](/azure/well-architected/service-guides/azure-netapp-files) is a managed, performance-intensive, and latency-sensitive storage solution. In this architecture, Azure NetApp Files hosts the WordPress content so that all pods have access to the shared data through high-performance file storage.

- [Azure Virtual Network](/azure/well-architected/service-guides/virtual-network) is a networking service that enables deployed resources to communicate with each other, the internet, and on-premises networks. In this architecture, virtual networks provide isolation and segmentation.

- [Key Vault](/azure/key-vault/general/overview) is a cloud service that stores and controls access to secrets, certificates, keys, and passwords. In this architecture, Key Vault provides secrets to the AKS cluster if pods need them.

- [Load Balancer](/azure/well-architected/service-guides/azure-load-balancer/reliability) is a layer-4 load balancer that distributes inbound traffic based on rules and health probe results. In this architecture, the load balancer distributes traffic from Azure Front Door to the ingress controller pods with low latency and high throughput.

- [Network security groups (NSGs)](/azure/virtual-network/network-security-groups-overview) are security features that use security rules to allow or deny inbound or outbound network traffic based on source or destination IP address, port, and protocol. In this architecture, NSG rules restrict traffic flow between the application components in the subnets.

### Alternatives

- Instead of using the Azure Managed Redis managed service, you can use a self-hosted Redis pod within the AKS cluster as the cache.

- Instead of using a managed storage solution like Azure NetApp Files, you can use a self-hosted solution like [Rook-Ceph storage](https://rook.io). For more information, see [Use Rook Ceph on AKS](https://github.com/Azure/kubernetes-volume-drivers/tree/master/rook-ceph).
- Instead of using AKS, you can use [Azure Container Apps](/azure/container-apps/overview) to host containerized WordPress workloads. Container Apps is a managed serverless container service that suits simpler or smaller-scale scenarios. For large, storage-intensive, and highly customizable deployments, use AKS.

## Scenario details

This example scenario works best for large, storage-intensive installations of WordPress. This deployment model can scale to meet spikes in traffic to the site.

### Potential use cases

- High-traffic blogs that use WordPress as their content management system
- Business or e-commerce websites that use WordPress

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

Consider the following recommendations when you deploy this solution:

- Use pods in AKS and a load balancer to distribute ingress traffic. This approach provides high availability even if a pod failure occurs.

- Place all networking components behind Azure Front Door. This approach makes the networking resources and application resilient to problems that can otherwise disrupt traffic and affect user access.
- Use Azure Front Door to cache all responses to gain a small availability benefit. Specifically, when the origin doesn't respond, you can still access content. But caching doesn't provide a complete availability solution.
- Replicate Azure NetApp Files storage between paired regions to increase availability. For more information, see [Understand Azure NetApp Files replication](/azure/azure-netapp-files/replication).
- Follow [high availability options](/azure/mysql/flexible-server/concepts-high-availability) that meet your needs to increase Azure Database for MySQL availability.
- The solution supports multiple regions, data replication, and autoscaling. The components distribute traffic to the pods. Health probes ensure that only healthy pods receive traffic.
- Azure Front Door is a global service that supports virtual machine scale sets deployed in another region.

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

Consider the following best practices when you deploy this solution:

- Use Web Application Firewall on Azure Front Door to help protect the virtual network traffic that flows into the front-end application tier. For more information, see [Web Application Firewall on Azure Front Door](/azure/web-application-firewall/afds/afds-overview).

- Don't allow outbound internet traffic to flow from the database tier.
- Don't allow public access to private storage, and disable public access to resources. Use private endpoints for Azure Database for MySQL, Azure Managed Redis, Key Vault, and Azure Container Registry. For more information, see [Azure Private Link](/azure/private-link/private-link-overview).

For more information, see [General WordPress security and performance tips](../../guide/infrastructure/wordpress-overview.yml#general-wordpress-security-and-performance-tips) and [Azure security documentation](/azure/security).

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

Review the following cost considerations when you deploy this solution:

- **Traffic expectations (GB/month):** Your traffic volume has the greatest effect on your cost. The amount of traffic that you receive determines the number of AKS nodes required and the price for outbound data transfer. The traffic volume also directly correlates with the amount of data that your content delivery network provides, where outbound data transfer costs are cheaper.

- **Amount of hosted data:** Consider the amount of data that you host, because Azure NetApp Files pricing is based on reserved capacity. To optimize costs, reserve the minimum capacity required for your data.
- **Write percentage:** Consider how much new data you write to your website and the cost to store it. For multi-region deployments, the amount of new data that you write to your website correlates with the amount of data mirrored across your regions.
- **Static versus dynamic content:** Monitor your database storage performance and capacity to determine whether a cheaper SKU can support your site. The database stores dynamic content, and the content delivery network caches static content.
- **AKS cluster optimization:** Follow general tips for AKS, such as guidance about virtual machine (VM) size and Azure reservations, to optimize your AKS cluster costs. For more information, see [AKS Cost Optimization](/azure/well-architected/services/compute/azure-kubernetes-service/azure-kubernetes-service#cost-optimization).

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

This scenario uses pods in AKS to host the front end. The autoscale feature enables the number of pods that run the front-end application tier to automatically scale in response to customer demand. They can also scale based on a defined schedule. For more information, see [Scaling options for applications in AKS](/azure/aks/concepts-scale).

> [!IMPORTANT]
> For best performance, mount a persistent volume that uses the NFS protocol version 4.1. The following YAML example shows how to configure a `PersistentVolume` object for this purpose. Note the value of the `mountOptions` field.

  ```yaml
  kind: PersistentVolume
  ...
      accessModes:
      - ReadWriteMany
      mountOptions:
      - vers=4.1
      nfs:
        server: xx.xx.xx.xx
  ```

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Vaclav Jirovsky](https://www.linkedin.com/in/vaclavjirovsky) | Cloud Solution Architect

Other contributor:

- Adrian Calinescu | Senior Cloud Solution Architect

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

Product documentation:

- [Azure Front Door overview](/azure/frontdoor/front-door-overview)
- [Web Application Firewall overview](/azure/web-application-firewall/overview)
- [Azure NetApp Files overview](/azure/azure-netapp-files/azure-netapp-files-introduction)
- [Create an NFS volume for Azure NetApp Files](/azure/azure-netapp-files/azure-netapp-files-create-volumes)
- [Configure Azure NetApp Files for AKS](/azure/aks/azure-netapp-files)
- [Azure Database for MySQL - Flexible Server](/azure/mysql/flexible-server/overview)
- [Virtual Network overview](/azure/virtual-network/virtual-networks-overview)
- [Key Vault overview](/azure/key-vault/general/overview)
- [Load Balancer overview](/azure/load-balancer/load-balancer-overview)
- [DDoS Protection overview](/azure/ddos-protection/ddos-protection-overview)

Microsoft training modules:

- [Develop and deploy applications on Kubernetes](/training/paths/develop-deploy-applications-kubernetes)
- [Introduction to Azure NetApp Files](/training/modules/introduction-to-azure-netapp-files)
- [Implement Key Vault](/training/modules/implement-azure-key-vault)
- [Introduction to Virtual Network](/training/modules/introduction-to-azure-virtual-networks)

## Related resources

- [Design principles for Azure applications](../../guide/design-principles/index.md)
- [Scalable cloud applications and site reliability engineering](../../example-scenario/apps/scalable-apps-performance-modeling-site-reliability.yml)
