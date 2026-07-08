---
title: Design a Ransomware-Resilient Backup Architecture by Using Azure Backup
description: Design ransomware-resilient backup architectures by using immutable vaults, multiple-subscription isolation, dual-region copies, and recovery testing.
ms.topic: concept-article
ms.subservice: architecture-guide
ai-usage: ai-assisted
author: mfrankovic
ms.author: mfrankovic
ms.date: 07/07/2026
---

# Design a ransomware-resilient backup architecture by using Azure Backup

Ransomware attacks target both production and backup systems. For systems in your workload that are the source of truth for critical customer data, architects design protections so that recovery data:

- Can't be deleted or modified.

- Can be recovered independently of the production environment.

- Exists across multiple administrative and regional boundaries.

- Can be tested regularly.

Use this architecture to protect critical customer data with two independent, immutable backup copies:

- The primary copy in a backup subscription and region
- The secondary copy in a different subscription and region

## Architecture

:::image type="complex" border="false" source="../images/ransomware-resilient-backup-architecture.svg" alt-text="Diagram that shows a ransomware-resilient backup architecture with dual immutable vaults." lightbox="../images/ransomware-resilient-backup-architecture.svg":::
   The diagram shows a production subscription in Region A that contains customer workloads. An arrow labeled backup policy and incremental backups points from the SQL workload to Azure Backup. From Azure Backup, an arrow labeled primary backup copy points to the backup subscription A in Region A on the left. Another arrow labeled secondary copy backup (cross-region, isolated) points to the backup subscription B in Region B on the right. Each backup subscription contains a Recovery Services vault. Beneath both subscriptions is a section that reads immutable recovery points can't be deleted or modified. At the bottom of the diagram, a security approval boundary section contains the Resource Guard/MUA component and text that reads approval required for destructive backup operations.
:::image-end:::

## Data flow

The following data flow corresponds to the previous diagram.

### Backup

The backup flow creates frequent, isolated, and tamper-resistant recovery points that remain available even if a ransomware attack compromises the production subscription or administrative identity. Each step reduces the cyberattacker's ability to delete, alter, or remove usable recovery data.

1. **Generate backup data.** The protected workload produces backup data according to its criticality tier and the capabilities of the Azure Backup-protected service. For example, Azure virtual machines (VMs) can use frequent snapshot-based backups that create multiple recovery points per day, while SQL Server and SAP HANA workloads can combine database backups with transaction log backups to support recovery to a specific point in time. Business-critical workloads can use less frequent schedules with longer backup intervals. Set the backup schedule based on the required recovery point objective (RPO), rather than only retention or compliance requirements.

1. **Write recovery points into Azure Backup vaults.** Azure Backup writes recovery points into a primary Backup vault or Recovery Services vault in the production recovery region. To create two independent backup copies, configure a second backup workflow that targets a vault in another region because vaults only protect resources in their region. The secondary copy provides a recovery path if the primary vault, production subscription, or regional control plane is unavailable or considered untrusted after the cyberattack.

1. **Store recovery points immutably.** Configure the vault so that recovery points can't be deleted, modified, or shortened before their retention period ends. For production-critical systems, lock immutability after policy validation so that privileged admins can't turn it off during a cyberattack. Enable soft delete, multi-user authorization (MUA), Azure role-based access control (Azure RBAC) separation, and diagnostic logging to add further protection around destructive backup operations.

1. **Isolate backup administration.** Separate backup administration from day-to-day production administration. The isolated backup subscription should use separate privileged groups, Privileged Identity Management (PIM), conditional access, and break-glass accounts. Production operators shouldn't have broad contributor or owner permissions over immutable backup vaults. This separation limits the scope of impact if cyberattackers compromise production identities.

1. **Enforce retention policy.** Azure Backup automatically enforces retention policies. Include both short-term operational retention and longer immutable retention for ransomware rollback. A common baseline is 7 to 35 days of short-term recovery points, with at least 14 to 30 days of immutable retention for critical workloads, plus monthly or yearly retention where regulatory requirements apply. Retention should be long enough to recover from cyberattacks discovered days or weeks after initial compromise. These ranges are examples. Actual retention should align with business risk tolerance and compliance needs.

1. **Monitor and verify backup health.** Monitor backup jobs, policy changes, vault access, failed backup attempts, and delete operations centrally. Route alerts outside the compromised production scope where possible. Run restore drills from both the primary and secondary vaults on a defined schedule. Backup success alone doesn't prove that the organization can meet its ransomware recovery time objective (RTO).

