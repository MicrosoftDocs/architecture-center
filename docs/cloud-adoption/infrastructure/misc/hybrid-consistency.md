---
title: "Enterprise Cloud Adoption: Create Hybrid Cloud Consistency" 
description: Defining the approach to Create Hybrid Cloud Consistency
author: BrianBlanchard
ms.date: 10/11/2018
---
# Enterprise Cloud Adoption: How To: Create Hybrid Cloud Consistency

The [Infrastructure section](../overview.md) of the [Enterprise Cloud Adoption framework](../../overview.md), clarifies the components required to migrate core infrastructure services to Azure. This section of the framework, expands on that topic by specifically guiding the reader through the high level approaches that could create hybrid consistency.

[Hybrid models](../../getting-started/cloud-deployment-models.md) during [migration](../../migration/overview.md) can reduce risk and contribute to a smooth transition. Cloud platforms offer the greatest level of flexibility when it comes to business processes, but many organizations are hesitant to make the move, preferring instead to keep full control over their most sensitive data. Unfortunately, on-premises servers don’t allow for the same rate of innovation. Hybrid cloud options allow for the best of both worlds: The speed of cloud innovation AND the comfort of on-prem management.

## Integrate hybrid cloud consistency

Using a hybrid cloud allows organizations to scale computing resources. It also eliminates the need to make massive capital expenditures to handle short-term spikes in demand. When the business needs to free up local resources for more sensitive data or applications, it is easy, faster, and cheaper to de-provision the cloud resources. Organizations pay only for resources they temporarily use instead of having to purchase and maintain additional resources. This reduces the amount of equipment that remains idle over long periods of time. Hybrid cloud computing is a “best of all possible worlds” platform, delivering all the benefits of cloud computing—flexibility, scalability, and cost efficiencies—with the lowest possible risk of data exposure.

![Creating hybrid cloud consistency across identity, management, security, data, development, & devops](../../_images/hybrid-consistency.png)
*Figure 1. Creating hybrid cloud consistency across identity, management, security, data, development, & devops*

A true hybrid cloud must provide four components, each of which brings significant benefits, including:

* Common identity for on-premises and cloud applications. This improves user productivity by giving users single sign-on to all their applications. It also ensures consistency as applications and users cross network/cloud boundaries.
* Integrated management and security across your hybrid cloud. This enables a cohesive way to monitor, manage, and secure the environment, providing increased visibility and control.
* A consistent data platform for the datacenter and the cloud. This creates data portability, combined with seamless access to on-premises and cloud data services for deep insight into all data sources.
* Unified development and DevOps across the cloud and on-premises datacenters. Move applications between the two environments as needed, improving developer productivity, since both places now have the same development environment.
  
Examples of these components from an Azure perspective would include:

* Azure Active Directory, which works with on-premises Active Directory to provide common identity for all users. Single sign-on across on-premises and in the cloud makes it simple for users to safely access the applications and assets they need. Administrators can manage security and governance controls, so users can access what they need—with flexibility to adjust those permissions without affecting the user experience.
* Azure provides integrated management and security services for both cloud and on-premises infrastructure that include an integrated set of tools for monitoring, configuring, and protecting hybrid clouds. This end-to-end approach to management specifically addresses real-world challenges facing organizations considering a hybrid cloud solution.
* Azure hybrid cloud provides common tools that ensure secure access to all data, seamlessly and efficiently. Azure data services combine with Microsoft SQL Server to create a consistent data platform. A consistent hybrid cloud model allows users to work with both operational and analytical data, providing the same services on-premises and in the cloud for data warehousing, data analysis, and data visualization.
* Microsoft Azure services in the cloud, combined with Microsoft Azure Stack on-premises, provide unified development and DevOps. Consistency across the cloud and on-premises means that DevOps team can build applications that run in either environment and easily deploy to the right location. Templates can be reused across the hybrid cloud as well, which can further simplify DevOps processes.

## Next steps

Review the remaining components of [Infrastructure Guidance](../overview.md) to begin designing & building a hybrid cloud infrastructure.

> [!div class="nextstepaction"]
> [Infrastructure Guidance](../overview.md)

## Azure Stack in a hybrid cloud environment

