---
title: "Aligning responsibilities"
titleSuffix: Microsoft Cloud adoption Framework for Azure
description: Provides an overview of aligning responsibilities across teams.
author: BrianBlanchard
ms.author: brblanch
ms.date: 07/04/2019
ms.topic: article
ms.service: cloud-adoption-framework
ms.subservice: organize
ms.custom: organize
---

# Develop a cross-team RACI diagram

This article provides an example of a *responsible, accountable, consulted, and informed* (RACI) matrix for the organizational structures that are described at [Establish team structures](./organization-structures.md):

- [Cloud adoption team only](#cloud-adoption-team-only)
- [MVP best practice](#best-practice-minimum-viable-product-mvp)
- [Cloud center of excellence (CCoE)](#cloud-center-of-excellence-ccoe)
- [Strategic alignment](#strategic-alignment)
- [Operational alignment](#strategic-alignment)
- [Fully staffed best practice](#best-practice-fully-staffed)

To track organization structure decisions over time, download and modify the [RACI spreadsheet template](https://archcenter.blob.core.windows.net/cdn/fusion/management/raci-template.xlsx).

The examples in this article specify these RACI constructs:

- The one team that's *accountable* for a function
- The teams that are *responsible* for the outcomes
- The teams that should be *consulted* during planning
- The teams that should be *informed* when work is completed

The last row of each table except the first one contains a link to the most-aligned cloud capability for additional information.

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
|Aligned cloud capability|[Cloud adoption](./cloud-adoption.md)|[Cloud strategy](./cloud-strategy.md)|[Cloud strategy](./cloud-strategy.md)|[Cloud operations](./cloud-operations.md)|[CCoE](./cloud-center-excellence.md)-[Cloud governance](./cloud-governance.md)|[CCoE](./cloud-center-excellence.md)-[Cloud platform](./cloud-platform.md)|[CCoE](./cloud-center-excellence.md)-[Cloud platform](./cloud-platform.md)|[CCoE](./cloud-center-excellence.md)-[Cloud automation](./cloud-automation.md)|

## Cloud center of excellence (CCoE)

|  |Solution delivery  |Business alignment  |Change management  |Solution operations  |Governance |Platform maturity  |Platform operations  |Platform automation  |
|---------|---------|---------|---------|---------|---------|---------|---------|---------|
|Cloud adoption team  |Accountable|Accountable|Accountable|Accountable|Informed   |Informed   |Informed   |Informed   |
|Cloud governance team|Consulted  |Informed   |Informed   |Informed   |Accountable|Consulted  |Responsible|Informed   |
|Cloud platform team  |Consulted  |Informed   |Informed   |Informed   |Consulted  |Accountable|Accountable|Responsible|
|Cloud automation team|Consulted  |Informed   |Informed   |Informed   |Consulted  |Responsible|Responsible|Accountable|
||||||||||
|Aligned cloud capability|[Cloud adoption](./cloud-adoption.md)|[Cloud strategy](./cloud-strategy.md)|[Cloud strategy](./cloud-strategy.md)|[Cloud operations](./cloud-operations.md)|[CCoE](./cloud-center-excellence.md)-[Cloud governance](./cloud-governance.md)|[CCoE](./cloud-center-excellence.md)-[Cloud platform](./cloud-platform.md)|[CCoE](./cloud-center-excellence.md)-[Cloud platform](./cloud-platform.md)|[CCoE](./cloud-center-excellence.md)-[Cloud automation](./cloud-automation.md)|

## Strategic alignment

|  |Solution delivery  |Business alignment  |Change management  |Solution operations  |Governance |Platform maturity  |Platform operations  |Platform automation  |
|---------|---------|---------|---------|---------|---------|---------|---------|---------|
|Cloud strategy team  |Consulted  |Accountable|Accountable|Consulted  |Consulted  |Informed   |Informed   |Informed   |
|Cloud adoption team  |Accountable|Consulted  |Responsible|Accountable|Informed   |Informed   |Informed   |Informed   |
|CCoE Model RACI      |Consulted  |Informed   |Informed   |Informed   |Accountable|Accountable|Accountable|Accountable|
||||||||||
|Aligned cloud capability|[Cloud adoption](./cloud-adoption.md)|[Cloud strategy](./cloud-strategy.md)|[Cloud strategy](./cloud-strategy.md)|[Cloud operations](./cloud-operations.md)|[CCoE](./cloud-center-excellence.md)-[Cloud governance](./cloud-governance.md)|[CCoE](./cloud-center-excellence.md)-[Cloud platform](./cloud-platform.md)|[CCoE](./cloud-center-excellence.md)-[Cloud platform](./cloud-platform.md)|[CCoE](./cloud-center-excellence.md)-[Cloud automation](./cloud-automation.md)|

## Operational alignment

|  |Solution delivery  |Business alignment  |Change management  |Solution operations  |Governance |Platform maturity  |Platform operations  |Platform automation  |
|---------|---------|---------|---------|---------|---------|---------|---------|---------|
|Cloud strategy team  |Consulted  |Accountable|Accountable|Consulted  |Consulted  |Informed   |Informed   |Informed   |
|Cloud adoption team  |Accountable|Consulted  |Responsible|Consulted  |Informed   |Informed   |Informed   |Informed   |
|Cloud operations team|Consulted  |Consulted  |Responsible|Accountable|Consulted  |Informed   |Accountable|Consulted  |
|CCoE Model RACI      |Consulted  |Informed   |Informed   |Informed   |Accountable|Accountable|Responsible|Accountable|
||||||||||
|Aligned cloud capability|[Cloud adoption](./cloud-adoption.md)|[Cloud strategy](./cloud-strategy.md)|[Cloud strategy](./cloud-strategy.md)|[Cloud operations](./cloud-operations.md)|[CCoE](./cloud-center-excellence.md)-[Cloud governance](./cloud-governance.md)|[CCoE](./cloud-center-excellence.md)-[Cloud platform](./cloud-platform.md)|[CCoE](./cloud-center-excellence.md)-[Cloud platform](./cloud-platform.md)|[CCoE](./cloud-center-excellence.md)-[Cloud automation](./cloud-automation.md)|

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
|Aligned cloud capability|[Cloud adoption](./cloud-adoption.md)|[Cloud strategy](./cloud-strategy.md)|[Cloud strategy](./cloud-strategy.md)|[Cloud operations](./cloud-operations.md)|[CCoE](./cloud-center-excellence.md)-[Cloud governance](./cloud-governance.md)|[CCoE](./cloud-center-excellence.md)-[Cloud platform](./cloud-platform.md)|[CCoE](./cloud-center-excellence.md)-[Cloud platform](./cloud-platform.md)|[CCoE](./cloud-center-excellence.md)-[Cloud automation](./cloud-automation.md)|

## Next steps

To track organization-structure decisions over time, download and modify the [RACI spreadsheet template](https://archcenter.blob.core.windows.net/cdn/fusion/management/raci-template.xlsx). Copy and modify the most closely aligned sample from the RACI matrices in this article.

> [!div class="nextstepaction"]
> [Download the RACI spreadsheet template](https://archcenter.blob.core.windows.net/cdn/fusion/management/raci-template.xlsx)
