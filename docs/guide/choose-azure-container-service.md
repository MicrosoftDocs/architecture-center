---
title: Choose an Azure container service 
description: Understand how to evaluate which Azure container service is best suited to your specific workload scenarios and requirements.  
author: MarcosMMartinez
ms.author: mamartin
ms.date: 01/02/2024
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
ms.custom:
  - arb-containers
products:
  - azure-kubernetes-service
  - azure-container-apps
  - azure-app-service
categories:
  - containers
---

# Choose an Azure container service

Azure offers a range of container hosting services that are designed to accommodate various workloads, architectures, and business requirements. This container service selection guide can help you understand which Azure container service is best suited to your workload scenarios and requirements.

> [!note]
> In this guide, the term *workload* refers to a collection of application resources that support a business goal or the execution of a business process. A workload uses multiple services, like APIs and data stores, that work together to deliver specific end-to-end functionality.

## How to use this guide

This guide includes two articles: this introduction article and another article about [considerations that are shared](container-service-general-considerations.md) across all workload types.

> [!note]
> If you aren't yet committed to containerization, see [Choose an Azure compute service](technology-choices/compute-decision-tree.yml) for information about other compute options that you can use to host your workload.

This introduction article describes the Azure container services that are in scope for this guide and how the service models compare in terms of tradeoffs between configurability and opinionated solutions, such as customer-managed versus Microsoft-managed approaches. After you identify candidate services based on your service model preferences, the next step is to evaluate the options against your workload requirements by reviewing the article on [shared considerations](container-service-general-considerations.md) for networking, security, operations, and reliability.

This guide takes into consideration tradeoffs that you might need to make, based on the technical requirements, size, and complexity of your workload and the expertise of your workload's team.

## Azure container services in scope for this guide

This guide focuses on a subset of the container services that Azure currently offers. This subset provides a mature feature set for web applications and APIs, networking, observability, developer tools, and operations. These container services are compared: 

