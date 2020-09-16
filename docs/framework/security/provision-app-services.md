---
title: Applications and services in Azure | Microsoft Docs
description: Firewalls and best practices in Azure.
author: v-aangie
ms.date: 09/17/2020
ms.topic: article
ms.service: architecture-center
ms.subservice: well-architected
---

# Applications and services

Web application firewalls (WAFs) mitigate the risk of an attacker being able to exploit commonly seen security vulnerabilities for applications. While not perfect, WAFs provide a basic minimum level of security for web applications.

Applications hosted in containers should follow general application best practices as well as some specific guidelines to manage this new application architecture type.

## Use Web Application Firewalls

WAFs are an important mitigation as attackers target web applications for an ingress point into an organization similar to a client endpoint. WAFs are appropriate for both.

- Organizations without a strong application security program as it is a critical safety measure (much like a parachute in a plane). Note that this shouldn’t be the only planned safety mechanism to reduce the volume and severity of security bugs in your applications. In addition to mitigation tools such as a WAF, a [Secure Development Lifecycle](https://www.microsoft.com/securityengineering/sdl/practices) approach should be adopted.

- Organizations who have invested in application security and a Secure Development Lifecycle approach, WAFs provide a valuable additional defense in-depth mitigation. WAFs in this case act as a final safety mechanism in case a security bug was missed by security practices in the development lifecycle.

Microsoft includes WAF capabilities in [Azure Application Gateway](https://azure.microsoft.com/services/application-gateway/) and many vendors offer these capabilities as standalone security appliances or as part of next generation firewalls.

## Follow best practices for container security

Containerized applications face the same risks as any application while also adding new considerations in order to secure the hosting and management of the applications.

Application containers architectures introduced a new layer of abstraction and management tooling (typically Kubernetes) that have increased developer productivity and adoption of DevOps principles.

While this is an emerging space that is evolving rapidly, several key lessons learned and best practices have become clear:

- **Use a Kubernetes managed service instead of installing and managing Kubernetes**  
    Kubernetes is a very complex system and still has a number of default settings that are not secure and few Kubernetes security experts in the marketplace. While this has been improving in recent years with each release, there are still a lot of risks that have to be mitigated.

- **Validate container + container supply chain**  
    Just as you should validate the security of any open-source code added to your applications, you should also validate containers you add to your applications.

    -   Ensure that the practices applied to building the container are validated against your security standards like application of security updates, scanning for unwanted code like backdoors and illicit crypto coin miners, scanning for security vulnerabilities, and application of secure development practices.

    -   Regularly scan containers for known risks in the container registry, before use, or during use.

- **Set up registry of known good containers**  
    This allows developers in your organization to use containers validated by security rapidly with low friction. Additionally, build a process for developer to request and rapidly get security validation of new containers to encourage developers to use this process vs. working around it.

- **Don’t run containers as root or administrator unless explicitly required**  
    Early versions of containers required root privileges (which makes attacks easier), but this is no longer required with current versions.

- **Monitor containers**  
    Ensure you deploy security monitoring tools that are container aware to monitor for anomalous behavior and enable investigation of incidents.

For more information, see [Best practices for cluster security and upgrades in Azure Kubernetes Service (AKS)](https://docs.microsoft.com/azure/aks/operator-best-practices-cluster-security).
