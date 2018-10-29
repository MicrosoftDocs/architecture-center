---
title: Microservices with AKS | Microsoft
description: Microservices with AKS
author: adamboeglin
ms.date: 10/29/2018
---
# Microservices with AKS | Microsoft
Use AKS to simplify the deployment and management of microservices basedarchitecture. AKS streamlines horizontal scaling, self-healing, load balancing,secret management.

## Architecture
<img src="media/microservices-with-aks.svg" alt='architecture diagram' />

## Data Flow
1. Developer uses IDE such as Visual Studio to commit changes to Github
1. Github triggers a new build on VSTS
1. VSTS packages microservices as containers and pushes them to the AzureContainer Registry
1. Containers are deployed to AKS cluster
1. Users access services via apps and website
1. Azure Active Directory is used to secure access to the resources
1. Microservices use databases to store and retrieve information
1. Administrator accesses via a separate admin portal