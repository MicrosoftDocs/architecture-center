This article demonstrates how to deploy an Azure Arc-enabled SQL managed instance in a highly available architecture across two sites. It's based on the Azure Arc Jumpstart [ArcBox for DataOps](https://azurearcjumpstart.io/azure_jumpstart_arcbox/dataops) implementation.

## Architecture

:::image type="content" source="./images/azure-arc-sql-managed-instance-dr.svg" alt-text="Diagram that shows an Azure Arc-enabled SQL Managed Instance topology." lightbox="./images/azure-arc-sql-managed-instance-dr.svg" :::

*Download a [PowerPoint file](https://arch-center.azureedge.net/azure-arc-sql-managed-instance-dr.pptx) of this architecture.*

### Workflow

The following workflow corresponds to the preceding diagram:

- Two Azure Arc-enabled Kubernetes clusters are deployed, one in each of two virtual networks that represent two different sites.
- Virtual network peering is established between the two virtual networks so that they can communicate.
- A domain controller is deployed in each site. Active Directory replication is configured between them.
- An Azure Arc data controller is deployed in each Kubernetes cluster.
- An Azure Arc-enabled SQL managed instance is deployed in the primary cluster, in the Business Critical service tier.
- An Azure Arc-enabled SQL managed instance is deployed in the secondary cluster, in the Business Critical service tier. It's configured as a disaster recovery instance.
- If the primary site fails, the system fails over to the SQL managed instance in the secondary site.

### Components

- [Azure Arc](https://azure.microsoft.com/products/azure-arc). Azure Arc is a bridge that extends the Azure platform to help you build applications and services. 
- [Azure Arc-enabled Kubernetes](/azure/azure-arc/kubernetes). You can attach and configure Kubernetes clusters inside or outside of Azure by using Azure Arc-enabled Kubernetes. When a Kubernetes cluster is attached to Azure Arc, you can deploy Azure Arc data services to it, services like Azure Arc-enabled SQL Managed Instance.
- [Azure Arc data controller](/azure/azure-arc/data/create-data-controller-direct-cli). Azure Arc data controller is the orchestrator in the Azure Arc-enabled data services architecture. It manages services like provisioning, elasticity, recoverability, monitoring, and high availability.
- [Azure Arc-enabled SQL Managed Instance](/azure/azure-arc/data/managed-instance-overview). You can deploy Azure Arc-enabled [SQL Managed Instance](https://azure.microsoft.com/products/azure-sql/managed-instance) to host your data workloads. It supports the Azure PaaS data services on your hybrid and multicloud infrastructure.
- Domain controllers. Domain controllers are deployed into this architecture to manage authentication and authorization to the Azure Arc-enabled SQL managed instances.

## Scenario details

This scenario is based on the Azure Arc Jumpstart [ArcBox for DataOps](https://azurearcjumpstart.io/azure_jumpstart_arcbox/dataops) implementation. ArcBox is a solution that provides an easy-to-deploy sandbox for Azure Arc. ArcBox for DataOps is a version of ArcBox that can help you experience Azure Arc-enabled SQL Managed Instance capabilities in a sandbox environment.

### Potential use cases

Typical use cases for this architecture include:

- Deploy, on one site, a highly available Azure Arc-enabled SQL managed instance that's resilient to failure.
- Deploy an Azure Arc-enabled SQL managed instance in a primary site and a DR site to recover from complete site downtime.
- Deploy a resilient data back end for mission-critical applications that reside on your hybrid or multicloud infrastructure.

## Recommendations

The following recommendations apply to most scenarios. Follow these recommendations unless you have a specific requirement that overrides them.

### Azure Arc-enabled SQL Managed Instance deployment

You can connect any [validated Kubernetes distribution](/azure/azure-arc/kubernetes/validation-program) to Azure Arc. Before you connect your clusters, be sure to complete the [Azure Arc-enabled Kubernetes prerequisites](/azure/azure-arc/kubernetes/quickstart-connect-cluster#prerequisites).

After your clusters are connected, you need to deploy an Azure Arc data controller. First, complete the [Azure Arc data controller prerequisites](/azure/azure-arc/data/create-data-controller-direct-prerequisites). You can then deploy SQL Managed Instance.

There are two service tiers on which you can deploy Azure Arc-enabled SQL Managed Instance:

- General Purpose is a lower-cost tier that's designed for most workloads that have common performance and availability features.
- Business Critical tier is designed for performance-sensitive workloads that have higher availability features.

For a more detailed comparison of the tiers, see [Azure Arc-enabled SQL Managed Instance service tiers](/azure/azure-arc/data/service-tiers#service-tier-comparison).

### Monitor Azure Arc-enabled SQL Managed Instance

You can use Log Analytics in Azure Monitor to monitor Azure Arc-enabled SQL Managed Instance, or you can use open-source solutions like [Grafana](/azure/azure-arc/data/monitor-grafana-kibana).

Design and plan your Log Analytics workspace deployment. Deploy it in the container where data is collected, aggregated, and later analyzed. A Log Analytics workspace provides a geographical location of your data, data isolation, and a scope for configurations like data retention. Use a single Log Analytics workspace as described in the [management and monitoring best practices](/azure/cloud-adoption-framework/ready/landing-zone/design-area/management) in the Cloud Adoption Framework for Azure.

### Business continuity and disaster recovery

- Deploy Azure Arc-enabled SQL Managed Instance in the Business Critical service tier with three replicas to achieve near-zero data loss.

- Ensure that your instances of Arc-enabled SQL Managed Instance have different names on the primary and secondary sites, and that the shared-name value for the sites is identical.

- Perform regular disaster recovery drills to validate the failover process.

- Create a process for initiating both manual and forced failovers.

- Monitor the health of your Azure Arc-enabled Kubernetes clusters by using [Azure Monitor Container insights](/azure/azure-monitor/containers/container-insights-overview).

- Define the DNS record for the shared name of the distributed availability group in your DNS servers to avoid needing to manually create DNS records during failovers.

For more best practices and guidance, see [Business continuity and disaster recovery for Azure Arc-enabled SQL Managed Instance](/azure/cloud-adoption-framework/scenarios/hybrid/arc-enabled-data-service-sql-managed-instance/eslz-arc-data-service-sql-managed-instance-business-continuity-disaster-recovery).

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).
- Define your targets for [recovery point objective](/azure/cloud-adoption-framework/manage/considerations/protect#recovery-point-objectives-rpo) (RPO) and [recovery time objective](/azure/cloud-adoption-framework/manage/considerations/protect#recovery-time-objectives-rto) (RTO).
- Configure [point-in-time restore](/azure/azure-sql/managed-instance/point-in-time-restore) so that you can restore your databases to a previous point in time.
- Determine how many replicas, between one and three, to deploy in the Business Critical service tier.
- Determine the number of secondary replicas to deploy in the Business Critical service tier. When you deploy an instance in a Business Critical service tier with two or more replicas, you can configure the secondary replicas as readable. For information on changing the number, see [Configure readable secondaries](/azure/azure-arc/data/configure-managed-instance#configure-readable-secondaries).
- Decide how to monitor the downtime of the primary instance to determine when to perform a failover to the secondary instance.
- Ensure that the instances of Azure Arc-enabled SQL Managed Instance in the geo-primary and geo-secondary sites are identical in compute and capacity and that they're deployed to the same service tier.
- Decide where to store the mirroring certificates when you create the disaster recovery configuration. Both clusters that host the instance must be able to access the location.
- Decide which Kubernetes service type to use: `LoadBalancer` or `NodePort`. If you use `LoadBalancer`, applications can reconnect to the same primary endpoint, and Kubernetes will redirect the connection to the new primary. If you use `NodePort`, applications must reconnect to the new IP address.
- Review the [business continuity and disaster recovery](/azure/cloud-adoption-framework/scenarios/hybrid/arc-enabled-data-service-sql-managed-instance/eslz-arc-data-service-sql-managed-instance-business-continuity-disaster-recovery) guidance to determine whether your requirements are met.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

- Determine the Azure regions in which to deploy your Azure Arc-enabled SQL managed instance and data controllers. Take into account your security and compliance requirements and any data sovereignty requirements. Be aware of [the types of data that are collected from your resources](/azure/azure-arc/data/privacy-data-collection-and-reporting) in directly connected mode and in indirectly connected mode, and plan accordingly based on the data residency requirements of your organization.
- Your Azure Arc-enabled SQL managed instance can reside in hybrid or multicloud Kubernetes clusters. Review the security and governance considerations for your cloud provider and Kubernetes distribution.
- Taking into account your organization's separation of duties and least-privileged access requirements, define cluster administration, operations, database administration, and developer roles for your organization. A mapping of each team to actions and responsibilities determines Azure role-based access control (RBAC) roles or the Kubernetes `ClusterRoleBinding` and `RoleBinding`, depending on the connectivity mode you use.
- Determine the authentication model to use in your Azure Arc-enabled SQL managed instance: Azure Active Directory (Azure AD) authentication or SQL authentication. Review the [identity and access management design area](/azure/cloud-adoption-framework/scenarios/hybrid/arc-enabled-data-service-sql-managed-instance/eslz-arc-data-service-sql-managed-instance-identity-access-management) for considerations and recommendations that can help you choose the right model.
- Review the [security capabilities](/azure/azure-arc/data/managed-instance-features#RDBMSS) that are available in Azure Arc-enabled SQL Managed Instance for your data workloads.
- Consider the need for keeping your Azure Arc-enabled SQL managed instance up to date with the latest versions, whether they're deployed in directly connected mode or in indirectly connected mode. For guidance, see the [upgradeability disciplines critical design area](/azure/Cloud-Adoption-framework/scenarios/hybrid/arc-enabled-data-service-sql-managed-instance/eslz-arc-data-service-sql-managed-instance-upgradeability-disciplines).
- Review the design considerations in the Azure Arc-enabled Kubernetes [governance and security disciplines design area](/azure/cloud-adoption-framework/scenarios/hybrid/arc-enabled-kubernetes/eslz-arc-kubernetes-governance-disciplines).
- See the [security and governance disciplines](/azure/cloud-adoption-framework/scenarios/hybrid/arc-enabled-data-service-sql-managed-instance/eslz-arc-data-service-sql-managed-instance-governance-disciplines#design-considerations) for a comprehensive overview of the security features in Azure Arc-enabled SQL Managed Instance.

### Cost optimization

Cost optimization is about reducing unnecessary expenses and improving operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

- Define your business requirements to determine the most appropriate service tier. Also consider the extra infrastructure that you need to support [business continuity and disaster recovery](/azure/cloud-adoption-framework/scenarios/hybrid/arc-enabled-data-service-sql-managed-instance/eslz-arc-data-service-sql-managed-instance-business-continuity-disaster-recovery).
- Be aware that the way in which usage and billing information is sent to Azure varies depending on whether you use the directly connected mode or the indirectly connected mode. If you use the indirectly connected mode, consider how the usage and billing information is regularly sent to Azure.
- Based on how long you expect to use Azure Arc-enabled SQL Managed Instance, consider whether pay-as-you-go, a one-year reserved instance, or a three-year reserved instance is most cost effective.
- Keep in mind that Azure Hybrid Benefits offers savings on both service tiers of Azure Arc-enabled SQL Managed Instance.
- See [Cost governance for Azure Arc-enabled SQL Managed Instance](/azure/cloud-adoption-framework/scenarios/hybrid/arc-enabled-data-service-sql-managed-instance/eslz-arc-data-service-sql-managed-instance-cost-governance) for more cost optimization guidance.
- Use the [Azure pricing calculator][pricing-calculator] to estimate costs.
- If you deploy the Jumpstart ArcBox for DataOps reference implementation for this architecture, keep in mind that ArcBox resources generate Azure consumption charges from the underlying Azure resources. These resources include core compute, storage, networking, and auxiliary services.

### Operational excellence

Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Overview of the operational excellence pillar](/azure/architecture/framework/devops/overview).

- Review the upgradeability design principle in the [Azure Arc-enabled SQL Managed Instance landing zone accelerator](/azure/cloud-adoption-framework/scenarios/hybrid/arc-enabled-data-service-sql-managed-instance/eslz-arc-data-service-sql-managed-instance-upgradeability-disciplines) for best practices on how to keep your instances up to date.
- Review [Azure Arc Jumpstart Unified Operations Use Cases](https://azurearcjumpstart.io/azure_arc_jumpstart/azure_arc_data/day2) to learn about more operational excellence scenarios for Azure Arc-enabled SQL Managed Instance.

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview).

- Use Azure Monitor to collect metrics and logs from your Azure Arc-enabled SQL managed instances for detailed analysis and correlation. Review the [deployment options](/azure/azure-arc/servers/concept-log-analytics-extension-deployment).
- You can also use open-source tools like [Grafana and Kibana](/azure/azure-arc/data/monitor-grafana-kibana) to monitor your instances.

## Deploy this scenario

You can find the reference implementation of this architecture in [Jumpstart ArcBox for DataOps](https://azurearcjumpstart.io/azure_jumpstart_arcbox/dataops), which is part of the [Azure Arc Jumpstart](https://azurearcjumpstart.io) project. ArcBox is designed to be self-contained in a single Azure subscription and [resource group](/azure/azure-resource-manager/management/manage-resource-groups-portal#what-is-a-resource-group). ArcBox can help you get hands-on experience with Azure Arc. 

To get started, go to Jumpstart ArcBox for DataOps:

> [!div class="nextstepaction"]
> [Deploy the reference implementation](https://azurearcjumpstart.io/azure_jumpstart_arcbox/dataops/#deployment-options-and-automation-flow)

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:
- [Seif Bassem](https://www.linkedin.com/in/seif-bassem) | Senior Cloud Solution Architect

Other contributor:
- [Mick Alberts](https://www.linkedin.com/in/mick-alberts-a24a1414) | Technical Writer

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Azure Arc documentation][Azure Arc docs]
- [Azure Arc-enabled SQL Managed Instance overview][Azure Arc-enabled SQL Managed Instance docs]
- [Azure Arc learning path](/training/paths/manage-hybrid-infrastructure-with-azure-arc)
- [Azure Arc Jumpstart scenarios][Arc Jumpstart data services scenarios]
- [Introduction to Azure Arc landing zone accelerator for hybrid and multicloud][CAF Arc Accelerator] 

## Related resources

- [Manage configurations for Azure Arc-enabled servers](azure-arc-hybrid-config.yml)
- [Azure Arc hybrid management and deployment for Kubernetes clusters](arc-hybrid-kubernetes.yml)

[Arc Jumpstart]: https://azurearcjumpstart.io
[Azure Arc docs]: /azure/azure-arc
[Azure Arc-enabled SQL Managed Instance docs]: /azure/azure-arc/data/managed-instance-overview
[Azure Log Analytics]: /azure/azure-monitor/logs/log-analytics-overview
[Azure Monitor]: https://azure.microsoft.com/services/monitor
[Azure Arc]: /azure/azure-arc
[Arc Jumpstart data services scenarios]: https://azurearcjumpstart.io/azure_arc_jumpstart/azure_arc_data
[Azure Resource Group]: /azure/azure-resource-manager/management/manage-resource-groups-portal#what-is-a-resource-group
[CAF Arc Accelerator]: /azure/cloud-adoption-framework/scenarios/hybrid/enterprise-scale-landing-zone
[Microsoft Defender for Cloud]: https://azure.microsoft.com/services/defender-for-cloud
[Microsoft Sentinel]: https://azure.microsoft.com/services/microsoft-sentinel
[pricing-calculator]: https://azure.microsoft.com/pricing/calculator
[rg-limits]: /azure/azure-resource-manager/management/azure-subscription-service-limits#resource-group-limits
[subscription-limits]: /azure/azure-resource-manager/management/azure-subscription-service-limits#subscription-limits
[waf-principles-reliability]: /azure/architecture/framework/resiliency/principles
[waf-principles-security]: /azure/architecture/framework/security/security-principles
[waf-principles-cost-opt]: /azure/architecture/framework/cost/principles
[waf-principles-operational-excellence]: /azure/architecture/framework/devops/principles
[waf-principles-performance-efficiency]: /azure/architecture/framework/scalability/principles
