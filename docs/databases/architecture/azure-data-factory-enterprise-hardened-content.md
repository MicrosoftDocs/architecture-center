This article describes how to modify and harden a [medallion lakehouse](/azure/databricks/lakehouse/medallion) when you adopt your system across an enterprise. This architecture follows a typical adoption pattern described in the [baseline architecture](azure-data-factory-on-azure-landing-zones-baseline.yml). This architecture is hardened to meet extra nonfunctional requirements (NFRs), provide extra capabilities, and shift responsibilities to a domain-based federated model.

This architecture incorporates best practices and guidance from the [Microsoft Cloud Adoption Framework for Azure](/azure/cloud-adoption-framework/) and focuses on the implementation of [data domains](/azure/cloud-adoption-framework/scenarios/cloud-scale-analytics/architectures/data-domains) and the adoption of [data products](/azure/cloud-adoption-framework/scenarios/cloud-scale-analytics/architectures/data-landing-zone-data-products).

> [!NOTE]
> The guidance in this article focuses on key differences of this architecture compared to the [baseline architecture](azure-data-factory-on-azure-landing-zones-baseline.yml).

## Harden the baseline architecture

According to the [baseline architecture](azure-data-factory-on-azure-landing-zones-baseline.yml), Contoso operates a [medallion lakehouse](/azure/databricks/lakehouse/medallion) that supports their first data workloads for the financial department. Contoso hardens and extends this system to support the analytical data needs of the enterprise. This strategy provides data science capabilities and self-service functionality.

### Key requirements

There are several key requirements to modify and harden a medallion lakehouse:

- The solution must be hardened to operate as an enterprise data and analytics platform. The solution must also extend to support other corporate functions and adhere to Contoso's data access policy requirements.

- The platform must be able to ingest, store, process, and serve data in near real-time. The performance target is defined as less than one minute of processing time from ingestion to availability in the reporting layer.

- The platform must deliver economies of scale savings and efficiency while driving reuse.

- The platform must enable business areas to decide the level of self-service and control that they require over their data solutions and products.

- The platform must support an enterprise data science capability, which includes the enablement of data citizens.

- The platform must support higher target service-level agreements (SLAs), which include:

  - A target uptime of 99.9%, or about 8.5 hours downtime per year.

  - A recovery point objective (RPO) of 1.5 days.

  - A recovery time objective (RTO) of less than 1 day.

- The platform must support the expected usage of 1,000 users across various domains with an estimated growth of 5% annually. Only Contoso employees can access the platform directly, but a capability to share data with other companies is required.

### Key design decisions

You can modify the [baseline architecture](azure-data-factory-on-azure-landing-zones-baseline.yml) to meet these requirements without creating a new architecture.

