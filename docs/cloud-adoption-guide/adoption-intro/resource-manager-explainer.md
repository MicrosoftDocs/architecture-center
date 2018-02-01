---
title: Explainer - what is Azure Resource Manager?
description: Explains the internal functioning of Azure Resource Manager
author: petertay
---

# Explainer: what is Azure Resource Manager?

In the "[how does Azure work?](azure-explainer.md)" explainer, you learned about the internal architecture of Azure. This architecture includes a front end that hosts the distributed applications that manage internal Azure services.

The Azure front end includes a service called Azure Resource Manager. Azure Resource Manager is responsible for the lifecycle of resources hosted in Azure from creation to deletion. There are many ways to interact with Azure Resource Manager &mdash; using Powershell, the Azure command-line interface, SDKs &mdash; but each of these tools is simply a wrapper over a RESTful API hosted by Azure Resource Manager.

The RESTful API provided by Azure Resource Manager is a consistent interface over a set of **resource providers**. Resource providers are simply Azure services that create, read, update, and delete resources in Azure. In fact, the RESTful API includes methods for each of these functions. 

The RESTful API requires an access token for the user, a **subscription ID**, and a **resource group ID**. Azure Resource Manager also requires the **tenant ID**, which is encoded as part of the access token. When a valid API call is received, Azure Resource Manager finds capacity in the specified region and copies any required files to a staging location. The request is then sent to the fabric controller in the rack, and the fabric controller allocates the resources. The fabric controller responds to the request with a success or failure notification, along with a **resource ID** for the newly created resource. These four IDs are stored internally in Azure and together serve as a unique identifier for a deployed resource.

## Next steps

* Now that you understand the internal functioning of Azure Resource Manager, learn [about resource groups](resource-group-explainer.md) to assist you in creating your first resource group.
