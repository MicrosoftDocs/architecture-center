---
title: Get Started with Management and Governance Architecture Design
description: Get an overview of Azure management and governance technologies, guidance offerings, solution ideas, and reference architectures.
ms.author: pnp
author: anaharris-ms
ms.update-cycle: 1095-days
ms.topic: concept-article
ms.subservice: category-get-started
ms.date: 06/25/2026
ai-usage: ai-assisted
---

# Get started with management and governance architecture design

Management and governance includes critical tasks like monitoring, auditing, and reporting on security and business requirements. It also encompasses backup, disaster recovery (DR), and high availability (HA) strategies, compliance with internal requirements and external regulations, and sensitive data protection. A well-designed management and governance strategy helps you maintain control, reduce risk, and operate efficiently as your Azure environment grows.

## Azure services for management and governance

Azure provides a range of services for management and governance:

- [Azure Attestation](/azure/attestation/overview): Remotely verify the trustworthiness of a platform and the integrity of the binaries that run inside it.

- [Azure confidential ledger](/azure/confidential-ledger/overview): Store and process confidential data with confidence.

- [Microsoft Purview](/purview/purview): Govern, protect, and manage your data.

- [Azure Policy](/azure/governance/policy/overview): Achieve real-time cloud compliance at scale by using consistent resource governance.

- [Azure Stack Hub](/azure-stack/operator/azure-stack-overview): Place technologies and services in appropriate locations, based on your business requirements. Meet custom compliance, sovereignty, and data gravity requirements.

- [Azure Backup](/azure/backup/backup-overview): Define backup policies and provide protection for enterprise workloads.

- [Azure Site Recovery](/azure/site-recovery/site-recovery-overview): Keep your business running with built-in DR.

- [The archive access tier of Azure Blob Storage](/azure/storage/blobs/access-tiers-overview#archive-access-tier): Store infrequently accessed data.

- [Azure Monitor](/azure/azure-monitor/fundamentals/overview): Monitor your applications, infrastructure, and network from a single platform.

- [Azure Update Manager](/azure/update-manager/overview): Centrally manage updates and compliance at scale.

## Architecture

:::image type="complex" border="false" source="../media/images/management-governance-get-started-diagram.svg" alt-text="Diagram that shows the management and governance solution journey on Azure." lightbox="../media/images/management-governance-get-started-diagram.svg":::
   Diagram that shows the management and governance solution journey on Azure. Azure SRE Agent appears in the top left of the diagram. Four boxes are stacked under it, including the network layer, the compute layer, the data layer, and the landing zone layer. The network layer is associated with firewalls. The compute layer is associated with a virtual machine (VM) and contains Azure Site Recovery and Azure Backup. The data layer is associated with Azure SQL and contains Azure Site Recovery, Microsoft Purview, and Azure Backup. These layers are grouped and connect with an arrow to Azure Monitor, which connects with an arrow to Log Analytics workspaces. The landing zone layer contains Cost Management, management groups, and Azure Policy. A separate box is labeled recommendations and protection. It contains Azure Advisor and Microsoft Defender for Cloud.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/management-governance-get-started-diagram.vsdx) of this architecture.*

