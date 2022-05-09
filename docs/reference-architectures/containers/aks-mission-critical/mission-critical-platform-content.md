## Reliability 
- Revist main principles that should be considered (add examples from RI where implemented)

## Scalability
- Talk about scale units here?

## Container considerations
- AKS whys?
- Container registry

## Networking consideration
- Front Door whys

## Security
- Identity and access management
- Data in transit
- Data at rest

## Monitoring setup
- Platform logs and metrics
- Observability from AKS
- Log analytics set up
- Health services --> Start with this.
- Setting up alerts

## Failure injection testing
- For each service

--- 
## Dump zone

### Scale units

A _scale unit_ approach is recommended for mission critical workloads where a set of resources can be independently scaled and deployed to keep up with the changes in demand.

![Regional resources](./images/mission-critical-regional-stamp.png)

A scale unit is a logical collection of resources. A stamp is a physical manifest of resources to be deployed. A stamp contains one or more scale units. They are meant to be short lived. After a stamp has served its purpose, it can be removed. 

Consider a use case where you want to deploy updates. It's recommended that a stamp is immutable. That is, deploy a new stamp with updates instead of redeploying the stamp with in- place updates. During the upgrade period, you might have the old and new stamps serving traffic simultaneously. After all the clients have migrated to the new version, you can remove the old stamp.

Here's another example. Suppose a stamp experiences high traffic and reaches its capacity. You deploy additional stamp in another region. When the traffic is back to normal, you can remove that additional stamp.

When a scale unit in a stamp reaches peak capacity, the entire stamp is considered at peak capacity regardless of the utilization of other scale units within that stamp. That's why relationship between related scale-units, and the components inside a single scale-unit, should be defined according to a capacity model, that balances the individual scalability of resources.

The capacity relations between all resources in a scale unit should be known and factored in. E.g.: "To handle 100 incoming requests, we need 5 ingress controller pods and 3 catalog service pods and 1000 RUs in Cosmos".

Thus, when scaling the ingress pods (ideally automatically), you should expect scaling of the catalog service and cosmos RUs within the same relations

Here are some scaling and availability considerations when choosing Azure services in a unit:

- Evaluate autoscaling capabilities of all the services. Load test the services to determine a range within which requests will be served. Based on the results configure minimum and maximum instances and target metrics. When the target is reached, you can choose to automate scaling of the entire unit. 

-  The Azure subscription scale limits and quotas must support the capacity and cost model set by the business requirements. Also check the limits of individual services in consideration. 

- Choose services that support availability zones to build redundancy. This might limit your technology choices.

