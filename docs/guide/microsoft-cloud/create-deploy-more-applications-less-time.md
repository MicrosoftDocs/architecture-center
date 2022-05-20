---
title: Create and deploy more applications in less time
description: Learn how to use the unified collection of services that the Microsoft Cloud provides to create and deploy more applications in less time.
author: DanWahlin
ms.author: dwahlin
ms.contributors: dwahlin-5182022
ms.date: 05/24/2022
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
categories:
  - developer-tools
products:
  - azure
  - power-platform
  - github
  - azure-devops
  - m365
ms.custom:
  - fcp
  - team=cloud_advocates
---

# Create and deploy more applications in less time

> [!Note]
> This is article 2 of 6 in **Build applications on the Microsoft Cloud**.

Most enterprise application development leaders share a goal: to create and deploy better applications in less time. This article shows how you can use the Microsoft Cloud to reach this goal.

- [Use Microsoft Azure to succeed with pro-code development](#use-microsoft-azure-to-succeed-with-pro-code-development)
- [Use Power Platform to succeed with low-code development](#use-power-platform-to-succeed-with-low-code-development)

## Use Microsoft Azure to succeed with pro-code development

Professional software developers are the heart of enterprise development organizations. These pro-code developers create custom software using C#, Java, Python, and other programming languages. They also use powerful database systems, messaging services, and other technologies aimed at professional developers.

To support pro-code developers, the Microsoft Cloud provides Microsoft Azure, which has a broad set of services. Your organization can choose the best options for the applications that you need to create.

- [Azure Virtual Machines](/azure/virtual-machines), for deploying Linux and Windows virtual machines.
- [Azure App Service](/azure/app-service), an HTTP-based technology for running web applications and mobile back ends. The software can be written in many different languages, and can run on either Windows or Linux.
- [Azure Kubernetes Service (AKS)](/azure/aks), for deploying a managed Kubernetes cluster to run containerized applications.
- [Azure Functions](/azure/azure-functions), for creating callable blocks of code, called functions, then automatically scaling as needed to handle client requests. This approach is an example of serverless computing.
- [Azure Static Web Apps](/azure/static-web-apps), for automatically building and deploying web applications to Azure, triggered by changes made to application source code in GitHub or in Azure DevOps repositories. Static Web Apps can also host serverless application APIs created with Azure Functions, and deploy front-end web applications built with Angular, React, and other frameworks.
- [Azure Logic Apps](/azure/logic-apps), a service that makes it possible for developers to create and run automated workflows. These workflows can integrate applications and data, so that your organization can quickly develop scalable integration solutions for enterprise and business-to-business (B2B) scenarios.
- Relational data services, including:
  - [Azure SQL Database](/azure/azure-sql/database)
  - [Azure Database for MySQL](/azure/mysql)
  - [Azure Database for PostgreSQL](/azure/postgresql)
- [Azure Cosmos DB](/azure/cosmos-db), a fully managed NoSQL database with scalable support for several different approaches to working with data.

To get a sense of how pro-code developers can use Azure, suppose that an organization needs to create a custom application for use both by customers and employees. For example:

- A healthcare organization wants to provide a way for patients to access test results that medical professionals upload.
- Customers of a financial services firm apply for loans that must be approved by the firm’s employees.

In scenarios like these, it's likely that the application has distinct components that interact with customers and employees and that share data. Figure 2 shows the basics of this solution.

:::image type="content" source="images/customers-employees-share-data.png" alt-text="Diagram that shows a customer application and an employee application sharing data." border="false" :::

**Figure 2: In many modern enterprise applications, customers and employees work with shared data.**

To keep the application responsive when it serves a large number of simultaneous users, the pro-code developers can build the customer-facing software on Azure. They might choose to use a microservices architecture on containers that run on Azure Kubernetes Service, or perhaps a simpler approach using a web application hosted in Azure App Service. Either way, your developers will also need to choose a data service for the application to use. Figure 3 shows how this looks.

:::image type="content" source="images/pro-code-developers-customer-facing.png" alt-text="Diagram that shows a customer application that was created with App Service. It access and Azure SQL database." border="false" :::

**Figure 3: Pro-code developers can use Azure App Service and Azure SQL Database to create the customer-facing part of the application.**

In our example, the development team chooses to create the customer-facing application by using Azure App Service and Azure SQL Database. The result is a scalable, reliable application that works effectively with the organization’s customers.

Besides providing application development tools, Microsoft Cloud also provides operations tools:

- [Azure Monitor](/azure/azure-monitor) is a service that monitors applications to maximize their availability and performance. It collects metrics that describe various aspects of a system, and it creates logs that contain events, traces, and performance data.
- [Application Insights](/azure/azure-monitor/app/app-insights-overview) is a feature of Azure Monitor for managing application performance.
- [Log Analytics](/azure/azure-monitor/logs/log-analytics-overview) is a tool in the Azure portal for querying log data.

The [Azure Well-Architected Framework](/azure/architecture/framework) has guidance to help professional developers create better Azure applications. The [Cloud Adoption Framework](/azure/cloud-adoption-framework) has guidance and best practices for adopting and governing Azure.

## Use Power Platform to succeed with low-code development

You can create some applications quickly and easily with low-code tools, which are tools that can be used by people who aren't software professionals. Whenever possible create applications the low-code way, not the pro-code way, to create more applications in less time, and to save money. Low-code development can be done either by software professionals or by citizen developers who aren't software professionals.

The Microsoft Cloud provides Power Platform for low-code development. It includes these services:

- [Power Apps](/power-apps) for building low-code applications
- [Power Automate](/power-automate) for creating flows to automate business processes
- [Power Virtual Agents](/power-virtual-agents) for building chatbots
- [Power BI](/power-bi) for creating data-driven insights

Although all of these services can be used by non-professional developers, low-code development can also have real value for professional developers. Often they can use Power Platform to create an application more quickly than if they used a language like C#.

In our example application, we create the employee-facing component by using Power Apps. Figure 4 shows how this looks.

:::image type="content" source="images/low-code-developers-employee-facing.png" alt-text="Diagram that shows a customer application that was written by using App Service and an employee application that was written by using Power Apps. They share an Azure SQL Database." border="false" :::

**Figure 4: Citizen developers or professional developers can use Power Apps to create a low-code application for the employee-facing part of the solution.**

Here are benefits of the low-code approach:

- A low-code application can be ready in less time. Power Apps developers commonly use Power Apps Studio to create an application quickly with a point-and-click approach—they don’t need to write code. If the application is created by citizen developers, they don't have to wait for professional developers to be available. They can create and update the application on their own schedule.
- A low-code application can easily connect to many kinds of data. In this example, the low-code application uses Azure SQL Database for its data, just like the pro-code part of the solution. Low-code applications can also work with many other data stores, such as Dataverse—designed for use with Power Platform—or Cosmos DB. An application accesses a data store by using a connector. A developer can quickly add a connector to an application by dragging and dropping the connector into the application.
- Connectors make it possible for a low-code application to work with many other technologies. For example, Microsoft provides connectors to applications and data from many sources, such as Oracle, Salesforce, Dropbox, and SAP. There are more than 450 connectors. An application can even use connectors to access functionality that's provided by other cloud services, such as sending tweets with Twitter.

Low-code development is a technology that gives your organization more ways to build applications and to build them quickly. It's an essential way to create better applications in less time.

When appropriate, professional and citizen developers can work together to create an application. This approach, called fusion development, is discussed in a companion article, [3. Get the most value from technical talent](get-most-value-technical-talent.md).

> ## Deploying applications with Microsoft Teams
>
> However they’re built, your applications have value only if they’re used. For this reason, it’s a good idea to embed applications in an environment where the users are.
>
> An important example of this is deploying applications within Microsoft Teams. Pro-code applications created by using Azure can use this option, as can low-code applications that are built on Power Platform. Teams is used by hundreds of millions of people every month, so why not connect your applications to this popular technology?
>
> For low-code applications, there’s another powerful option: using [Dataverse for Teams](/learn/paths/work-power-platform-teams). It's part of Microsoft Teams, which is part of Microsoft 365, so typically there's no extra license required to use it. Dataverse for Teams also includes subsets of Power Automate, Power Virtual Agents, and Power BI.
>
> Here are some benefits of using Dataverse for Teams:
>
>- It simplifies the deployment of applications and data to team members.
> - You can control the permissions for the application by using Teams. Rather than working with the more detailed options available with Power Apps itself, you can use the permissions already established for the members of a team. This is simpler and less likely to lead to mistakes.
> - You get a uniform user interface style for your low-code applications. Rather than letting each group of citizen developers define their own approach, they can match the style of Teams to make the applications easier to understand and use.
>
> Whether or not you use Dataverse for Teams, deploying applications within Teams is a clear example of the value provided by the unified services of the Microsoft Cloud.

## Next steps

See how successful enterprise application development leaders get the most value from technical talent with fusion development and an integrated low-code and pro-code development process that includes GitHub and Azure DevOps.

> [!div class="nextstepaction"]
> [3. Get the most value from technical talent](get-most-value-technical-talent.md)
