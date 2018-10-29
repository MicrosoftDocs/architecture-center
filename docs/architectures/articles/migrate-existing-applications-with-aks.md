---
title: Lift and shift to containers with AKS | Microsoft
description: Lift and shift to containers with AKS
author: adamboeglin
ms.date: 10/29/2018
---
# Lift and shift to containers with AKS | Microsoft
Easily migrate existing application to container(s) and run within the Azure managed Kubernetes service (AKS).  Control access via integration with AzureActive Directory and access SLA-backed Azure Services such as Azure Databasefor MySQL using OSBA (Opensource Broker for Azure) for your data needs.

## Architecture
<img src="media/migrate-existing-applications-with-aks.svg" alt='architecture diagram' />

## Data Flow
1. User converts existing application to container(s) &amp; publishes container image(s)to the Azure Container Registry
1. Using Azure Portal or command line, user deploys containers to AKS cluster
1. Azure Active Directory is used to control access to AKS resources
1. Easily access SLA-backed Azure Services such as Azure Database for MySQL usingOSBA (Opensource Broker for Azure)
1. Optionally, AKS can be deployed with a VNET virtual network