Microsoft Azure Stack is a hybrid cloud solution that allows organizations to run Azure-consistent services in their datacenter, providing a simplified development, management, and security experience that is consistent with Azure public cloud services. Azure Stack is an extension of Azure, enabling you to run Azure services from your on-premises environments and then move to the Azure cloud if and when required.

Azure Stack allows you to deploy and operate both IaaS and PaaS using the same tools and offering the same experience as the Azure public cloud. Management of Azure Stack, whether through the web UI portal or through PowerShell, has a consistent look and feel for IT administrators and end users with Azure.
Azure and Azure Stack unlock new hybrid use cases for both customer-facing and internal line-of-business applications, including:

* Edge and disconnected solutions – Customers can address latency and connectivity requirements by processing data locally in Azure Stack and then aggregating in Azure for further analytics, with common application logic across both. Many customers are interested in this edge scenario across different contexts, including factory floors, cruise ships, and mine shafts.
* Cloud applications that meet varied regulations – Customers can develop and deploy applications in Azure, with full flexibility to deploy on-premises on Azure Stack to meet regulatory or policy requirements, with no code changes needed. Illustrative application examples include global audit, financial reporting, foreign exchange trading, online gaming, and expense reporting. Customers are sometimes looking to deploy different instances of the same application to Azure or Azure Stack, based on business and technical requirements. While Azure meets most requirements, Azure Stack complements the deployment approach where needed.
* Cloud application model on-premises – Customers can use Azure web services, containers, serverless, and microservice architectures to update and extend existing applications or build new ones. You can use consistent DevOps processes across Azure in the cloud and Azure Stack on-premises. We’re seeing broad interest in application modernization, including for core mission-critical applications.

Azure Stack is offered in two deployment options:

* Azure Stack integrated systems – Azure Stack integrated systems are offered through a partnership of Microsoft and hardware partners, creating a solution that provides cloud-paced innovation balanced with simplicity in management. Because Azure Stack is offered as an integrated system of hardware and software, you are offered the right amount of flexibility and control, while still adopting innovation from the cloud. Azure Stack integrated systems range in size from 4–12 nodes and are jointly supported by the hardware partner and Microsoft. Use Azure Stack integrated systems to enable new scenarios for your production workloads.
* Azure Stack Development Kit – Microsoft Azure Stack Development Kit is a single-node deployment of Azure Stack, which you can use to evaluate and learn about Azure Stack. You can also use the kit as a developer environment, where you can develop using APIs and tooling that are consistent with Azure. Azure Stack Development Kit is not intended to be used as a production environment.

## Azure Stack One Cloud Ecosystem

You can speed up Azure Stack initiatives by leveraging the rich Azure ecosystem:

* Azure ensures that most applications and services that are certified for Azure will work on Azure Stack. Several ISVs—including Bitnami, Docker, Kemp Technologies, Pivotal Cloud Foundry, Red Hat Enterprise Linux, and SUSE Linux—are extending their solutions to Azure Stack.
* You can opt to have Azure Stack delivered and operated as a fully managed service. Several partners—including Tieto, Yourhosting, Revera, Pulsant, and NTT—will have managed service offerings across Azure and Azure Stack shortly. These partners have been delivering managed services for Azure via the Cloud Solution Provider (Cloud Providers) program and are now extending their offerings to include hybrid solutions.
* As an example of a complete, fully managed hybrid cloud solution, Avanade is delivering an all-in-one offer that includes cloud transformation services, software, infrastructure, setup and configuration, and ongoing managed services so customers can consume Azure Stack just as they do with Azure today.
* Systems Integrators (SI) can help accelerate application modernization initiatives by building end-to-end Azure solutions for customers. They bring in-depth Azure skill sets, domain and industry knowledge, and process expertise (e.g., DevOps). Every Azure Stack cloud is an opportunity for an SI to design the solution, lead and influence system deployment, customize the included capabilities, and deliver operational activities. This includes SIs like Avanade, DXC, Dell EMC Services, InFront Consulting Group, HPE Pointnext, and Pricewaterhouse Coopers (PwC).

## Additional Next steps

See more [guidance and examples](../overview.md#azure-examples-and-guidance) on how to use core infrastructure components in the Azure cloud.

> [!div class="nextstepaction"]
> [Azure Examples and Guidance](../overview.md#azure-examples-and-guidance)