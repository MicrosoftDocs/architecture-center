A hierarchy service allows your business stakeholders to centrally define how production assets like machines are organized within factories, from both an operational and maintenance point of view. You can use this information as a master data source in multiple scenarios such as plant condition monitoring or measuring overall equipment effectiveness (OEE).

When building these services, you can leverage [Azure Digital Twins](/azure/digital-twins) to create a model of nodes (for example, machines, work centers, and locations) and their relationships. Each node contains metadata including identifiers from your enterprise resource management (ERP) systems. You can use this contextual information in downstream applications to gain insights into production states, aggregate machine data, or identify machines that can fulfill a given order.

## Potential use cases

Typical uses for this architecture workload:
- Predictive maintenance
- Enabling connectivity in a plant or factory
- Sustaining productivity in a plant or factory
- Monitoring safety and compliance
- Empowering workers on the shop floor

## Architecture

The following example hierarchy service is developed as an ASP.NET Core REST API hosted on [Azure Kubernetes Services (AKS)](/azure/aks/intro-kubernetes). Data is persisted in [Azure Digital Twins](/azure/digital-twins) and retrieved from either Azure Digital Twins or an in-memory cache for queries that would result in long response times when issued directly against Azure Digital Twins. The in-memory cache improves the speed of a 3,000-node graph traversal from \~10 seconds to under a second.

