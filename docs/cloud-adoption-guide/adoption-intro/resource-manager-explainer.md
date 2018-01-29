---
title: Explainer - How does Azure Resource Manager work?
description: Explanation of the internal functioning of Azure Resource Manager
author: petertay
---

# Explainer: How does Azure Resource Manager work?

In the [how does Azure work?](azure-explainer.md) explainer, you learned that the internal architecture of Azure includes a front end that hosts all of the distributed applications that manage Azure services.

The Azure front end includes a service called Azure Resource Manager. Azure Resource Manager is responsible for the lifecycle of resources hosted in Azure from creation to deletion. There are many ways to interact with Azure Resource Manager - using Powershell, the Azure command line interface, SDKs - but each of these is simply a wrapper on top of a RESTful API hosted by Azure Resource Manager.

The RESTful API provided by Azure Resource Manager is a consistent interface over a set of **resource providers**. Resource providers are simply services running in Azure that include all the functionality necessary to create, read, update, and delete resources in Azure. In fact, the RESTful API includes methods for each of these functions. 

The RESTful API requires an access token for the user, a **subscription ID**, and a **resource group ID**. Azure Resource Manager also requires the **tenant ID**, but that is encoded as part of the access token.   

   

A customer can use any of these to request a resource in a region, and Azure Resource Manager is responsible for locating capacity in the specified region and copying any necessary files to a staging location. The request is sent to the fabric controller in the rack, and the fabric controller allocates the resources. The fabric controller then sends the status of the request back Azure Resource Manager, which responds to the customers request with success or failure along with other useful information. The resource is then available for use.