---
title: Identity considerations
description: TODO
author: johndowns
ms.date: 06/01/2022
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: best-practice
categories:
  - identity
products:
  - azure-active-directory
  - azure-active-directory-b2c
ms.custom:
  - guide
---

# Identity considerations

TODO

- The best option is to use a managed IdP (Azure AD, AAD B2C, or another system like it) because it takes care of all of these concerns.
- You might also consider using a framework or off-the-shelf system that you run yourself. This avoids the implementation of protocols, but you still have the problem of keeping it secured, maintained, backed up, highly available, security reviewed/pen tested, so this isn't an ideal option either.

## Implement identity and federation protocols

IdPs require implementing complex protocols like OIDC and OAuth 2, and just as importantly, keeping up to date with protocol changes and evolution. This is a deep area that requires expertise.

Increasingly often, we need to [federate IdPs together](../patterns/federated-identity.yml). Federation protocols are complex to establish, manage, and maintain, and again requires specialist knowledge and experience.

## Adopt modern identity features

To run a modern identity platform you need to allow for MFA, conditional access, auditing, JIT access control, etc. If identity isn't your core business, you won't be motivated to add these important security features, and your system's security will suffer as a result.

## Gain insights from identity signals

The signals and intelligence that come from running a massive multi-tenanted system (such as detection of unlikely travel, botnets, common credentials, monitoring of leaked creds on the dark web, ...) which are practically impossible to achieve on your own self-hosted solution.

## Avoid storing credentials

When you run your own IdP, you end up with a database of credentials (usually hashed and salted, but still, credentials). This makes you an ideal target for attack - just look at the news. Holding credentials is a liability, not an asset. And just because you've hashed and salted credentials doesn't mean you're safe - it's not that hard for these protections to be circumvented with modern hardware and techniques.

## Focus on your core value

Building an IdP is almost certainly not what differentiates you from your competitors. Focus on building the components that actually add business value, and leave complex and fraught areas like identity to experts.

## Build a reliable and performant identity system

Your identity system must be reliable. If your identity system goes down, your solution probably can't function. So it's important to use a service that has a high SLA and reliability.

Your identity system must be performant. Depending on your application architecture, every session or every request is likely to flow through the IdP. Ensure you use a service that can scale to support load and your growth.

## Next steps

- TODO
