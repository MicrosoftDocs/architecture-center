---
title: Naming conventions for Azure resources
titleSuffix: Best practices for cloud applications
description: Recommendations for naming virtual machines, storage accounts, networks, virtual networks, subnets and other Azure entities.
author: telmosampaio
ms.date: 10/19/2018
ms.topic: best-practice
ms.service: architecture-center
ms.subservice: cloud-fundamentals
ms.custom: seodec18
---

# Naming conventions for Azure resources

This article is a summary of the naming rules and restrictions for Azure resources and a baseline set of recommendations for naming conventions. You can use these recommendations as a starting point for your own conventions specific to your needs.

The choice of a name for any resource in Microsoft Azure is important because:

- It is difficult to change a name later.
- Names must meet the requirements of their specific resource type.

Consistent naming conventions make resources easier to locate. They can also indicate the role of a resource in a solution.

The key to success with naming conventions is establishing and following them across your applications and organizations.

## Naming subscriptions

When naming Azure subscriptions, verbose names make understanding the context and purpose of each subscription clear. When working in an environment with many subscriptions, following a shared naming convention can improve clarity.

A recommended pattern for naming subscriptions is:

`<Company> <Department (optional)> <Product Line (optional)> <Environment>`

- Company would usually be the same for each subscription. However, some companies may have child companies within the organizational structure. These companies may be managed by a central IT group. In these cases, they could be differentiated by having both the parent company name (*Contoso*) and child company name (*Northwind*).
- Department is a name within the organization that contains a group of individuals. This item within the namespace is optional.
- Product line is a specific name for a product or function that is performed from within the department. This is generally optional for internal-facing services and applications. However, it is highly recommended to use for public-facing services that require easy separation and identification (such as for clear separation of billing records).
- Environment is the name that describes the deployment lifecycle of the applications or services, such as Dev, QA, or Prod.

| Company | Department | Product Line or Service | Environment | Full Name |
| --- | --- | --- | --- | --- |
| Contoso |SocialGaming |AwesomeService |Production |Contoso SocialGaming AwesomeService Production |
| Contoso |SocialGaming |AwesomeService |Dev |Contoso SocialGaming AwesomeService Dev |
| Contoso |IT |InternalApps |Production |Contoso IT InternalApps Production |
| Contoso |IT |InternalApps |Dev |Contoso IT InternalApps Dev |

For more information on how to organize subscriptions for larger enterprises, see [Azure enterprise scaffold - prescriptive subscription governance](/azure/architecture/cloud-adoption/appendix/azure-scaffold).

## Use affixes to avoid ambiguity

When naming resources in Azure, it is recommended to use common prefixes or suffixes to identify the type and context of the resource. While all the information about type, metadata, context, is available programmatically, applying common affixes simplifies visual identification. When incorporating affixes into your naming convention, it is important to clearly specify whether the affix is at the beginning of the name (prefix) or at the end (suffix).

For instance, here are two possible names for a service hosting a calculation engine:

- SvcCalculationEngine (prefix)
- CalculationEngineSvc (suffix)

Affixes can refer to different aspects that describe the particular resources. The following table shows some examples typically used.

| Aspect | Example | Notes |
| --- | --- | --- |
| Environment |dev, prod, QA |Identifies the environment for the resource |
| Location |uw (US West), ue (US East) |Identifies the region into which the resource is deployed |
| Instance |1, 2, ... |For resources that have more than one named instance such as VMs or NICs. |
| Product or Service |service |Identifies the product, application, or service that the resource supports |
| Role |sql, web, messaging |Identifies the role of the associated resource |

When developing a specific naming convention for your company or projects, it is important to choose a common set of affixes and their position (suffix or prefix).

## Naming rules and restrictions

Each resource or service type in Azure enforces a set of naming restrictions and scope; any naming convention or pattern must adhere to the requisite naming rules and scope. For example, while the name of a VM maps to a DNS name (and is thus required to be unique across all of Azure), the name of a VNET is scoped to the Resource Group that it is created within.

In general, avoid having any special characters (`-` or `_`) as the first or last character in any name. These characters will cause most validation rules to fail.

### General

