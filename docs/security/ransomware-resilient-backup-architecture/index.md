# Designing ransomware‑resilient backups in Azure using immutable vaults

Ransomware attacks increasingly target not only production workloads but also backup infrastructure. In cloud environments, attackers often combine credential compromise, privilege escalation, and destructive administrative actions to prevent recovery without paying ransom.

This article describes a reference architecture for designing ransomware‑resilient backups in Azure using Azure Backup immutable vaults, subscription isolation, and identity‑based controls. The guidance focuses on **design intent and responsibility boundaries**, helping organizations understand both what immutable backups protect by design and what must be addressed through governance and identity controls.

---

## Overview

Modern ransomware is commonly human‑operated. Attackers may gain administrative access, move laterally across subscriptions, and explicitly attempt to delete or invalidate backups before encrypting production data.

Azure Backup provides native capabilities—such as immutable vaults, soft delete, and multi‑user authorization—that help protect backup data from accidental or malicious deletion. However, these capabilities operate within defined scope boundaries. Effective ransomware resilience requires combining backup immutability with subscription isolation, identity governance, and operational practices.

This architecture is intended for cloud architects, security architects, and platform engineers who design or operate regulated or mission‑critical Azure environments.

---

## Design principles

The architecture is based on the following principles:

- **Defense in depth**  
  No single control is sufficient. Backup immutability must be combined with identity, governance, and monitoring controls.

- **Separation of failure domains**  
  Production, backup storage, and security approval paths are isolated to reduce blast radius.

- **Explicit trust boundaries**  
  Administrative privileges are assumed to be compromise‑prone and must not implicitly grant destructive backup access.

- **Assume credential compromise**  
  Designs must remain recoverable even if high‑privilege credentials are exposed.

---

## Threat model and attack vectors

The architecture considers the following threats:

- Compromise of privileged identities, including backup and subscription administrators
- Intentional deletion of backup data or reduction of retention settings
- Insider risk or credential reuse across subscriptions
- Subscription‑level destructive actions, such as cancellation or deletion
- Coordinated attacks that target backups before encrypting production workloads

Importantly, some of these actions occur **outside the scope of resource‑level protections** and must be mitigated through governance rather than technical backup controls alone.

---

## Azure Backup immutability: scope and boundaries

Azure Backup immutable vaults are designed to protect recovery points once they are created. When immutability is enabled and locked:

- Recovery points cannot be deleted before their retention period expires
- Retention periods cannot be reduced
- Destructive backup operations are blocked, even for privileged administrators

Immutable vaults intentionally operate **at the backup data level**. They do not govern subscription ownership, billing configuration, or tenant lifecycle operations. Actions such as subscription cancellation or tenant deletion are outside the enforcement scope of backup immutability and are managed by Azure’s broader subscription and identity control planes.

Understanding this boundary is critical for accurate threat modeling and customer expectations.

---

## Reference architecture

![The reference architecture uses layered isolation to protect backups even in high‑risk scenarios](images/Reference%20architecture.png)

### Key components

- **Production subscriptions**  
  Host business workloads such as virtual machines, databases, and platforms. Production administrators do not have destructive access to backup governance components.

- **Dedicated backup subscription**  
  Contains only Recovery Services vaults. No production workloads are deployed in this subscription.

- **Recovery Services Vault**  
  Configured with:
  - Immutable vault enabled and locked
  - Soft delete enabled
  - Geo‑redundant or zone‑redundant storage as required

- **Multi‑User Authorization (MUA)**  
  Implemented using Resource Guard to require separate approval for critical backup operations.

- **Security approval boundary**  
  Resource Guard is managed by a separate security owner and can optionally reside in a separate subscription or tenant for stronger isolation.

This separation ensures that compromise of production access does not directly enable backup destruction.

---

## Identity and governance considerations

Identity is a primary attack vector in ransomware‑driven incidents. The architecture incorporates the following controls:

- Privileged Identity Management (PIM) for time‑bound role activation
- Separation of roles between production administration, backup administration, and security approval
- Approval‑based workflows for high‑impact backup operations
- Monitoring and alerting on privilege elevation, vault configuration changes, and subscription‑level actions

These controls are essential complements to immutability and are not replaceable by immutable storage alone.

---

## Subscription and tenant lifecycle considerations

Azure Backup immutability is designed to protect recovery points and retention settings within the scope of a Recovery Services vault. When immutability is enabled and locked, backup data cannot be deleted or altered before the configured retention period expires, even by privileged administrators.

Subscription and tenant lifecycle operations are intentionally governed outside individual Azure resource providers. Actions such as subscription cancellation, subscription deletion, or tenant deletion are managed through Azure billing and identity control planes and are not enforced by backup immutability settings.

When a subscription is canceled, Azure follows a defined lifecycle to disable and eventually deprovision the subscription and its associated resources. Resource‑level protections, including immutable backup vaults, do not override this lifecycle. As a result, backup data retained within an immutable vault remains protected while the subscription exists, but is not intended to persist independently of the subscription boundary.

This separation ensures consistent governance across all Azure services and prevents individual resource configurations from superseding subscription ownership and billing controls.

### Risk mitigation strategies

Organizations should address subscription‑level risk through governance and operational controls rather than relying on backup immutability alone. Common mitigations include:

- Restricting who can cancel or delete subscriptions through role separation and least‑privilege access
- Separating billing administration from technical administration roles
- Monitoring and alerting on subscription state changes
- Maintaining documented break‑glass and recovery procedures, such as restoring from backups stored in a separate subscription

Designing ransomware‑resilient architectures requires treating subscription lifecycle management as a governance responsibility, while using immutable backups to protect data integrity within the subscription boundary.

---

## Operational considerations

To maintain effective recovery capability:

- Regularly validate restore procedures from immutable backups
- Test cross‑subscription restore scenarios
- Monitor backup health and backup success rates
- Periodically review administrative role assignments and approval workflows
- Document incident response procedures that include backup recovery paths

---

## Cost and compliance considerations

Immutable retention affects storage consumption and long‑term costs. Architects should balance regulatory requirements, recovery objectives, and cost management when defining retention periods and redundancy options.

Immutability can support regulatory and audit requirements by enforcing write‑once, read‑many behavior and reducing the risk of tampering.

---

## Summary

Azure Backup immutable vaults provide strong protection against backup deletion and retention tampering, even in the presence of compromised administrative credentials. However, they are not intended to govern subscription or tenant lifecycle actions.

A ransomware‑resilient backup architecture combines immutable backups with subscription isolation, identity governance, and operational discipline. Clearly understanding and designing for these boundaries enables organizations to recover with confidence even in high‑impact security incidents.

---

## Related resources

- Azure Backup immutable vault concepts  
- Multi‑user authorization using Resource Guard  
- Ransomware protection in Azure  
- Azure Well‑Architected Framework – Security
