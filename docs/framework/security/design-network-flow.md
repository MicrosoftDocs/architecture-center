---
title: Traffic flow security in Azure
description: Examine traffic flow security in Azure. Learn about best practices for protecting a workload from data exfiltration.
author: PageWriter-MSFT
ms.date: 02/03/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
azureCategories:
  - networking
products:
  - azure-virtual-network
ms.custom:
  - article
---

# Traffic flow security in Azure

Protect data anywhere it goes including cloud services, mobile devices, workstations, or collaboration platforms. In addition to using access control and encryption mechanisms, apply strong network controls that detect, monitor, and contain attacks.

## Key points

- Control network traffic between subnets (east-west) and application tiers (north-south).
- Apply a layered defense-in-depth approach that starts with Zero-Trust policies.
- Use a cloud application security broker (CASB).

## East-west and north-south traffic

When analyzing the network flow of a workload, distinguish between east-west traffic from north-south traffic. Most cloud architectures use a combination of both types.

**Is the traffic between subnets, Azure components and tiers of the workload managed and secured?**
***

- **North-south traffic**

    *North-south* refers to the traffic that flows in and out of a datacenter. For example, traffic from an application to a backend service. This type of traffic is a typical target for attack vectors because it flows over the public internet. Proper network controls must be in place so that the queries to and from a data center are secure.

    Consider a typical flow in an Azure Kubernetes Service (AKS) cluster. The cluster receives incoming (ingress) traffic from HTTP requests. The cluster can also send outgoing (egress) traffic to send queries to other services, such as pulling a container image.

    Your design can use Web Application Firewall on Application Gateway to secure ingress traffic, and Azure Firewall to secure outgoing (egress) traffic.

- **East-west traffic**

    *East-west* traffic refers to traffic between or within data centers. For this type of traffic, several resources of the network infrastructure communicate with each other. Those resources can be virtual networks, subnets within those virtual networks, and so on. Security of east-west traffic can get overlooked even though it makes up a large portion of the workload traffic. It's assumed that the infrastructure firewalls are sufficient to block attacks. Make sure there are proper controls between network resources.

    Extending the example of the AKS cluster to this concept, east-west traffic is the traffic within the cluster. For example, communication between pods, such as the ingress controller and the workload. If your workload is composed of multiple applications, the communication between those applications would fall into this category.

    By using Kubernetes network policies, you can restrict which pods can communicate, starting from a Zero-Trust policy and then opening specific communication paths as needed.

> [!TIP]
> Here are the resources for the preceding AKS example:
>
> ![GitHub logo](../../_images/github.svg) [GitHub: Azure Kubernetes Service (AKS) Secure Baseline Reference Implementation](https://github.com/mspnp/aks-secure-baseline).
>
> The design considerations are described in [Azure Kubernetes Service (AKS) production baseline](../../reference-architectures/containers/aks/secure-baseline-aks.yml).

## Data exfiltration

Data exfiltration is a common attack where an internal or external malicious actor does an unauthorized data transfer. Most often access is gained because of lack of network controls.

Network virtual appliance (NVA) solutions and Azure Firewall (for supported protocols) can be leveraged as a reverse proxy to restrict access to only authorized PaaS services for services where Private Link is not yet supported (Azure Firewall).

Configure Azure Firewall or a third-party next generation firewall to protect against data exfiltration concerns.

**Are there controls in the workload design to detect and protect from data exfiltration?**
***
Choose a defense-in-depth design that can protect network communications at various layers, such as a hub-spoke topology. Azure provides several controls to support the layered design:

- Use Azure Firewall to allow or deny traffic using layer 3 to layer 7 controls.
- Use Azure Virtual Network User Defined Routes (UDR) to control next hop for traffic.
- Control traffic with Network Security Groups (NSGs) between resources within a virtual network, internet, and other virtual networks.
- Secure the endpoints through Azure PrivateLink and Private Endpoints.
- Detect and protect at deep levels through packet inspection.
- Detect attacks and respond to alerts through Microsoft Sentinel and Microsoft Defender for Cloud.

> [!IMPORTANT] 
>
> Network controls are not sufficient in blocking data exfiltration attempts. Harden the protection with proper identity controls, key protection, and encryption. For more information, see these sections:
> - [Data protection considerations](design-storage.md)
> - [Identity and access management considerations](design-identity.md)

**Have you considered a cloud application security broker (CASB) for this workload?**
***

CASBs provide a central point of control for enforcing policies. They  provide rich visibility, control over data travel, and sophisticated analytics to identify and combat cyberthreats across all Microsoft and third-party cloud services.

## Learn more

- [Azure firewall documentation](/azure/firewall/)
- [Azure Marketplace networking apps](https://azuremarketplace.microsoft.com/marketplace/apps/category/networking)

## Related links

- [Azure Firewall](/azure/firewall/overview)
- [Network Security Groups (NSG)](/azure/virtual-network/security-overview)
- [What is Azure Web Application Firewall on Azure Application Gateway?](/azure/web-application-firewall/ag/ag-overview)
- [What is Azure Private Link?](/azure/private-link/private-link-overview)

> Go back to the main article: [Network security](design-network.md)
