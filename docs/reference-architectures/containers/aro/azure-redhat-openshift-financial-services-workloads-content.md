This article describes how to implement an Azure Red Hat OpenShift landing zone architecture for the financial services industry (FSI). This guidance outlines how to use Azure Red Hat OpenShift in a hybrid cloud environment to create secure, resilient, and compliant solutions for the FSI.

Before you build a production environment with Azure Red Hat OpenShift, read the [Azure Red Hat OpenShift landing zone](/azure/cloud-adoption-framework/scenarios/app-platform/azure-red-hat-openshift/landing-zone-accelerator) guidance in the Cloud Adoption Framework for Azure.

## Architecture

:::image type="content" source="./images/fsi-architecture.svg" alt-text="Diagram that shows the Azure Red Hat OpenShift hybrid architecture FSI scenario." border="false" lightbox="./images/fsi-architecture.svg":::

*Download a [Visio file](https://arch-center.azureedge.net/fsi-architecture.vsdx) of this architecture.*

### Dataflow

This scenario uses an application that runs on an Azure Red Hat OpenShift cluster. The application connects to on-premises resources and a hub virtual network on Azure that Azure Firewall protects. The following dataflow corresponds to the preceding diagram:

- The developer writes code within the company's network and pushes the code to GitHub Enterprise. You can use any code repository for your scenario.

- The customer's deployment pipeline containerizes the code, which deploys it in an on-premises container registry.

- The image can then be deployed into an on-premises OpenShift cluster and to the Azure Red Hat OpenShift cluster on Azure. The image also gets deployed to Azure Red Hat OpenShift through Azure ExpressRoute, which routes the traffic through the Azure hub virtual network to the private Azure Red Hat OpenShift cluster in the spoke virtual network. These two networks are peered.

- Outgoing traffic that comes from the Azure Red Hat OpenShift cluster is first routed through the peered hub virtual network and then through an Azure Firewall instance.

- To access the application, customers can go to a web address that routes traffic through Azure Front Door.

- Azure Front Door uses Azure Private Link service to connect to the private Azure Red Hat OpenShift cluster.

### Components

- [Azure Red Hat OpenShift](/azure/openshift/intro-openshift) provides fully managed, highly available OpenShift clusters on demand. These clusters serve as the primary compute platform in this architecture. Microsoft and Red Hat jointly monitor and operate the clusters.

- [Microsoft Entra ID](/entra/fundamentals/whatis), formerly known as Azure Active Directory, is a cloud-based identity and access management service that your employees can use to access external resources. In this architecture, Microsoft Entra ID provides customers with secure, granular access to external resources.

- You can use [ExpressRoute](/azure/well-architected/service-guides/azure-expressroute) with a connectivity provider to extend your on-premises networks into the Microsoft cloud over a private connection. This architecture uses ExpressRoute to provide private, high-bandwidth connectivity between on-premises resources and Azure.

- [Azure Key Vault](/azure/key-vault/general/overview) is a key management solution that stores and manages secrets, keys, and certificates. This architecture uses Key Vault to securely store secrets for the applications that run on the private Azure Red Hat OpenShift cluster.

- [Azure Bastion](/azure/bastion/bastion-overview) is a fully managed platform as a service (PaaS) that you can deploy to securely connect to virtual machines (VM) through a private IP address. This architecture uses Azure Bastion to connect to an Azure VM within the private network because this scenario implements a private cluster.

- [Azure Firewall](/azure/well-architected/service-guides/azure-firewall) is a cloud-native and intelligent network firewall security service that provides threat protection for your cloud workloads that run in Azure. This architecture uses Azure Firewall to monitor and filter network traffic that goes in and out of the Azure Red Hat OpenShift environment.

### Alternatives

You can use Azure Red Hat OpenShift to access the OpenShift ecosystem. When you run OpenShift on-premises, most of the included platform services apply to Azure Red Hat OpenShift. You can use these platform services as alternatives to some of the Azure services mentioned in this article.

Non-Microsoft alternatives are available. For example, you can host your container registry on-premises or use OpenShift GitOps instead of GitHub Actions. You can also use non-Microsoft monitoring solutions that work with Azure Red Hat OpenShift environments. This article focuses on Azure alternatives that customers often use to build their solutions on Azure Red Hat OpenShift.

## Scenario details

FSI and other regulated industry Azure Red Hat OpenShift customers often have stringent requirements for their environments. This architecture outlines comprehensive criteria and guidelines that financial institutions can use to design solutions that meet their unique requirements when they use Azure Red Hat OpenShift in a hybrid cloud environment.

This scenario focuses on security measures. For example, you can enable private connectivity from on-premises environments, implement stringent controls on private link usage, establish private registries, ensure network segregation, and deploy encryption for data at rest and in transit. Identity and access management and role-based access control (RBAC) both ensure secure user administration within Azure Red Hat OpenShift clusters.

To add resilience, you can distribute resources across availability zones for fault tolerance. Compliance obligations involve non-Microsoft risk assessments, regulatory adherence, and disaster recovery protocols. To improve observability, you can add logging, monitoring, and backup mechanisms to uphold operational efficiency and regulatory compliance. The guidelines in this article provide a comprehensive framework that you can use to deploy and manage Azure Red Hat OpenShift solutions that are specifically tailored to the needs of the financial services industry.

### Potential use cases

This scenario is most relevant to customers in regulated industries, such as finance and healthcare. This scenario also applies to customers who have elevated security requirements, such as solutions that have strict data governance requirements.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

Resilience is essential for Microsoft Azure Red Hat OpenShift to maintain the uninterrupted operation of mission-critical applications. Follow these reliability recommendations:

- **Availability zones**: Distribute control plane and worker nodes across three availability zones within an Azure region. This setup ensures that the control plane cluster maintains quorum and mitigates potential failures across entire availability zones. Implement this distribution as a standard practice.

- **Multi-region deployments**: Deploy Azure Red Hat OpenShift clusters in multiple regions to protect against region-wide failures. Use Azure Front Door to route traffic to these clusters for improved resilience.

- **Disaster recovery**: Implement rigorous disaster recovery standards to safeguard customer data and ensure continuous business operations. To meet these standards effectively, follow the guidelines in [Considerations for disaster recovery](https://cloud.redhat.com/experts/aro/disaster-recovery/).

- **Backup**: To protect sensitive customer data, ensure compliance with stringent backup requirements. Configure Azure Red Hat OpenShift to attach to Azure storage by default and ensure that it automatically reattaches after a restore operation. To enable this feature, follow the instructions in [Create an Azure Red Hat OpenShift cluster application backup](/azure/openshift/howto-create-a-backup).

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

Security is paramount in the financial industry. To protect sensitive data and ensure regulatory compliance, you need stringent security measures.

#### Networking

- **Private connectivity from an on-premises environment**: Financial industry use cases require exclusive private network connectivity without public internet access. To improve security, implement Azure private links for private IP addresses that are inaccessible from the internet, and use ExpressRoute for connectivity from on-premises datacenters. For more information, see [Create an Azure Red Hat OpenShift private cluster](/azure/openshift/howto-create-private-cluster-4x).

- **Push-only private link**: Financial companies often restrict Azure workload traffic from connecting back to their datacenters. Configure Private Link gateways for inbound-only access from private datacenters to Azure. Ensure that system dependencies in private datacenters push data to Azure. Use Private Link and Azure Firewall to apply firewall policy exceptions on an individual basis according to least-privilege principles.

- **Private registry**: To scan images and prevent the use of vulnerable images, use a centralized container repository within your perimeter. Distribute container images to runtime locations. Implement Azure Container Registry and supported external registries for this purpose. For more information, see [Use Container Registry in private Azure Red Hat OpenShift clusters](https://cloud.redhat.com/experts/aro/aro-acr/).

- **Network segmentation**: Segment default subnets for security and network isolation. Use Azure networking to create distinct subnets for Azure Red Hat OpenShift control planes, worker planes, and data planes, Azure Front Door, Azure Firewall, Azure Bastion, and Azure Application Gateway.

#### Data

- **Encryption of data at rest**: Use default storage policies and configurations to ensure encryption of data at rest. Encrypt *etcd* behind the control plane, and encrypt storage on each worker node. Configure Container Storage Interface (CSI) access to Azure storage, including file, block, and blob storage, for persistent volumes. To manage keys through the customer or Azure, use etcd and the Azure Red Hat OpenShift feature, storage data encryption. For more information, see [Security for Azure Red Hat OpenShift](/azure/cloud-adoption-framework/scenarios/app-platform/azure-red-hat-openshift/security).

- **Encryption of data in transit**: Encrypt interconnections between services in a default Azure Red Hat OpenShift cluster. Enable Transport Layer Security (TLS) for traffic between services. Use network policies, service mesh, and Key Vault for certificate storage. For more information, see [Update Azure Red Hat OpenShift cluster certificates](/azure/openshift/howto-update-certificates).

- **Key management service**: To ensure that you securely store and service secrets, use Key Vault. Consider partner independent software vendors like Hashicorp Vault or CyberArk Concur for more options. Handle certificates and secrets with Key Vault and consider bring-your-own-key models. Use Key Vault as the main component. For more information, see [Customer-managed keys for Azure Storage encryption](/azure/storage/common/customer-managed-keys-overview).

#### Authentication and authorization

- **Identity and access management**: Use Microsoft Entra ID for centralized identity management of Azure Red Hat OpenShift clusters. For more information, see [Configure Azure Red Hat OpenShift to use Microsoft Entra ID group claims](https://cloud.redhat.com/experts/idp/group-claims/aro/).

- **RBAC**: Implement RBAC in Azure Red Hat OpenShift to provide granular authorization of user actions and access levels. Use RBAC in FSI scenarios to ensure least-privilege access to the cloud environment. For more information, see [Manage RBAC](https://docs.openshift.com/aro/3/admin_guide/manage_rbac.html).

#### Compliance

- **Non-Microsoft risk assessments**: To follow financial compliance regulations, adhere to least-privilege access, limit duration for escalated privileges, and audit site reliability engineer (SRE) resource access. For the SRE shared responsibility model and access-escalation procedures, see [Overview of responsibilities for Azure Red Hat OpenShift](/azure/openshift/responsibility-matrix) and [SRE access to Azure Red Hat OpenShift](https://access.redhat.com/solutions/6997379).

- **Regulatory compliance**: Use Azure Policy to address various regulatory requirements related to compliance in FSI scenarios. For more information, see [Azure Policy](/azure/governance/policy/overview) and [Azure Policy built-in initiative definitions](/azure/governance/policy/samples/built-in-initiatives).

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

FSI companies can use robust observability tools and practices to proactively detect and address problems and optimize resource usage. Follow these operational-excellence recommendations:

- **Implement effective logging and monitoring**: Use Azure Monitor and Microsoft Sentinel to track actions and ensure system integrity within your Azure Red Hat OpenShift environment. To supplement observability and monitoring practices, use non-Microsoft tools such as Dynatrace, Datadog, and Splunk. Ensure that managed service for Prometheus or Azure Managed Grafana are available for Azure Red Hat OpenShift.

- **Use Azure Arc-enabled Kubernetes**: Integrate Azure Arc-enabled Kubernetes with your Azure Red Hat OpenShift environment for enhanced logging and monitoring capabilities. Use the provided tools to optimize resource usage and maintain compliance with industry regulations. Enable comprehensive monitoring and observability. For more information, see [Azure Arc-enabled Kubernetes](/azure/azure-arc/kubernetes/overview) and [Enable monitoring for Azure Arc-enabled clusters](/azure/azure-monitor/containers/kubernetes-monitoring-enable).

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Ayobami Ayodeji](https://www.linkedin.com/in/ayobamiayodeji/) | Senior Program Manager

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next step

[Cloud Adoption Framework guidance for adopting Azure Red Hat OpenShift in Azure landing zones](/azure/cloud-adoption-framework/scenarios/app-platform/azure-red-hat-openshift/landing-zone-accelerator)