:::row:::
    :::column::: 
    ![Container Apps logo](media/images/container-apps.png) 
    :::column-end:::
    :::column span="3":::
    [Azure Container Apps](https://azure.microsoft.com/products/container-apps) is a fully managed Kubernetes-based application platform that helps you deploy HTTP and non-HTTP apps from code or containers without orchestrating infrastructure. For more information, see [Azure Container Apps documentation](/azure/container-apps).
    :::column-end:::
:::row-end:::
:::row:::
    :::column::: 
    ![AKS logo](media/images/aks.png)
    :::column-end:::
    :::column span="3":::
    [Azure Kubernetes Service (AKS)](https://azure.microsoft.com/products/kubernetes-service) is a managed Kubernetes service for running containerized applications. With AKS, you can take advantage of managed [add-ons and extensions](/azure/aks/integrations) for additional capabilities while preserving the broadest level of configurability. For more information, see [AKS documentation](/azure/aks/). 
    :::column-end:::
:::row-end:::
:::row:::
    :::column::: 
    ![App Service logo](media/images/app-service.png) 
    :::column-end:::
    :::column span="3":::
    [Web App for Containers](https://azure.microsoft.com/products/app-service/containers) is a feature of Azure App Service, a fully managed service for hosting HTTP-based web apps with built-in infrastructure maintenance, security patching, scaling, and diagnostic tooling. For more information, see [App Service documentation](/azure/app-service/).
    :::column-end:::
:::row-end:::

For a complete list of all Azure container services, see [the container services product category page](https://azure.microsoft.com/products/category/containers/).

## Service model considerations

The service model provides the broadest insight into the level of flexibility and control that any Azure container service provides, in exchange for its overall simplicity and ease of use.

For a general introduction into the terminology and concepts around service models, including infrastructure as a service (IaaS) and platform as a service (PaaS), see [Shared responsibility in the cloud](/azure/security/fundamentals/shared-responsibility).

### Comparing the service models of Azure container solutions

#### AKS Standard

As a hybrid of IaaS and PaaS, AKS prioritizes control over simplicity, leveraging the de facto standard for container orchestration: Kubernetes. Though AKS streamlines the management of the underlying core infrastructure, this VM-based platform is still exposed to your applications and requires appropriate guardrails and processes, like patching, to ensure security and business continuity. The compute infrastructure is supported by additional Azure resources that are hosted directly in your subscription, like Azure load balancers.

AKS also provides access to the Kubernetes API server, which enables you to customize the container orchestration and thus deploy projects from the Cloud Native Computing Foundation (CNCF). Consequently, there's a significant learning curve for workload teams that are new to Kubernetes. If you're new to containerized solutions, this learning curve must be taken in consideration. The following PaaS solutions offer a lower barrier to entry. You can move to Kubernetes when your requirements dictate that move.

#### AKS Automatic

[AKS Automatic](https://learn.microsoft.com/en-us/azure/aks/intro-aks-automatic) simplifies the adoption of Kubernetes by automating complex cluster management tasks, reducing the need for deep Kubernetes expertise. It offers a more streamlined, PaaS-like experience while retaining the flexibility and extensibility of Kubernetes. Azure handles cluster setup, node provisioning, scaling, security patching, and applies best-practice configurations by default. This reduces operational effort and accelerates time-to-market. 

Compared to standard AKS, AKS Automatic minimizes the learning curve associated with Kubernetes, making it more accessible for teams new to container orchestration. While it still provides access to the Kubernetes API for advanced configurations, many operational complexities are abstracted away.

> [!note]
> This guide will distinguish between AKS Standard and AKS Automatic where applicable. It can otherwise be assumed that functionality described has parity between both Standard and Automatic offerings.

#### Azure Container Apps  

Container Apps, a PaaS offering, balances control with simplicity. It offers both serverless and dedicated compute options. It maximizes simplicity by abstracting the underlying Kubernetes infrastructure which abstract away the need to patch the operating system or build guardrails around applications. It also completely abstracts away the container orchestration API and provides a subset of its key functionality through Azure APIs that your team might already be familiar with. Additionally, Layer 7 ingress, traffic splitting, A/B testing, and application lifecycle management are all fully available out of the box. It is ideal for teams that want to deploy containerized applications without managing Kubernetes complexities.

#### Web App for Containers

Web App for Containers is also a PaaS offering, but it provides more simplicity, and less control, than Container Apps. It abstracts away container orchestration but still provides appropriate scaling, application lifecycle management, traffic splitting, network integration, and observability.

### Hosting model considerations

You can use Azure resources, like AKS clusters, to host multiple workloads. Doing so can help you streamline operations and thereby reduce overall cost. If you choose this path, here are a few important considerations:

- **AKS** is commonly used to host multiple workloads or disparate workload components. You can isolate these workloads and components by using Kubernetes native functionality, like namespaces, access controls, and network controls, to meet security requirements.

   You can also use AKS in single-workload scenarios if you need the additional functionality that the Kubernetes API provides and your workload team has enough experience to operate a Kubernetes cluster. Teams with less Kubernetes experience can still successfully operate their own clusters by taking advantage of Azure managed [add-ons](/azure/aks/integrations#available-add-ons) and features, like [cluster auto-upgrade](/azure/aks/auto-upgrade-cluster), to reduce operational effort.

- **Container Apps** should be used to host a single workload with a shared security boundary. Container Apps has a single top-level logical boundary called a *Container Apps environment*, which also serves as an enhanced-security boundary. There are no mechanisms for additional granular access control. For example, intra-environment communication is unrestricted, and all applications share a single Log Analytics workspace.

  If the workload has multiple components and multiple security boundaries, deploy multiple Container Apps environments, or consider AKS instead.

- **Web App for Containers** is a feature of App Service. App Service groups applications into a billing boundary called an *App Service plan*. Because you can scope role-based access control (RBAC) at the application level, it might be tempting to host multiple workloads in a single plan. However, we recommend that you host a single workload per plan to avoid the Noisy Neighbor problem. All apps in a single App Service plan share the same allocated compute, memory, and storage.

  When you consider hardware isolation, you need to be aware that App Service plans generally run on infrastructure that's shared with other Azure customers. You can choose Dedicated tiers for dedicated VMs or Isolated tiers for dedicated VMs in a dedicated virtual network.

In general, all Azure container services can host multiple applications that have multiple components. However, Container Apps and Web App for Containers are better suited for a single-workload component or multiple highly related workload components that share a similar lifecycle, where a single team owns and runs the applications.

If you need to host disparate, potentially unrelated application components or workloads on one host, consider AKS.

## The tradeoff between control and ease of use

AKS provides the most configurability, but this configurability requires more operational effort, as compared to the other services. Although Container Apps and Web App for Containers are both PaaS services that have similar levels of Microsoft-managed features, Web App for Containers emphasizes simplicity to cater to its target audience: existing Azure PaaS customers, who find the interface familiar. 

### Rule of thumb

Generally, services that offer more simplicity tend to suit customers who prefer to focus on feature development rather than infrastructure management. Services that offer more control tend to suit customers who need more configurability and have the skills, resources, and business justification necessary to manage their own infrastructure. AKS Automatic provides a balanced approach, reducing operational effort while offering more control than fully managed PaaS services like Azure Container Apps and App Service. Standard AKS offer the most control and are suited for customers with advanced Kubernetes expertise and the need for extensive configurability.

## Shared considerations across all workloads

Although a workload team might prefer a particular service model, that model might not meet the requirements of the organization as a whole. For example, developers might prefer less operational effort, but security teams might consider this type of overhead necessary to meet compliance requirements. Teams need to collaborate to make the appropriate tradeoffs.

Be aware that shared considerations are broad. Only a subset might be relevant to you, depending not just on the workload type but also on your role within the organization.

The following table provides a high-level overview of considerations, including service feature comparisons. Review the considerations in each category and compare them against your workload's requirements.

| Category| Overview|
|---|---|
| [Networking considerations](container-service-general-considerations.md#networking-considerations) | Networking in Azure container services varies depending on your preference for simplicity versus configurability. AKS is highly configurable, providing extensive control over network flow, but it requires more operational effort. Container Apps offers Azure-managed networking features. It's a middle ground between AKS and Web App for Containers, which is tailored to customers who are familiar with App Service. <br><br>Crucially, network design decisions can have long-term consequences because of the challenges of changing them without re-deploying workloads. Several factors, like IP address planning, load balancing responsibilities, service discovery methods, and private networking capabilities, differ across these services. You should carefully review how the services meet specific networking requirements. |
| [Security considerations](container-service-general-considerations.md#security-considerations) | Container Apps, AKS, and Web App for Containers all provide integration with key Azure security offerings like Azure Key Vault and managed identities. AKS offers additional features like runtime threat protection and network policies. Although it might seem that PaaS services like Container Apps offer fewer security features, that's partly because more of the underlying infrastructure components are managed by Azure and not exposed to customers, which reduces risk. |
| [Operational considerations](container-service-general-considerations.md#operational-considerations) | AKS offers the most customization, but it demands greater operational input. In contrast, PaaS solutions like Container Apps and Web App for Containers let Azure handle tasks like OS updates. Scalability and hardware SKU flexibility are crucial. AKS provides flexible hardware options, whereas Container Apps and Web App for Containers provide less options. Application scalability in AKS is the responsibility of the customer, which means you can apply any Kubernetes-compatible solution. Container Apps and Web App for Containers focus on simpler approaches. |
| [Reliability considerations](container-service-general-considerations.md#reliability) | Web App for Containers and Container Apps health probe configurations are limited compared to AKS, but simpler to setup, given that they use the familiar Azure Resource Manager API. AKS requires the use of the Kubernetes API. It also requires you to take on the additional responsibility of managing Kubernetes node pool scalability and availability in order to properly schedule application instances. These requirements result in additional operational effort for AKS.<br><br>Moreover, SLAs for Container Apps and Web App for Containers are simpler to calculate than those of AKS, for which the control plane and node pools each have their own SLAs and need to be compounded accordingly. All services offer zone redundancy in datacenters that offer it. |

After reviewing the preceding considerations, you still might not have found the perfect fit. That's perfectly normal.

## Evaluating tradeoffs

Choosing a cloud service isn't a straightforward exercise. Given the complexity of cloud computing, the collaboration between many teams, and resource constraints involving people, budgets, and time, every solution has tradeoffs.

Be aware that, for any given workload, some requirements might be more critical than others. For example, an application team might prefer a PaaS solution like Container Apps but choose AKS because their security team requires deny-by-default network controls between colocated workload components, which is an AKS-only feature that uses Kubernetes network policies.

Finally, note that the preceding shared considerations include the most common requirements but aren't comprehensive. It's the workload team's responsibility to investigate every requirement against the preferred service's feature set before confirming a decision.

## Conclusion

This guide describes the most common considerations that you face when you choose an Azure container service. It's designed to guide workload teams in making informed decisions. The process starts with choosing a cloud service model, which involves determining the desired level of control. Control comes at the expense of simplicity. In other words, it's a process of finding the right balance between a self-managed infrastructure and one that's managed by Microsoft.

Many workload teams can choose an Azure container service solely based on the preferred service model: PaaS versus IaaS. Other teams need to investigate further to determine how service-specific features address workload or organizational requirements.

All workload teams should use this guide in addition to incorporating due diligence to avoid difficult-to-reverse decisions. Be aware, however, that the decision isn't confirmed until developers try the service and decide based on experience rather than theory.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Andre Dewes](https://www.linkedin.com/in/andre-dewes-480b5b62/) | Senior Customer Engineer
- [Marcos Martinez](https://www.linkedin.com/in/marcosmarcusm/) | Senior Service Engineer  
- [Julie Ng](https://www.linkedin.com/in/julie-io/) | Senior Engineer 

Other contributors:

- [Mick Alberts](https://www.linkedin.com/in/mick-alberts-a24a1414/) | Technical Writer 
- [Martin Gjoshevski](https://www.linkedin.com/in/martin-gjoshevski/) | Senior Customer Engineer
- [Don High](https://www.linkedin.com/in/donhighdevops/) |  Principal Customer Engineer
- [Nelly Kiboi](https://www.linkedin.com/in/nellykiboi/)  | Service Engineer
- [Xuhong Liu](https://www.linkedin.com/in/xuhong-l-5937159b/) | Senior Service Engineer  
- [Faisal Mustafa](https://www.linkedin.com/in/faisalmustafa/) |  Senior Customer Engineer
- [Walter Myers](https://www.linkedin.com/in/waltermyersiii/) | Principal Customer Engineering Manager
- [Sonalika Roy](https://www.linkedin.com/in/sonalika-roy-27138319/) | Senior Customer Engineer
- [Paolo Salvatori](https://www.linkedin.com/in/paolo-salvatori/) |  Principal Customer Engineer
- [Victor Santana](https://www.linkedin.com/in/victorwelascosantana/) |  Principal Customer Engineer

## Next step

Learn more about shared architectural considerations for the services mentioned in this article.

> [!div class="nextstepaction"]
> [Shared architectural considerations](container-service-general-considerations.md)
