This article describes how to implement an Azure Red Hat OpenShift landing zone architecture for the financial services industry (FSI). This guidance outlines how to create secure, resilient, and compliant solutions for the FSI by using Azure Red Hat OpenShift in a hybrid cloud environment.

Before you build a production environment with Azure Red Hat OpenShift, read the [Azure Red Hat OpenShift landing zone](/azure/cloud-adoption-framework/scenarios/app-platform/azure-red-hat-openshift/landing-zone-accelerator) guidance in the Cloud Adoption Framework (CAF).

## Architecture

:::image type="content" source="./images/fsi-architecture.png" alt-text="Diagram that shows the Azure Red Hat OpenShift Hybrid architecture FSI scenario." border="false" lightbox="./images/fsi-architecture.png":::

*Download a [Visio file](https://arch-center.azureedge.net/[file-name].vsdx) of this architecture.*

### Dataflow

This scenario describes an application that runs on an Azure Red Hat OpenShift cluster with connectivity to on-premises resources and in a hub virtual network on Azure that is protected by Azure Firewall. The following dataflow corresponds to the preceding diagram:

- The developer writes code within the company's network and pushes the code to a code repository. GitHub Enterprise is the code repository that's used in this scenario.

- The customer's deployment pipeline takes the code and containerizes it, which deploys the code in an on-premises container registry.

- You can then deploy the image into an on-premises OpenShift Cluster and to the Azure Red Hat OpenShift cluster on Azure. The image also gets deployed to Azure Red Hat OpenShift through Azure ExpressRoute, which routes the traffic through the Azure hub virtual network to the private Azure Red Hat OpenShift cluster in the Spoke virtual network. These two networks are peered.

- Outgoing traffic that comes in from the Azure Red Hat OpenShift cluster is first routed through the peered hub virtual network and through an Azure Firewall instance.

- Customers can access the application by going to a web address that routes traffic through Azure Front Door.

- Azure Front door uses Azure Private Link services to connect to the private Azure Red Hat OpenShift cluster.

### Components

- [Azure Red Hat OpenShift](https://azure.microsoft.com/products/openshift) provides fully managed, highly available OpenShift clusters on demand. These clusters serve as the primary compute platform in this architecture and are jointly monitored and operated by Microsoft and Red Hat.

- [Microsoft Entra ID](https://learn.microsoft.com/entra/fundamentals/whatis), formerly known as Azure Active Directory, is a cloud-based identity and access management service that your employees can use to access external resources. In this architecture, Entra ID provides customers with secure, granular access to external resources.

- [ExpressRoute](/azure/well-architected/service-guides/azure-expressroute) lets you use a connectivity provider to extend your on-premises networks into the Microsoft cloud over a private connection. In this architecture, you can use ExpressRoute to provide private, high-bandwidth connectivity between on-premises resources and Azure.

- [Azure Key Vault](/azure/key-vault/general/overview) is a key management solution that stores and manages secrets, keys, and certificates. In this architecture, you can use Key Vault to securely store secrets for the applications that run on the private Azure Red Hat OpenShift cluster.

- [Azure Bastion](/azure/bastion/design-architecture) is a fully managed platform as a service (PaaS) that you can deploy to securely connect to virtual machines (VM) through a private IP address. In this architecture, you can use Azure Bastion to connect to the Azure VM within the private network because the implementation is in a private cluster.

- [Azure Firewall](/azure/well-architected/service-guides/azure-firewall) is a cloud-native and intelligent network firewall security service that provides best-in-breed threat protection for your cloud workloads that run in Azure. In this architecture, you can use Azure Firewall to monitor and filter network traffic in and out of the ARO environment.

### Alternatives

Red Hat and Azure Red Hat OpenShift is a platform that provides alternatives to customers. You can use Azure Red Hat OpenShift to access the OpenShift ecosystem. This means that the platform services that you get when you run OpenShift on-premises apply mostly to Azure Red Hat OpenShift. Azure Red Hat OpenShift enables you to use these platform services as alternatives to some of the Azure services mentioned in this article.

Non-Microsoft alternatives are available. For example, customers might decide to host their container registry on-premises or use OpenShift GitOps instead of GitHub Actions. Other alternative considerations are third-party monitoring solutions that work seamlessly with Azure Red Hat OpenShift environments. This article focuses on Azure alternatives that customers often use to build their solutions on Azure Red Hat OpenShift.

## Scenario details

FSI and other regulated industry Azure Red Hat OpenShift customers often have more stringent requirements for their environments. This solution is an architectural guidance that outlines the comprehensive criteria and guidelines for designing solutions to meet the unique requirements of financial institutions that utilize Azure Red Hat OpenShift in a hybrid cloud environment.

This scenario focuses on security measures such as enabling private connectivity from on-premises environments, implementing stringent controls on private link usage, establishing private registries, ensuring network segregation, and deploying robust encryption protocols for data at rest and data in transit. Identity and access management and role-based access controls both ensure secure user administration within Azure Red Hat OpenShift clusters.

Resilience planning involves distributing resources across availability zones for fault tolerance. Compliance obligations involve third-party risk assessments, regulatory adherence, and disaster recovery protocols. Observability strategies include logging, monitoring, and backup mechanisms to uphold operational efficiency and regulatory compliance. These guidelines provide a comprehensive framework for deploying and managing Azure Red Hat OpenShift solutions that are specifically tailored to the needs of the financial services industry.

### Potential use cases

This scenario is most relevant to customers in regulated industries, such as finance and healthcare. This scenario also applies to customers who have elevated security requirements, such as solutions that have strict data governance requirements.

## Considerations

These recommendations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

Resilience is essential for Microsoft Azure Red Hat OpenShift to maintain the uninterrupted operation of mission-critical applications. Follow these reliability recommendations:

- **Availability zones**: Distribute control plane and worker nodes across three Availability Zones (AZs) within an Azure region. This ensures that the control plane cluster maintains quorum and mitigates potential failures across entire AZs. Implement this distribution as a standard practice.

- **Multi-region deployments**: Deploy Azure Red Hat OpenShift clusters in multiple regions to protect against region-wide failures. Use Azure Front Door to route traffic to these clusters for improved resilience.

- **Disaster recovery**: Implement rigorous disaster recovery standards to safeguard customer data and ensure continuous business operations. Follow the guidelines in [Azure Red Hat OpenShift - Considerations for Disaster Recovery](https://cloud.redhat.com/experts/aro/disaster-recovery/) to meet these standards effectively.

- **Backup**: Ensure compliance with stringent backup requirements to protect sensitive customer data. Configure Azure Red Hat OpenShift to attach to Azure storage by default and ensure that it automatically reattaches after a restore operation. Enable this feature by following the instructions in [Create an Azure Red Hat OpenShift 4 cluster Application Backup](/azure/openshift/howto-create-a-backup).

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

Security is paramount in the financial industry. Stringent security measures are required to protect sensitive data and ensure regulatory compliance.

#### Networking

- **Private connectivity from an on-premises environment**: Financial industry use cases require exclusive private network connectivity without public internet access. Implement Azure private links for private IP addresses that are inaccessible from the internet, and use ExpressRoute for connectivity from on-premises datacenters. Use Private Link and ExpressRoute for security. For more information, see [Create an Azure Red Hat OpenShift 4 private cluster](/azure/openshift/howto-create-private-cluster-4x).

- **Push-only private link**: Financial companies often restrict Azure workload traffic from connecting back to their datacenters. Configure Private Link Gateways for inbound-only access from private datacenters to Azure. Ensure that system dependencies in the private datacenter push data to Azure. Apply firewall policy exceptions on a case-by-case basis according to least privilege principles. Use Private Link and Firewall policy for this configuration.

- **Private registry**: To scan all images and prevent the use of vulnerable images, use a centralized container repository within your perimeter. Distribute container images to runtime locations. Implement Azure Container Registry and supported external registries for this purpose. Learn more about connecting to private registries at the [Using Container Registry in Private Azure Red Hat OpenShift clusters](https://cloud.redhat.com/experts/aro/aro-acr/) documentation.

- **Network segmentation**: Segment default subnets for security and network isolation. Create distinct subnets for Front Door, Azure Red Hat OpenShift Control Plane, Azure Red Hat OpenShift Worker/Data Plane, Azure Firewall, Azure Bastion, and Azure Application Gateway. Utilize Azure networking for these configurations.

#### Data

- **Encryption of data at rest**: Use default storage policies and configurations to ensure encryption of data at rest. Encrypt ETCD behind the control plane, storage on each worker node, and configure CSI access to Azure File, Block, and Blob for persistent volumes. Use ETCD and storage data encryption, which is a Azure Red Hat OpenShift feature, and manage keys through the customer or Azure. For more information, see [Security for Azure Red Hat OpenShift](/azure/cloud-adoption-framework/scenarios/app-platform/azure-red-hat-openshift/security).

- **Encryption of data in transit**: Encrypt all interconnections between services in a default Azure Red Hat OpenShift cluster. Enable TLS for traffic between services, use network policies, service mesh, and Key Vault for certificate storage. Implement TLS, network policies, service mesh, and Key Vault. For more information, see [Update Azure Red Hat OpenShift cluster certificates](/azure/openshift/howto-update-certificates).

- **Key management service**: Use Key Vault to ensure secure storage and servicing of secrets. Consider third-party ISVs like Hashicorp Vault or Cyberark Concur for more options. Handle certificates and secrets with Key Vault and consider bring your own key (BYOK) models. Use Key Vault as the main component. For more information, see [Customer-managed keys for Azure Storage encryption](/azure/storage/common/customer-managed-keys-overview).

#### Authentication and authorization

- **Identity and access management**: Use Microsoft Entra ID for centralized identity management of Azure Red Hat OpenShift clusters. For more information, see [Configure Azure Red Hat OpenShift to use Microsoft Entra ID Group Claims](https://cloud.redhat.com/experts/idp/group-claims/aro/).

- **Role-based access control**: Implement role-based access control in Azure Red Hat OpenShift to provide granular authorization of user actions and access levels. Use role-based access control in FSI scenarios to ensure least privilege access to the cloud environment. For more information, see [Managing role-based access control](https://docs.openshift.com/aro/3/admin_guide/manage_rbac.html).

#### Compliance

- **Third-party risk assessments**: Follow financial compliance regulations by adhering to least privilege access, limiting duration for escalated privileges, and auditing Site reliability engineer (SRE) resource access. Refer to the Azure Red Hat OpenShift documentation for the SRE shared responsibility model and access escalation procedures. For more information, see [SRE Access to Azure Red Hat OpenShift](https://access.redhat.com/solutions/6997379) and [Overview of responsibilities for Azure Red Hat OpenShift](/azure/openshift/responsibility-matrix).

- **Regulatory compliance**: Use Azure Policy to address various regulatory requirements related to compliance in FSI scenarios. For more information, see [Azure Policy](/azure/governance/policy/overview) and [Azure Policy built-in initiative definitions](/azure/governance/policy/samples/built-in-initiatives).

### Operational excellence

Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

FSI companies can use robust observability tools and practices to proactively detect and address issues and optimize resource utilization. Follow these operational-excellence recommendations:

- **Implement effective logging and monitoring**: Use Azure Monitor and Azure Sentinel to track actions and ensure system integrity within your Azure Red Hat OpenShift environment. Supplement observability and monitoring practices by using non-Microsoft tools such as Dynatrace, Datadog, and Splunk. Ensure Azure Monitor Managed Service for Prometheus or Azure Managed Grafana are available for Azure Red Hat OpenShift.

- **Use Arc-enabled Kubernetes**: Integrate Arc-enabled Kubernetes with your Azure Red Hat OpenShift environment for enhanced logging and monitoring capabilities. Use the provided tools to optimize resource utilization and maintain compliance with industry regulations. Enable comprehensive monitoring and observability by following the guidelines in the Arc-enabled Kubernetes documentation. For more information, see [Arc-enabled Kubernetes](/azure/azure-arc/kubernetes/overview) and [enabling monitoring for Arc enabled clusters](/azure/azure-monitor/containers/kubernetes-monitoring-enable?tabs=cli#arc-enabled-cluster).

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

- [Ayobami Ayodeji](https://www.linkedin.com/in/ayobamiayodeji/) | Senior Program Manager

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next step

- The [Azure Red Hat OpenShift landing zone accelerator](https://github.com/Azure/ARO-Landing-Zone-Accelerator) is an open-source repo that consists of an Azure CLI reference implementation and Critical Design Area recommendations.
