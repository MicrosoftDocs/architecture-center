---
title: Explainer - what is Azure Resource Manager?
description: Explanation of the internal functioning of Azure Resource Manager
author: petertay
---

# Explainer: what is Azure Resource Manager?

In the [how does Azure work?](azure-explainer.md) explainer, you learned that the internal architecture of Azure includes a front end that hosts all of the distributed applications that manage internal Azure services.

The Azure front end includes a service called Azure Resource Manager. Azure Resource Manager is responsible for the lifecycle of resources hosted in Azure from creation to deletion. There are many ways to interact with Azure Resource Manager - using Powershell, the Azure command line interface, SDKs - but each of these is simply a wrapper on top of a RESTful API hosted by Azure Resource Manager.

The RESTful API provided by Azure Resource Manager is a consistent interface over a set of **resource providers**. Resource providers are simply services running in Azure that include all the functionality necessary to create, read, update, and delete resources in Azure. In fact, the RESTful API includes methods for each of these functions. 

The RESTful API requires an access token for the user, a **subscription ID**, and a **resource group ID**. Azure Resource Manager also requires the **tenant ID**, but that is encoded as part of the access token.     

Once a valid RESTful API call has been received, Azure Resource Manager is responsible for locating capacity in the specified region and copying any necessary files to a staging location. The request is then sent to the fabric controller in the rack, and the fabric controller allocates the resources. The fabric controller responds to the request with a success or failure notification along with a **resource ID** for the newly created resource. The tenant ID, subscription ID, resource group ID, and resource ID are stored internally in Azure and uniquely identify a deployed resource.

# Next steps

* Now that you understand the internal functioning of Azure Resource Manager, learn [about resource groups](resource-group-explainer.md) to assist you in creating your first resource group.