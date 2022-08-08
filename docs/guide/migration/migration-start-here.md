---
title: Migration architecture design
description: Get an overview of Azure migration technologies, guidance offerings, solution ideas, and reference architectures.
author: EdPrice-MSFT
ms.author: architectures
ms.date: 08/10/2022
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
  - azure-migrate
  - azure-database-migration
  - azure-data-box-family
categories:
  - migration
---
# Migration architecture design

Azure provides resources for every stage of your cloud migration with tools and guidance to help you move and manage your workloads.

These are just some of the key migration services available on Azure:

- [Azure Migrate](https://azure.microsoft.com/services/azure-migrate). Simplify migration and modernization with a unified platform.
- [Azure Database Migration Service](https://azure.microsoft.com/services/database-migration). Accelerate your data migration to Azure.
- [Azure Data Box](https://azure.microsoft.com/services/databox). Easily move data to Azure when busy networks aren't an option.
- [Azure App Service migration tools](https://azure.microsoft.com/services/app-service/migration-tools). Quickly assess your web apps and migrate them to Azure with free, easy-to-use tools.

## Introduction to migration on Azure

If you're new to migration on Azure, the best way to learn more is with [Microsoft Learn](/learn/?WT.mc_id=learnaka), a free online training platform. Microsoft Learn provides interactive training for Microsoft products and more.

Here are some learning paths and modules to get you started:

- [Learning path: Best practices for Azure migration and modernization](/learn/paths/best-practices-azure-migration)
- [Learning path: Migrate virtual machines and apps using Azure Migrate](/learn/paths/m365-azure-migrate-virtual-machine)
- [Learning path: Migrate SQL workloads to Azure](/learn/paths/migrate-sql-workloads-azure)
- [Module: Design migrations](/learn/modules/design-migrations)
- [Module: Applications and infrastructure migration and modernization](/learn/modules/app-and-infra-migration-and-modernization)
- [Module: Migrate to Azure through repeatable processes and common tools](/learn/modules/cloud-adoption-framework-migrate)

## Path to production

For information about creating a migration plan, see [Build a migration plan with Azure Migrate](/azure/migrate/concepts-migration-planning?toc=https%3A%2F%2Fdocs.microsoft.com%2Fazure%2Farchitecture%2Ftoc.json&bc=https%3A%2F%2Fdocs.microsoft.com%2Fazure%2Farchitecture%2Fbread%2Ftoc.json).

## Best practices

The Cloud Adoption Framework for Azure provides proven guidance and best practices that can help you confidently adopt the cloud and achieve business outcomes. Here are some migration best practices to check out: 

- [Azure cloud migration best practices checklist](/azure/cloud-adoption-framework/migrate/azure-best-practices)
- [Multiple datacenters](/azure/cloud-adoption-framework/migrate/azure-best-practices/multiple-datacenters)
- [Azure regions decision guide](/azure/cloud-adoption-framework/migrate/azure-best-practices/multiple-regions)
- [Best practices when data requirements exceed network capacity during a migration effort](/azure/cloud-adoption-framework/migrate/azure-best-practices/network-capacity-exceeded)
- [Best practices to set up networking for workloads migrated to Azure](/azure/cloud-adoption-framework/migrate/azure-best-practices/migrate-best-practices-networking)
- [Deploy a migration infrastructure](/azure/cloud-adoption-framework/migrate/azure-best-practices/contoso-migration-infrastructure)
- [Best practices to cost and size workloads migrated to Azure](/azure/cloud-adoption-framework/migrate/azure-best-practices/migrate-best-practices-costs)
- [Scale a migration to Azure](/azure/cloud-adoption-framework/migrate/azure-best-practices/contoso-migration-scale)
- [Governance or compliance strategy](/azure/cloud-adoption-framework/migrate/azure-best-practices/governance-or-compliance)

For security best practices for Azure Migrate, see [Azure security baseline for Azure Migrate](/security/benchmark/azure/baselines/migrate-security-baseline?toc=https%3A%2F%2Fdocs.microsoft.com%2Fazure%2Farchitecture%2Ftoc.json&bc=https%3A%2F%2Fdocs.microsoft.com%2Fazure%2Farchitecture%2Fbread%2Ftoc.json).

## Migration architectures

The following sections provide links to reference architectures in a few high-level migration categories:

### Hyper-V migrations

- [Support matrix for Hyper-V migration](/azure/migrate/migrate-support-matrix-hyper-v-migration?toc=https%3A%2F%2Fdocs.microsoft.com%2Fazure%2Farchitecture%2Ftoc.json&bc=https%3A%2F%2Fdocs.microsoft.com%2Fazure%2Farchitecture%2Fbread%2Ftoc.json)
- [How does Hyper-V replication work?](/azure/migrate/hyper-v-migration-architecture?toc=https%3A%2F%2Fdocs.microsoft.com%2Fazure%2Farchitecture%2Ftoc.json&bc=https%3A%2F%2Fdocs.microsoft.com%2Fazure%2Farchitecture%2Fbread%2Ftoc.json)

### VMware migrations

- [Support matrix for VMware migration](/azure/migrate/migrate-support-matrix-vmware-migration?toc=https%3A%2F%2Fdocs.microsoft.com%2Fazure%2Farchitecture%2Ftoc.json&bc=https%3A%2F%2Fdocs.microsoft.com%2Fazure%2Farchitecture%2Fbread%2Ftoc.json)
- [Migrate workloads for Azure VMware Solution](/azure/cloud-adoption-framework/scenarios/azure-vmware/migrate?toc=https%3A%2F%2Fdocs.microsoft.com%2Fazure%2Farchitecture%2Ftoc.json&bc=https%3A%2F%2Fdocs.microsoft.com%2Fazure%2Farchitecture%2Fbread%2Ftoc.json)
- [Azure Migrate agentless migration of VMware virtual machines](/azure/migrate/concepts-vmware-agentless-migration?toc=https%3A%2F%2Fdocs.microsoft.com%2Fazure%2Farchitecture%2Ftoc.json&bc=https%3A%2F%2Fdocs.microsoft.com%2Fazure%2Farchitecture%2Fbread%2Ftoc.json)
- [Prepare for VMware agentless migration](/azure/migrate/prepare-for-agentless-migration?toc=https%3A%2F%2Fdocs.microsoft.com%2Fazure%2Farchitecture%2Ftoc.json&bc=https%3A%2F%2Fdocs.microsoft.com%2Fazure%2Farchitecture%2Fbread%2Ftoc.json)
- [VMware Agent-based migration architecture](/azure/migrate/agent-based-migration-architecture?toc=https%3A%2F%2Fdocs.microsoft.com%2Fazure%2Farchitecture%2Ftoc.json&bc=https%3A%2F%2Fdocs.microsoft.com%2Fazure%2Farchitecture%2Fbread%2Ftoc.json)

### Mainframe migrations

- [Modernize mainframe and midrange data](../../reference-architectures/migration/modernize-mainframe-data-to-azure.yml)
- [General mainframe refactor to Azure](../../example-scenario/mainframe/general-mainframe-refactor.yml)
- [Rehost a general mainframe on Azure](../../example-scenario/mainframe/mainframe-rehost-architecture-azure.yml)
- [Migrate IBM mainframe applications to Azure with TmaxSoft OpenFrame](../../solution-ideas/articles/migrate-mainframe-apps-with-tmaxsoft-openframe.yml)

### Oracle migrations

- [Oracle database migration to Azure](../../solution-ideas/articles/reference-architecture-for-oracle-database-migration-to-azure.yml)
- [Overview of Oracle database migration](../../example-scenario/oracle-migrate/oracle-migration-overview.yml)
- [Oracle database migration: Cross-cloud connectivity](../../example-scenario/oracle-migrate/oracle-migration-cross-cloud.yml)
- [Oracle database migration: Lift and shift](../../example-scenario/oracle-migrate/oracle-migration-lift-shift.yml)
- [Oracle database migration: Refactor](../../example-scenario/oracle-migrate/oracle-migration-refactor.yml)
- [Oracle database migration: Rearchitect](../../example-scenario/oracle-migrate/oracle-migration-rearchitect.yml)

### Migrations of banking systems

- [Banking system cloud transformation on Azure](../../example-scenario/banking/banking-system-cloud-transformation.yml)
- [Patterns and implementations for a banking cloud transformation](../../example-scenario/banking/patterns-and-implementations.yml)

## Stay current with migration on Azure

Get the latest updates on [Azure migration services and features](https://azure.microsoft.com/updates/?category=migration).

## Additional resources

### Example solutions

Following are some additional migration architectures to consider:

- [Modernize .NET applications](../../solution-ideas/articles/net-app-modernization.yml)
- [Migrate an e-commerce solution to Azure](../../industries/retail/migrate-ecommerce-solution.md)
- [Lift and shift to containers with AKS](../../solution-ideas/articles/migrate-existing-applications-with-aks.yml)
- [Migrate an Azure Cloud Services application to Azure Service Fabric](../../service-fabric/migrate-from-cloud-services.yml)
- [Migrate a monolith application to microservices using domain-driven design](../../microservices/migrate-monolith.yml)
- [Support matrix for migration of physical servers, AWS VMs, and GCP VMs](/azure/migrate/migrate-support-matrix-physical-migration?toc=https%3A%2F%2Fdocs.microsoft.com%2Fazure%2Farchitecture%2Ftoc.json&bc=https%3A%2F%2Fdocs.microsoft.com%2Fazure%2Farchitecture%2Fbread%2Ftoc.json)
- [Migrate a web app using Azure API Management](../../example-scenario/apps/apim-api-scenario.yml)
- [JMeter implementation for a load testing pipeline](../../example-scenario/banking/jmeter-load-testing-pipeline-implementation-reference.yml)

### AWS or Google Cloud professionals

#### AWS

- [Azure Migrate](/azure/migrate/migrate-services-overview) is comparable to [AWS Application Discovery Service](https://aws.amazon.com/application-discovery). Azure Migrate assesses on-premises workloads for migration to Azure, performs performance-based sizing, and provides cost estimations.
- [Azure Database Migration Service](/azure/dms/dms-overview) is comparable to [AWS Database Migration Service](https://aws.amazon.com/dms). Azure Database Migration Service enables seamless migrations from multiple database sources to Azure Data platforms with minimal downtime.

#### Google Cloud
- [Google Cloud to Azure services comparison - Migration tools](../../gcp-professional/services.md#migration-tools)