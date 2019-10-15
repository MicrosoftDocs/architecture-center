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

This article summarizes naming rules and restrictions for Azure resources.

Each resource or service type in Azure enforces a set of naming rules and scope. Any naming convention or pattern must follow the naming rules and scope. For example, the name of a virtual machine (VM) maps to a DNS name, so the VM name must be unique throughout Azure. But the name of a VM is scoped to the resource group in which it resides.

In general, avoid using a special character, such as a hyphen (`-`) or underscore (`_`), as the first or last character in any name. These characters cause most validation rules to fail.

## General

| Entity | Scope | Length | Casing | Valid characters | Suggested pattern | Example |
| --- | --- | --- | --- | --- | --- | --- |
|Resource group |Subscription |1-90 |Insensitive |Alphanumeric, underscore, parentheses, hyphen, period (except at the end), and Unicode characters that match the [regex documentation](/rest/api/resources/resourcegroups/createorupdate) |`<service short name>-<environment>-rg` |`profx-prod-rg` |
|Availability set |Resource group |1-80 |Insensitive |Alphanumeric, underscore, and hyphen |`<service-short-name>-<context>-as` |`profx-sql-as` |
|Tag |Associated entity |512 (name), 256 (value) |Insensitive |Alphanumeric, including Unicode characters; special characters except `<`, `>`, `%`, `&`, `\`, `?`, `/`, and [other limitations](/azure/azure-resource-manager/resource-group-using-tags) |`"key" : "value"` |`"department" : "Central IT"` |
|API management |Global |1-50 |Insensitive |0-9, a-z, A-Z, and `-` |`<apim-service-name>` |`contoso` |
|Key vault | Global | 3-24 | Insensitive | 0-9, a-z, A-Z, and `-`. Must start with a letter. | `<service short name>-<environment>-kv` | `myapp-prod-kv` |

## Compute

| Entity | Scope | Length | Casing | Valid characters | Suggested pattern | Example |
| --- | --- | --- | --- | --- | --- | --- |
|Virtual machine |Resource group |1-15 (Windows), 1-64 (Linux) |Insensitive |0-9, a-z, A-Z, and `-` |`<name>-<role>-vm<number>` |`profx-sql-vm1` |
|Function app | Global |1-60 |Insensitive |0-9, a-z, A-Z, and `-` |`<name>-func` |`calcprofit-func` |

> [!NOTE]
> VMs in Azure have two distinct names: the VM name and the host name. When you create a VM in the portal, the same name is used for both the host name and the VM resource name. The restrictions in the preceding table are for the host name. The actual resource name can have up to 64 characters.

## Web

| Entity | Scope | Length | Casing | Valid characters | Suggested pattern | Example |
| --- | --- | --- | --- | --- | --- | --- |
|Web app |Global |1-60 |Insensitive |0-9, a-z, A-Z, and `-` |`<app_name>-<source-slot-name>` |`contoso-staging` |
|Web app name |Resource group | 3-24 | Insensitive| 0-9, a-z, A-Z, and `-` | `<appname>` | `mywebapp`|
|Slot name | Web app | 2-59 | Insensitive|0-9, a-z, A-Z, and `-`|`<slotname>`|`production`|
|Web app setting name | Web app | N/A | Insensitive | All characters | N/A | N/A|
|Web app setting value | Setting | N/A | Insensitive | All characters | N/A | N/A|
|Web app connection string | Web app | N/A |Insensitive | All characters | N/A | N/A|
|Web job name | Web app | 1-29 | Insensitive | 0-9, a-z, A-Z, and `-` | `<jobname>`|`myJob`|

> [!WARNING]
> The web app settings name for *Linux apps* has a valid character pattern of 0-9, a-z, A-Z, and `_`.


## Storage

| Entity | Scope | Length | Casing | Valid characters | Suggested pattern | Example |
| --- | --- | --- | --- | --- | --- | --- |
|Storage account name (data) |Global |3-24 |Lowercase |Alphanumeric |`<globally unique name><number>` |`profxdata001` |
|Storage account name (disks) |Global |3-24 |Lowercase |Alphanumeric |`<vm name without hyphens>st<number>` |`profxsql001st0` |
| Container name |Storage account |3-63 |Lowercase |0-9, a-z, and `-` |`<context>` |`logs` |
|Blob name | Container |1-1024 |Sensitive |Any URL characters |`<variable based on blob usage>` |`<variable based on blob usage>` |
|Queue name |Storage account |3-63 |Lowercase |0-9, a-z, and `-` |`<service short name>-<context>-<num>` |`awesomeservice-messages-001` |
|Table name | Storage account |3-63 |Insensitive |Alphanumeric |`<service short name><context>` |`awesomeservicelogs` |
|File share name | Storage account |3-63 |Lowercase | 0-9, a-z, and `-` |`<variable based on file share usage>` |`<variable based on file share usage>` |
|Data Lake Storage | Global |3-24 |Lowercase | Alphanumeric |`<name>dls` |`telemetrydls` |
|Managed disk name | Resource group | 1-80 | Insensitive |Alphanumeric, hyphen, and underscore, but not on character 1|`<disktype>disk<number>`|`OSdisk1`|

## Networking

| Entity | Scope | Length | Casing | Valid characters | Suggested pattern | Example |
| --- | --- | --- | --- | --- | --- | --- |
|Virtual network (VNet) |Resource group |2-64 |Insensitive |Alphanumeric, hyphen, underscore, and period |`<service short name>-vnet` |`profx-vnet` |
|Subnet |Parent VNet |2-80 |Insensitive |Alphanumeric, hyphen, underscore, and period |`<descriptive context>` |`web` |
|Network interface |Resource group |1-80 |Insensitive |Alphanumeric, hyphen, underscore, and period |`<vmname>-nic<num>` |`profx-sql1-vm1-nic1` |
|Network security group |Resource group |1-80 |Insensitive |Alphanumeric, hyphen, underscore, and period |`<service short name>-<context>-nsg` |`profx-app-nsg` |
|Network security group rule |Resource group |1-80 |Insensitive |Alphanumeric, hyphen, underscore, and period |`<descriptive context>` |`sql-allow` |
|Public IP address |Resource group |1-80 |Insensitive |Alphanumeric, hyphen, underscore, and period |`<vm or service name>-pip` |`profx-sql1-vm1-pip` |
|Load balancer |Resource group |1-80 |Insensitive |Alphanumeric, hyphen, underscore, and period |`<service or role>-lb` |`profx-lb` |
|Load-balanced rules config |Load balancer |1-80 |Insensitive |Alphanumeric, hyphen, underscore, and period |`<descriptive context>` |`http` |
|Azure application gateway |Resource group |1-80 |Insensitive |Alphanumeric, hyphen, underscore, and period |`<service or role>-agw` |`profx-agw` |
|Traffic manager profile |Resource group |1-63 |Insensitive |Alphanumeric, hyphen, and period |`<descriptive context>` |`app1` |

## Containers

| Entity | Scope | Length | Casing | Valid characters | Suggested pattern | Example |
| --- | --- | --- | --- | --- | --- | --- |
|Container registry | Global |5-50 |Insensitive | Alphanumeric |`<service short name>registry` |`app1registry` |

## Messaging

| Entity | Scope | Length | Casing | Valid characters | Suggested pattern | Example |
| --- | --- | --- | --- | --- | --- | --- |
|Service Bus namespace | Global | 6-50 |Insensitive | Alphanumeric, hyphen. Must start with a letter. For more information, see [Create namespace](/rest/api/servicebus/create-namespace). |`<service short name>-bus` |`app1-bus` |
| Event Hubs namespace | Global | 6-50 | Insensitive | Alphanumeric, hyphen. Must start with a letter. Must end with a letter or number. |  `<service>-ehns` | `app1-ehns` |
| Event hub | Event Hubs namespace | 1-50 | Insensitive | Alphanumeric, period, hyphen, underscore. Must start and end with a letter or number. | `<service>-<role>-eh` | `app1-orders-eh` |

## Next steps

For recommendations on developing resource naming conventions for your organization, see [Ready: Recommended naming and tagging conventions](/azure/architecture/cloud-adoption/ready/considerations/name-and-tag).
