---
title: DevTest Image Factory 
description: Create, maintain, and distribute custom images with the DevTest Image Factory, an automated image development and management solution from Azure Dev Test Labs.
author: adamboeglin
ms.date: 10/29/2018
---
# DevTest Image Factory 
The image factory provides a great way for organizations to create, maintain, and distribute custom images with Azure Dev Test Labs.Whether you have globally distributed teams that need to work with a common set of custom images, need to centrally manage the configuration of images to ensure they meet regulatory compliance and security requirements, or complex software setup and configuration requirements, the image factory provides an automated solution to manage it

## Architecture
<img src="media/dev-test-image-factory.svg" alt='architecture diagram' />

## Data Flow
1. With config as code, define the images to push and select which labs will receive the image.
1. IT admin checks into source code control of choice (such as Visual Studio Team Services or Github + Jenkins).
1. Orchestrator triggers golden image creation based on configuration in source code control that goes to the image factory.
1. Image factory lab receives commands to create virtual machines (VMs) and custom images.
1. Specified images copied from image factory lab to team labs.
1. Team lab users claim VMs or create VMs with the latest images.

## Components
* [Azure Lab Services](href="http://azure.microsoft.com/services/lab-services/): Set up labs for classrooms, trials, development and testing, and other scenarios
* [Virtual Machines](href="http://azure.microsoft.com/services/virtual-machines/): Provision Windows and Linux virtual machines in seconds
* [Azure DevOps](href="http://azure.microsoft.com/services/devops/): Services for teams to share code, track work, and ship software

## Next Steps
* [Azure Lab Services documentation](https://docs.microsoft.com/azure/lab-services/)
* [Virtual Machines documentation](https://docs.microsoft.com/azure/virtual-machines/)
* [Azure Devops documentation](https://docs.microsoft.com/azure/devops/)