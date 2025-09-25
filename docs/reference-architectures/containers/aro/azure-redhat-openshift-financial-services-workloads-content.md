This article describes how to implement an Azure Red Hat OpenShift (ARO) landing zone architecture for the financial services industry (FSI). This guidance outlines how to use Azure Red Hat OpenShift 4.x in a hybrid cloud environment to create secure, resilient, and compliant solutions that meet FSI regulatory requirements and security standards.

Before you build a production environment with Azure Red Hat OpenShift, read the [Azure Red Hat OpenShift landing zone](/azure/cloud-adoption-framework/scenarios/app-platform/azure-red-hat-openshift/landing-zone-accelerator) guidance in the Cloud Adoption Framework for Azure. Consider also reviewing the latest [ARO service updates and version compatibility matrix](/azure/openshift/support-policies-v4) for production planning.

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

- Azure Front Door uses Azure Private Link service to connect to the private Azure Red Hat OpenShift (ARO) cluster.

### Components

- [Azure Red Hat OpenShift](/azure/openshift/intro-openshift) provides fully managed, highly available OpenShift 4.x clusters on demand with 99.95% SLA availability. These clusters serve as the primary compute platform in this architecture. Microsoft and Red Hat jointly monitor and operate the clusters, providing enterprise-grade support with automated updates, patching, and lifecycle management. Azure Red Hat OpenShift (ARO) supports OpenShift 4.12+ with regular version updates and extended support options.

- [Microsoft Entra ID](/entra/fundamentals/whatis) is a cloud-based identity and access management service that your employees can use to access external resources. In this architecture, Microsoft Entra ID integrates with Azure RBAC and OpenShift RBAC, providing customers with secure, granular access to external resources.

- You can use [ExpressRoute](/azure/well-architected/service-guides/azure-expressroute) with a connectivity provider to extend your on-premises networks into the Microsoft cloud over a private connection. This architecture uses ExpressRoute to provide private, high-bandwidth connectivity between on-premises resources and Azure.