### Recovery

The recovery process minimizes the risk of reintroducing compromised data into the production environment. Each step includes verification gates that the operations team must complete before they proceed to the next stage.

1. **Select a recovery point.** The backup operator reviews the available recovery points across both the primary and secondary immutable vaults and selects the most recent point created before the suspected compromise. Because recovery points are immutable, operators can trust that the selected point reflects the original state of the workload and isn't tampered with by an attacker who gained administrative access. When the primary vault becomes unavailable or compromised, the operator falls back to the secondary copy in the isolated subscription and alternate region.

1. **Restore into a clean environment.** The selected recovery point is restored in a newly provisioned clean environment that's network-isolated from the compromised production estate. This isolation prevents any surviving malware, compromised credentials, or attacker-controlled systems from interacting with the restored workload during recovery. Deploy the clean environment by using infrastructure as code (IaC) templates so that it's reproducible and free of configuration drift.

1. **Validate data and application.** Before the workload is considered for production use, application owners, data owners, and security teams validate the restored environment. Functional testing, integrity checks, and security investigations confirm that the selected recovery point predates the attack and that the restored workload behaves as expected. If validation fails, repeat the process by using an earlier recovery point.

1. **Promote the validated workload to the recovery production environment.** After validation succeeds, promote the restored workload out of the clean environment or redeploy it into a dedicated recovery production environment. Re-establish required network connectivity, identity integrations, and platform services under controlled conditions. This recovery environment becomes the new production candidate while the compromised environment remains in quarantine for investigation.

1. **Redirect production workload.** After the recovery production environment is operational and approved for service, redirect traffic by using mechanisms such as Domain Name System (DNS) updates, Azure Traffic Manager, Azure Front Door, or Azure Application Gateway configuration changes. Enhanced monitoring should remain in place during and after cutover to detect signs of reinfection or residual compromise.

   The clean environment isn't intended to become production directly. Its purpose is to verify that backups are trustworthy and free of compromise before establishing a replacement production environment.

### Alternative: In-place restore

An in-place restore overwrites a protected workload in its existing environment with a recovery point. This approach is faster because it avoids new infrastructure provisioning and network endpoint reconfiguration. In a ransomware context, it poses a much higher risk and should only be used when the incident response team has strong confidence that the environment is free of attacker presence. The following points summarize the main benefits and risks of choosing an in‑place restore:

- **Faster recovery** because no new infrastructure needs deployment, and existing network paths and identities continue to function across the workload.

- **Higher risk of reinfection** because any malware, persistence mechanisms, or compromised credentials that remain in the environment can reintroduce compromise to the restored workload.

- **Use only when the environment is verified clean**, typically for non-ransomware scenarios such as accidental deletion, configuration errors, or failed deployments where the underlying infrastructure is known to be trustworthy.

For ransomware events, prefer the clean environment approach unless a thorough forensic sweep confirms that the production estate is uncompromised.

## Components

This section describes the core components of the backup architecture, including the protected workload, Azure Backup services, security controls such as Resource Guard, immutable Recovery Services vaults, and the use of dedicated backup subscriptions to strengthen resilience against ransomware and administrative compromise.

### Workload data

In this architecture, the business-critical data that requires protection exists on a VM, file share, database that runs in a VM, or another [supported data source](/azure/backup/backup-support-matrix).

This tier is typically the highest-value target in a ransomware attack because it stores transactional, application, or business data on which the organization depends. Frequent, immutable backups of this data help the organization recover to a known good state without payment of a ransom or acceptance of prolonged downtime.

### Azure Backup

[Azure Backup](/azure/backup/backup-overview) is the managed backup as a service (BaaS) offering that orchestrates much of the data protection lifecycle, including scheduling, snapshot creation, transfer to vault storage, retention enforcement, and restore operations.

It provides workload-aware backup for supported data sources. You must configure it to respect your application consistency requirements, such as application-consistent snapshots for VMs or transactional systems.

#### Resource Guard (MUA)

[Resource Guard](/azure/backup/multi-user-authorization-concept) adds an extra defense layer against malicious or accidental destructive actions on backup data. It implements MUA for critical operations, such as disabling soft delete, reducing retention, or removing immutability. Before those operations can take effect, a security principal that has permissions on the Resource Guard must approve them. The core requirement is that a different user owns the Resource Guard and that the vault admin has no permissions on it, which enforces separation of duties. For stronger isolation, place the Resource Guard in a separate subscription or, ideally, a separate Microsoft Entra tenant from the vaults. This separation ensures that even if an attacker compromises the backup operator's credentials, they can't unilaterally weaken the vault's protection posture.

