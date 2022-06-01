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

- IdPs require implementing complex protocols like OIDC and OAuth 2, and just as importantly, keeping up to date with protocol changes and evolution. This is a deep area that requires expertise.
- When you run your own IdP, you end up with a database of credentials (usually hashed and salted, but still, credentials). This makes you an ideal target for attack - just look at the news. Holding credentials is a liability, not an asset. And just because you've hashed and salted credentials doesn't mean you're safe - it's not that hard for these protections to be circumvented with modern hardware and techniques.
- To run a modern identity platform you need to allow for MFA, conditional access, auditing, JIT access control, etc. If identity isn't your core business, you won't be motivated to add these important security features, and your system's security will suffer as a result.
- Increasingly often, we need to federate IdPs together. Federation protocols are complex to establish, manage, and maintain, and again requires specialist knowledge and experience.
- Building an IdP is almost certainly not what differentiates you from your competitors. Focus on building the components that actually add business value, and leave complex and fraught areas like identity to experts.
- Your identity system must be reliable. If your identity system goes down, your solution probably can't function. So it's important to use a service that has a high SLA and reliability.
- Your identity system must be performant. Depending on your application architecture, every session or every request is likely to flow through the IdP. Ensure you use a service that can scale to support load and your growth.
- The best option is to use a managed IdP (Azure AD, AAD B2C, or another system like it) because it takes care of all of these concerns. You might also consider using a framework or off-the-shelf system that you run yourself, but you still have the problem of keeping it secured, maintained, etc, so this isn't an ideal option either.

## Next steps

- TODO
