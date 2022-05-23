---
title: Create and run secure applications
description: Learn how to use the unified collection of services that the Microsoft Cloud provides to improve security.
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

# Create and run secure applications

> [!Note]
> This is article 5 of 6 in **Build applications on the Microsoft Cloud**.

Good security protects your systems, and therefore your organization, against accidental and intentional damage. It assures that only the right people can access your resources and minimizes the possibility that they can do inadvertent harm. It also warns you of dangers, violations, and other important security events.

This article discusses ways that Microsoft Cloud can help you secure your systems.

- [Use Azure Active Directory for a unified identity and access management solution](#use-azure-active-directory-for-a-unified-identity-and-access-management-solution)
- [Use Microsoft Sentinel to monitor and manage the security of your applications](#use-microsoft-sentinel-to-monitor-and-manage-the-security-of-your-applications)

## Use Azure Active Directory for a unified identity and access management solution

In our cloud-based world, employees and customers can access your custom applications from many devices in many different locations. Granting access to the right people, with the right restrictions, depends fundamentally on identity. Good security requires that each user prove their identity before they can access systems, and that they only access the resources they require to do their job.

Building the software to do this is hard. It requires specialists, and it takes time to get right, so you definitely don’t want to build your own. Just as important, identity should be as simple to use as possible, both for your users and your developers. Ideally, you’d like a uniform way to manage identity throughout your environment.

This is what the Microsoft Cloud provides with [Azure Active Directory](/azure/active-directory) (Azure AD), the world’s largest cloud identity service. If your organization uses any components of the Microsoft Cloud today, such as Azure, Power Platform, Microsoft 365, or Dynamics 365, you’re already using Azure AD. It's used throughout the Microsoft Cloud, giving your users a single identity for all of its components.

Your custom applications built on the Microsoft Cloud should also use Azure AD. Figure 9 shows how this looks for our sample application.

:::image type="content" source="images/ad-ad-b2c-provide-identity-services.png" alt-text="Diagram that shows Azure A D B 2 C and Azure A D providing identity services both for customer applications and employee applications." border="false" :::

**Figure 9: Azure Active Directory and Azure Active Directory B2C provide a common identity service for applications built on the Microsoft cloud.**

As the figure shows, custom applications can use two related identity services:

- [Azure AD](/azure/active-directory), which provides identities within the Microsoft Cloud. Employees who access your custom applications will typically use Azure AD to sign in and establish the identity they use to access all Microsoft Cloud services.
- [Azure AD B2C](/azure/active-directory-b2c), which provides identities for external users. This service lets your customers create their own accounts or use existing public accounts from Microsoft, Google, Facebook, and others.

Using Azure AD for identity brings several benefits:

- Having the same identity throughout the Microsoft Cloud makes life simpler for both developers and users of your applications. In the example shown in Figure 9, an employee can start by signing in to their organization’s Azure AD environment, known as a tenant. After they’ve done this, they can access the employee-facing component of the application that was created by using Power Apps. This application can call Azure API Management, Dynamics 365, and Microsoft Graph using the same identity, so the employee doesn’t have to sign in again.
- Your developers can use the Microsoft identity platform in applications that they create. The libraries and management tools make it easier for developers to build applications that use identities from Azure AD and elsewhere. To help do this, the Microsoft identity platform implements industry standards such as OAuth 2.0 and OpenID Connect.
- Using Azure AD and the Microsoft identity platform gives you control over how you use identity. For example, you can turn on support for multi-factor authentication in multiple applications built with the Microsoft identity platform by changing a single setting. Azure AD also integrates with Microsoft’s security tools for monitoring identity-based security threats and attacks.

Getting identity and access management right is a fundamental part of doing security well. Building applications on the Microsoft Cloud with Azure AD makes this goal easier to achieve.

## Use Microsoft Sentinel to monitor and manage the security of your applications

Everybody building applications today should assume that their software is targeted by attackers. Given this, your organization must continuously monitor and manage the security of your applications and the environment that they run in. The Microsoft Cloud provides several tools for doing this.

One of the most important of these is [Microsoft Sentinel](/azure/sentinel). Sentinel provides security information and event management (SIEM), letting you capture and analyze a wide range of security-related data. It can also respond automatically to threats, providing security orchestration, automation, and response (SOAR). Sentinel can help your organization find and fix security problems more effectively.

Sentinel’s broad reach encompasses the Microsoft Cloud and beyond through a large set of connectors. These connectors let Sentinel interact with many other services and technologies. Among the most important of these are the Microsoft Defender tools, including:

- [Microsoft Defender for Cloud](/azure/defender-for-cloud), which helps your organization understand and improve the security of your Azure applications. It can also protect specific cloud services such as Azure Storage.
- [Microsoft 365 Defender](/microsoft-365/security/defender), which provides components such as:
  - [Microsoft Defender for Office 365](/microsoft-365/security/office-365-security), which guards Exchange and other aspects of Office 365.
  - [Microsoft Defender for Identity](/defender-for-identity), which monitors Active Directory to detect compromised identities and other threats.
  - [Microsoft Defender for Cloud Apps](/defender-cloud-apps), which acts as a cloud access security broker between the users in your organization and the cloud resources that they use. It helps you better understand which apps you use, both in the Microsoft Cloud and elsewhere, and who is using them.

Microsoft Sentinel can also import Office 365 audit logs, Azure activity logs, and other security relevant information within the Microsoft Cloud. Sentinel can also access security related information from many other sources provided by a diverse set of vendors. Once you’ve connected Sentinel to your information sources, you can analyze the data to understand security incidents and respond to them.

Security isn’t a simple topic. Because of this, Microsoft provides Microsoft Sentinel and other security offerings to address this area. All these technologies work together to improve the security of applications running on the Microsoft Cloud.

## Next steps

See a summary of **Build applications on the Microsoft Cloud** and find out how to learn more about succeeding as an enterprise application development leader.

> [!div class="nextstepaction"]
> [6. Summary](summary.md)
