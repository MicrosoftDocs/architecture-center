This scenario explores an example hierarchy service implementation. A hierarchy service centrally defines the organization of production assets like machines within factories, from both an operational and maintenance point of view. Business stakeholders can use this information as a common data source for monitoring plant conditions or overall equipment effectiveness (OEE).

## Problem

Production assets like machines are organized within factories in context-specific hierarchies. For example, machines can be organized by physical location, maintenance requirements, or their products. Individual stakeholders, processes, and IT systems define production asset organizations differently. Multiple IT systems can define hierarchical structures redundantly, or information from enterprise resource management (ERP) systems might be replicated across multiple applications. These redundancies can lead to inconsistencies, heterogeneous governance concepts, and missing correlations between master data and application-specific hierarchies.

Changes to hierarchical structures and the metadata that defines them are very time consuming. If a new machine is added or a production line is reorganized, changes need to be applied manually in multiple places. The consistency of these changes must be verified manually. Decentralized access control increases the need for manual processes, and makes links between application-specific hierarchies difficult to establish. These issues impact business agility and scalability. 

An additional challenge is that individual sites or organizations might use different ERP systems, often for historical reasons such as an acquisition. Standardizing ERP systems might not be feasible within a reasonable amount of time. This heterogeneous ERP landscape adds even more complexity and challenge to the process of integrating shop floor applications with ERP systems.

## Solution

A hierarchy service addresses these problems by providing a centralized, consolidated, and consistent overall hierarchy definition.

Anytime an application needs to reference hierarchy data, it retrieves the latest definitions from the hierarchy service. Any changes to the hierarchy always reflect across all applications, without manual steps.

Every node in the hierarchy contains a system-defined unique identifier issued by the service. This ID uniquely identifies items, such as a specific machine in a specific factory, across applications throughout an entire organization. The ID can also be added to telemetry data sent by machines, to contextualize that data based on the hierarchy.

To maintain a separation of concerns, the hierarchy service only contains information about nodes, relationships, and references to corresponding master data, such as the ERP ID of a given machine. The hierarchy service  maintains other information, like actual master data records or application-specific parameters, separately. Master data records can be provided via a dedicated master data document service. A shop floor application might maintain parameters like thresholds or default cavity values that are defined on a machine level. The hierarchy service remains lean and efficient, and avoids evolving into a parallel master data management system.

The hierarchy service acts as the single point of integration with ERP systems, decoupling the lifecycle of ERP systems from the hierarchy. You can integrate with ERP systems manually via graphical UI, bulk import, or an API the hierarchy service provides.

A maintenance view and an operational view cover the needs of both perspectives. The service provides access control to govern changes. Business stakeholders can define and maintain the hierarchy by using a graphical UI, without involving IT personnel. 

[Azure Digital Twins](/azure/digital-twins) can help build a hierarchy service by creating a model of nodes, like machines, work centers, and locations, and their relationships. Each node has metadata that includes identifiers from ERP systems. You can use this contextual information in downstream applications to gain insights into production states, aggregate machine data, or identify machines that can fulfill a given order.

## Potential use cases

Potential uses for this solution include:

- Predictive maintenance
- Enabling connectivity in a plant or factory
- Sustaining productivity in a plant or factory
- Monitoring safety and compliance
- Empowering workers on the shop floor

## Architecture

The following example hierarchy service is an ASP.NET Core REST API hosted on [Azure Kubernetes Services (AKS)](/azure/aks/intro-kubernetes).