### Recovery Services vaults

[Recovery Services vaults](/azure/backup/backup-azure-recovery-services-vault-overview) are the storage and management entities that hold recovery points and the policies that govern them. In this architecture, two vaults deploy in separate subscriptions and regions to provide geographic and administrative isolation. When you [enable and lock immutability](/azure/backup/backup-azure-immutable-vault-concept) on a vault, the protection becomes irreversible during the retention period:

- You can't delete recovery points before their scheduled expiration, even as a vault owner.

- You can only extend retention periods, never shorten them.

- Backup data is protected from destructive actions taken by compromised admin accounts, malicious insiders, or automation that an attacker hijacks.

Locking immutability is a one-way operation, so apply it only after validating the retention policy against business and compliance requirements.

### Backup subscriptions

Dedicated backup subscriptions provide a strong administrative and security boundary between the production environment and the backup data that protects it. Place each Recovery Services vault in its own subscription, separate from the workload subscription and from each other, so a compromise of production identities, role assignments, or policies doesn't automatically grant access to the backup copies.

This separation supports the principle of least privilege (PoLP). Backup operators receive permissions only in the backup subscriptions, while workload owners retain control of production without the ability to delete or alter backup data.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability ensures that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

In a ransomware scenario, reliability extends beyond traditional availability concerns. The backup system itself must remain trustworthy and recoverable even when the production environment is compromised. The following design choices contribute to that resilience:

- **Two independent backup copies:** Maintaining a primary and secondary copy across separate subscriptions removes single points of failure (SPoF). If one vault, subscription, or set of credentials is compromised, the other remains intact and recoverable.

- **Cross-region protection:** Storing the secondary copy in a different Azure region provides an independent recovery path if the primary region experiences a large-scale outage or becomes unavailable. Ransomware attacks aren't typically region-specific, but immutable backups combined with regional separation improve overall resilience because they address both cyber-recovery and regional-failure scenarios.

- **Immutable data ensures recoverability:** Locked recovery points help preserve clean restore options that support RTO and RPO during a ransomware event.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

Ransomware operators frequently target backup infrastructure first to eliminate recovery options before they attack production systems. The following controls protect the backup estate against both external attackers and insider threats:

- **Backup data is protected from deletion.** Soft delete and immutability prevent attackers or compromised admins from purging recovery points within the retention window. These protections preserve the ability to recover even after credential theft.

- **Retention is enforced.** Locked retention policies prevent attackers from shortening the retention window to remove clean recovery points before they can be used.

- **Administrative actions require approval.** MUA through Resource Guard requires that a principal in a separate trust boundary approve destructive operations. This requirement enforces separation of duties and reduces the impact of a single compromised identity.

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

A backup architecture is only as effective as the procedures that surround it. Untested backups and undocumented recovery steps frequently lead to extended outages during real incidents. The following practices keep the recovery capability dependable over time:

- **Test restore procedures regularly.** Periodic restore drills validate that recovery points are usable, surface gaps in tooling or permissions, and give operators the practical experience that they need to perform under pressure.

- **Document and make recovery repeatable.** Clear runbooks, IaC templates for the clean recovery environment, and defined approval workflows ensure that recovery can be performed consistently regardless of which team members are available during an incident.

## Data residency

Storing backup copies across multiple regions strengthens ransomware resilience, but it also introduces data residency and sovereignty obligations that architects must address. Many industries and jurisdictions impose strict requirements on where customer or business data, including backups, can be stored, processed, or transferred. Before you finalize the secondary region, review the following considerations to ensure that the architecture meets both resilience goals and regulatory commitments:

- Backup data stays in the region of each vault.

- A secondary copy in another region creates geographic separation.

- Architects must validate regulatory requirements for both regions.

## Retention and storage optimization

Long retention windows and dual backup copies are essential for ransomware resilience, but they also increase storage consumption over time. Balance recovery objectives, retention requirements, and storage cost when you design backup architectures. The following guidance explains the primary drivers of Azure Backup storage consumption and describes design approaches that can help reduce long-term storage costs without compromising recovery objectives. Revisit these decisions periodically as workload size, change rates, and retention requirements evolve.