| Entity | Scope | Length | Casing | Valid Characters | Suggested Pattern | Example |
| --- | --- | --- | --- | --- | --- | --- |
|Resource Group |Subscription |1-90 |Case insensitive |Alphanumeric, underscore, parentheses, hyphen, period (except at end), and Unicode characters that match the regex documented [here](/rest/api/resources/resourcegroups/createorupdate). |`<service short name>-<environment>` |`profx-prod` |
|Availability Set |Resource Group |1-80 |Case insensitive |Alphanumeric, underscore, and hyphen |`<service-short-name>-<context>-as` |`profx-sql-as` |
|Tag |Associated Entity |512 (name), 256 (value) |Case insensitive |Alphanumeric, special characters except `<`, `>`, `%`, `&`, `\`, `?`, `/`. See limitations [here](/azure/azure-resource-manager/resource-group-using-tags). |`"key" : "value"` |`"department" : "Central IT"` |

### Compute

| Entity | Scope | Length | Casing | Valid Characters | Suggested Pattern | Example |
| --- | --- | --- | --- | --- | --- | --- |
|Virtual Machine |Resource Group |1-15 (Windows), 1-64 (Linux) |Case insensitive |Alphanumeric and hyphen |`<name>-<role>-vm<number>` |`profx-sql-vm1` |
|Function App | Global |1-60 |Case insensitive |Alphanumeric and hyphen |`<name>-func` |`calcprofit-func` |

> [!NOTE]
> Virtual machines in Azure have two distinct names: virtual machine name, and host name. When you create a VM in the portal, the same name is used for both the host name, and the virtual machine resource name. The restrictions above are for the host name. The actual resource name can have up to 64 characters.

### Storage

| Entity | Scope | Length | Casing | Valid Characters | Suggested Pattern | Example |
| --- | --- | --- | --- | --- | --- | --- |
|Storage account name (data) |Global |3-24 |Lowercase |Alphanumeric |`<globally unique name><number>` (use a function to calculate a unique guid for naming storage accounts) |`profxdata001` |
|Storage account name (disks) |Global |3-24 |Lowercase |Alphanumeric |`<vm name without hyphens>st<number>` |`profxsql001st0` |
| Container name |Storage account |3-63 |Lowercase |Alphanumeric and hyphen |`<context>` |`logs` |
|Blob name | Container |1-1024 |Case sensitive |Any URL characters |`<variable based on blob usage>` |`<variable based on blob usage>` |
|Queue name |Storage account |3-63 |Lowercase |Alphanumeric and hyphen |`<service short name>-<context>-<num>` |`awesomeservice-messages-001` |
|Table name | Storage account |3-63 |Case insensitive |Alphanumeric |`<service short name><context>` |`awesomeservicelogs` |
|File name | Storage account |3-63 |Lowercase | Alphanumeric |`<variable based on blob usage>` |`<variable based on blob usage>` |
|Data Lake Store | Global |3-24 |Lowercase | Alphanumeric |`<name>dls` |`telemetrydls` |

### Networking

| Entity | Scope | Length | Casing | Valid Characters | Suggested Pattern | Example |
| --- | --- | --- | --- | --- | --- | --- |
|Virtual Network (VNet) |Resource Group |2-64 |Case insensitive |Alphanumeric, hyphen, underscore, and period |`<service short name>-vnet` |`profx-vnet` |
|Subnet |Parent VNet |2-80 |Case insensitive |Alphanumeric, hyphen, underscore, and period |`<descriptive context>` |`web` |
|Network Interface |Resource Group |1-80 |Case insensitive |Alphanumeric, hyphen, underscore, and period |`<vmname>-nic<num>` |`profx-sql1-vm1-nic1` |
|Network Security Group |Resource Group |1-80 |Case insensitive |Alphanumeric, hyphen, underscore, and period |`<service short name>-<context>-nsg` |`profx-app-nsg` |
|Network Security Group Rule |Resource Group |1-80 |Case insensitive |Alphanumeric, hyphen, underscore, and period |`<descriptive context>` |`sql-allow` |
|Public IP Address |Resource Group |1-80 |Case insensitive |Alphanumeric, hyphen, underscore, and period |`<vm or service name>-pip` |`profx-sql1-vm1-pip` |
|Load Balancer |Resource Group |1-80 |Case insensitive |Alphanumeric, hyphen, underscore, and period |`<service or role>-lb` |`profx-lb` |
|Load Balanced Rules Config |Load Balancer |1-80 |Case insensitive |Alphanumeric, hyphen, underscore, and period |`<descriptive context>` |`http` |
|Azure Application Gateway |Resource Group |1-80 |Case insensitive |Alphanumeric, hyphen, underscore, and period |`<service or role>-agw` |`profx-agw` |
|Traffic Manager Profile |Resource Group |1-63 |Case insensitive |Alphanumeric, hyphen, and period |`<descriptive context>` |`app1` |

### Containers

| Entity | Scope | Length | Casing | Valid Characters | Suggested Pattern | Example |
| --- | --- | --- | --- | --- | --- | --- |
|Container Registry | Global |5-50 |Case insensitive | Alphanumeric |`<service short name>registry` |`app1registry` |

### Service Bus

| Entity | Scope | Length | Casing | Valid Characters | Suggested Pattern | Example |
| --- | --- | --- | --- | --- | --- | --- |
|Service Bus Namespace | Global |6-50 |Case insensitive | Alphanumeric, hyphen, must start with leter; see [here](/rest/api/servicebus/create-namespace) for details. |`<service short name>-bus` |`app1-bus` |

## Organize resources with tags

The Azure Resource Manager supports tagging entities with arbitrary text strings to identify context and streamline automation. For example, the tag `"sqlVersion"="sql2014ee"` could identify VMs running SQL Server 2014 Enterprise Edition. Tags should be used to augment and enhance context along side of the naming conventions chosen.

> [!TIP]
> One other advantage of tags is that tags span resource groups, allowing you to link and correlate entities across disparate deployments.

Each resource or resource group can have a maximum of **15** tags. The tag name is limited to 512 characters, and the tag value is limited to 256 characters.

For more information on resource tagging, refer to [Using tags to organize your Azure resources](/azure/azure-resource-manager/resource-group-using-tags/).

Some of the common tagging use cases are:

- **Billing**. Grouping resources and associating them with billing or charge back codes.
- **Service Context Identification**. Identify groups of resources across Resource Groups for common operations and grouping.
- **Access Control and Security Context**. Administrative role identification based on portfolio, system, service, app, instance, etc.

> [!TIP]
> Tag early, tag often. Better to have a baseline tagging scheme in place and adjust over time rather than having to retrofit after the fact.

An example of some common tagging approaches:

| Tag Name | Key | Example | Comment |
| --- | --- | --- | --- |
| Bill To / Internal Chargeback ID |billTo |`IT-Chargeback-1234` |An internal I/O or billing code |
| Operator or Directly Responsible Individual (DRI) |managedBy |`joe@contoso.com` |Alias or email address |
| Project Name |projectName |`myproject` |Name of the project or product line |
| Project Version |projectVersion |`3.4` |Version of the project or product line |
| Environment |environment |`<Production, Staging, QA >` |Environmental identifier |
| Tier |tier |`Front End, Back End, Data` |Tier or role/context identification |
| Data Profile |dataProfile |`Public, Confidential, Restricted, Internal` |Sensitivity of data stored in the resource |

## Tips and tricks

Some types of resources may require additional care on naming and conventions.

### Virtual machines

Especially in larger topologies, carefully naming virtual machines streamlines identifying the role and purpose of each machine, and enabling more predictable scripting.

### Storage accounts and storage entities

There are two primary use cases for storage accounts: backing disks for VMs, and storing data in blobs, queues and tables. Storage accounts used for VM disks should follow the naming convention of associating them with the parent VM name (and with the potential need for multiple storage accounts for high-end VM SKUs, also apply a number suffix).

> [!TIP]
> Storage accounts - whether for data or disks - should follow a naming convention that allows for multiple storage accounts to be leveraged (i.e. always using a numeric suffix).

It's possible to configure a custom domain name for accessing blob data in your Azure Storage account. The default endpoint for the Blob service is `https://<name>.blob.core.windows.net`.