[![Infographic of an example hierarchy service.](../media/connected-factory-hierarchy-service-03.png)](../media/connected-factory-hierarchy-service-03.png#lightbox)


1. The **web app** allows users to manage the hierarchy.
1. **Azure Digital Twins Explorer** allows users to manage the hierarchy directly against Azure Digital Twins.
1. The **IO API** supports bulk import and export for manufacturing-specific scenarios.
1. The **Query API** provides query capabilities for manufacturing-specific data needs. The API improves Azure Digital Twins query performance when materializing large graphs by using an in-memory cache. The in-memory cache improves the speed of a 3,000-node graph traversal from about 10 seconds to less than a second.
1. The **Admin API** supports atomic business operations and validation of business rules.

### Data model

The hierarchy service provides a consolidated data model that lets you define and query hierarchical views of production assets within factories and other locations. The hierarchy service can validate business rules to enforce hierarchy consistency and data integrity.

![A Hierarchy Service architecture infographic](../media/connected-factory-hierarchy-service-01.png)

Data is retrieved from either [Azure Digital Twins](/azure/digital-twins), or an in-memory cache for queries that would result in long response times when issued directly against Azure Digital Twins. 

### Supported operations

The hierarchy service lets you filter query operations by node types and node attributes. The service supports the following operations:

Admin

|Operation|Filter|Description|
|---|---|---|
|`post`|`/api/v0.1/nodes`|Add new node with relations into hierarchy.|
|`delete`|`/api/v0.1/nodes/{nodeId}`|Remove a leaf node from hierarchy.|
|`put`|`/api/v0.1/nodes/{nodeId}`|Update existing node and relationships with parents.|

Query

|Operation|Filter|Description|
|---|---|---|
|`get`|`/api/v0.1/nodes`|Get nodes by their attribute values.|
|`get`|`/api/v0.1/nodes/{nodeId}`|Get a node by Id.|
|`get`|`/api/v0.1/nodes/{nodeId}/subtree`|Get subtree of a hierarchy node.|
|`get`|`/api/v0.1/nodes/{nodeId}/children`|Get direct children of a hierarchy node.|
|`get`|`/api/v0.1/nodes/{nodeId}/parent`|Get parent of a hierarchy node.|

Bulk

|Operation|Filter|Description|
|---|---|---|
|`get`|`/api/v0.1/bulk`|Export hierarchy data.|
|`post`|`/api/v0.1/bulk`|Import hierarchy data file.|
|`post`|`/api/v0.1/bulk/validate`|Validate hierarchy data import file.|
|`get`|`/api/v0.1/bulk/status/{operationId}`|Get the status of a bulk import operation.|

### Components

- [Azure Digital Twins](https://azure.microsoft.com/services/digital-twins/#overview) is an IoT platform that creates digital representations of real-world things, places, processes, and people in the cloud.
- [Azure Digital Twins Explorer](/samples/azure-samples/digital-twins-explorer/digital-twins-explorer) lets you connect to an Azure Digital Twins instance to understand, visualize, and modify your digital twin data.
- [Azure Kubernetes Services (AKS)](/azure/aks/intro-kubernetes) offers serverless Kubernetes for running microservices, integrated continuous integration and continuous deployment (CI/CD), and enterprise-grade security and governance.
- [Azure App Service](https://azure.microsoft.com/services/app-service/#overview) is a platform-as-a-service (PaaS) for building and hosting apps in managed virtual machines. App Service manages the underlying compute infrastructure that runs your apps. App Service provides monitoring of resource usage quotas and app metrics, logging of diagnostic information, and alerts based on metrics.
- [Azure Data Explorer](https://azure.microsoft.com/services/data-explorer/#overview) is a fast, fully managed data analytics service for real-time analysis on large volumes of data streaming from applications, websites, and IoT devices.

### Alternatives

- This architecture uses AKS for running the microservices that query master data from the various connected services. You can also run the microservices in [Azure Container Instances (ACI)](https://azure.microsoft.com/services/container-instances). ACI offers the fastest and simplest way to run a container in Azure, without having to adopt a higher-level service like AKS.

- Instead of hosting the web application separately from the microservices running in AKS, you can deploy the web app inside the AKS cluster. There's then no need to introduce another service such as [Azure App Service.](/azure/app-service/overview).

- Consider hosting [SAP on Azure](https://azure.microsoft.com/solutions/sap), to use all the benefits and integrations with the Azure platform and the [Microsoft 365 ecosystem](https://news.microsoft.com/2021/01/22/sap-and-microsoft-expand-partnership-and-integrate-microsoft-teams-across-solutions).

- Consider using [Azure Monitor](https://azure.microsoft.com/services/monitor/) to analyze and optimize the performance of the AKS cluster and other resources, and to monitor and diagnose networking issues.

This system design is intentionally simple to avoid the introduction of more services or dependencies. Consider supporting the following functionality:

- Change notifications. This example implements cache synchronization by periodically polling Azure Digital Twins for changes. You can also use [Azure Digital Twins event notifications](/azure/digital-twins/concepts-event-notifications) to initiate a cache refresh and to notify downstream applications.

- Telemetry data. The example doesn't use the Azure Digital Twins [telemetry data processing capability](/azure/digital-twins/concepts-data-ingress-egress). You can extend the solution to process telemetry data if the resulting data rates are compatible with the [Azure Digital Twins service limits](/azure/digital-twins/reference-service-limits).

- Integration with [Azure Data Explorer](https://azure.microsoft.com/services/data-explorer/#overview). You can ingest data directly into a store that can manage manufacturing data rates, then use Azure Digital Twins for contextualization via Azure Digital Twins/Azure Data Explorer joint queries. Use the [Azure Digital Twin query plugin for Azure Data Explorer](/azure/digital-twins/concepts-data-explorer-plugin).

## Considerations

The following considerations apply to this solution:

### Availability

Consider deploying [AKS](/azure/aks/availability-zones) in [availability zones](/azure/availability-zones/az-overview). An AKS cluster distributes resources such as nodes and storage across logical sections of the underlying Azure infrastructure. This deployment model, when using availability zones, ensures nodes in one availability zone are physically separated from those defined in another availability zone. AKS clusters deployed with multiple availability zones configured across a cluster provide a higher level of availability by minimizing the chance a hardware failure or planned maintenance event will disrupt service.

### DevOps

[CI/CD processes](/azure/architecture/example-scenario/apps/devops-with-aks) deploy the microservices to the AKS cluster automatically. Use a solution like Azure Pipelines or GitHub Actions.

### Scalability

AKS services can [scale up or out, manually or automatically](/azure/aks/scale-cluster). The [AKS cluster autoscaler](/azure/aks/cluster-autoscaler) can automatically scale an entire cluster to meet application demands on AKS. The cluster autoscaler watches for cluster pods that can't be scheduled because of resource constraints. When the autoscaler detects issues, it increases the number of nodes in the node pool to meet the application demand.

Azure App Service can also scale up or out, manually or automatically.

### Security

To improve AKS security, apply and enforce built-in security policies by using [Azure Policy](/azure/governance/policy/overview). Azure Policy helps enforce organizational standards and can assess compliance at scale. The [Azure Policy Add-on for AKS](/azure/governance/policy/concepts/policy-for-kubernetes) can apply individual policy definitions or groups of policy definitions called initiatives to your cluster.

Use [role-based access control (RBAC)](/azure/role-based-access-control/overview) to restrict who can access and use the connected factory resources, and limit data access based on the user's identity or role. This solution uses [Azure Active Directory (Azure AD)](/azure/active-directory/fundamentals/active-directory-whatis) for identity and access control, and [Azure Key Vault](/azure/key-vault/general/overview) to manage keys and secrets.

## Pricing

In general, use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate costs. Use the [AKS calculator](https://azure.microsoft.com/pricing/calculator/?service=kubernetes-service) to estimate the cost of running AKS in Azure. See the Cost section in [Microsoft Azure Well-Architected Framework](/azure/architecture/framework/) to learn about other considerations.

## Next steps

- [Industrial services on Azure Kubernetes](https://github.com/Azure/Industrial-IoT/tree/master/docs/services)
- [Develop with Azure Digital Twins (Learning path)](/learn/paths/develop-azure-digital-twins)
- [Introduction to Kubernetes on Azure (Learning path)](/learn/paths/intro-to-kubernetes-on-azure)

## Related resources

- [Predictive maintenance for Industrial IoT](iot-predictive-maintenance.yml)
- [Condition monitoring for Industrial IoT](condition-monitoring.yml)
- [IoT and data analytics](../../example-scenario/data/big-data-with-iot.yml)
- [Advanced Azure Kubernetes Service (AKS) microservices architecture](../../reference-architectures/containers/aks-microservices/aks-microservices-advanced.yml)
- [Microservices with AKS](microservices-with-aks.yml)