The previous diagram demonstrates a typical basic or baseline management and governance implementation. For real-world solutions that you can build in Azure, see [Management and governance architectures](#management-and-governance-architectures).

## Explore management and governance guides and architectures

The articles in this section include guides and fully developed architectures that you can deploy in Azure and expand to production-grade solutions. These articles can help you decide how to use management and governance technologies in Azure.


### Management and governance guides

The following articles help you evaluate and select the best management and governance technologies for your workload requirements:

- [Plan deployment for updating Windows VMs in Azure](../../example-scenario/wsus/index.yml): Provides guidance on how to use Windows Server Update Services in Azure to securely update virtual machines (VMs) in locked-down virtual networks.

- [Use Azure Governance Visualizer to optimize cloud governance](../../landing-zones/azure-governance-visualizer-accelerator.md): Describes how to deploy and automate Azure Governance Visualizer to capture management group hierarchy, policy information, and Azure role-based access control (Azure RBAC) insights across your Azure tenant.

### Management and governance architectures

The following production-ready architectures demonstrate end-to-end management and governance solutions that you can deploy and customize:

- [Azure Arc hybrid management and deployment for Kubernetes clusters](../../hybrid/arc-hybrid-kubernetes.yml): Describes how to use Azure Arc to manage and deploy Kubernetes clusters across on-premises, multicloud, and edge environments.

- [Hybrid availability and performance monitoring](../../hybrid/hybrid-perf-monitoring.yml): Demonstrates how to design a hybrid monitoring solution that provides visibility across on-premises and Azure resources.

## Organizational readiness

Organizations at the beginning of the cloud adoption process can use the [Cloud Adoption Framework for Azure](/azure/cloud-adoption-framework/) to access proven guidance that accelerates cloud adoption.

- [Design area: Management for Azure environments](/azure/cloud-adoption-framework/ready/landing-zone/design-area/management): Provides recommendations for landing zone management design decisions, including inventory and visibility, operational compliance, and protect and recover capabilities.

- [Design area: Azure governance](/azure/cloud-adoption-framework/ready/landing-zone/design-area/governance): Covers governance tooling for compliance auditing, automated guardrails, Azure Policy, and cost management.

To help ensure the quality of your management and governance solution on Azure, follow the guidance in the [Azure Well-Architected Framework](/azure/well-architected/). The Well-Architected Framework provides prescriptive guidance for organizations that seek architectural excellence and describes how to design, configure, and monitor cost-optimized Azure solutions. For management and governance-specific guidance, see the following Well-Architected Framework service guides:

- [Application Insights](/azure/well-architected/service-guides/application-insights): Covers application, infrastructure, and network observability.

- [Log Analytics](/azure/well-architected/service-guides/azure-log-analytics): Covers log collection and analysis workspace design and configuration.

- [Azure Traffic Manager](/azure/well-architected/service-guides/azure-traffic-manager): Covers incoming traffic routing for high performance and HA.

## Best practices

Follow these best practices to improve the security, reliability, performance, and operational quality of your management and governance workloads on Azure.

- [Establish a security baseline](/azure/well-architected/security/establish-baseline): Align your security baseline to compliance requirements, industry standards, and platform recommendations, including regulatory compliance controls.

- [Harden workload resources](/azure/well-architected/security/harden-resources): Reduce attack surface and tighten configurations for admin accounts and privileged access.

- [Landing zone governance](/azure/cloud-adoption-framework/ready/considerations/landing-zone-governance): Best practices for Azure landing zone governance, including policy, compliance, and cost management.

- [Automate operational tasks](/azure/well-architected/operational-excellence/enable-automation): Reduce errors and improve efficiency by using routine management and operational task automation.

- [Recommendations for designing a monitoring and alerting strategy](/azure/well-architected/operational-excellence/observability): Design effective monitoring and alerting to maintain visibility into management and governance workloads.

## Stay current with management and governance

Azure management and governance services evolve to address modern data challenges. Stay informed about the latest [updates and features](https://azure.microsoft.com/updates/).

To stay current with key management and governance services, see the following articles:

- [What's new in Azure Monitor](/azure/azure-monitor/fundamentals/whats-new): A summary of recent documentation changes and new features for Azure Monitor, including Application Insights, alerts, autoscale, and container monitoring.

- [What's new in Backup](/azure/backup/whats-new): Recent feature releases and improvements for Backup, including new workload support, security enhancements, and cross-region restore capabilities.

- [What's new in Site Recovery](/azure/site-recovery/site-recovery-whats-new): Updates to Site Recovery, including OS support, update rollups, and DR improvements.

- [What's new in Update Manager](/azure/update-manager/whats-new): New features and regional availability updates for Update Manager, including premaintenance and postmaintenance events and hotpatching support.

## Other resources

The following resources can help you discover more about management and governance.

- [Azure governance documentation](/azure/governance/): Provides a central hub for Azure Policy, Azure Blueprints, Azure Resource Graph, and Azure management groups.

- [Azure Monitor overview](/azure/azure-monitor/fundamentals/overview): Describes the full-stack monitoring platform for telemetry collection, analysis, and response across cloud and hybrid environments.

- [Microsoft Defender for Cloud documentation](/azure/defender-for-cloud/): Covers security posture management and workload protection, including regulatory compliance dashboards and recommendations.

- [Microsoft Cost Management documentation](/azure/cost-management-billing/costs/): Explains how to monitor, allocate, and optimize cloud spending with budgets, alerts, and cost analysis.

- [Management and monitoring for an Azure VMware Solution enterprise-scale scenario](/azure/cloud-adoption-framework/scenarios/azure-vmware/eslz-management-and-monitoring): Outlines recommendations for management and monitoring design in Azure VMware Solution environments. Covers Azure-native tooling and VMware-specific considerations for platform and guest workload monitoring.

- [Computer forensics chain of custody in Azure](../../example-scenario/forensics/index.yml): Describes an infrastructure and workflow process to help teams provide digital evidence that demonstrates a valid chain of custody by using Azure Automation, immutable blob storage, and Azure Key Vault.

## Amazon Web Services (AWS) or Google Cloud professionals

To help you get started quickly, the following articles compare Azure management and governance options to other cloud services and provide migration guidance:

### Service comparison

- [AWS to Azure services comparison - Management and governance](../../aws-professional/index.md#management-and-governance)
- [Google Cloud to Azure services comparison - Management](../../gcp-professional/services.md#management)

### Migration guidance

If you're migrating from another cloud platform, see the following articles:

- [Migrate a workload from AWS to Azure](/azure/migration/migrate-workload-from-aws-introduction): Covers workload migration from AWS to Azure, from plan development through post-migration evaluation and workload retirement.