- A [domain design](/azure/cloud-adoption-framework/scenarios/cloud-scale-analytics/architectures/data-domains#domain-modeling-recommendations) that's backed by an enterprise-managed foundation works well for this scenario. A domain design supports the requirements for extending the platform across the enterprise, the self-service functionality, and the business strategic objective. The foundation is defined as:

  - Identity and access controls.
  - The underlying networking, boundary controls, and security baseline.
  - The governance, audit, and monitoring functionality.
  - Functions to ingest and initially process data into the platform.

- The domain design is anchored around a given business department's ownership of their data and the originating source system. A new [operating model](/azure/cloud-adoption-framework/scenarios/cloud-scale-analytics/organize-roles-teams) enables business groups to optionally build their own stack of model-and-serve components that they control and maintain going forward. Domains operate within guardrails according to enterprise requirements and are enabled to perform well-defined and controlled experiments. The data science capability is delivered through:

  - [Power BI](/power-bi/connect-data/service-tutorial-build-machine-learning-model) for low code and for simple or medium complexity use cases across tabular data. This model is an ideal starting point for data citizens.

  - [Azure Machine Learning](/azure/machine-learning) and AI service offerings that support the full set of use cases and [user maturity](/azure/architecture/ai-ml/guide/mlops-maturity-model).

  - [Azure Databricks](/azure/databricks/lakehouse-architecture/performance-efficiency/best-practices#use-parallel-computation-where-it-is-beneficial) for large enterprise volume use cases with significant processing demands.

  - An innovation sandbox that supports proof-of-concept work for new technologies or techniques. It provides an isolated environment that's segregated from production and preproduction.

- [Azure Data Factory](/azure/data-factory/introduction) capabilities to cover near real-time and micro-batch ingestion use cases that are enabled by the [change data capture](/azure/data-factory/concepts-change-data-capture) functionality. This functionality, combined with [Azure Databricks structured streaming](/azure/databricks/structured-streaming/) and [Power BI](/power-bi/connect-data/service-real-time-streaming), supports the end-to-end solution.

- Power BI to enable data sharing with external parties as required with [Microsoft Entra B2B](/fabric/enterprise/powerbi/service-admin-entra-b2b) authorization and access controls.

- Streaming data patterns can be complicated to implement and manage, especially in failure case scenarios. Ensure that business requirements are tested for acceptable latency and that source system and network infrastructure can support streaming requirements before implementation.

- Any decision to move toward a domain model must be made in collaboration with business stakeholders. It's critical that stakeholders understand and accept the increased [responsibilities of domain ownership](/azure/cloud-adoption-framework/scenarios/cloud-scale-analytics/organize-roles-responsibilities).

- The stakeholders' data maturity, available skilling across the software development life cycle (SDLC), governance framework, standards, and automation maturity all influence how far the initial operating model leans into [domain enablement](/azure/cloud-adoption-framework/scenarios/cloud-scale-analytics/architectures/self-serve-data-platforms). These factors can also indicate your current position in the cloud-scale analytics [adoption lifecycle](/azure/cloud-adoption-framework/scenarios/cloud-scale-analytics/architectures/data-mesh-checklist) and highlight the steps needed to advance further.

## Architecture

:::image type="content" source="_images/azure-data-factory-hardened.png" lightbox="_images/azure-data-factory-hardened.png" alt-text="Diagram that shows the hardened medallion architecture." border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/azure-data-factory-hardened-logical.vsdx) of this architecture.*

### Workflow

The following workflow corresponds to the preceding diagram:

1. The ingested data and Delta Lake are [source aligned](/azure/cloud-adoption-framework/scenarios/cloud-scale-analytics/architectures/data-domains#source-system-aligned-domains) and remain the responsibility of the central technical team. This decision reflects the level of technical expertise required for Spark development and supports a consistent, standardized implementation approach that takes enterprise reusability into consideration.

    - [Data contracts](/azure/cloud-adoption-framework/scenarios/cloud-scale-analytics/architectures/data-contracts#data-contracts-1) govern the data feeds from source systems. Data contracts can be used to drive a [metadata-driven](/azure/cloud-adoption-framework/scenarios/cloud-scale-analytics/architectures/data-contracts#:~:text=metadata%2Ddriven%20ingestion%20frameworks) extract, transform, load (ETL) framework and make the data available to users as part of the [governance capability](/purview/how-to-browse-catalog).

    - The directory structure of the bronze layer (or the *raw layer*) in Delta Lake reflects how [data is consumed](/azure/storage/blobs/data-lake-storage-best-practices#directory-structure). The source system orders the data. This organization methodology enables a unified security implementation based on the business ownership of source systems.

    - A fast path for data supports the streaming requirement. A fast path ingests data through Data Factory, and Azure Databricks structured streaming directly processes the data for analysis and use. You can use Delta Lake [change data capture](/azure/databricks/structured-streaming/delta-lake#stream-a-delta-lake-change-data-capture-cdc-feed) to create the audit history. This feature supports replay and propagating incremental changes to downstream tables in the medallion architecture.

2. A model-and-serve path remains the responsibility of the central technical team in support of the enterprise-owned data solutions. The technical team is also responsible for providing the service catalog optionality for business areas that require data solutions but don't have the skilling, budget, or interest in technically managing their own domain implementation. Self-service is offered within the model-and-serve components that the central technical team manages.

3. The central technical team manages the enterprise data science capability. This model also aligns with their support for enterprise-focused solutions, provision of service optionality, and hosting services with an enterprise pricing structure.

4. Domains are enabled through logical containers at the subscription level. [Subscriptions](/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-subscriptions) provide the necessary domain-level unit of management, billing, governance, and isolation.

    - The approach is managed through infrastructure as code (IaC) [infrastructure as code (IaC)](/azure/well-architected/operational-excellence/infrastructure-as-code-design), which provides a baseline of enterprise monitoring, audit, and security controls. The platform [tagging strategy](/azure/cloud-adoption-framework/ready/azure-best-practices/naming-and-tagging) is extended to support the domain extension.

    - Each domain has its own set of Azure role-based access control (Azure RBAC) roles that cover the [control planes and data planes](/azure/azure-resource-manager/management/control-plane-and-data-plane). Control plane roles are primarily used within domain logical containers. In contrast, data plane roles apply across the platform, which ensures consistent, unified, and low-complexity control.

5. Within a domain subscription, the available components can be configured based on skill sets, priorities, and use cases.

    - Power BI [workspaces](/power-bi/collaborate-share/service-new-workspaces) enable domains to collaborate when it's practical. Workspaces can also be unique to domains and linked to specific [premium capacities](/power-bi/enterprise/service-premium-what-is#workspaces) if increased performance is required.

    - An innovation sandbox is a temporary entity, which enables the validation of new technologies or processes. Data storage is provided to onboard, create, or modify data, without being limited by the append-only functionality of the Delta Lake bronze layer.

### Network design

:::image type="complex" source="./_images/azure-data-factory-hardened-network.svg" alt-text="Diagram that shows a hardened network design for an Azure Data Factory workload." border="false" lightbox="_images/azure-data-factory-hardened-network.svg":::
    Diagram that shows an example of the workflow for a system that uses the Valet Key pattern. Boxes on the far left show on-premises infrastructure and user connectivity. A box in the upper right shows the ingress infrastructure in the connectivity hub subscription. Underneath that ingress infrastructure box are the main components of the design that all use private endpoints. Next to the main infrastructure is a box with monitoring infrastructure in the shared services subscription.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/azure-data-factory-hardened.vsdx) of this architecture.*

- Use a next generation firewall like [Azure Firewall](/azure/firewall/overview) to secure network connectivity between your on-premises infrastructure and your Azure virtual network.

- You can deploy a self-hosted integration runtime (SHIR) on a virtual machine (VM) in your on-premises environment or in Azure. To simplify governance and security, consider deploying the VM in Azure as part of the shared support resource landing zone. You can use the SHIR to securely connect to on-premises data sources and perform data integration tasks in Data Factory.

- Machine learning-assisted data labeling doesn't support default storage accounts because they're secured behind a virtual network. First create a storage account for machine learning-assisted data labeling. Then apply the labeling and secure it behind the virtual network.

- [Private endpoints](/azure/private-link/private-endpoint-overview) provide a private IP address from your virtual network to an Azure service. This process effectively brings the service into your virtual network. This functionality makes the service accessible only from your virtual network or connected networks, which ensures a more secure and private connection.

  Private endpoints use [Azure Private Link](/azure/private-link/private-link-overview), which secures the connection to the platform as a service (PaaS) solution. If your workload uses any resources that don't support private endpoints, you might be able to use [service endpoints](/azure/virtual-network/virtual-network-service-endpoints-overview). We recommend that you use private endpoints for mission-critical workloads whenever possible.

### Data science capability

In data science scenarios, Data Factory primarily handles data movement, scheduling, and orchestration. These tasks are essential for batch inferencing in machine learning use cases. Batch inferencing, also known as batch scoring, includes making predictions on a batch of observations. These scenarios typically require high data throughput and scoring at a predefined frequency.

Within Data Factory, these workflows are defined in pipelines that consist of various interlinked activities. Scalable Data Factory pipelines are typically parameterized and controlled by metadata that's defined in a control table. This pattern ingests data, processes it to generate machine learning predictions, and transfers the data outputs to a service for modeling purposes and serving purposes.

Azure Machine Learning and Azure Databricks process data to generate machine learning predictions in different ways.

- An [Azure Databricks notebook](/azure/databricks/notebooks/) incorporates all model scoring logic. You can use an [Azure Databricks notebook activity](/azure/data-factory/transform-data-databricks-notebook) to perform model scoring.

- A Machine Learning [batch endpoint](/azure/machine-learning/concept-endpoints-batch) is used to incorporate all model scoring logic. You can use a [Machine Learning pipeline activity](/azure/data-factory/transform-data-machine-learning-service) to perform model scoring.

## Alternatives

- You can use [Azure Event Hubs](/azure/event-hubs/) as an alternative for data streaming. In this scenario, Azure Databricks provides the necessary functionality, which simplifies the design.

- You can use [Azure Data Share](/azure/data-share/) as an alternative for data sharing. In this scenario, Power BI provides the necessary functionality, which simplifies the design.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

Compared to the baseline architecture, this architecture:

- Meets the uplifted requirements with the default [Azure SLAs](https://www.microsoft.com/licensing/docs/view/Service-Level-Agreements-SLA-for-Online-Services?lang=1) across the solution. This strategy eliminates the need for high availability or multi-regional uplift.

- Uplifts the [disaster recovery strategy](/azure/architecture/data-guide/disaster-recovery/dr-for-azure-data-platform-overview) to cover the full scope of platform services and updated target metrics. This strategy must be tested regularly to ensure that it remains fit for purpose.

- Uses zone-redundancy features in solution components to protect against localized service problems. The following table shows the resiliency types for the services or features in this architecture.

|Service or feature|Resiliency type|
| :---------- | :---------- |
Data Factory|Zone redundant
Azure Databricks|Zone redundant
Azure Data Lake Storage Gen2 |Zone redundant
Azure Databricks auto loader|Zone redundant
Azure Key Vault|Zone redundant
Azure Virtual Network gateway|Zone redundant
SHIR|Same-zone high availability

> [!NOTE]
> Not all Azure services are supported in all regions and not all regions support landing zones. Before you select a region, confirm that all of the required resources and redundancy requirements are supported.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

Compared to the baseline architecture, this architecture:

- Creates domain-specific data Azure RBAC roles when domain-specific data is ingested into the platform with data classification higher than enterprise. For more information, see [Govern overview](/azure/cloud-adoption-framework/govern/policy-compliance/data-classification#classifications-microsoft-uses). The roles are then reused across all solution components that use this data. You can reuse these domain data roles for any new domain data onboarded to the platform. This approach delivers consistent and unified controls for the access to data.

- Considers the higher data sensitivity requirements for the platform, [Microsoft Entra Privileged Identity Management (PIM)](/entra/id-governance/privileged-identity-management/pim-resource-roles-assign-roles) for all key operational support roles.

### Cost Optimization

Cost Optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

Compared to the baseline architecture, this architecture:

- Provides skilling to the domain teams to ensure that they understand the discipline of [cost optimization](/azure/well-architected/cost-optimization/) and their responsibilities under the new operating model.

- Extends the [cost management alerting](/azure/cost-management-billing/costs/cost-mgt-alerts-monitor-usage-spending) to the domains and business stakeholders to provide transparency and observability.

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

Compared to the baseline architecture, this architecture:

- Evolves the operating model to account for the new domain model, stakeholders, governance structures, persona-based training, and RACI.

- Extends the [tagging strategy](/azure/cloud-adoption-framework/ready/azure-best-practices/resource-tagging) to account for the domain model.

- Develops a central [nonfunctional requirements register](/azure/architecture/guide/design-principles/build-for-business) and adopts a standard of [software development best practices](/azure/architecture/best-practices/index-best-practices) that any platform solution can reference in any developer area. To support these standards, integrate a robust [testing framework](/devops/develop/shift-left-make-testing-fast-reliable) into the continuous integration and continuous deployment practice.

### Performance Efficiency

Performance Efficiency is the ability of your workload to meet the demands placed on it by users in an efficient manner. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

Compared to the baseline architecture, this architecture:

- Provides alerting and [observability](/azure/cloud-adoption-framework/manage/monitor/observability) to the domain teams as part of the domain establishment and [baseline of monitoring](/azure/azure-monitor/overview).

- Encourages sharing knowledge and best practices between knowledge workers and offers [incentives](/power-bi/guidance/fabric-adoption-roadmap-community-of-practice#incentives) for community engagement.

## Antipatterns

- **Non-collaborative transformation:** The shift to a domain model is a major undertaking that requires significant change across the organization. This shift shouldn't be a one-sided effort where technology leadership makes decisions solely based on the technology they wish to adopt. This approach can lead to disagreements or misunderstandings between business stakeholders and technology teams further down the line if problems arise in the workload. Instead, this transformation is most effective when business stakeholders understand the necessary activities and appreciate the value of the delivered outcomes. [Deep collaboration](/azure/well-architected/reliability/principles#design-for-business-requirements) between technology and business stakeholders is the key to any successful transformation.

- **Uncritically adopting technology trends:** New ideas drive technology. New functionality, new approaches, and new designs are constantly introduced through various online forums. For example, a trending data design pattern on LinkedIn might seem like an appealing option. Resist the temptation to adopt the latest trends when you build an enterprise-class solution, and favor proven technologies and patterns. Trending solutions might lack thorough testing and proven performance in production enterprise environments. These solutions might fail in production if they have missing functionalities, insufficient documentation, or an inability to scale properly.

- **Building functionality without proper consideration:** When you identify a gap in technical functionality, it's often tempting to "build your own." While this approach might be valid in some cases, product owners should consider the effect on the overall product lifecycle that building a bespoke solution might introduce. You can build bespoke solutions to cover a gap in existing, well-supported products. This approach can significantly increase technical debt over the course of a product's lifecycle because maintaining that solution adds considerable management burden that increases over time. The amount of projected technical debt needs to be weighed against the criticality of the missing functionality. If that functionality is on the product roadmap for an off-the-shelf solution, waiting for the vendor to deliver the feature might be a better strategy in the long term.

## Next steps

- [Azure landing zone](/azure/cloud-adoption-framework/ready/landing-zone/)
- [Microsoft Cloud Adoption Framework](/azure/cloud-adoption-framework/)
- [Data domain guidance](/azure/cloud-adoption-framework/scenarios/cloud-scale-analytics/architectures/data-domains)

## Related resources

- [Data Factory mission-critical architecture](azure-data-factory-mission-critical.yml)
- [Baseline architecture](azure-data-factory-on-azure-landing-zones-baseline.yml)