### Storage components

Before you estimate cost or capacity, identify which factors actually drive billed storage in Azure Backup across supported components. With this insight, you can build a defensible cost model and identify which parts of the workload contribute most to backup spend. Backup storage planning consists of two primary elements:

- **Protected instance sizing** depends on the current size of the protected workload, that is, the size of the actual used data at the source when protection is enabled. This size reflects the amount of data stored in the workload itself and determines the pricing tier for the protected instance. This component doesn't depend on retention, backup frequency, or how much backup data exists over time, and remains relatively stable unless the workload itself grows.

- **Backup storage growth** depends on the total volume of backup data retained across all recovery points. After the initial full backup or snapshot, subsequent backups are incremental where supported and capture only the data that changed. For workloads with frequent updates or high change rates, the amount of change between backups can be significant and result in continuous accumulation of backup data over time.

Storage consumption scales with the amount of backup data retained over time. For workloads with high churn or long retention requirements, backup storage can quickly exceed the size of the production workload itself. Plan capacity by using realistic change-rate measurements rather than the current workload size alone.

#### Archive tier reduces long-term storage growth

Azure Backup archive tier is a low-cost storage tier for Azure Backup recovery points that are retained in Backup vaults or Recovery Services vaults for long-term retention (LTR). It's designed for recovery points that are rarely accessed but must be preserved for compliance or ransomware protection. It's important to understand what the archive tier can hold:

- Archive supports only monthly and yearly LTR recovery points. It doesn't support daily and weekly points.

- A point becomes archivable only after it meets minimum age and remaining-retention thresholds. For example, Azure VMs require a recovery point age of at least three months in the standard tier with at least six months of retention remaining. SQL Server and SAP HANA support only full backups at least 45 days old.

As a result, the frequent recovery points used for short-window operational and ransomware rollback must stay on the standard tier. Only the long-term points of the secondary copy qualify as candidates for archive. Archive tier also isn't supported on vaults configured with zone-redundant storage (ZRS). Apply the following pattern for the LTR points of the secondary copy when retention exceeds three months and those points are unlikely to be accessed in normal operations:

- **Preserves ransomware protection** because immutability and retention locks continue to apply in the archive tier.

- **Reduces standard-tier storage growth**, which lowers monthly cost for long-retention scenarios.

- **Requires rehydration before restore**, which adds hours to the recovery time and should be factored into RTO commitments.

#### Separation of backup roles improves efficiency

When you assign a distinct role to each backup copy, you can tune storage tier, retention, and access patterns independently. Optimize the primary copy for quick operational recovery from common problems such as accidental deletion or data corruption. Optimize the secondary copy for cost-effective LTR and last-resort ransomware recovery. Because the archive tier holds only monthly and yearly LTR points, the secondary copy keeps its recent, frequent recovery points in the standard tier and moves only eligible LTR points to the archive tier. Use the following role assignment as a baseline.

| Backup copy | Purpose | Storage tier |
| --- | --- | --- |
| Primary | Fast operational recovery | Standard |
| Secondary | Ransomware protection and retention | Standard for recent points; Archive for monthly and yearly long-term points (immutable) |

When you implement this separation, configure the primary vault with shorter retention (for example, 30 to 90 days) on standard storage and the secondary vault with full regulatory retention (for example, one year or longer). Tier eligible monthly and yearly long-term points to archive storage while you keep recent points on standard. This split keeps the hot, frequently accessed dataset small and also meets compliance obligations economically in your protected workload.

#### Trade-off: Storage efficiency versus recovery time

Choosing a storage tier is a trade-off between ongoing cost and how quickly you can recover. Use the following table to map each tier to the recovery scenarios it best supports, and align the choice with the RTO commitments documented in your service-level objectives (SLOs). If your workload has strict RTO requirements measured in minutes, keep at least one copy on the standard tier even if it increases cost.

| Tier | Storage impact | Recovery time | Usage |
| --- | --- | --- | --- |
| Standard | Higher storage consumption | Minutes to hours | Operational restore |
| Archive | Lower standard-tier storage consumption | Hours to days (rehydration required) | Ransomware and compliance |

### Storage optimization practices

Backup storage costs continuously grow as you add new recovery points and lengthen retention windows. Regularly review the design to keep protection effective without overspending.

Use these practices during backup governance to control storage growth while preserving the recovery guarantees that the dual-vault, dual-tier model provides. Validate each change against your documented RPO, RTO, and compliance requirements before you roll it out broadly.

