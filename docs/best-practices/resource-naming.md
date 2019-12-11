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

Each resource or service type in Azure enforces a set of naming rules and scope. Any naming convention or pattern must follow the naming rules and scope. For example, Some resource names, such as PaaS services with public endpoints or virtual machine DNS labels, have global scopes, which means that they must be unique across the entire Azure platform. But the name of a VM is scoped to the resource group in which it resides.

In general, avoid using a special character, such as a hyphen (`-`) or underscore (`_`), as the first or last character in any name. These characters cause most validation rules to fail.

## General

| Entity | Scope | Length | Casing | Valid characters |
| --- | --- | --- | --- | --- |
|Management Group ID |Root Management Group |1-90 |Insensitive |Alphanumeric, underscore, hyphen, period |
|Subscription name |Management Group |1-64 | Insensitive| 0-9, a-z, A-Z, and cannot contain: greater than or lesser than signs, semicolon, pipe |
|Resource group |Subscription |1-90 |Insensitive |Alphanumeric, underscore, parentheses, hyphen, period (except at the end), and Unicode characters that match the [regex documentation](/rest/api/resources/resourcegroups/createorupdate) |
|Availability set |Resource group |1-80 |Insensitive |Alphanumeric, underscore, and hyphen |
|Tag |Associated entity |512 (name), 256 (value) |Insensitive |Alphanumeric, including Unicode characters; special characters except `<`, `>`, `%`, `&`, `\`, `?`, `/`, and [other limitations](/azure/azure-resource-manager/resource-group-using-tags) |`"key" : "value"` |`"department" : "Central IT"` |
|API management |Global |1-50 |Insensitive |0-9, a-z, A-Z, and `-` |
|Key vault | Global | 3-24 | Insensitive | 0-9, a-z, A-Z, and `-`. Must start with a letter. |

## Compute

| Entity | Scope | Length | Casing | Valid characters |
| --- | --- | --- | --- | --- |
|Virtual machine |Resource group |1-15 (Windows), 1-64 (Linux) |Insensitive |0-9, a-z, A-Z, and `-` |
|Function app | Global |1-60 |Insensitive |0-9, a-z, A-Z, and `-` |

> [!NOTE]
> VMs in Azure have two distinct names: the VM name and the host name. When you create a VM in the portal, the same name is used for both the host name and the VM resource name. The restrictions in the preceding table are for the host name. The actual resource name can have up to 64 characters.

## Web

| Entity | Scope | Length | Casing | Valid characters |
| --- | --- | --- | --- | --- |
|Web app |Global |2-60 |Insensitive |0-9, a-z, A-Z, and `-` |
|Web app name |Resource group | 3-24 | Insensitive| 0-9, a-z, A-Z, and `-` |
|Slot name | Web app | 2-59 | Insensitive|0-9, a-z, A-Z, and `-`|
|Web app setting name | Web app | N/A | Insensitive | All characters |
|Web app setting value | Setting | N/A | Insensitive | All characters |
|Web app connection string | Web app | N/A |Insensitive | All characters |
|Web job name | Web app | 1-29 | Insensitive | 0-9, a-z, A-Z, and `-` |

> [!WARNING]
> The web app settings name for *Linux apps* has a valid character pattern of 0-9, a-z, A-Z, and `_`.


## Storage

| Entity | Scope | Length | Casing | Valid characters |
| --- | --- | --- | --- | --- |
|Storage account name (data) |Global |3-24 |Lowercase |Alphanumeric |
|Storage account name (disks) |Global |3-24 |Lowercase |Alphanumeric |
| Container name |Storage account |3-63 |Lowercase |0-9, a-z, and `-` |
|Blob name | Container |1-1024 |Sensitive |Any URL characters |
|Queue name |Storage account |3-63 |Lowercase |0-9, a-z, and `-` |
|Table name | Storage account |3-63 |Insensitive |Alphanumeric |
|File share name | Storage account |3-63 |Lowercase | 0-9, a-z, and `-` |
|Data Lake Storage | Global |3-24 |Lowercase | Alphanumeric |
|Managed disk name | Resource group | 1-80 | Insensitive |Alphanumeric, hyphen, and underscore, but not on character 1|

## Networking

| Entity | Scope | Length | Casing | Valid characters |
| --- | --- | --- | --- | --- |
|Virtual network (VNet) |Resource group |2-64 |Insensitive |Alphanumeric, hyphen, underscore, and period |
|Subnet |Parent VNet |2-80 |Insensitive |Alphanumeric, hyphen, underscore, and period |
|Network interface |Resource group |1-80 |Insensitive |Alphanumeric, hyphen, underscore, and period |
|Network security group |Resource group |1-80 |Insensitive |Alphanumeric, hyphen, underscore, and period |
|Network security group rule |NSG |1-80 |Insensitive |Alphanumeric, hyphen, underscore, and period |
|Public IP address |Resource group |1-80 |Insensitive |Alphanumeric, hyphen, underscore, and period |
|Load balancer |Resource group |1-80 |Insensitive |Alphanumeric, hyphen, underscore, and period |
|Load-balanced rules config |Load balancer |1-80 |Insensitive |Alphanumeric, hyphen, underscore, and period |
|Azure application gateway |Resource group |1-80 |Insensitive |Alphanumeric, hyphen, underscore, and period |
|Traffic manager profile |Resource group |1-63 |Insensitive |Alphanumeric, hyphen, and period |

## Containers

| Entity | Scope | Length | Casing | Valid characters |
| --- | --- | --- | --- | --- |
|Container registry | Global |5-50 |Insensitive | Alphanumeric |

## Messaging

| Entity | Scope | Length | Casing | Valid characters |
| --- | --- | --- | --- | --- |
|Service Bus namespace | Global | 6-50 |Insensitive | Alphanumeric, hyphen. Must start with a letter. For more information, see [Create namespace](/rest/api/servicebus/create-namespace). |
| Event Hubs namespace | Global | 6-50 | Insensitive | Alphanumeric, hyphen. Must start with a letter. Must end with a letter or number. |
| Event hub | Event Hubs namespace | 1-50 | Insensitive | Alphanumeric, period, hyphen, underscore. Must start and end with a letter or number. |

## Next steps

For recommendations on developing resource naming conventions for your organization, see [Ready: Recommended naming and tagging conventions](/azure/cloud-adoption-framework/ready/azure-best-practices/naming-and-tagging).