- [Azure Key Vault](/azure/key-vault/general/overview) is a cloud-native key management solution that stores and manages secrets, keys, and certificates with FIPS 140-3 Level 3 validated HSMs, and complies with standards such as PCI DSS, PCI 3DS. For FSI scenarios, this architecture recommends using Key Vault Premium tier instead of the Standard SKU to provide enhanced security compliance, including customer-managed keys (CMK), bring-your-own-key (BYOK) capabilities, and dedicated HSM backing for applications running on the private Azure Red Hat OpenShift cluster. Key Vault Premium enables FIPS 140-3 Level 3 compliance required by many financial regulations. Integration with Azure Red Hat OpenShift (ARO) includes native support for Key Vault CSI driver and Azure Workload Identity. For more information on the different Azure key-management solutions; please refer to this document: [How to choose the right Azure key management solution](/azure/security/fundamentals/key-management-choose#learn-more-about-azure-key-management-solutions).

- [Azure Bastion](/azure/bastion/bastion-overview) is a fully managed platform as a service (PaaS) that you can deploy to securely connect to virtual machines (VM) through a private IP address. This architecture uses Azure Bastion to connect to an Azure VM within the private network because this scenario implements a private cluster.

- [Azure Firewall](/azure/well-architected/service-guides/azure-firewall) is a cloud-native and intelligent network firewall security service that provides threat protection for your cloud workloads that run in Azure. This architecture uses Azure Firewall to monitor and filter network traffic that goes in and out of the Azure Red Hat OpenShift environment.

### Alternatives

You can use Azure Red Hat OpenShift to access the comprehensive OpenShift ecosystem and cloud-native toolchain. When you run OpenShift on-premises, most of the included platform services apply to Azure Red Hat OpenShift. You can use these platform services as alternatives to some of the Azure services mentioned in this article.

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

- **Multi-region deployments**: Deploy Azure Red Hat OpenShift clusters in multiple regions to protect against region-wide failures. Use Azure Front Door Premium for global load balancing and traffic routing to these clusters, with health probes and automatic failover capabilities for improved resilience. Choose Azure services that support geo-redundancy and match that secondary location to the location where the OpenShift cluster will be deployed to.

- **Disaster recovery**: Implement rigorous disaster recovery standards to safeguard customer data and ensure continuous business operations. To meet these standards effectively, follow the guidelines in [Considerations for disaster recovery](https://cloud.redhat.com/experts/aro/disaster-recovery/).


- **Backup**: To protect sensitive customer data and meet stringent compliance requirements, implement a robust backup and restore strategy for Azure Red Hat OpenShift (ARO).

    - Start by configuring ARO clusters to attach to Azure storage by default and ensure they automatically reattach after a restore operation. Use the guidance in [Create an Azure Red Hat OpenShift cluster application backup](/azure/openshift/howto-create-a-backup) for application-level backups using Velero.

    - For backup and disaster recovery workflows—including scheduled backups, remote object store replication, and data mover support—consider the Red Hat guide [Backup and Restore for ARO using OADP](https://cloud.redhat.com/experts/aro/backup-restore/). This approach is recommended for production environments that require strict Recovery Time Objectives (RTO), Recovery Point Objectives (RPO), and adherence to compliance standards.

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

Security is paramount in the financial industry. To protect sensitive data and ensure regulatory compliance, you need stringent security measures.

#### Networking

- **Private connectivity from an on-premises environment**: Financial industry use cases require exclusive private network connectivity without public internet access. 
    - Implement Azure Private Link endpoints for secure connectivity and use ExpressRoute for private connectivity from on-premises datacenters. Azure Red Hat OpenShift (ARO) supports private clusters with private ingress controllers and API endpoints. 
    - For enhanced security, consider using a hub-spoke network topology. For more information, see [Create an Azure Red Hat OpenShift private cluster](/azure/openshift/howto-create-private-cluster-4x). 
    - Use the [Azure Red Hat OpenShift (ARO) landing zone accelerator](/azure/cloud-adoption-framework/scenarios/app-platform/azure-red-hat-openshift/landing-zone-accelerator) template to expedite the creation of a new cluster with the best practices and guidance from the Azure Cloud Adoption Framework.

- **Push-only private link**: Financial companies often restrict Azure workload traffic from connecting back to their datacenters. Configure Private Link gateways for inbound-only access from private datacenters to Azure. 
    - Ensure that system dependencies in private datacenters push data to Azure. 
    - Use Private Link and Azure Firewall to apply firewall policy exceptions on an individual basis according to least-privilege principles.

- **Private registry with vulnerability scanning**: Use Azure Container Registry Premium tier with integrated security scanning to identify vulnerabilities in images hosted in your registry. This feature can be enabled at a subscription level using the [Microsoft Defender for container registries](/azure/defender-for-cloud/defender-for-containers-va-acr) powered by Microsoft Defender for Cloud.
    - Implement image signing with Notation and Cosign for supply chain security.
    - Distribute container images through private endpoints and configure Azure Red Hat OpenShift (ARO) to use private registries exclusively. 
    - Enable quarantine policies for vulnerable images. For more information, see [Use Container Registry in private Azure Red Hat OpenShift clusters](https://cloud.redhat.com/experts/aro/aro-acr/).
    - Use [Private Link for Azure Container Registry](/azure/container-registry/container-registry-private-link).

- **Network segmentation**: Segment default subnets for security and network isolation. 
    - Use Azure networking to create distinct subnets for Azure Red Hat OpenShift control plane, worker plane, and data plane, Azure Front Door, Azure Firewall, Azure Bastion, and Azure Application Gateway.
    - [Create NetworkPolicy](https://docs.redhat.com/en/documentation/openshift_container_platform/4.14/html/networking/network-policy#about-network-policy) objects to restrict traffic between pods in a Project. 

#### Data

- **Encryption of data at rest**: Use default storage policies and configurations to ensure encryption of data at rest. 
    - Enable [*etcd* encryption](https://docs.openshift.com/container-platform/4.10/security/encrypting-etcd.html) behind the control plane, and encrypt storage on each worker node.
    - Configure the [Azure Key Vault Provider for Secret Store CSI driver (CSI)](https://azure.github.io/secrets-store-csi-driver-provider-azure/) to mount secrets in Azure Key Vault to your pods.
    - To manage keys through the customer or Azure, use etcd and the Azure Red Hat OpenShift feature, storage data encryption. For more information, see [Security for Azure Red Hat OpenShift](/azure/cloud-adoption-framework/scenarios/app-platform/azure-red-hat-openshift/security).

- **Encryption of data in transit**: Encrypt interconnections between services in a default Azure Red Hat OpenShift cluster.
    - Enable Transport Layer Security (TLS) for traffic between services. 
    - Use network policies, service mesh, and Key Vault for certificate storage. For more information, see [Update Azure Red Hat OpenShift cluster certificates](/azure/openshift/howto-update-certificates).
    - Use Red Hat OpenShift Service Mesh to enforce traffic management, service identity, security, policy and to gain telemetry. See [Introduction to Red Hat OpenShift Service Mesh](https://docs.redhat.com/en/documentation/openshift_container_platform/4.18/html/service_mesh/service-mesh-2-x#ossm-servicemesh-overview_ossm-about) for more details.

- **Key management service**: Use [Azure Key Vault](/azure/key-vault/general/overview) as the primary service for securely storing and managing secrets, keys, and certificates. 
    - For workloads requiring **HSM-backed keys** use [Azure Key Vault Premium](/azure/security/fundamentals/key-management-choose) which now meet **FIPS 140-3 Level 3** standards. 
    - Enable [Microsoft Defender for Key Vault](/azure/defender-for-cloud/defender-for-key-vault-introduction) for advanced threat detection, configure [diagnostic logging](/azure/key-vault/general/logging) for auditing, and implement [automated key rotation](/azure/key-vault/keys/how-to-configure-key-rotation) and [secret lifecycle management](/azure/key-vault/secrets/tutorial-rotation) using built-in policies or event-driven automation. 
    - For advanced or multi-cloud scenarios, consider independent software vendors such as [HashiCorp Vault](https://developer.hashicorp.com/vault/docs) or [CyberArk Conjur](https://docs.cyberark.com/portal/latest/en/docs.htm). Bring-your-own-key (BYOK) models are fully supported across [Azure services](/azure/storage/common/customer-managed-keys-overview).


#### Authentication and authorization

- **Identity and access management**: Use Microsoft Entra ID for centralized identity management of Azure Red Hat OpenShift clusters. For more information, see [Configure Azure Red Hat OpenShift to use Microsoft Entra ID group claims](https://cloud.redhat.com/experts/idp/group-claims/aro/).
    - Use [Microsoft Entra to authenticate](/azure/openshift/configure-azure-ad-cli) users against your Azure Red Hat OpenShift cluster.
    - Use [Privileged Identity Management (PIM) in Microsoft Entra ID](/azure/openshift/configure-azure-ad-cli) to manage, control and monitor access to the cluster with **just-in-time** privilege and **multifactor authentication (MFA)**.
    - Create a separate service principal with scoped Azure RBAC roles for your Azure Red Hat OpenShift landing zone. For more information, see [Prerequisites Checklist to Deploy ARO Cluster](https://cloud.redhat.com/experts/aro/prereq-list/).

- **RBAC**: Implement RBAC in Azure Red Hat OpenShift to provide granular authorization of user actions and access levels. 
    - Use RBAC in FSI scenarios to ensure least-privilege access to the cloud environment. For more information, see [Using RBAC to define and apply permissions](https://docs.redhat.com/en/documentation/openshift_container_platform/4.17/html/authentication_and_authorization/using-rbac).
    - Use role bindings between OpenShift and Microsoft Entra for distinct groups like Site Reliability Engineering, SecOps, DevOps and developers. For more information, see [Configure ARO to use Microsoft Entra ID](https://cloud.redhat.com/experts/idp/azuread-aro/).

#### Compliance

- **Non-Microsoft risk assessments**: To follow financial compliance regulations, adhere to least-privilege access, limit duration for escalated privileges, and audit site reliability engineer (SRE) resource access. For the SRE shared responsibility model and access-escalation procedures, see [Overview of responsibilities for Azure Red Hat OpenShift](/azure/openshift/responsibility-matrix) and [SRE access to Azure Red Hat OpenShift](https://access.redhat.com/solutions/6997379).

- **Regulatory compliance**: Use Azure Policy to address various regulatory requirements related to compliance in FSI scenarios. 
    - Use [Azure Policy to apply tags](/azure/openshift/howto-tag-resources) to resources to an Azure Red Hat OpenShift cluster's managed resource group. For more information, see [Azure Policy](/azure/governance/policy/overview) and [Azure Policy built-in initiative definitions](/azure/governance/policy/samples/built-in-initiatives).

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

FSI companies can use robust observability tools and practices to proactively detect and address problems and optimize resource usage. Follow these operational-excellence recommendations:

- **Implement effective logging and monitoring**: Use Azure Monitor and Microsoft Sentinel to track actions and ensure system integrity within your Azure Red Hat OpenShift environment. 
    - Supplement observability and monitoring practices, use non-Microsoft tools such as Dynatrace, Datadog, and Splunk. 
    - Ensure that Managed service for Prometheus or Azure Managed Grafana is available for Azure Red Hat OpenShift.
    - Use the [Cluster Logging Forwarder](https://cloud.redhat.com/experts/aro/clf-to-azure/) to send logs to Azure Monitor and Azure Log Analytics, allowing you to query and view your Azure Red Hat OpenShift (ARO) workloads in Azure Monitor.

- **Use Azure Arc-enabled Kubernetes**: Integrate Azure Arc-enabled Kubernetes with your Azure Red Hat OpenShift environment for enhanced logging and monitoring capabilities. 
    - Use the provided tools to optimize resource usage and maintain compliance with industry regulations. 
    - Enable comprehensive monitoring and observability. For more information, see [Azure Arc-enabled Kubernetes](/azure/azure-arc/kubernetes/overview) and [Enable monitoring for Azure Arc-enabled clusters](/azure/azure-monitor/containers/kubernetes-monitoring-enable).

- **Deploy Red Hat Advanced Cluster Management and OpenShift Data Foundation for Azure Red Hat OpenShift disaster recovery**: For Business Continuity and Disaster Recovery scenarios consider running a hub cluster with Advanced Cluster Management (ACM) and the OpenShift Data Foundation (ODF) Multicluster Orchestrator to coordinate primary and secondary clusters across peered virtual networks. For more information, see the [Deploying Advanced Cluster Management and OpenShift Data Foundation for ARO Disaster Recovery](https://cloud.redhat.com/experts/aro/acm-odf-aro/).

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Ayobami Ayodeji](https://www.linkedin.com/in/ayobamiayodeji/) | Senior Program Manager
- [Diego Casati](https://www.linkedin.com/in/diegocasati/) | Azure Global Black Belt

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

**Production Deployment Resources:**
- [Azure Red Hat OpenShift Landing Zone Accelerator](https://github.com/Azure/ARO-Landing-Zone-Accelerator) - Comprehensive reference implementation with Terraform/Bicep templates and critical design area recommendations
- [ARO Workshop](https://aroworkshop.io/) - Hands-on lab exercises for learning Azure Red Hat OpenShift (ARO) deployment and management
- [Red Hat OpenShift on Azure documentation](/azure/openshift/) - Complete technical documentation and tutorials

**Architecture and Best Practices:**
- [Azure Architecture Center - Container architectures](/azure/architecture/browse/?expanded=azure&products=azure-kubernetes-service%2Cazure-container-instances%2Cazure-red-hat-openshift) - Reference architectures and design patterns
- [Azure Red Hat OpenShift support policies](/azure/openshift/support-policies-v4) - Version support and lifecycle information

**Security and Compliance:**
- [Azure security baseline for Azure Red Hat OpenShift (ARO)](/security/benchmark/azure/baselines/azure-red-hat-openshift-aro-security-baseline) - Security baseline guidance from the Microsoft cloud security benchmark version 1.0 to Azure Red Hat OpenShift (ARO)
