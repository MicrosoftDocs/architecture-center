---
title: Get the most value from technical talent
description: Learn how to use the unified collection of services that the Microsoft Cloud provides to get the most value from technical talent.
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

# Get the most value from technical talent

> [!Note]
> This is article 3 of 6 in **Build applications on the Microsoft Cloud**.

Using both pro-code and low-code development can help your organization get the most from on-staff talent. It also changes the way you create software. This article shows ways to use the Microsoft Cloud to get the most from your talent.

- [Use Power Platform and Azure for fusion development](#use-power-platform-and-azure-for-fusion-development)
- [Use GitHub and Azure DevOps to create an integrated development process](#use-github-and-azure-devops-to-create-an-integrated-development-process)

## Use Power Platform and Azure for fusion development

Low-code development is useful, but it’s not the best solution for everything. In our example application, for instance, the employee-facing part was built on Power Platform, but because the customer-facing part required greater scalability and better performance, it was built by pro-code developers on Azure.

Creating complete solutions that combine low-code and pro-code is known as fusion development. Being successful with fusion development requires making good decisions about when to use low-code and when to use pro-code. In general, you should consider using low-code whenever possible, especially for employee-facing applications, because it’s likely to be less expensive and take less time to build.

You shouldn’t expect to do everything with low-code. A pro-code approach is better for apps that must handle tens of thousands of simultaneous users with good response. One way to meet these requirements is to use a microservices architecture and run on Kubernetes, but this can't be done by using Power Platform.

With Azure and Power Platform, the Microsoft Cloud provides an integrated approach to fusion development. Here are some benefits of this approach:

- Power Platform is built on Azure, so they work well together. For example, applications created on either foundation can easily use the same data sources, as shown in [2. Create and deploy more applications in less time](create-deploy-more-applications-less-time.md). Both also use the same underlying technologies for identity and security.
- Power Platform makes it easy for pro developers to create useful extensions for low-code development. For example, pro developers can use Visual Studio to create custom controls for low-code user interfaces. They can also create custom connectors for accessing applications and data.
- Developers using both Power Platform and Azure can rely on the same technologies for managing source code and deploying applications. The next section looks at this approach in more detail.

Low-code and pro-code development are both important for your organization, and successful enterprise development groups typically do both. They embrace fusion development.

## Use GitHub and Azure DevOps to create an integrated development process

Although both professional and non-professional developers can use Power Apps to create useful applications, it's still important to use a modern development process. Professional developers can help citizen developers understand and use a more professional approach to creating and deploying software. The Microsoft Cloud provides two technologies to implement professional development processes:

- [GitHub](https://docs.github.com/en) provides source code control and other services that help developers collaborate on the same code base. By using GitHub Actions, developers can create workflows that automatically build and deploy code.
- [Azure DevOps](/azure/devops) also provides source code control and other services that help developers collaborate. Developers can use DevOps to create pipelines, which are like workflows, that build and deploy code.

GitHub and Azure DevOps overlap in some ways. Both can help developers automate build and deployment, for example. They can also be used together. For example, you can use GitHub for source control and Azure DevOps to implement a pipeline.

Both GitHub and Azure DevOps were created to meet the needs of professional developers, and both are widely used today for this purpose. But both technologies are part of the Microsoft Cloud and can be used by low-code developers to create apps for Power Platform. This means that your organization can use GitHub, Azure DevOps, or both, to support fusion development teams. Figure 5 illustrates this idea.

:::image type="content" source="images/pro-code-low-code-integrated-development.png" alt-text="Diagram that shows developers using GitHub and Azure DevOps to develop a customer application with App Service and an employee application with Power Apps. The apps access the same Azure SQL database." border="false" :::

**Figure 5: Pro-code and low-code development can use an integrated development process.**

Here are some benefits of using GitHub and Azure DevOps to support fusion development:

- Just as a group of pro-code developers working together to create a C# application can use GitHub and Azure DevOps for source code control, a group of low-code developers working together to create a Power Apps application can take advantage of these same technologies. Much like pro developers, Power Apps developers can extract apps from a repo, modify them, then return the updated version. This integration gives citizen developers the ability to use a more disciplined development process, improving the quality of the apps they create.
- Just as pro-code developers automate deployment with GitHub workflows and Azure Pipelines, Power Platform developers can use these same technologies to deploy a solution into the correct environment. This pipeline is typically simpler than one used by pro-code developers. Power Platform solutions aren’t compiled, for example, so there’s no build step.

Using the Microsoft Cloud makes possible a modern process for fusion development that's built on shared technologies including GitHub and Azure DevOps.

> ## Use new technologies for business innovation
>
> One of the best ways to improve your organization is to take advantage of new technologies that facilitate business innovation. Exploiting these advances can lower your costs, reach more customers, and help you enter new lines of business. In fact, ignoring new technology is dangerous: why let your competitors get these benefits first?
>
> The Microsoft Cloud provides an ongoing stream of leading-edge technologies for your organization. For example, one important area for innovation is artificial intelligence (AI) and machine learning. Among the advanced AI technologies in the Microsoft Cloud are:
>
> - [Azure Cognitive Services](/azure/cognitive-services), which makes it possible for professional developers to exploit machine learning models from Microsoft in their applications. The services available include Computer Vision for processing images, an API for facial recognition, a Language service for understanding natural languages, and a speech service that makes it possible for your applications to have capabilities such as speech-to-text and text-to-speech conversion, and speech translation.
> - [AI Builder](/ai-builder), a Power Platform capability that makes it possible for low-code developers to create and use their own custom machine learning models. It also provides prebuilt models for common business scenarios such as object detection and extraction of information from invoices or other business documents.
> - [Power Apps Ideas](/power-apps/maker/canvas-apps/power-apps-ideas), which gives low-code developers the ability to specify application behavior by expressing what they want in plain natural language. These requests are automatically translated into the Power Fx formulas that Power Apps uses. This translation relies on OpenAI GPT-3, one of the most advanced natural language models in the world.
>
> Another important area for innovation is the Internet of Things (IoT)—networks of physical devices that exchange data with one another and with services. There are billions of connected devices in the world, and more to come. To help your organization take advantage of IoT, the Microsoft Cloud offers such technologies as:
>
> - [Azure IoT Hub](/azure/iot-hub), a managed service hosted in the Microsoft Cloud that acts as a central message hub for communication between an IoT application and its attached devices. Your organization can use this service to connect millions of devices to back-end solutions reliably and securely.
> - [Azure IoT Edge](/azure/iot-edge), which extends IoT Hub by analyzing device data on-premises by using edge applications instead of cloud applications. Edge applications react to events more quickly than cloud applications, and reduce traffic to the cloud.
>
> A third area for innovation is quantum computing. To help your organization start using this technology, the Microsoft Cloud provides [Azure Quantum](/azure/quantum), with two main paths:
>
> - [Quantum Computing](/azure/quantum/overview-understanding-quantum-computing), which helps you experiment with and create prototypes using a variety of quantum hardware providers.
> - [Optimization](/azure/quantum/optimization-overview-introduction), focused on using quantum computing to find the best solution from a set of possible options.
>
> Microsoft also provides the Quantum Development Kit, a set of tools, including the open-source Q# language, for creating quantum software.
>
> The Microsoft Cloud provides leading-edge technologies that can help your organization create real business innovation. Keeping abreast of what new technologies can do is an essential part of succeeding as an application development leader.

## Next steps

See how successful enterprise application development leaders integrate new applications with existing solutions by using Azure API Management, Microsoft Graph, and Dynamics 365.

> [!div class="nextstepaction"]
> [4. Integrate new applications with existing solutions](integrate-new-applications-existing-solutions.md)
