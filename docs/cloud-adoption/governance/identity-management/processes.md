---
title: "Fusion: Policy adherence processes for identity management"
description: Explanation of the concept identity management in relation to cloud governance processes
author: BrianBlanchard
ms.date: 1/4/2019
---

# Fusion: Identity management policy compliance processes

This article discusses an approach to policy adherence processes that govern [identity management](./overview.md). Effective governance of identity starts with recurring manual processes that guide identity policy adoption and revisions. However, you can automate these processes and supplement with tooling to reduce the overhead of governance and allow for faster response to deviation.

## Planning, review, and reporting processes

Identity management tools offer capabilities and features that greatly assist user management and access control within a cloud deployment. However, they also require well thought out processes and policies to support your organizations cloud goals. The following is a set of manual processes commonly used as part of an identity management discipline.

**Deployment planning**: Prior to any deployment, review the access needs for any workloads and develop an access control strategy that aligns with established corporate identity policy. Document any gaps between needs and current policy to determine if policy updates are required, and modify policy as needed.

**Quarterly planning**: On a quarterly basis perform a general review of identity and access control audit data, and meet with cloud adoption teams to identify any potential new risks or operational requirements that would require updates to identity policy or changes in access control strategy.

**Education and Training**: On a bi-monthly basis, offer training sessions to make sure IT staff and developers are up-to-date on the latest identity policy requirements. As part of this process review and update any documentation, guidance, or other training assets to ensure they are in sync with the latest corporate policy statements.

**Monthly audit and reporting reviews**: On a monthly basis, perform an audit on all cloud deployments to assure their continued alignment with identity policy. Use this review to check user access against business change to ensure users have correct access to cloud resources, and ensure access strategies such as RBAC are being followed consistently. Identify any privileged accounts and document their purpose. The result of this review process is a report for the Cloud Strategy Team and each Cloud Adoption Team to communicate overall adherence to policy. The report is also stored for auditing and legal purposes.

## Ongoing monitoring, violation triggers and enforcement actions

Violations of identity policy can result in unauthorized access to sensitive data and lead to serious disruption of mission critical application and services. It's important to be proactive in monitoring your identity management systems on an ongoing basis to ensure prompt detection and mitigation of potential problems.

When violations are detected, you should take actions to realign with policy as soon as possible. You can automate most violation triggers using the tools outlined in the [Azure-Specific Toolchain](toolchain.md).

The following are examples of identity related triggers and enforcement actions:

- Suspicious activity detected: Users logins detected from anonymous proxy IP addresses, unfamiliar locations, or successive logins from impossibly distant geographical locations may indicate a potential account breach or malicious access attempt. Login will be blocked until user identity can be verified and password reset.
- Leaked user credentials: Accounts that have their username and password detected on the public internet will bedisabled until user identity can be verified and password reset.
- Insufficient access controls detected: Any protected assets where access restrictions do not meet security requirements will have access blocked until the resource is brought into compliance.

## Next steps

Using the [Cloud Management template](./template.md), document the processes and triggers that align to the current cloud adoption plan.

For guidance on executing cloud management policies in alignment with adoption plans, see the article on [maturity alignment](maturity-adoption-alignment.md).

> [!div class="nextstepaction"]
> [Align Discipline Maturity with Cloud Adoption Phases](./maturity-adoption-alignment.md)
