---
title: identity
description: Describes how to manage identities in your workload.
author: david-stanford
ms.date: 10/16/2019
ms.topic: article
ms.service: architecture-center
ms.subservice: cloud-design-principles
ms.custom: How are you managing identity for this workload? 
---

# identity

In cloud-focused architecture, identity provides the basis of a large percentage
of security assurances. While legacy IT infrastructure often heavily relied on
firewalls and network security solutions at the internet egress points for
protection against outside threats, these controls are less effective in cloud
architectures with shared services being accessed across cloud provider networks
or the internet.

It is challenging or impossible to write concise firewall rules when you don’t
control the networks where these services are hosted, different cloud resources
spin up and down dynamically, cloud customers may share common infrastructure,
and employees and users expect to be able to access data and services from
anywhere. To enable all these capabilities, you must manage access based on
identity authentication and authorization controls in the cloud services to
protect data and resources and to decide which requests should be permitted.

Additionally, using a cloud-based identity solution like Azure AD offers
additional security features that legacy identity services cannot because they
can apply threat intelligence from their visibility into a large volume of
access requests and threats across many customers.<!-- Secrets -->
[!include[79de83f8-b5cd-4dd1-b39c-4b60fb26f23e](../../../includes/aar_guidance/79de83f8-b5cd-4dd1-b39c-4b60fb26f23e.md)]

<!-- Isolation -->
[!include[de1c1879-8308-484a-aa73-6743b26bce09](../../../includes/aar_guidance/de1c1879-8308-484a-aa73-6743b26bce09.md)]

<!-- Identity strategy -->
[!include[cd05c86a-d4a1-41b9-a146-b555a82d7661](../../../includes/aar_guidance/cd05c86a-d4a1-41b9-a146-b555a82d7661.md)]

<!-- System to manage identity -->
[!include[699e0bec-18d8-4f21-ab2a-fd1871148244](../../../includes/aar_guidance/699e0bec-18d8-4f21-ab2a-fd1871148244.md)]

<!-- Credential policies in place -->
[!include[a982ae49-0817-4115-b0db-800cd00e12b7](../../../includes/aar_guidance/a982ae49-0817-4115-b0db-800cd00e12b7.md)]

<!-- Enabled Single Sign-on (SSO) -->
[!include[d3d7496f-438b-4cd8-9673-623271f49f08](../../../includes/aar_guidance/d3d7496f-438b-4cd8-9673-623271f49f08.md)]

<!-- Self-service password reset & password management -->
[!include[95b6e2ca-d1e3-4f6d-aef0-75721f239743](../../../includes/aar_guidance/95b6e2ca-d1e3-4f6d-aef0-75721f239743.md)]

<!-- Multi-factor authentication (MFA) -->
[!include[8b457523-89e1-4b27-93ae-2c438b96f358](../../../includes/aar_guidance/8b457523-89e1-4b27-93ae-2c438b96f358.md)]

<!-- enforce identity for SaaS apps, integrating with custom apps -->
[!include[60b6b658-3a88-4370-8796-b005e80c07c9](../../../includes/aar_guidance/60b6b658-3a88-4370-8796-b005e80c07c9.md)]

