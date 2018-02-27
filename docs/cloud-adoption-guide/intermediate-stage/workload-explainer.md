---
title: "Explainer: what is a workload?"
description: Defines the term workload and describes a workload in the context of modernizing an on-premises workload
author: petertay
---

# Explainer: what is a workload?

In the foundational adoption stage, you learned about some simple workloads: a simple Azure web application, and, a single infrastructure-as-a-service (IaaS) virtual machine (VM). We may intuitively understand the term **workload** to represent the code artifacts and data sources for a given application on-premises, but the term has an expanded meaning in the cloud.

On-premises applications typically share networking, security, and other on-premises services. However, an organization's workloads in Azure may be completely isolated from one another and share no networking, security, or management services at all. For example, a development team may have a proof-of-concept environment in Azure that is used only by their team and is not used for production. Access to IaaS resources in Azure may only be through a secure network connection such as a point-to-site VPN or externally tunneling in via a bastion host. In this case, the workload is defined by its environment: everything required by the application must be present within the isolation boundary.

It's also possible that an organization's workloads in Azure are integrated with on-premises workloads and share security, identity, and other services with on-premises applications. For example, an organization can extend the on-premises datacenter security boundary to include Azure and host IaaS VMs that are running Windows Server and Active Directory Domain Services (AD DS). In this case, the workload is defined nearly the same way that it would be defined on-premises, with the key distinction being that it is also defined by its Azure resources and management infrastructure.

As you continue your learning through the Azure cloud adoption stages and into scenarios such as migrating an existing on-premises application, you will be categorizing on-premises applications into *workloads*. The important takeaway from this explanation is that the term *workload* is used broadly to encompass many different development, test, build, and administration artifacts. When you encounter this term, the best way to understand what it means is to understand the context in which it is being used.