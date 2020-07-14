---
title: Secure baseline architecture for an Azure Kubernetes Service (AKS) cluster
description: Reference architecture for a baseline infrastructure that deploys an Azure Kubernetes Service (AKS) cluster with focus on security.
author: PageWriter-MSFT
ms.date: 10/16/2018
ms.topic: reference-architecture
ms.service: architecture-center
ms.category:
  - containers
  - kubernetes
  - aks
ms.subservice: reference-architecture
ms.custom: seojul20, containers
---

# Secure baseline architecture for an AKS cluster
In this reference architecture, we’ll build a baseline infrastructure that
deploys an Azure Kubernetes Service (AKS) cluster with focus on security. This
article includes recommendations for networking, security, identity, management,
and monitoring of the cluster based on an organization’s business requirements.

![GitHub logo](../../../_images/github.png) An implementation of this architecture is available
on [GitHub: Azure Kubernetes Service (AKS) Secure Baseline Reference Implementation](https://github.com/mspnp/aks-secure-baseline). You can use it as a
starting point and configure it as per your needs.

## Case study – Contoso Bicycle
----------------------------

This architecture is built for a fictitious company, Contoso Bicycle. The
company is a small and fast-growing startup that provides online web services to
its clientele in the west coast, North America. The web services were deployed
to the cloud from the get-go. They have no on-premises datacenters or legacy
applications.

Contoso Bicycle have several workloads already running and operating in Azure.
They have some knowledge about containers and considered them for
application development purposes. They're aware that Kubernetes is a well-known
choice for container orchestration and have researched AKS. The IT teams need guidance about architectural recommendations for running their web services
in an AKS cluster.

### Organization structure

Contoso Bicycle has a single IT Team with these sub teams.

![Org Pic]()

#### Architecture team

Work with the line of business from idea through deployment into production.
They understand all aspects of the Azure components: ￼function, integration,
controls, and monitoring capabilities. The team evaluates those aspects for
functional, security, and compliance requirements. They coordinate and have
representation from other teams. Their workflow aligns with Contoso's SDL process.

#### Development team

Responsible for developing Contoso’s web services. They rely on the guidance
from the architecture team about implementing cloud design patterns. They own and run the integration and deployment pipeline for the web services.

#### Security team

Review Azure services and workloads from the lens of security. Incorporate Azure
service best practices in configurations. They review choices for authentication, authorization, network connectivity, encryption, and key management and, or rotation. Also, they have monitoring requirements for any proposed service.

#### Identity team

Responsible for identity and access management for the Azure environment. They
work with the Security and Architecture teams for use of Azure Active Directory,
role-based access controls, and segmentation. Also, monitoring service
principles for service access and application level access.

#### Networking team

Make sure that different architectural components can talk to each other in a secure manner. They manage the hub and spoke network topologies and IP space allocation.

#### Operations team

Responsible for the infrastructure deployment and day-to-day operations of the
Azure environment.

### Business requirements

Here are the requirements based on an initial [Well-Architected
Framework review](https://docs.microsoft.com/assessments/?mode=pre-assessment&session=local).

#### Reliability

- Global presence: The customer base is focused on the West Coast of North
America.

- Business continuity: The workloads need to be highly available at a minimum
cost. They have a Recovery Time Objective (RTO) of 4 hours.

- On-premises connectivity: They don’t need to connect to on-premises datacenters or
legacy applications.

#### Performance efficiency

The web service’s host should have these capabilities.

- Auto scaling: Automatically scale to handle the demands of expected traffic
patterns. The web service is unlikely to experience a high-volume scale event.
The scaling methods shouldn't drive up the cost.

- Right sizing: Select hardware size and features that are suited for the web
service and are cost effective.

- Growth: Ability to expand the workload or add adjacent workloads as the product
matures and gains market adoption.

- Monitoring: Emit telemetry metrics to get insights into the performance and
scaling operations. Integration with Azure Monitor is preferred.

- Workload-based scaling: Allow granular scaling per workload and independent
scaling between different partitions in the workload.

#### Security

- Identity management: Contoso is an existing Microsoft 365 user. They rely
heavily on Azure Active Directory as their control plane for identity.

- Certificate: They must expose all web services through SSL and aim for
end-to-end encryption, as much as possible.

- Network: They have existing workloads running in Azure Virtual Networks. They
would like to minimize direct exposure to Azure resources to the public
internet. Their existing architecture runs with regional hub and spoke
topologies. This way, the network can be expanded in the future and also provide workload isolation.
All web applications require a web application firewall (WAF) service to help
govern HTTP traffic flows.

- Secrets management: They would like to use a secure store for sensitive
information.

- Container registry: Currently not using a registry and are looking for guidance.

- Container scanning: They know the importance of container scanning but
are concerned about added cost. The information isn't sensitive, but would like the option to scan in the future.

#### Operational excellence

- Logging, monitoring, metrics, alerting: They use Azure Monitor for their
existing workloads. They would like to use it for AKS, if possible.

- Automated deployments: They understand the importance of automation. They build
automated processes for all infrastructure so that environments and workloads
can easily be recreated consistently and at any time.

#### Cost optimization

- Cost center: There’s only one line-of-business. So, all costs are billed to a
single cost center.

- Budget and alerts: They have certain planned budgets. They want to be alerted
when certain thresholds like 50%, 75%, and 90% of the plan has been reached.

### Design and technology choices

-   Deploy the AKS cluster into an existing Azure Virtual Network spoke. Use the
    existing Azure Firewall in the regional hub for securing outgoing traffic
    from the cluster.

-   Traffic from public facing website is required to be encrypted. This encryption is
    implemented with Azure Application Gateway with integrated web
    application firewall (WAF).

-   Use Traefik as the Kubernetes ingress controller.

-   The workload is stateless. No data will be persisted inside the cluster.

-   Given there's only one line-of-business, there is a single workload. Azure
    Network Policy will be enabled for future use.￼

-   Azure Container Registry will be used for the container image registry. The cluster will access the registry through Azure Private Link.

-   To stay up to date with OS and security patches, have a tool chain ￼to help
    the restart of nodes when needed.

-   AKS will be integrated with Azure Active Directory for role-based access control. This choice is aligned with the strategy of using identity as an operational control plane.

-   Azure Monitor will be used for logging, metrics, monitoring, and alerting to
    use the existing knowledge of Log Analytics.

-   Azure Key Vault will be used to store all secret information including SSL certificates. Key Vault data will be mounted into the pods by using Azure Key Vault with Secrets Store CSI Driver.

-   Two node pools will be used in AKS. The system node pool will be used for
    critical system pods. The second node pool will be used for the
    application workload.

-   To make sure the workload is scaled properly, requests and limits will be
    enforced by assigning quotas for the Horizontal Pod Autoscaling (HPA). AKS cluster autoscaler will be enabled so that additional nodes are automatically provisioned if pods can’t be scheduled.
