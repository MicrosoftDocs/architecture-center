---
title: Use objects as parameters in an ARM template
description: Describes how to extend the functionality of Azure Resource Manager templates to use objects as parameters.
author: martinekuan
ms.author: martinek
ms.date: 01/05/2023
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

When you use [objects as parameters](/azure/azure-resource-manager/templates/parameters#objects-as-parameters) in Azure Resource Manager templates (ARM templates), you can include them in a copy loop. This technique is very useful when it's combined with a [serial copy loop](/azure/azure-resource-manager/templates/copy-resources#serial-or-parallel), especially for deploying child resources.

To demonstrate this approach, let's look at a template that deploys a [network security group (NSG)][nsg] with two security rules.

First, let's look at our parameters. When we look at our template we see that we defined one parameter named `networkSecurityGroupsSettings` that includes an array named `securityRules`. This array contains two JSON objects, each of which specifies settings that define a security rule.

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

Now, let's look at our template. We have a resource named `NSG1` that deploys the NSG. It also uses [ARM's built-in property iteration feature](/azure/azure-resource-manager/templates/copy-properties). By adding copy loop to the properties section of a resource in your template, you can dynamically set the number of items for a property during deployment. You also avoid having to repeat template syntax.

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
                            "name": "[parameters('networkSecurityGroupsSettings').securityRules[copyIndex('securityRules')].name]",
                            "properties": {

                                "description": "[parameters('networkSecurityGroupsSettings').securityRules[copyIndex('securityRules')].description]",
                                "priority": "[parameters('networkSecurityGroupsSettings').securityRules[copyIndex('securityRules')].priority]",
                                "protocol": "[parameters('networkSecurityGroupsSettings').securityRules[copyIndex('securityRules')].protocol]",
                                "sourcePortRange": "[parameters('networkSecurityGroupsSettings').securityRules[copyIndex('securityRules')].sourcePortRange]",
                                "destinationPortRange": "[parameters('networkSecurityGroupsSettings').securityRules[copyIndex('securityRules')].destinationPortRange]",
                                "sourceAddressPrefix": "[parameters('networkSecurityGroupsSettings').securityRules[copyIndex('securityRules')].sourceAddressPrefix]",
                                "destinationAddressPrefix": "[parameters('networkSecurityGroupsSettings').securityRules[copyIndex('securityRules')].destinationAddressPrefix]",
                                "access": "[parameters('networkSecurityGroupsSettings').securityRules[copyIndex('securityRules')].access]",
                                "direction": "[parameters('networkSecurityGroupsSettings').securityRules[copyIndex('securityRules')].direction]"
                            }
                        }
                    }
                ]
            }
        }
    ]
}
```

Let's take a closer look at how we specify our property values in the `securityRules` child resource. All of our properties are referenced by using the `parameters()` function. Then we use the dot operator to reference our `securityRules` array, and index it by the current value of the iteration. Finally, we use another dot operator to reference the name of the object.

## Try the template

An example template is available on [GitHub][github]. To deploy the template, clone the repo and run the following [Azure CLI][cli] commands:

```azurecli
git clone https://github.com/mspnp/template-examples.git
cd template-examples/example3-object-param
az group create --location <location> --name <resource-group-name>
az deployment group create -g <resource-group-name> \
    --template-uri https://raw.githubusercontent.com/mspnp/template-examples/master/example3-object-param/deploy.json \
    --parameters deploy.parameters.json
```

## Next steps

- [Azure Resource Manager](https://azure.microsoft.com/get-started/azure-portal/resource-manager)
- [What are ARM templates?](/azure/azure-resource-manager/templates/overview)
- [Tutorial: Create and deploy your first ARM template](/azure/azure-resource-manager/templates/template-tutorial-create-first-template)
- [Tutorial: Add a resource to your ARM template](/azure/azure-resource-manager/templates/template-tutorial-add-resource?tabs=azure-powershell)
- [ARM template best practices](/azure/azure-resource-manager/templates/best-practices)
- [Azure Resource Manager documentation](/azure/azure-resource-manager)
- [ARM template documentation](/azure/azure-resource-manager/templates)

## Related resources

- [Update a resource in an Azure Resource Manager template](update-resource.md)
- [Use objects as parameters in a copy loop in an Azure Resource Manager template](objects-as-parameters.md)
- [Implement a property transformer and collector in an Azure Resource Manager template](collector.md)

[nsg]: /azure/virtual-network/virtual-networks-nsg
[cli]: /cli/azure/
[github]: https://github.com/mspnp/template-examples
