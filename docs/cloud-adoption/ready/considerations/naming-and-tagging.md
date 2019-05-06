---
title: "Ready: Recommended naming and tagging conventions"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
ms.service: architecture-center
ms.subservice: enterprise-cloud-adoption
ms.custom: readiness
ms.date: 04/01/2019
description: Large enterprise – Additional technical details regarding governance MVP
author: BrianBlanchard
---

# Ready: Recommended naming and tagging conventions

Organizing cloud-based assets in ways that both aid operational management and support accounting requirements is a common challenge facing large cloud adoption efforts. Applying well-defined naming and metadata tagging conventions to cloud-hosted resources allows IT staff to quickly find and manage resources, while also helping to align cloud usage costs with business teams using chargeback and showback accounting mechanisms.

The Azure Architecture Center's [naming conventions for Azure resources](/azure/architecture/best-practices/naming-conventions) guidance provides general recommendations on naming conventions as well as discussions of naming limitations and platform rules. The discussion below extends that generic guidance with more detailed recommendations aimed specifically at supporting enterprise cloud adoption efforts.

Resource names can be difficult to change, so establishing a comprehensive naming convention before you begin any large cloud deployment should be a priority for your cloud adoption teams.

> [!NOTE]
> Every business has different organizational and management requirements, and the recommendations in this article should act as a starting point for discussions within your cloud adoption teams.
>
> As these discussions progress, use the template linked below to capture the naming and tagging decisions you make when aligning these recommendations to your specific business needs.
>
> Download the [naming and tagging convention tracking template](https://archcenter.blob.core.windows.net/cdn/fusion/readiness/CAF%20Readiness%20Naming%20and%20Tagging%20tracking%20template.xlsx).

## Naming and tagging resources

Naming and tagging strategy should include business and operational details as components of resource names and metadata tags. The business-related side of this strategy should ensure resource names and tags include the organizational information needed to identify the teams using a resource along with the business owners responsible for resource costs. The operational side should ensure names and tags include information that IT teams use to identify the workload, application, environment, criticality, and other information useful for managing resources.

### Resource naming

An effective naming convention assembles resource names using important resource information as parts of a resource's name. For example, using the recommended naming conventions discussed [later in this article](#sample-naming-convention), a public IP resource for a production SharePoint workload would be named like this: `pip-sharepoint-prod-westus-001`.

From the name, you can quickly identify the resource's type, its associated workload, its deployment environment, and the Azure region hosting it.

#### Naming scope

All Azure resource types have a scope defining how these assets can be managed relative to other resource types. In terms of naming conventions, this means that a resource must have a unique name within its scope.

For example, a virtual network has a resource group scope, meaning that there can only be one network named `vnet-prod-westus-001` in a given resource group. However, other resource groups can have their own virtual network named `vnet-prod-westus-001`. Subnets, to give another example, are scoped to virtual networks, meaning each subnet within a virtual network must be uniquely named.

Some resources names, such as PaaS services with public endpoints or virtual machine DNS labels, have global scopes, meaning that they must be unique across the entire Azure platform.

Resource names have length limits, so balancing the context embedded in a name with its scope and length is important when developing your naming conventions. For more information about naming rules regarding allowed characters, scopes, and name lengths for resource types, see [Naming conventions for Azure resources](/azure/architecture/best-practices/naming-conventions).

#### Recommended naming components

When constructing your naming convention, you need to identify the key pieces of information that you want to reflect in a resource name. Different information is relevant for different resource types, but the following list provides examples of information that are useful when constructing resource names.

Note: Keep the length of naming components short to prevent exceeding resource name length limits.

| Naming component           | Description                                                                                                                                                                                          | Examples                                         |
|----------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------|
| Business unit              | Top-level division of your company that owns the subscription or workload the resource belongs to. In smaller organizations, this may represent a single corporate top-level organizational element. | *fin*, *mktg*, *product*, *it*, *corp*           |
| Subscription type          | Summary description of the purpose of the subscription containing the resource. Often broken down by deployment environment type or specific workloads.                                              | *prod,* s*hared, client*                         |
| Application / Service name | Name of the application, workload, or service that the resource is a part of.                                                                                                                        | *navigator*, *emissions*, *sharepoint*, *hadoop* |
| Deployment environment     | The stage of the workload's development lifecycle that the resource is supporting.                                                                                                                   | *prod, dev, qa, stage, test*                     |
| Region                     | Azure region where the resource is deployed.                                                                                                                                                         | *westus, eastus2, westeurope, usgovia*           |

#### Recommended resource type prefixes

Each workload can consist of many individual resources and services. Incorporating resource type prefixes into your resource names makes visually identifying application or service components much easier.

The following list provides recommended Azure resource type prefixes to use when defining your naming conventions.

| Resource type                       | Resource name prefix |
|-------------------------------------|----------------------|
| Resource group                      | rg-                  |
| Virtual network                     | vnet-                |
| Virtual network gateway             | vnet-gw-             |
| Gateway connection                  | cn-                  |
| Subnet                              | snet-                |
| NSG                                 | nsg-                 |
| Virtual machines                    | vm-                  |
| VM storage account                  | stvm                 |
| Public IP                           | pip-                 |
| Load balancer                       | lb-                  |
| NIC                                 | nic-                 |
| Service Bus                         | sb-                  |
| Service Bus queues                  | sbq-                 |
| App Service apps                    | azapp-               |
| Function apps                       | azfun-               |
| Cloud Services                      | azcs-                |
| Azure SQL Database                  | sqldb-               |
| Azure Cosmos DB (Document Database) | cosdb-               |
| Azure Cache for Redis               | redis-               |
| Azure Database for MySQL            | mysql-               |
| SQL Data Warehouse                  | sqldw-               |
| SQL Server Stretch Database         | sqlstrdb-            |
| Azure Storage                       | stor                 |
| StorSimple                          | ssimp                |
| Azure Search                        | srch-                |
| Cognitive Services                  | cs-                  |
| Azure Machine Learning workspace    | aml-                 |
| Azure Data Lake Storage             | dls                  |
| Azure Data Lake Analytics           | dla                  |
| HDInsight - Spark                   | hdis-                |
| HDInsight - Hadoop                  | hdihd-               |
| HDInsight - R server                | hdir-                |
| HDInsight - HBase                   | hdihb-               |
| Power BI Embedded                   | pbiemb               |
| Stream analytics                    | asa-                 |
| Data Factory                        | df-                  |
| Event Hub                           | evh-                 |
| Azure IoT Hub                       | aih-                 |
| Notification Hubs                   | anh-                 |
| Notification Hub Namespace          | anhns-               |

### Metadata tags

Applying metadata tags to your cloud resources allows you to include information about those assets that couldn't be included in the resource name, and also allows you to perform more sophisticated filtering and reporting on resources. These tags should include context about the resource's associated workload or application, operational requirements, and ownership information, which can be used by IT or business teams to find resources or generate reports about resource usage and billing.

What tags you apply to resources, and what tags are required versus optional, will differ between organizations. The list below provides examples of common tags capturing important context and information about a resource that you can use as a starting point for establishing your own tagging conventions.

| Tag Name                  | Description                                                                                                                                                                                                    | Key               | Example Value                                   |
|---------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------------|-------------------------------------------------|
| Application Name          | Name of the application, service, or workload the resource is associated with.                                                                                                                                 | *ApplicationName* | *{app name}*                                    |
| Approver Name             | Person responsible for approving costs related to this resource.                                                                                                                                               | *Approver*        | *{email}*                                       |
| Budget required/approved  | Money allocated for this application, service, or workload.                                                                                                                                                     | *BudgetAmount*    | *{\$}*                                          |
| Business Unit             | Top-level division of your company that owns the subscription or workload the resource belongs to. In smaller organizations, this may represent a single corporate or shared top-level organizational element. | *BusinessUnit*    | *FINANCE, MARKETING,{Product Name},CORP, SHARED* |
| Cost Center               | Accounting cost center associated with this resource.                                                                                                                                                          | *CostCenter*      | *{number}*                                      |
| Disaster Recovery         | Business criticality of this application, workload, or service.                                                                                                                                                | *DR*              | *Mission-critical, Critical, Essential*         |
| End Date of the Project   | Date when this application, workload, or service is scheduled for retirement.                                                                                                                                     | *EndDate*         | *{date}*                                        |
| Environment               | Deployment environment of this application, workload, or service.                                                                                                                                              | *Env*             | *Prod, Dev, QA, Stage, Test*                    |
| Owner Name                | Owner of the application, workload, or service.                                                                                                                                                                | *Owner*           | *{email}*                                       |
| Requester Name            | User that requested the creation of this application.                                                                                                                                                          | *Requestor*       | *{email}*                                       |
| Service Class             | Service Level Agreement level of this application, workload, or service.                                                                                                                                       | *ServiceClass*    | *Dev, Bronze, Silver, Gold*                     |
| Start Date of the project | Date when this application, workload, or service was first deployed.                                                                                                                                           | *StartDate*       | *{date}*                                        |

## Sample naming convention

The following section provides examples of naming schemes for common Azure resource types deployed during an enterprise cloud deployment.

### Subscriptions

| Asset type   | Scope                        | Format                                             | Examples                                     |
|--------------|------------------------------|----------------------------------------------------|----------------------------------------------|
| Subscription | Account/Enterprise Agreement | \<Business Unit\>-\<Subscription type\>-\<\#\#\#\> | <ul><li>mktg-prod-001 </li><li>corp-shared-001 </li><li>fin-client-001</li></ul> |

### Resource groups

| Asset type     | Scope        | Format                                                     | Examples                                                                            |
|----------------|--------------|------------------------------------------------------------|-------------------------------------------------------------------------------------|
| Resource Group | Subscription | rg-\<App / Service name\>-\<Subscription type\>-\<\#\#\#\> | <ul><li>rg-mktgsharepoint-prod-001 </li><li>rg-acctlookupsvc-share-001 </li><li>rg-ad-dir-services-shared-001</li></ul> |

### Virtual Networking

| Asset type               | Scope           | Format                                                                | Examples                                                                                              |
|--------------------------|-----------------|-----------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------|
| Virtual Network          | Resource group  | vnet-\<Subscription type\>-\<Region\>-\<\#\#\#\>                      | <ul><li>vnet-shared-eastus2-001 </li><li>vnet-prod-westus-001 </li><li>vnet-client-eastus2-001</li></ul>                                  |
| Vnet virtual gateway     | Virtual network | vnet-gw-v-\<Subscription type\>-\<Region\>-\<\#\#\#\>                 | <ul><li>vnet-gw-v-shared-eastus2-001 </li><li>vnet-gw-v-prod-westus-001 </li><li>vnet-gw-v-client-eastus2-001</li></ul>                   |
| Vnet local gateway       | Virtual gateway | vnet-gw-l-\<Subscription type\>-\<Region\>-\<\#\#\#\>                 | <ul><li>vnet-gw-l-shared-eastus2-001 </li><li>vnet-gw-l-prod-westus-001 </li><li>vnet-gw-l-client-eastus2-001</li></ul>                   |
| Site to site connections | Resource group  | cn-\<local gateway name\>-to-\<virtual gateway name\>                 | <ul><li>cn-l-gw-shared-eastus2-001-to-v-gw-shared-eastus2-001 </li><li>cn-l-gw-shared-eastus2-001-to-shared-westus-001</li></ul> |
| VNet Connections         | Resource group  | cn-\<subscription1\>\<region1\>-to-\<subscription2\>\<region2\>-      | <ul><li>cn-shared-eastus2-to-shared-westus </li><li>cn-prod-eastus2-to-prod-westus</li></ul>                                     |
| Subnet                   | Virtual network | snet-\<subscription\>-\<subregion\>-\<\#\#\#\>                       | <ul><li>snet-shared-eastus2-001 </li><li>snet-prod-westus-001 </li><li>snet-client-eastus2-001</li></ul>                                  |
| NSG                      | Subnet or NIC   | nsg-\<policy name or appname\>-\<\#\#\#\>                             | <ul><li>nsg-weballow-001 </li><li>nsg-rdpallow-001 </li><li>nsg-sqlallow-001 </li><li>nsg-dnsbloked-001</li></ul>                                  |
| Public IP                | Resource group  | pip-\<vm name or app name\>-\<Environment\>-\<subregion\>-\<\#\#\#\> | <ul><li>pip-dc1-shared-eastus2-001 </li><li>pip-hadoop-prod-westus-001</li></ul>                                                 |

### Azure Virtual Machines

| Asset type         | Scope          | Format                                                              | Examples                                                                             |
|--------------------|----------------|---------------------------------------------------------------------|--------------------------------------------------------------------------------------|
| Virtual Machine    | Resource group | vm\<policy name or appname\>\<\#\#\#\>                              | <ul><li>vmnavigator001 </li><li>vmsharepoint001 </li><li>vmsqlnode001 </li><li>vmhadoop001</li></ul>                              |
| VM Storage account | Global         | stvm\<performance type\>\<appname or prodname\>\<region\>\<\#\#\#\> | <ul><li>stvmstcoreeastus2001 </li><li>stvmpmcoreeastus2001 </li><li>stvmstplmeastus2001 </li><li>stvmsthadoopeastus2001</li></ul> |
| DNS Label          | Global         | \<A record of vm\>.[\<region\>.cloudapp.azure.com]                  | <ul><li>dc1.westus.cloudapp.azure.com </li><li>web1.eastus2.cloudapp.azure.com</li></ul>                        |
| Load Balancer      | Resource group | lb-\<app name or role\>\<Environment\>\<\#\#\#\>                    | <ul><li>lb-navigator-prod-001 </li><li>lb-sharepoint-dev-001</li></ul>                                          |
| NIC                | Resource group | nic-\<\#\#\>-\<vmname\>-\<subscription\>\<\#\#\#\>                  | <ul><li>nic-01-dc1-shared-001 </li><li>nic-02-vmhadoop1-prod-001 </li><li>nic-02-vmtest1-client-001</li></ul>            |

### PaaS Services

| Asset type     | Scope  | Format                                                              | Examples                                                                                 |
|----------------|--------|---------------------------------------------------------------------|------------------------------------------------------------------------------------------|
| App Service    | Global | azapp-\<App Name\>-\<Environment\>-\<\#\#\#\>.[{azurewebsites.net}] | <ul><li>azapp-navigator-prod-001.azurewebsites.net </li><li>azapp-accountlookup-dev-001.azurewebsites.net</li></ul> |
| Function App   | Global | azfun-\<App Name\>-\<Environment\>-\<\#\#\#\>.[{azurewebsites.net}] | <ul><li>azfun-navigator-prod-001.azurewebsites.net </li><li>azfun-accountlookup-dev-001.azurewebsites.net</li></ul> |
| Cloud Services | Global | azcs-\<App Name\>-\<Environment\>-\<\#\#\#\>.[{cloudapp.net}]       | <ul><li>azcs-navigator-prod-001.azurewebsites.net </li><li>azcs-accountlookup-dev-001.azurewebsites.net</li></ul>   |

### Azure Service Bus

| Asset type         | Scope       | Format                                                     | Examples                           |
|--------------------|-------------|------------------------------------------------------------|------------------------------------|
| Service Bus        | Global      | sb-\<App Name\>-\<Environment\>.[{servicebus.windows.net}] | <ul><li>sb-navigator-prod </li><li>sb-emissions-dev</li></ul> |
| Service Bus queues | Service Bus | sbq-\<query descriptor\>                                   | <ul><li>sbq-messagequery</li></ul>                   |

### Databases

| Asset type                          | Scope              | Format                                | Examples                                       |
|-------------------------------------|--------------------|---------------------------------------|------------------------------------------------|
| Azure SQL Database                  | Global             | sqldb-\<App Name\>-\<Environment\>    | <ul><li>sqldb-navigator-prod </li><li>sqldb-emissions-dev</li></ul>       |
| Azure Cosmos DB (Document Database) | Global             | cosdb-\<App Name\>-\<Environment\>    | <ul><li>cosdb-navigator-prod </li><li>cosdb-emissions-dev</li></ul>       |
| Azure Cache for Redis               | Global             | redis-\<App Name\>-\<Environment\>    | <ul><li>redis-navigator-prod </li><li>redis-emissions-dev</li></ul>       |
| Azure Database for MySQL            | Global             | mysql-\<App Name\>-\<Environment\>    | <ul><li>mysql-navigator-prod </li><li>mysql-emissions-dev</li></ul>       |
| SQL Data Warehouse                  | Global             | sqldw-\<App Name\>-\<Environment\>    | <ul><li>sqldw-navigator-prod </li><li>sqldw-emissions-dev</li></ul>       |
| SQL Server Stretch Database         | Azure SQL Database | sqlstrdb-\<App Name\>-\<Environment\> | <ul><li>sqlstrdb-navigator-prod </li><li>sqlstrdb-emissions-dev</li></ul> |

### Storage

| Asset type                              | Scope  | Format                                                                        | Examples                                   |
|-----------------------------------------|--------|-------------------------------------------------------------------------------|--------------------------------------------|
| Azure Storage account - general use     | Global | st\<storage name\>\<\#\#\#\>                                                  | <ul><li>stnavigatordata001 </li><li>stemissionsoutput001</li></ul>    |
| Azure Storage account - diagnostic logs | Global | stdiag\<first 2 letters of subscription name and number\>\<region\>\<\#\#\#\> | <ul><li>stdiagsh001eastus2001 </li><li>stdiagsh001westus001</li></ul> |
| StorSimple                              | Global | ssimp\<App Name\>\<Environment\>                                              | <ul><li>ssimpnavigatorprod </li><li>ssimpemissionsdev</li></ul>       |

### AI + Machine Learning

| Asset type                       | Scope          | Format                            | Examples                               |
|----------------------------------|----------------|-----------------------------------|----------------------------------------|
| Azure Search                     | Global         | srch-\<App Name\>-\<Environment\> | <ul><li>srch-navigator-prod </li><li>srch-emissions-dev</li></ul> |
| Cognitive Services               | Resource group | cs-\<App Name\>-\<Environment\>   | <ul><li>cs-navigator-prod </li><li>cs-emissions-dev</li></ul>     |
| Azure Machine Learning workspace | Resource group | aml-\<App Name\>-\<Environment\>  | <ul><li>aml-navigator-prod </li><li>aml-emissions-dev</li></ul>   |

### Analytics

| Asset type                | Scope  | Format                             | Examples                                 |
|---------------------------|--------|------------------------------------|------------------------------------------|
| Azure Data Factory        | Global | df-\<App Name\>\<Environment\>     | <ul><li>df-navigator-prod </li><li>df-emissions-dev</li></ul>       |
| Azure Data Lake Storage   | Global | dls\<App Name\>\<Environment\>     | <ul><li>dlsnavigatorprod </li><li>dlsemissionsdev</li></ul>         |
| Azure Data Lake Analytics | Global | dla\<App Name\>\<Environment\>     | <ul><li>dlanavigatorprod </li><li>dlaemissionsdev</li></ul>         |
| HDInsight - Spark         | Global | hdis-\<App Name\>-\<Environment\>  | <ul><li>hdis-navigator-prod </li><li>hdis-emissions-dev </li></ul>  |
| HDInsight - Hadoop        | Global | hdihd-\<App Name\>-\<Environment\> | <ul><li>hdihd-hadoop-prod </li><li>hdihd-emissions-dev</li></ul>    |
| HDInsight - R server      | Global | hdir-\<App Name\>-\<Environment\>  | <ul><li>hdir-navigator-prod </li><li>hdir-emissions-dev</li></ul>   |
| HDInsight - HBase         | Global | hdihb-\<App Name\>-\<Environment\> | <ul><li>hdihb-navigator-prod </li><li>hdihb-emissions-dev</li></ul> |
| Power BI Embedded         | Global | pbiemb\<App Name\>\<Environment\>  | <ul><li>pbiem-navigator-prod </li><li>pbiem-emissions-dev</li></ul> |

### Internet of Things (IoT)

| Asset type                         | Scope          | Format                             | Examples                                 |
|------------------------------------|----------------|------------------------------------|------------------------------------------|
| Azure Stream Analytics on IoT Edge | Resource group | asa-\<App Name\>-\<Environment\>   | <ul><li>asa-navigator-prod </li><li>asa-emissions-dev</li></ul>     |
| Azure IoT Hub                      | Global         | aih-\<App Name\>-\<Environment\>   | <ul><li>aih-navigator-prod </li><li>aih-emissions-dev</li></ul>     |
| Event Hub                          | Global         | evh-\<App Name\>-\<Environment\>   | <ul><li>evh-navigator-prod </li><li>evh-emissions-dev</li></ul>     |
| Notification Hub                   | Resource group | anh-\<App Name\>-\<Environment\>   | <ul><li>evh-navigator-prod </li><li>evh-emissions-dev</li></ul>     |
| Notification Hub Namespace         | Global         | anhns-\<App Name\>-\<Environment\> | <ul><li>anhns-navigator-prod </li><li>anhns-emissions-dev</li></ul> |

<!-- update once primitives document is complete

## Next steps

Review the [Azure primitives document](./xx-primitives.md) to understand core concepts relating to the Azure platform and the features, products, and services you will need to deploy workloads to the cloud.

> [!div class="nextstepaction"]
> [Azure primitives](./xx-primitives.md)
-->

## Next steps

For next steps and the most recent status regarding the Ready model in the Cloud Adoption Framework, see the [overview page](../index.md).