- **Move older recovery points to the archive tier.** After the operational recovery window (typically 30 to 90 days), archive older recovery points to reduce costs when the added rehydration time remains acceptable for the workload's RTO.

- **Adjust retention based on workload criticality.** Mission-critical workloads typically require longer retention periods and more recovery points than business-critical or noncritical workloads. Align retention policies with business requirements, recovery objectives, and compliance obligations to avoid unnecessary storage costs.

- **Monitor and reduce data churn where possible.** High change rates increase incremental backup size and storage consumption. Identify workloads that generate large volumes of transient or temporary data, and exclude nonessential paths (such as caches, logs, and scratch directories) from backup scope where applicable.

- **Scope immutable protection to critical datasets only.** Apply immutability to datasets that are essential for ransomware recovery and regulatory compliance, rather than enabling it indiscriminately across all backup data.

- **Review and rightsize backup frequency.** Align backup frequency with the workload's actual RPO to prevent unnecessary recovery points from accumulating. For workloads that tolerate longer RPOs, reducing frequency directly lowers storage growth.

## Testing and validation

A backup architecture that you don't exercise provides only theoretical protection. Restore procedures, tooling, permissions, and runbooks all degrade over time as the environment evolves. The middle of a ransomware incident is the worst possible moment to discover those gaps.

Regular testing builds operator confidence, validates that recovery points are usable, and produces measured RTO and RPO values that the business can rely on when it sets SLOs.

- **Perform periodic restore tests** on a defined schedule (for example, quarterly) to ensure that recovery procedures stay aligned with the current state of the workload and operators remain practiced.

- **Validate both backup copies independently** to confirm that the secondary copy is genuinely usable as a last-resort recovery source, rather than assuming that a successful primary restore implies the secondary is healthy.

- **Measure recovery metrics** during each test and compare them against business commitments:

  - **Recovery time (RTO)**, including any rehydration time required for archive-tier recovery points

  - **Data loss (RPO)**, based on the age of the most recent usable recovery point that predates the simulated compromise

## Trade-offs

Designing a ransomware-resilient backup architecture requires balancing recovery assurance against cost, operational complexity, and flexibility. Use these key decisions and trade-offs to tune the design to match your workload's risk profile and business requirements.

| Decision | Benefit | Trade-off |
| --- | --- | --- |
| Dual backup copies | Maximum resilience | Increased storage consumption |
| Long retention | Strong recovery guarantees | Storage growth |
| Cross-region design | Regional protection | Compliance complexity |
| Immutable storage | Prevents deletion | Limits flexibility |

## When to use this architecture

Use this architecture when data loss or extended downtime costs more than maintaining dual, immutable, cross-region backup copies. It's especially well suited to environments that face regulatory scrutiny, that underpin revenue-generating services, or that store data that can't be reconstructed from other sources. If your workload is noncritical, has a high tolerance for data loss, or is already protected by an equivalent platform-managed recovery capability, a lighter-weight backup design might be more appropriate.

Consider this architecture when one or more of the following conditions apply:

- **The workload spans or depends on a single Azure region.** Regional loss, whether from a large-scale outage, a destructive attack, or a compliance-driven isolation event, leaves no viable recovery path.

- **Insider threat or credential compromise is part of the threat model.** This threat model requires controls such as MUA, immutable vaults, and separation of duties between backup operators and workload admins.

- **Ransomware resilience is an explicit business requirement.** The organization must be able to recover workloads to a known good state without ransom payment, even if an attacker with elevated privileges compromises production identities, management planes, or primary backup copies.

- **Recovery must be guaranteed and testable.** Documented and regularly exercised procedures produce measurable RTO and RPO values the business can commit to in service-level agreements (SLAs), audit responses, or board-level risk reporting.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Marin Frankovic](https://www.linkedin.com/in/marin-frankovic/) | Senior Solutions Engineer

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Choose the right Azure storage option](../../guide/technology-choices/storage-options.md)
- [Plan disaster recovery (DR) for Azure data platforms](../../data-guide/disaster-recovery/dr-for-azure-data-platform-recommendations.md)

## Related resources

- [Azure Backup immutable vault concepts](/azure/backup/backup-azure-immutable-vault-concept)
- [MUA by using Resource Guard](/azure/backup/multi-user-authorization-concept)
- [Ransomware protection in Azure](/azure/backup/protect-backups-from-ransomware-faq)