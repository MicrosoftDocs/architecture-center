---
title: "Aligning responsibilities"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Provides an overview of aligning responsibilities across teams.
author: BrianBlanchard
ms.author: brblanch
ms.date: 07/04/2019
ms.topic: article
ms.service: architecture-center
ms.subservice: enterprise-cloud-adoption
ms.custom: organize
---

# Developing a cross-team RACI diagram

To track organization structure decisions over time, download and modify the [RACI spreadsheet template](https://archcenter.blob.core.windows.net/cdn/fusion/management/raci-template.xlsx). This article provides an example of a RACI matrix for each of the organizational structures described in the article on [maturing organizational structures](./organization-structures.md), which include the following example structures:

1. [Cloud Adoption Team Only](#cloud-adoption-team-only)
2. [**MVP Best Practice**](#best-practice-minimum-viable-product-mvp)
3. [Cloud Center of Excellence (CCoE)](#cloud-center-of-excellence-ccoe)
4. [Strategic Alignment](#strategic-alignment)
5. [Operational Alignment](#strategic-alignment)
6. [**Fully staffed Best Practice**](#best-practice-fully-staffed)

Each example, provides a table that outlines the following RACI constructs:

- The one team that is **accountable** for a function
- Any teams **responsible** for the outcomes
- Teams that should be **consulted** during planning
- Teams that should be **informed** when work is completed

The last row of each table contains a link to the most aligned cloud capability for additional information.

## Cloud adoption team only

|  |Solution delivery  |Business alignment  |Change management  |Solution operations  |Governance |Platform maturity  |Platform operations  |Platform automation  |
|---------|---------|---------|---------|---------|---------|---------|---------|---------|
|Cloud strategy team  |Accountable|Accountable|Accountable|Accountable|Accountable|Accountable|Accountable|Accountable|

## Best practice: minimum viable product (MVP)

|  |Solution delivery  |Business alignment  |Change management  |Solution operations  |Governance |Platform maturity  |Platform operations  |Platform automation  |
|---------|---------|---------|---------|---------|---------|---------|---------|---------|
|Cloud adoption team|Accountable|Accountable|Accountable|Accountable|Consulted|Consulted|Consulted|Informed|
|Cloud governance team|Consulted|Informed|Informed|Informed|Accountable|Accountable|Accountable|Accountable|
||||||||||
|Aligned cloud capability|[cloud adoption](./cloud-adoption.md)|[cloud strategy](./cloud-strategy.md)|[cloud strategy](./cloud-strategy.md)|[cloud operations](./cloud-operations.md)|[CCoE](./cloud-center-excellence.md)-[cloud governance](./cloud-governance.md)|[CCoE](./cloud-center-excellence.md)-[cloud platform](./cloud-platform.md)|[CCoE](./cloud-center-excellence.md)-[cloud platform](./cloud-platform.md)|[CCoE](./cloud-center-excellence.md)-[cloud automation](./cloud-automation.md)|

## Cloud Center of Excellence (CCoE)

|  |Solution delivery  |Business alignment  |Change management  |Solution operations  |Governance |Platform maturity  |Platform operations  |Platform automation  |
|---------|---------|---------|---------|---------|---------|---------|---------|---------|
|Cloud adoption team  |Accountable|Accountable|Accountable|Accountable|Informed   |Informed   |Informed   |Informed   |
|Cloud governance team|Consulted  |Informed   |Informed   |Informed   |Accountable|Consulted  |Responsible|Informed   |
|Cloud platform team  |Consulted  |Informed   |Informed   |Informed   |Consulted  |Accountable|Accountable|Responsible|
|Cloud automation team|Consulted  |Informed   |Informed   |Informed   |Consulted  |Responsible|Responsible|Accountable|
||||||||||
|Aligned cloud capability|[cloud adoption](./cloud-adoption.md)|[cloud strategy](./cloud-strategy.md)|[cloud strategy](./cloud-strategy.md)|[cloud operations](./cloud-operations.md)|[CCoE](./cloud-center-excellence.md)-[cloud governance](./cloud-governance.md)|[CCoE](./cloud-center-excellence.md)-[cloud platform](./cloud-platform.md)|[CCoE](./cloud-center-excellence.md)-[cloud platform](./cloud-platform.md)|[CCoE](./cloud-center-excellence.md)-[cloud automation](./cloud-automation.md)|

## Strategic Alignment

|  |Solution delivery  |Business alignment  |Change management  |Solution operations  |Governance |Platform maturity  |Platform operations  |Platform automation  |
|---------|---------|---------|---------|---------|---------|---------|---------|---------|
|Cloud strategy team  |Consulted  |Accountable|Accountable|Consulted  |Consulted  |Informed   |Informed   |Informed   |
|Cloud adoption team  |Accountable|Consulted  |Responsible|Accountable|Informed   |Informed   |Informed   |Informed   |
|CCoE Model RACI      |Consulted  |Informed   |Informed   |Informed   |Accountable|Accountable|Accountable|Accountable|
||||||||||
|Aligned cloud capability|[cloud adoption](./cloud-adoption.md)|[cloud strategy](./cloud-strategy.md)|[cloud strategy](./cloud-strategy.md)|[cloud operations](./cloud-operations.md)|[CCoE](./cloud-center-excellence.md)-[cloud governance](./cloud-governance.md)|[CCoE](./cloud-center-excellence.md)-[cloud platform](./cloud-platform.md)|[CCoE](./cloud-center-excellence.md)-[cloud platform](./cloud-platform.md)|[CCoE](./cloud-center-excellence.md)-[cloud automation](./cloud-automation.md)|

## Operational Alignment

|  |Solution delivery  |Business alignment  |Change management  |Solution operations  |Governance |Platform maturity  |Platform operations  |Platform automation  |
|---------|---------|---------|---------|---------|---------|---------|---------|---------|
|Cloud strategy team  |Consulted  |Accountable|Accountable|Consulted  |Consulted  |Informed   |Informed   |Informed   |
|Cloud adoption team  |Accountable|Consulted  |Responsible|Consulted  |Informed   |Informed   |Informed   |Informed   |
|Cloud operations team|Consulted  |Consulted  |Responsible|Accountable|Consulted  |Informed   |Accountable|Consulted  |
|CCoE Model RACI      |Consulted  |Informed   |Informed   |Informed   |Accountable|Accountable|Responsible|Accountable|
||||||||||
|Aligned cloud capability|[cloud adoption](./cloud-adoption.md)|[cloud strategy](./cloud-strategy.md)|[cloud strategy](./cloud-strategy.md)|[cloud operations](./cloud-operations.md)|[CCoE](./cloud-center-excellence.md)-[cloud governance](./cloud-governance.md)|[CCoE](./cloud-center-excellence.md)-[cloud platform](./cloud-platform.md)|[CCoE](./cloud-center-excellence.md)-[cloud platform](./cloud-platform.md)|[CCoE](./cloud-center-excellence.md)-[cloud automation](./cloud-automation.md)|

## Best practice: Fully staffed

|  |Solution delivery  |Business alignment  |Change management  |Solution operations  |Governance |Platform maturity  |Platform operations  |Platform automation  |
|---------|---------|---------|---------|---------|---------|---------|---------|---------|
|Cloud strategy team  |Consulted  |Accountable|Accountable|Consulted  |Consulted  |Informed   |Informed   |Informed   |
|Cloud adoption team  |Accountable|Consulted  |Responsible|Consulted  |Informed   |Informed   |Informed   |Informed   |
|Cloud operations team|Consulted  |Consulted  |Responsible|Accountable|Consulted  |Informed   |Accountable|Consulted  |
|Cloud governance team|Consulted  |Informed   |Informed   |Consulted  |Accountable|Consulted  |Responsible|Informed   |
|Cloud platform team  |Consulted  |Informed   |Informed   |Consulted  |Consulted  |Accountable|Responsible|Responsible|
|Cloud automation team|Consulted  |Informed   |Informed   |Informed   |Consulted  |Responsible|Responsible|Accountable|
||||||||||
|Aligned cloud capability|[cloud adoption](./cloud-adoption.md)|[cloud strategy](./cloud-strategy.md)|[cloud strategy](./cloud-strategy.md)|[cloud operations](./cloud-operations.md)|[CCoE](./cloud-center-excellence.md)-[cloud governance](./cloud-governance.md)|[CCoE](./cloud-center-excellence.md)-[cloud platform](./cloud-platform.md)|[CCoE](./cloud-center-excellence.md)-[cloud platform](./cloud-platform.md)|[CCoE](./cloud-center-excellence.md)-[cloud automation](./cloud-automation.md)|

## Next steps

To track organization structure decisions over time, download and modify the [RACI spreadsheet template](https://archcenter.blob.core.windows.net/cdn/fusion/management/raci-template.xlsx). Copy, paste, and modify the most closely aligned sample from the RACI matrices in this article.

> [!div class="nextstepaction"]
> [Download the RACI spreadsheet template](https://archcenter.blob.core.windows.net/cdn/fusion/management/raci-template.xlsx)
