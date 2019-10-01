---
title: Naming rules and restrictions for Azure resources
description: A summary of the naming rules and restrictions for Azure resources.
author: dermar
ms.date: 09/06/2019
ms.topic: best-practice
ms.service: architecture-center
ms.subservice: cloud-fundamentals
ms.custom: seodec18
---

# Naming rules and restrictions for Azure resources

This article is a summary of naming rules and restrictions for Azure resources.

Each resource or service type in Azure enforces a set of naming restrictions and scope. Any naming convention or pattern must adhere to the required naming rules and scope. For example, while the name of a virtual machine maps to a DNS name (and is thus required to be unique across all of Azure), the name of a virtual network is scoped to the resource group in which it resides.

In general, avoid having any special characters (`-` or `_`) as the first or last character in any name. These characters will cause most validation rules to fail.

## General

| Entity | Scope | Length | Casing | Valid Characters | Suggested Pattern | Example |
| --- | --- | --- | --- | --- | --- | --- |
|Resource Group |Subscription |1-90 |Insensitive |Alphanumeric, underscore, parentheses, hyphen, period (except at end), and Unicode characters that match the regex documented [here](/rest/api/resources/resourcegroups/createorupdate). |`<service short name>-<environment>-rg` |`profx-prod-rg` |
|Availability Set |Resource Group |1-80 |Insensitive |Alphanumeric, underscore, and hyphen |`<service-short-name>-<context>-as` |`profx-sql-as` |
|Tag |Associated Entity |512 (name), 256 (value) |Insensitive |Alphanumeric including Unicode characters; special characters except `<`, `>`, `%`, `&`, `\`, `?`, `/`. See limitations [here](/azure/azure-resource-manager/resource-group-using-tags). |`"key" : "value"` |`"department" : "Central IT"` |
|API Management |Global |1-50 |Insensitive |0-9, a-z, A-Z and - |`<apim-service-name>` |`contoso` |
|Key Vault | Global | 3-24 | Insensitive | 0-9, a-z, A-Z and - | `<service short name>-<environment>-kv` | `myapp-prod-kv` |

## Compute

| Entity | Scope | Length | Casing | Valid Characters | Suggested Pattern | Example |
| --- | --- | --- | --- | --- | --- | --- |
|Virtual Machine |Resource Group |1-15 (Windows), 1-64 (Linux) |Insensitive |0-9, a-z, A-Z and - |`<name>-<role>-vm<number>` |`profx-sql-vm1` |
|Function App | Global |1-60 |Insensitive |0-9, a-z, A-Z and - |`<name>-func` |`calcprofit-func` |

> [!NOTE]
> Virtual machines in Azure have two distinct names: virtual machine name, and host name. When you create a VM in the portal, the same name is used for both the host name, and the virtual machine resource name. The restrictions above are for the host name. The actual resource name can have up to 64 characters.

## Web

| Entity | Scope | Length | Casing | Valid Characters | Suggested Pattern | Example |
| --- | --- | --- | --- | --- | --- | --- |
|Web App |Global |1-60 |Insensitive |0-9, a-z, A-Z and - |`<app_name>-<source-slot-name>` |`contoso-staging` |
|Web App Name |Resource Group | 3-24 | Insensitive| 0-9, a-z, A-Z and - | `<appname>` | `mywebapp`|
|Slot Name | Web App | 2-59 | Insensitive|0-9, a-z, A-Z and -|`<slotname>`|`production`|
|Web App Setting Name | Web App | N/A | Insensitive | All characters | N/A | N/A|
|Web App Setting Value | Setting | N/A | Insensitive | All characters | N/A | N/A|
|Web App Connection String | Web App | N/A |Insensitive | All characters | N/A | N/A|
|Web Job Name | Web App | 1-29 | Insensitive | 0-9, a-z, A-Z and - | `<jobname>`|`myJob`|

> [!WARNING]
> Web App Settings Name for **Linux Apps** has a valid character pattern of: 0-9, a-z, A-Z, _


## Storage

| Entity | Scope | Length | Casing | Valid Characters | Suggested Pattern | Example |
| --- | --- | --- | --- | --- | --- | --- |
|Storage account name (data) |Global |3-24 |Lowercase |Alphanumeric |`<globally unique name><number>` |`profxdata001` |
|Storage account name (disks) |Global |3-24 |Lowercase |Alphanumeric |`<vm name without hyphens>st<number>` |`profxsql001st0` |
| Container name |Storage account |3-63 |Lowercase |0-9, a-z and - |`<context>` |`logs` |
|Blob name | Container |1-1024 |Sensitive |Any URL characters |`<variable based on blob usage>` |`<variable based on blob usage>` |
|Queue name |Storage account |3-63 |Lowercase |0-9, a-z and - |`<service short name>-<context>-<num>` |`awesomeservice-messages-001` |
|Table name | Storage account |3-63 |Insensitive |Alphanumeric |`<service short name><context>` |`awesomeservicelogs` |
|File share name | Storage account |3-63 |Lowercase | 0-9, a-z and - |`<variable based on file share usage>` |`<variable based on file share usage>` |
|Data Lake Store | Global |3-24 |Lowercase | Alphanumeric |`<name>dls` |`telemetrydls` |
|Managed Disk name | Resource Group | 1-80 | Insensitive |Alphanumeric, hyphen and underscore but not on character 1|`<disktype>disk<number>`|`OSdisk1`|

## Networking

| Entity | Scope | Length | Casing | Valid Characters | Suggested Pattern | Example |
| --- | --- | --- | --- | --- | --- | --- |
|Virtual Network (VNet) |Resource Group |2-64 |Insensitive |Alphanumeric, hyphen, underscore, and period |`<service short name>-vnet` |`profx-vnet` |
|Subnet |Parent VNet |2-80 |Insensitive |Alphanumeric, hyphen, underscore, and period |`<descriptive context>` |`web` |
|Network Interface |Resource Group |1-80 |Insensitive |Alphanumeric, hyphen, underscore, and period |`<vmname>-nic<num>` |`profx-sql1-vm1-nic1` |
|Network Security Group |Resource Group |1-80 |Insensitive |Alphanumeric, hyphen, underscore, and period |`<service short name>-<context>-nsg` |`profx-app-nsg` |
|Network Security Group Rule |Resource Group |1-80 |Insensitive |Alphanumeric, hyphen, underscore, and period |`<descriptive context>` |`sql-allow` |
|Public IP Address |Resource Group |1-80 |Insensitive |Alphanumeric, hyphen, underscore, and period |`<vm or service name>-pip` |`profx-sql1-vm1-pip` |
|Load Balancer |Resource Group |1-80 |Insensitive |Alphanumeric, hyphen, underscore, and period |`<service or role>-lb` |`profx-lb` |
|Load Balanced Rules Config |Load Balancer |1-80 |Insensitive |Alphanumeric, hyphen, underscore, and period |`<descriptive context>` |`http` |
|Azure Application Gateway |Resource Group |1-80 |Insensitive |Alphanumeric, hyphen, underscore, and period |`<service or role>-agw` |`profx-agw` |
|Traffic Manager Profile |Resource Group |1-63 |Insensitive |Alphanumeric, hyphen, and period |`<descriptive context>` |`app1` |

## Containers

| Entity | Scope | Length | Casing | Valid Characters | Suggested Pattern | Example |
| --- | --- | --- | --- | --- | --- | --- |
|Container Registry | Global |5-50 |Insensitive | Alphanumeric |`<service short name>registry` |`app1registry` |

## Messaging

| Entity | Scope | Length | Casing | Valid Characters | Suggested Pattern | Example |
| --- | --- | --- | --- | --- | --- | --- |
|Service Bus namespace | Global | 6-50 |Insensitive | Alphanumeric, hyphen; must start with a letter; see [here](/rest/api/servicebus/create-namespace) for details. |`<service short name>-bus` |`app1-bus` |
| Event Hubs namespace | Global | 6-50 | Insensitive | Alphanumeric, hyphen; must start with a letter; must end with a letter or number |  `<service>-ehns` | `app1-ehns` |
| Event hub | Event Hubs namespace | 1-50 | Insensitive | Alphanumeric, period, hyphen, underscore. Must start and end with a letter or number. | `<service>-<role>-eh` | `app1-orders-eh` |

## Next steps

For recommendations on developing resource naming conventions for your organization, see [Ready: Recommended naming and tagging conventions](/azure/architecture/cloud-adoption/ready/considerations/name-and-tag).
