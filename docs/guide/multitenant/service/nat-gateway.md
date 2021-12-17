---
title: NAT Gateway considerations for multitenancy
titleSuffix: Azure Architecture Center
description: This article describes the features of NAT Gateway that are useful when you work with multitenanted systems, and it provides links to guidance and examples for how to use NAT Gateway in a multitenant solution.
author: johndowns
ms.author: jodowns
ms.date: 12/17/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
 - azure
 - azure-resource-manager
categories:
 - management-and-governance
 - security
ms.category:
  - fcp
ms.custom:
  - guide
  - fcp
---

# NAT Gateway considerations for multitenancy

NAT Gateway can be used as an option for controlling outbound NAT, such as to send traffic from a specified IP address or to handle large numbers of SNAT port allocations.

You might be able to also use an Azure Firewall or another NVA to achieve the benefits listed below. Firewalls will also enable you to control and log your outbound traffic. NAT Gateway is cheaper but doesn't give you the security controls.

## Features of NAT Gateway that support multitenancy

### Scaling SNAT ports

* Each NAT Gateway provides up to 1 million SNAT ports when used with 16 public IP addresses.
* You can [deploy multiple NAT Gateway instances across multiple subnets](/azure/virtual-network/nat-gateway/nat-gateway-resource#performance) if you need to scale to a higher level.
* Can be helpful when working with large numbers of concurrent outbound connections to the same public IP address and port combination, such as when you use multitenant databases or APIs.
* Can use this to mitigate SNAT port exhaustion when you work with Azure services that are themselves multitenant, such as App Service and Azure Functions (see /azure/app-service/troubleshoot-intermittent-outbound-connection-errors, /azure/app-service/networking/nat-gateway-integration).

NOTE: SNAT port exhaustion is usually an indication that your application isn't correctly handling HTTP connections or TCP ports. You should verify this before deploying NAT Gateway. However, multitenant applications are at particular risk of exceeding SNAT port limits, so if you determine that you are experiencing SNAT exhaustion and also that your application correctly handles your connections, you can consider deploying NAT Gateway. 

### Outbound IP address control

* When you send your traffic through NAT Gateway, the gateway's public IP address (or addresses) are for the outbound connection.
* Helpful when you need to connect to your tenants' on-premises networks and they need to perform IP address-based filtering.

## Isolation models

* A subnet can be associated with a single NAT Gateway, and a NAT Gateway can't span multiple VNets.
* A PIP (or PIP prefix) can be associated with a single NAT Gateway.
* So if you want to use different public IP addresses for different tenants, you'll need to deploy multiple subnets, NAT Gateway resources, and PIPs for each tenant.
* This can have cost implications, because each NAT Gateway incurs an hourly fee in addition to data transfer fees.

## Next steps

- [Learn more about NAT Gateway](/azure/virtual-network/nat-gateway/nat-gateway-resource)
- (To add: link somewhere else within the multitenancy guidance)
