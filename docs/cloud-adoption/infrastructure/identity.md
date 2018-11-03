---
title: "Enterprise Cloud Adoption: Identity" 
description: Discussion of Identity as a core service in Azure migrations
author: rotycenh
ms.date: 10/29/2018
---

# Enterprise Cloud Adoption: Identity

As with on-premises environments, IT staff responsible for maintaining and
securing resources in cloud environments need to control which users and
groups have access to resources. Identity and access management (IAM) services
allow you to manage access control within your IT estate.

## Determine Identity Integration Requirements

\*Reviewers note: This table is a working list of questions to help readers pick
the right architecture for their migration. Eventually this is intended to be
more of a decision list diagram or something similar.\*

| Question                                                                      | Cloud Native | Federation | Directory Migration |
|-------------------------------------------------------------------------------|--------------|------------|---------------------|
| Do you currently lack an on-premises directory service?                       | Yes          | No         | No                  |
| Do your workloads need to authenticate against on-premises identity services? | No           | Yes        | No                  |
| Are your workload requirements incompatible with hybrid authentication?       | No           | No         | Yes                 |
| Is integration between cloud and on-premises identity services impossible     | No           | No         | Yes                 |

As part of planning migration to Azure, you will need to determine how best to
integrate your existing identity management and cloud identity services. The
following are common integration scenarios:

### Cloud native

Public cloud platforms provide a native IAM system capable of granting users and groups access to management features.
If your organization currently lacks a significant on-premises identity
solution, and where migrating workloads will be compatible with cloud-based
authentication mechanisms, it makes sense to simply build your identity
infrastructure using a cloud native identity service.

### Federation

For organizations with an existing Identity infrastructure, federation is often
the best solution for preserving existing user and access management while
providing the required IAM capabilities for managing cloud resources. Federation
syncs directory information between the cloud and on-premises environments,
allowing single sign-in for users and a consistent role and permission system
across your entire organization.

### Directory Migration

In scenarios where hybrid authentication methods are not possible, you may need
to consider migrating your current directories to a cloud identity provider.
This approach will ensure your identity and authentication services will work in
the cloud environment but could entail refactoring legacy workloads that do not
currently support cloud compatible authentication mechanisms.

## Evolving Identity Integration

Along with other aspects of the Enterprise Cloud Adoption model, integration can
be an iterative process. It may make sense starting off using a cloud native
solution with a small set of users and roles for an initial deployment. As your
migration matures you may want to move to federated model as the
migration process matures, or even perform a full directory migration of your on-premises identity services to the cloud. It's
important to revisit your identity strategy in every iteration of your migration
process.

## Azure Active Directory

Azure uses [Microsoft Azure Active
Directory](https://azure.microsoft.com/en-us/services/active-directory/?&OCID=AID719825_SEM_w1MNAVjn&lnkd=Google_Azure_Brand&gclid=EAIaIQobChMIgvD6itOi3gIVj8JkCh1AbQApEAAYASAAEgJ28PD_BwE)
(AD) by default for identity services. With Azure AD, you can manage access to
your Azure resources, controlling identity management, device registration, user
provisioning, application access control and data protection.

The [Azure AD
Connect](https://docs.microsoft.com/en-us/azure/active-directory/hybrid/whatis-hybrid-identity)
tool allows you to connect Azure AD instances with your existing identity
management solutions. Azure AD Federation supports integration with existing
on-premises deployments of Active Directory or other supported third-party
identity services.

![Azure AD Connect can be used to provide synchronized authentication between Azure AD and on-premises directory services](../_images/infra-identity-figure1.png)

*Figure 1. Azure AD Connect can be used to provide synchronized authentication
between Azure AD and on-premises directory services.*

## Identity and the Azure Management Plane

The Azure management plane includes Azure Resource Manager and the related
operations, monitoring, and management capabilities used by your IT staff to
deploy and configure resources and services in Azure. These features are
accessible through the Azure Portal, APIs, PowerShell, and CLI tools, which all
rely on Azure AD for identity and access management.

As with on-premises resources, you will need to organize staff into groups of
people to take on assorted responsibilities or roles, and provide these roles
with access to the required Azure resources. While Azure removes the need for
some traditional on-premises roles, such as facilities management and physical security,
many other responsibilities such as network security and operations
can work much like they do in a physical datacenter.

For efficiently and securely managing access to resources in the management plane,
Azure supports role-based access control (RBAC) through Azure AD. Using RBAC,
jobs and responsibilities are organized into Azure AD roles, to which users are
assigned.

By defining organizational roles during your migration, you can specify the
access rights for specific Azure resources and give subscription management
rights to users and groups assigned to a role. The scope of a role can encompass
an Azure subscription, resource group, or single resource. RBAC also supports
the inheritance of permissions, so a role assigned at a parent level also grants
access to any child resources.

Azure AD and RBAC gives you a way to assign different teams to various
management tasks within the Azure environment. For large deployments, this
distribution of access and permissions can be critical in giving your central IT
teams control over core access and security features, while safely delegating
significant control over workload resources to the development and operations
teams best suited to manage them.

## Identity and authentication for workloads

While Azure AD is the only supported IAM mechanism for the Azure management
plane and most Azure-hosted PaaS services, IaaS workloads are free to use
whatever identity solutions are supported by the OS and applications running on
the workload's VMs.

Azure AD offers a [variety of
mechanisms](https://docs.microsoft.com/en-us/azure/active-directory/develop/app-types)
for authentication, but it's possible technologies used by applications and
services you plan to migrate are not supported. For instance, you can't perform
Kerberos authentication against Azure AD. In scenarios like this you would need
provision a compatible authentication service either within your Azure
deployment or connect your Azure networks to on-premises environment where your
workloads could access existing authentication mechanisms such as an Active
Directory server.

Federation using the Azure AD Connect tool allows these more sophisticated
hybrid authentication mechanisms, letting workloads authenticate against an Azure
AD provider or on-premises hosted services, maximizing compatibility with existing 
workloads and processes. To choose the best Azure AD authentication mechanism for your
organization, see [choosing the right authentication method for your Azure
Active Directory hybrid identity
solution](https://docs.microsoft.com/en-us/azure/security/azure-ad-choose-authn).

## Next steps

Learn how [encryption](encryption.md) is used to secure data in cloud environments.

> [!div class="nextstepaction"]
> [Encryption](encryption.md)