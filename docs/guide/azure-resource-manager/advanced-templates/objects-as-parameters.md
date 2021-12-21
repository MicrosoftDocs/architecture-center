---
title: Use objects as parameters in an ARM template
description: Describes how to extend the functionality of Azure Resource Manager templates to use objects as parameters.
author: EdPrice-MSFT
ms.author: pnp
ms.date: 09/07/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
ms.category:
  - developer-tools
  - devops
categories:
  - developer-tools
  - devops
products:
  - azure-resource-manager
ms.custom:
  - article
---

<!-- cSpell:ignore subproperties -->

# Use objects as parameters in a copy loop in an Azure Resource Manager template

When [using objects as a parameter in Azure Resource Manager templates](/azure/azure-resource-manager/templates/parameters#objects-as-parameters) you may want to include them in a copy loop, so here is an example that uses them in that way:

This approach becomes very useful when combined with the [serial copy loop](/azure/azure-resource-manager/templates/copy-resources#serial-or-parallel), particularly for deploying child resources.

To demonstrate this, let's look at a template that deploys a [network security group (NSG)][nsg] with two security rules.

First, let's take a look at our parameters. When we look at our template we'll see that we've defined one parameter named `networkSecurityGroupsSettings` that includes an array named `securityRules`. This array contains two JSON objects that specify a number of settings for a security rule.

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters":{
        "networkSecurityGroupsSettings": {
            "value": {
                "securityRules": [
                    {
                        "name": "RDPAllow",
                        "description": "allow RDP connections",
                        "direction": "Inbound",
                        "priority": 100,
                        "sourceAddressPrefix": "*",
                        "destinationAddressPrefix": "10.0.0.0/24",
                        "sourcePortRange": "*",
                        "destinationPortRange": "3389",
                        "access": "Allow",
                        "protocol": "Tcp"
                    },
                    {
                        "name": "HTTPAllow",
                        "description": "allow HTTP connections",
                        "direction": "Inbound",
                        "priority": 200,
                        "sourceAddressPrefix": "*",
                        "destinationAddressPrefix": "10.0.1.0/24",
                        "sourcePortRange": "*",
                        "destinationPortRange": "80",
                        "access": "Allow",
                        "protocol": "Tcp"
                    }
                ]
            }
        }
    }
}
```

Now let's take a look at our template. We have a resource named `NSG1` deploys the NSG, it also leverages [ARM's built-in property iteration feature](/azure/azure-resource-manager/templates/copy-properties); by adding copy loop to the properties section of a resource in your template, you can dynamically set the number of items for a property during deployment. You also avoid having to repeat template syntax.

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "VNetSettings": {
            "type": "object"
        },
        "networkSecurityGroupsSettings": {
            "type": "object"
        }
    },
    "resources": [
        {
            "apiVersion": "2020-05-01",
            "type": "Microsoft.Network/virtualNetworks",
            "name": "[parameters('VNetSettings').name]",
            "location": "[resourceGroup().location]",
            "properties": {
                "addressSpace": {
                    "addressPrefixes": [
                        "[parameters('VNetSettings').addressPrefixes[0].addressPrefix]"
                    ]
                },
                "subnets": [
                    {
                        "name": "[parameters('VNetSettings').subnets[0].name]",
                        "properties": {
                            "addressPrefix": "[parameters('VNetSettings').subnets[0].addressPrefix]"
                        }
                    },
                    {
                        "name": "[parameters('VNetSettings').subnets[1].name]",
                        "properties": {
                            "addressPrefix": "[parameters('VNetSettings').subnets[1].addressPrefix]"
                        }
                    }
                ]
            }
        },
        {
            "apiVersion": "2020-05-01",
            "type": "Microsoft.Network/networkSecurityGroups",
            "name": "NSG1",
            "location": "[resourceGroup().location]",
            "properties": {
                "copy": [
                    {
                        "name": "securityRules",
                        "count": "[length(parameters('networkSecurityGroupsSettings').securityRules)]",
                        "input": {
                            "description": "[parameters('networkSecurityGroupsSettings').securityRules[copyIndex()].description]",
                            "priority": "[parameters('networkSecurityGroupsSettings').securityRules[copyIndex()].priority]",
                            "protocol": "[parameters('networkSecurityGroupsSettings').securityRules[copyIndex()].protocol]",
                            "sourcePortRange": "[parameters('networkSecurityGroupsSettings').securityRules[copyIndex()].sourcePortRange]",
                            "destinationPortRange": "[parameters('networkSecurityGroupsSettings').securityRules[copyIndex()].destinationPortRange]",
                            "sourceAddressPrefix": "[parameters('networkSecurityGroupsSettings').securityRules[copyIndex()].sourceAddressPrefix]",
                            "destinationAddressPrefix": "[parameters('networkSecurityGroupsSettings').securityRules[copyIndex()].destinationAddressPrefix]",
                            "access": "[parameters('networkSecurityGroupsSettings').securityRules[copyIndex()].access]",
                            "direction": "[parameters('networkSecurityGroupsSettings').securityRules[copyIndex()].direction]"
                        }
                    }
                ]
            }
        }
    ]
}
```

Let's take a closer look at how we specify our property values in the `securityRules` child resource. All of our properties are referenced using the `parameters()` function, and then we use the dot operator to reference our `securityRules` array, indexed by the current value of the iteration. Finally, we use another dot operator to reference the name of the object.

## Try the template

An example template is available on [GitHub][github]. To deploy the template, clone the repo and run the following [Azure CLI][cli] commands:

```bash
git clone https://github.com/mspnp/template-examples.git
cd template-examples/example3-object-param
az group create --location <location> --name <resource-group-name>
az deployment group create -g <resource-group-name> \
    --template-uri https://raw.githubusercontent.com/mspnp/template-examples/master/example3-object-param/deploy.json \
    --parameters deploy.parameters.json
```

## Next steps

- Learn how to create a template that iterates through an object array and transforms it into a JSON schema. See [Implement a property transformer and collector in an Azure Resource Manager template](./collector.md)

<!-- links -->

[azure-resource-manager-authoring-templates]: /azure/azure-resource-manager/templates/template-syntax
[azure-resource-manager-create-template]: /azure/azure-resource-manager/templates/template-tutorial-create-first-template
[azure-resource-manager-create-multiple-instances]: /azure/azure-resource-manager/
[azure-resource-manager-functions]: /azure/azure-resource-manager/templates/template-functions-deployment#parameters
[nsg]: /azure/virtual-network/virtual-networks-nsg
[cli]: /cli/azure/
[github]: https://github.com/mspnp/template-examples