[![Infographic of an example hierarchy service.](../media/connected-factory-hierarchy-service-03.png)](../media/connected-factory-hierarchy-service-03.png#lightbox)

1. Allows users to manage the hierarchy.
2. Allows users to manage the hierarchy directly against Azure Digital Twins.
3. API for all hierarchy service bulk import-export operations.
4. Query API for epics and all consumers of hierarchy.
5. API for all admin-related hierarchy activities.

### Extensibility

This system design is intentionally simple to avoid the introduction of additional services or dependencies. However, you might consider extending support for the following functionality, depending on your usage scenarios and requirements:

- Change notifications: Cache synchronization is implemented by periodically polling Azure Digital Twins for changes. You can use [Azure Digital Twins event notifications](/azure/digital-twins/concepts-event-notifications) to initiate a cache refresh and to notify downstream applications.

- Telemetry data: The example Hierarchy Service does not leverage [the capability of Azure Digital Twins to process telemetry data](/azure/digital-twins/concepts-data-ingress-egress). You can extend the solution to process telemetry data if the resulting data rates are compatible with the [service limits of Azure Digital Twins](/azure/digital-twins/reference-service-limits).

- Integration with [Azure Data Explorer](https://azure.microsoft.com/services/data-explorer/#overview): Manufacturing customers are likely to ingest data directly into a store that can manage manufacturing data rates, and then use Azure Digital Twins for contextualization via Azure Digital Twins/Azure Data Explorer joint queries. You can achieve this using the [Azure Digital Twin query plugin for Azure Data Explorer](/azure/digital-twins/concepts-data-explorer-plugin).

### Components

- [Azure Digital Twins](https://azure.microsoft.com/services/digital-twins/#overview) is an IoT platform that creates digital representations of real-world things, places, processes, and people in the cloud.

- [Azure Digital Twins Explorer](/samples/azure-samples/digital-twins-explorer/digital-twins-explorer/) is a developer tool for the [Azure Digital Twins service](/azure/digital-twins/overview). It lets you connect to an Azure Digital Twins instance to understand, visualize, and modify your digital twin data.

- [Azure Kubernetes Services AKS)](/azure/aks/intro-kubernetes) offers serverless Kubernetes for running microservices, an integrated continuous integration and continuous deployment (CI/CD) experience, and enterprise-grade security and governance.

- [Azure App Service](https://azure.microsoft.com/services/app-service/#overview) is a PaaS service for building and hosting apps in managed virtual machines. The underlying compute infrastructure on which your apps run is managed for you. App Service provides monitoring of resource usage quotas and app metrics, logging of diagnostic information, and alerts based on metrics.

- [Azure Data Explorer](https://azure.microsoft.com/services/data-explorer/#overview) is a fast, fully managed data analytics service for real-time analysis on large volumes of data streaming from applications, websites, IoT devices, and more.

### Alternatives

This architecture uses
[AKS](/azure/aks/intro-kubernetes) for running the microservices that query master data from the various connected services. As an alternative, you can run these microservices in Azure Container Instances. Azure Container Instances offers the fastest and simplest way to run a container in Azure, without having to adopt a higher-level service, such as AKS.

The web application that is hosted separately from the microservices running in AKS can also be deployed inside the AKS cluster. This way, there is no need to introduce an additional service such as [Azure App Service.](/azure/app-service/overview)

Consider hosting [SAP on Azure](https://azure.microsoft.com/solutions/sap) to make use of all the additional benefits and integrations it offers with the Azure platform and the
[Microsoft 365 ecosystem](https://news.microsoft.com/2021/01/22/sap-and-microsoft-expand-partnership-and-integrate-microsoft-teams-across-solutions).

Also consider using [Azure Monitor](https://azure.microsoft.com/services/monitor/) to analyze and optimize the performance of your AKS cluster and other resources, and to monitor and diagnose networking issues.

## Problem

Production assets, such as machines, are organized within factories in context-specific hierarchies. For example, they can be organized by physical location, by maintenance requirements, or by the products that they produce.

Since individual stakeholders, processes, and IT systems have different perspectives and needs, the definition of how production assets are organized—and the definition of the corresponding metadata—comes from various sources. This can lead to situations where hierarchical structures are redundantly defined in multiple IT systems, or where information from ERP systems is replicated across multiple applications. These redundancies can lead to inconsistencies, missing correlations between master data and application-specific hierarchies, as well as heterogeneous governance concepts implemented across IT systems and the wider organization.

In such situations, changes to hierarchical structures and metadata are very time consuming, impacting your business agility and scalability. If a new machine is added or a production line is reorganized, changes need to be applied manually in multiple places and the consistency of these changes needs to be verified manually as well. Decentralized access control further increases the need for manual processes, and makes links between application-specific hierarchies more difficult to establish.

An additional challenge when rolling out applications to multiple plants is that individual sites or organizations might use different ERP systems, often for historical reasons such as an acquisition. While standardizing ERP systems is desirable, it might not be feasible to do so within a reasonable amount of time. This heterogeneous ERP landscape adds even more complexity and challenge to the process of integrating shop floor applications with ERP systems.

## Solution

A Hierarchy Service addresses these problems by providing a centralized, consolidated, and consistent definition of the overall hierarchy. A maintenance view and an operational view are supported to cover the needs of both perspectives. It allows your business stakeholders to define and maintain the hierarchy using a graphical UI (without involvement of IT personnel) and provides access control to govern changes.

Anytime an application needs to reference hierarchy data, it retrieves the latest definitions from the Hierarchy Service. This ensures any changes to the hierarchy are always reflected across all applications, without any additional manual steps.

Every node in the hierarchy contains a system-defined unique identifier issued by the Hierarchy Service, which allows you to uniquely identify items (such as a specific machine in a specific factory) across applications throughout your entire organization. This ID can also be added to telemetry data sent by machines, which allows you to contextualize that data based on the hierarchy.

Since only one definition of the hierarchy exists, the Hierarchy Service can act as the single point of integration with ERP systems, allowing you to decouple the lifecycle of ERP systems from the hierarchy. You can integrate with ERP systems manually via graphical UI, via bulk import functionality, or via an API provided by the Hierarchy Service.

To maintain a clean separation of concerns, the Hierarchy Service only contains information about nodes, relationships, and additional metadata like references to corresponding master data (for example, the ERP ID of a given machine). The Hierarchy Service separately maintains any additional information, like actual master data records or application-specific parameters. For instance, your master data records can be provided via a dedicated master data document service, or a shop floor application might maintain parameters like thresholds or default cavity values that are defined on a machine level. With this approach, you can keep the Hierarchy Service lean and efficient, and avoid evolving it into a parallel master data management system.

## Capabilities

This scenario explores an example Hierarchy Service implementation.

### Data model

The Hierarchy Service provides a consolidated data model that allows you to define and query hierarchical views of production assets within factories and other physical locations. This includes the validation of corresponding business rules to enforce consistency and data integrity of the hierarchy.

![A Hierarchy Service architecture infographic](../media/connected-factory-hierarchy-service-01.png)

### Key capabilities

- Business-specific query capabilities and fast query response times when materializing large graphs
- Consistent modeling of core ownership structure of plant assets
- Tailored, domain-specific model, (including validation of business rules)
- Bulk import and export capabilities
- Extensibility based on capabilities provided by Azure Digital Twins and [Azure Data Explorer](https://azure.microsoft.com/services/data-explorer/#overview)
- Role-based access control (RBAC)

### Inventory

These capabilities consist of the following components:

| **Component** | **Value Proposition**                                                                                                                                                               |
|---------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Admin API** | Supports atomic business operations and validation of business rules.                                                                                                               |
| **Query API** | Improves Azure Digital Twins query performance when materializing large graphs (by using an in-memory cache) and provides query capabilities for manufacturing-specific data needs. |
| **IO API**    | Enables bulk import/export for manufacturing-specific scenarios.                                                                                                                    |

### Supported operations

The components listed above support the following operations.

![A screenshot support operations](../media/connected-factory-hierarchy-service-02.png)

Query operations allow you to additionally filter by node types and node attributes.

## Considerations

### Availability

Consider deploying
[AKS](/azure/aks/availability-zones) in availability zones. [Availability zones](/azure/availability-zones/az-overview) are unique physical locations within Azure regions that help protect VMs, applications, and data from datacenter failures.

An AKS cluster distributes resources such as nodes and storage across logical sections of the underlying Azure infrastructure. This deployment model, when using availability zones, ensures nodes in one availability zone are physically separated from those defined in another availability zone. AKS clusters deployed with multiple availability zones configured across a cluster provide a higher level of availability by minimizing the chance a hardware failure or a planned maintenance event will disrupt service.

### Scalability

[AKS services](/azure/aks/scale-cluster) are also designed to scale up or out manually or automatically. For additional scalability, you can consider using [AKS cluster autoscaler](/azure/aks/cluster-autoscaler), which can automatically scale an entire cluster to meet application demands on AKS. The cluster autoscaler component can watch for pods in your cluster that can't be scheduled because of resource constraints. When issues are detected, the number of nodes in a node pool is increased to meet the application demand.

[Azure App Service](/azure/app-service/overview) can also scale up or out manually or automatically.

### Security

To improve the security of your AKS cluster, you can apply and enforce built-in security policies using [Azure Policy](/azure/governance/policy/overview). Azure Policy helps to enforce organizational standards and can assess compliance at-scale. After installing the [Azure Policy Add-on for AKS](/azure/governance/policy/concepts/policy-for-kubernetes), you can apply individual policy definitions or groups of policy definitions called initiatives (sometimes called policysets) to your cluster.

You should restrict who can access and use the connected factory resources, and you should also limit what data can be accessed based on the user's identity or role. Use [Azure Active Directory (Azure AD)](/azure/active-directory/fundamentals/active-directory-whatis) for identity and access control, and use [Azure Key Vault](/azure/key-vault/general/overview) to manage keys and secrets.

### DevOps

For deploying the microservices to the AKS cluster automatically, it's best to use [CI/CD processes](/azure/architecture/example-scenario/apps/devops-with-aks). Consider using a solution such as Azure DevOps or GitHub Actions, as described in the [Azure DevOps Starter](/azure/devops-project/overview) documentation.

## Pricing

In general, use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate costs, and use the [AKS calculator](https://azure.microsoft.com/pricing/calculator/?service=kubernetes-service) to estimate the costs for running AKS in Azure. See the Cost section in
[Microsoft Azure Well-Architected Framework](/azure/architecture/framework/) to learn about other considerations.

## Next steps

- [Industrial Services on Azure Kubernetes](https://github.com/Azure/Industrial-IoT/tree/master/docs/services)
Product documentation:
- [Azure Digital Twins](/azure/digital-twins/overview)
- [Azure Kubernetes Service (AKS)](/azure/aks/intro-kubernetes)
- [Azure Active Directory](/azure/active-directory/fundamentals/active-directory-whatis)
- [Azure DevOps](/azure/devops/user-guide/what-is-azure-devops?view=azure-devops)
    / [GitHub](https://docs.github.com/en/get-started)
- [Azure Monitor](/azure/azure-monitor/overview)
- [Azure App Services](/azure/app-service/overview)
- [Azure Active Directory](/azure/active-directory/fundamentals/active-directory-whatis)

Microsoft Learn learning paths:
- [Develop with Azure Digital Twins](/learn/paths/develop-azure-digital-twins)
- [Introduction to Kubernetes on Azure](/learn/paths/intro-to-kubernetes-on-azure)
- [Manage identities and governance for Azure administrators](/learn/paths/azure-administrator-manage-identities-governance)
- [Monitor and back up resources for Azure administrators](/learn/paths/azure-administrator-monitor-backup-resources)

## Related resources
Azure Architecture Center overview articles:

- [Predictive maintenance for Industrial IoT](/azure/architecture/solution-ideas/articles/iot-predictive-maintenance)
- [Condition monitoring for Industrial IoT](/azure/architecture/solution-ideas/articles/condition-monitoring)
- [IoT and data analytics](/azure/architecture/example-scenario/data/big-data-with-iot)
- [Advanced Azure Kubernetes Service (AKS) microservices architecture](/azure/architecture/reference-architectures/containers/aks-microservices/aks-microservices-advanced)
- [Microservices with AKS](/azure/architecture/solution-ideas/articles/microservices-with-aks)
- [Project 15 Open Platform](/azure/architecture/solution-ideas/articles/project-15-iot-sustainability)