For other considerations about the size of a unit, and combination of resources, see [Misson critical guidance in Well-architected Framework: ](https://docs.microsoft.com/en-us/azure/architecture/framework/mission-critical/mission-critical-application-design#scale-unit-architecture).


## Table of contents

- [Architecture](#architecture)
  - [Stamp independence](#stamp-independence)
  - [Stateless compute clusters](#stateless-compute-clusters)
  - [Scale Units](#scale-units)
- [Infrastructure](#infrastructure)
  - [Available Azure regions](#available-azure-regions)
  - [Global resources](#global-resources)
  - [Stamp resources](#stamp-resources)
  - [Naming conventions](#naming-conventions)

---

The Azure Mission-Critical reference implementation follows a layered and modular approach. This approach achieves the following goals:

- Cleaner and manageable deployment design
- Ability to switch service(s) with other services providing similar capabilities depending on requirements
- Separation between layers which enables implementation of RBAC easier in case multiple teams are responsible for different aspects of Azure Mission-Critical application deployment and operations

The Azure Mission-Critical reference implementations are composed of three distinct layers:

- Infrastructure
- Configuration
- Application

Infrastructure layer contains all infrastructure components and underlying foundational services required for Azure Mission-Critical reference implementation. It is deployed using [Terraform](./workload/README.md).

> Note: Bicep (ARM DSL) was considered during the early stages as part of a proof-of-concept. Please refer to the following [(archived stub)](/docs/reference-implementation/ZZZ-Archived-Bicep.md) for more details.

[Configuration layer](/src/config/README.md) applies the initial configuration and additional services on top of the infrastructure components deployed as part of infrastructure layer.

[Application layer](/src/app/README.md) contains all components and dependencies related to the application workload itself.

## Architecture

![Architecture overview](/docs/media/mission-critical-architecture-online.svg)

### Stamp independence

Every [stamp](https://docs.microsoft.com/azure/architecture/patterns/deployment-stamp) - which usually corresponds to a deployment to one Azure Region - is considered independent. Stamps are designed to work without relying on components in other regions (i.e. "share nothing").

The main shared component between stamps which requires synchronization at runtime is the database layer. For this, **Azure Cosmos DB** was chosen as it provides the crucial ability of multi-region writes i.e., each stamp can write locally with Cosmos DB handling data replication and synchronization between the stamps.

Aside from the database, a geo-replicated **Azure Container Registry** (ACR) is shared between the stamps. The ACR is replicated to every region which hosts a stamp to ensure fast and resilient access to the images at runtime.

Stamps can be added and removed dynamically as needed to provide more resiliency, scale and proximity to users.

A global load balancer is used to distribute and load balance incoming traffic to the stamps (see [Networking](/docs/reference-implementation/Networking-Design-Decisions.md) for details).

### Stateless compute clusters

As much as possible, no state should be stored on the compute clusters with all states externalized to the database. This allows users to start a user journey in one stamp and continue it in another.

### Scale Units

In addition to [stamp independence](#stamp-independence) and [stateless compute clusters](#stateless-compute-clusters), each "stamp" is considered to be a Scale Unit (SU) following the [Deployment stamps pattern](https://docs.microsoft.com/azure/architecture/patterns/deployment-stamp). All components and services within a given stamp are configured and tested to serve requests in a given range. This includes auto-scaling capabilities for each service as well as proper minimum and maximum values and regular evaluation.

An example Scale Unit design in Azure Mission-Critical consists of scalability requirements i.e. minimum values / the expected capacity:

**Scalability requirements**
| Metric | max |
| --- | --- |
| Users | 25k |
| New games/sec. | 200 |
| Get games/sec. | 5000 |

This definition is used to evaluate the capabilities of a SU on a regular basis, which later then needs to be translated into a Capacity Model. This in turn will inform the configuration of a SU which is able to serve the expected demand:

**Configuration**
| Component | min | max |
| --- | --- | --- |
| AKS nodes | 3 | 12 |
| Ingress controller replicas | 3 | 24 |
| Game Service replicas | 3 | 24 |
| Result Worker replicas | 3 | 12 |
| Event Hub throughput units | 1 | 10 |
| Cosmos DB RUs | 4000 | 40000 |

> Note: Cosmos DB RUs are scaled in all regions simultaneously.

Each SU is deployed into an Azure region and is therefore primarily handling traffic from that given area (although it can take over traffic from other regions when needed). This geographic spread will likely result in load patterns and business hours that might vary from region to region and as such, every SU is designed to scale-in/-down when idle.

## Infrastructure

### Available Azure Regions

The reference implementation of Azure Mission-Critical deploys a set of Azure services. These services are not available across all Azure regions. In addition, only regions which offer **[Availability Zones](https://docs.microsoft.com/azure/availability-zones/az-region)** (AZs) are considered for a stamp. AZs are gradually being rolled-out and are not yet available across all regions. Due to these constraints, the reference implementation cannot be deployed to all Azure regions.

As of March 2022, following regions have been successfully tested with the reference implementation of Azure Mission-Critical:

**Europe/Africa**

- northeurope
- westeurope
- germanywestcentral
- francecentral
- uksouth
- norwayeast
- swedencentral
- southafricanorth

**Americas**

- westus2
- eastus
- eastus2
- centralus
- southcentralus
- brazilsouth
- canadacentral

**Asia Pacific**

- australiaeast
- southeastasia
- eastasia
- japaneast
- koreacentral

> Note: Depending on which regions you select, you might need to first request quota with Azure Support for some of the services (mostly for AKS VMs and Cosmos DB).

It's worth calling out that where an Azure service is not available, an equivalent service may be deployed in its place. Availability Zones are the main limiting factor as far as the reference implementation of AZ is concerned.

As regional availability of services used in reference implementation and AZs ramp-up, we foresee this list changing and support for additional Azure regions improving where reference implementation can be deployed.

> Note: If the target availability SLA for your application workload can be achieved without AZs and/or your workload is not bound with compliance related to data sovereignty, an alternate region where all services/AZs are available can be considered.

### Global resources

#### Azure Front Door

- Front Door is used as the only entry point for user traffic. All backend systems are locked down to only allow traffic that comes through the AFD instance.
- Each stamp comes with a pre-provisioned Public IP address resource, which DNS name is used as a backend for Front Door.
- Diagnostic settings are configured to store all log and metric data for 30 days (retention policy) in Log Analytics.

#### Azure Cosmos DB

- SQL-API (Cosmos DB API) is being used
- `Multi-master write` is enabled
- The account is replicated to every region in which there is a stamp deployed.
- `zone_redundancy` is enabled for each replicated region.
- Request Unit `autoscaling` is enabled on container-level.

#### Azure Container Registry

- `sku` is set to *Premium* to allow geo-replication.
- `georeplication_locations` is automatically set to reflect all regions that a regional stamp was deployed to.
- `zone_redundancy_enabled` provides resiliency and high availability within a specific region.
- `admin_enabled` is set to *false*. The admin user access will not be used. Access to images stored in ACR, for example for AKS, is only possible using AzureAD role assignments.
- Diagnostic settings are configured to store all log and metric data in Log Analytics.

#### Azure Log Analytics for Global Resources

- Used to collect [diagnostic logs](https://docs.microsoft.com/azure/azure-monitor/essentials/diagnostic-settings) of the global resources
- `daily_quota_gb` is set to prevent overspend, especially on environments that are used for load testing.
- `retention_in_days` is used to prevent overspend by storing data longer than needed in Log Analytics - long term log and metric retention is supposed to happen in Azure Storage.

### Stamp resources

A _stamp_ is a regional deployment and can also be considered as a scale-unit. For now we only always deploy one stamp in an Azure Region but this can be extended to allow multiple stamps per region if required.

#### Networking

The current networking setup consists of a single Azure Virtual Network per _stamp_ that consists of one subnet dedicated for Azure Kubernetes Service (AKS).

- Each stamp infrastructure includes a pre-provisioned static _Public IP address_ resource with a DNS name (_[prefix]-cluster.[region].cloudapp.azure.com_). This _Public IP address_ is used for the Kubernetes Ingress controller Load Balancer and as a backend address for Azure Front Door.
- Diagnostic settings are configured to store all log and metric data in Log Analytics.

#### Azure Key Vault

- Key Vault is used as the sole configuration store by the application for both secret as well as non-sensitive values.
- `sku_name` is set to *standard*.
- Diagnostic settings are configured to store all log and metric data in Log Analytics.

#### Azure Kubernetes Service

Azure Kubernetes Service (AKS) is used as the compute platform as it is most versatile and as Kubernetes is the de-facto compute platform standard for modern applications, both inside and outside of Azure.

This Azure Mission-Critical reference implementation uses Linux-only clusters as its sample workload is written in .NET Core and there is no requirement for any Windows-based containers.

- `role_based_access_control` (RBAC) is **enabled**.
- `sku_tier` set to **Paid** (Uptime SLA) to achieve the 99.95% SLA within a single region (with `availability_zones` enabled).
- `http_application_routing` is **disabled** as it is [not recommended for production environments](https://docs.microsoft.com/azure/aks/http-application-routing), a separate Ingress controller solution will be used.
- Managed Identities (SystemAssigned) are used, instead of Service Principals.
- `azure_policy_enabled` is set to `true` to enable the use of [Azure Policies in Azure Kubernetes Service](https://docs.microsoft.com/azure/aks/use-azure-policy). The policy configured in the reference implementation is in "audit-only" mode. It is mostly integrated to demonstrate how to set this up through Terraform.
- `oms_agent` is configured to enable the Container Insights addon and ship AKS monitoring data to Azure Log Analytics via an in-cluster OMS Agent (DaemonSet).
- Diagnostic settings are configured to store all log and metric data in Log Analytics.
- `default_node_pool` settings
  - `availability_zones` is set to `3` to leverage all three AZs in a given region.
  - `enable_auto_scaling` is configured to let the default node pool automatically scale out if needed.
  - `os_disk_type` is set to `Ephemeral` to leverage [Ephemeral OS disks](https://docs.microsoft.com/azure/aks/cluster-configuration#ephemeral-os) for performance reasons.
  - `upgrade_settings` `max_surge` is set to `33%` which is the [recommended value for production workloads](https://docs.microsoft.com/azure/aks/upgrade-cluster#customize-node-surge-upgrade).

> **Important!** In production environments it's recommended to separate system and user node pools (see [Manage system node pools in Azure Kubernetes Service](https://docs.microsoft.com/azure/aks/use-system-pools)). This Azure Mission-Critical reference implementation is using a single (system) node pool for cost-saving purposes and to reduce overhead.

> The `kubernetes.tf` file contains a commented-out example for an additional user node pool with a taint `workload=true:NoSchedule` set to prevent non-workload pods from being scheduled. The `node_label` set to `role=workload` can be used to target this node pool when deploying a workload (see [charts/catalogservice](/src/app/charts/catalogservice/) for an example).

Individual stamps are considered ephemeral and stateless. Updates to the infrastructure and application are following a [Zero-downtime Update Strategy](/docs/reference-implementation/DeployAndTest-DevOps-Zero-Downtime-Update-Strategy.md) and do not touch existing stamps. Updates to Kubernetes are therefore primarily rolled out by releasing new versions and replacing existing stamps. To update node images between two releases, the `automatic_channel_upgrade` in combination with `maintenance_window` is used:

- `automatic_channel_upgrade` is set to `node-image` to [automatically upgrade node pools](https://docs.microsoft.com/azure/aks/upgrade-cluster#set-auto-upgrade-channel) with the most recent AKS node image.
- `maintenance_window` contains the allowed window to run `automatic_channel_upgrade` upgrades. It is currently set to `allowed` on `Sunday` between 0 and 2 AM.

#### Azure Log Analytics for Stamp Resources

Each region has an individual Log Analytics workspace configured to store all log and metric data. As each stamp deployment is considered ephemeral, these workspaces are deployed as part of the global resources and do not share the lifecycle of a stamp. This ensures that when a stamp is deleted (which happens regularly), logs are still available. Log Analytics workspaces reside in a separate resource group `<prefix>-monitoring-rg`.

- `sku` is set to *PerGB2018*.
- `daily_quota_gb` is set to `30` GB to prevent overspend, especially on environments that are used for load testing.
- `retention_in_days` is set to `30` days to prevent overspend by storing data longer than needed in Log Analytics - long term log and metric retention is supposed to happen in Azure Storage.
- For the Health Model, a set of Kusto Functions needs to be added to LogAnalytics. There is a sub-resource type called `SavedSearch`. Because these queries can get quite bulky, they are loaded from files instead of specified inline in Terraform. They are stored in the subdirectory monitoring/queries in the `/src/infra` directory.

#### Azure Application Insights

As with Log Analytics, Application Insights is also deployed per-region and does not share the lifecycle of an stamp. All Application Insight resources are deployed in a separate resource group `<prefix>-monitoring-rg` and are deployed as part of the global resources deployment.

- Log Analytics Workspace-attached mode is being used.
- `daily_data_cap_in_gb` is set to `30` GB to prevent overspend, especially on environments that are used for load testing.

#### Azure Policy

Azure Policy is used to monitor and enforce certain baselines. All policies are assigned on a per-stamp, per-resource group level. Azure Kubernetes Service is configured to use the `azure_policy` addon to leverage Policies configured outside of Kubernetes.

#### Azure Event Hub

- Each stamp has one `standard` tier, `zone_redundant` Event Hub Namespace.
- Auto-inflate (auto-scaleup) can be optionally enabled via a Terraform variable.
- The namespace holds one Event Hub `backendqueue-eh` with dedicated consumer groups for each consumer (currently only one).
- Diagnostic settings are configured to store all log and metric data in Log Analytics.

#### Azure Storage Accounts

- Two storage accounts are deployed per stamp:
  - A "public" storage account with "static web site" enabled. This is used to host the UI single-page application.
  - A "private" storage account which is used for internals such as the health service and the Event Hub checkpointing.
- Both accounts are deployed in zone-redundant mode (`ZRS`).

#### Supporting services

This repository also contains a couple of supporting services for the Azure Mission-Critical project:

- [Self-hosted Agents](./build-agents/README.md)
- [Locust Load Testing](../testing/loadtest-locust/README.md)

These supporting services are required / optional based on how you chose to use Azure Mission-Critical.

## Naming conventions

All resources used for Azure Mission-Critical follow a pre-defined and consistent naming structure to make it easier to identify them and to avoid confusion. Resource abbreviations are based on the [Cloud Adoption Framework](https://docs.microsoft.com/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations#general). These abbreviations are typically attached as a suffix to each resource in Azure.

A **prefix** is used to uniquely identify "deployments" as some names in Azure must be worldwide unique. Examples of these include Storage Accounts, Container Registries and CosmosDB accounts.

**Resource groups**

Resource group names begin with the prefix and then indicate whether they contain per-stamp or global resources. In case of per-stamp resource groups, the name also contains the Azure region they are deployed to.

`<prefix><suffix>-<global | stamp>-<region>-rg`

This will, for example, result in `aoprod-global-rg` for global services in prod or `aoprod7745-stamp-eastus2-rg` for a stamp deployment in `eastus2`.

**Resources**

`<prefix><suffix>-<region>-<resource>` for resources that support `-` in their names and `<prefix><region><resource>` for resources such as Storage Accounts, Container Registries and others that do not support `-` in their names.

This will result in, for example, `aoprod7745-eastus2-aks` for an AKS cluster in `eastus2`.

---