But if you map a custom domain (such as `www.contoso.com`) to the blob endpoint for your storage account, you can also access blob data in your storage account by using that domain. For example, with a custom domain name, `https://mystorage.blob.core.windows.net/mycontainer/myblob` could be accessed as
`https://www.contoso.com/mycontainer/myblob`.

For more information about configuring this feature, refer to [Configure a custom domain name for your Blob storage endpoint](/azure/storage/storage-custom-domain-name/).

For more information on naming blobs, containers and tables, refer to the following list:

- [Naming and Referencing Containers, Blobs, and Metadata](https://msdn.microsoft.com/library/dd135715.aspx)
- [Naming Queues and Metadata](https://msdn.microsoft.com/library/dd179349.aspx)
- [Naming Tables](https://msdn.microsoft.com/library/azure/dd179338.aspx)

A blob name can contain any combination of characters, but reserved URL characters must be properly escaped. Avoid blob names that end with a period (.), a forward slash (/), or a sequence or combination of the two. By convention, the forward slash is the *virtual* directory separator. Do not use a backward slash (\\) in a blob name. The client APIs may allow it, but then fail to hash properly, and the signatures will not match.

It is not possible to modify the name of a storage account or container after it has been created. If you want to use a new name, you must delete it and create a new one.

> [!TIP]
> We recommend that you establish a naming convention for all storage accounts and types
> before embarking on the development of a new service or application.

