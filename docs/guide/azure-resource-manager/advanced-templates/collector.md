---
title: Transformer and collector ARM template
description: Describes how to implement a property transformer and collector in an Azure Resource Manager template.
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
  - devx-track-arm-template
---

<!-- cSpell:ignore copyindex -->

# Implement a property transformer and collector in an Azure Resource Manager template

In article [Use objects as parameters in a copy loop in an Azure Resource Manager template][objects-as-parameters] you can see how to store resource property values in an object and how to apply them to a resource during deployment. This is a very useful way to manage your parameters, but it requires that you map the properties of the object to resource properties each time you use the object in your template.

To work around this, you can implement a property transform and collector template that iterates your object array and transforms it into the JSON schema for the resource.

> [!IMPORTANT]
> This approach requires that you have a deep understanding of Resource Manager templates and functions.

Let's look at an example that implements a property collector and transformer to deploy a [network security group][nsg]. The diagram below shows how our templates are related to the resources in those templates:

:::image type="content" source="../images/collector-transformer.png" alt-text="property collector and transformer architecture" lightbox="../images/collector-transformer.png" border="false":::

Our **calling template** includes two resources:

- A template link that invokes our **collector template**
- The network security group resource to deploy

Our **collector template** includes two resources:

- An **anchor** resource
- A template link that invokes the transform template in a copy loop

Our **transform template** includes a single resource: an empty template with a variable that transforms our `source` JSON to the JSON schema that's expected by our network security group resource in the **main template**.

## Parameter object

We use our `securityRules` parameter object from [Use objects as parameters in a copy loop in an Azure Resource Manager template][objects-as-parameters]. Our **transform template** transforms each object in the `securityRules` array into the JSON schema that's expected by the network security group resource in our **calling template**.

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
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

Let's look at our **transform template** first.

## Transform template

Our **transform template** includes two parameters that are passed from the **collector template**:

- `source` is an object that receives one of the property value objects from the property array. In our example, each object from the `securityRules` array is passed one at a time.
- `state` is an array that receives the concatenated results of all the previous transforms. This is the collection of transformed JSON.

Our parameters look like this:

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "source": {
            "type": "object"
        },
        "state": {
            "type": "array",
            "defaultValue": []
        }
    },
```

Our template also defines a variable named `instance` that transforms our `source` object into the required JSON schema:

```json
"variables": {
    "instance": [
        {
            "name": "[parameters('source').name]",
            "properties": {
                "description": "[parameters('source').description]",
                "protocol": "[parameters('source').protocol]",
                "sourcePortRange": "[parameters('source').sourcePortRange]",
                "destinationPortRange": "[parameters('source').destinationPortRange]",
                "sourceAddressPrefix": "[parameters('source').sourceAddressPrefix]",
                "destinationAddressPrefix": "[parameters('source').destinationAddressPrefix]",
                "access": "[parameters('source').access]",
                "priority": "[parameters('source').priority]",
                "direction": "[parameters('source').direction]"
            }
        }
    ]
}
```

Finally, the `output` of our template concatenates the collected transforms of our `state` parameter with the current transform that's performed by our `instance` variable:

```json
"resources": [],
"outputs": {
    "collection": {
        "type": "array",
        "value": "[concat(parameters('state'), variables('instance'))]"
    }
}
```

Next, let's take a look at our **collector template** to see how it passes our parameter values.

## Collector template

Our **collector template** includes three parameters:

- `source` is our complete parameter object array. It's passed by the **calling template**. It has the same name as the `source` parameter in our **transform template**, but there's one key difference: although it's the complete array, we only pass one array element at a time to the **transform template**.
- `transformTemplateUri` is the URI of our **transform template**. We define it as a parameter for template reusability.
- `state` is an initially empty array that we pass to our **transform template**. It stores the collection of transformed parameter objects after the copy loop finishes.

Our parameters look like this:

```json
"parameters": {
    "source": {
        "type": "array"
    },
    "transformTemplateUri": {
        "type": "string"
    },
    "state": {
        "type": "array",
        "defaultValue": []
    }
}
```

Next, we define a variable named `count`. Its value is the length of the `source` parameter object array:

```json
"variables": {
    "count": "[length(parameters('source'))]"
}
```

We use it for the number of iterations in our copy loop.

Now let's take a look at our resources. We define two resources:

- `loop-0` is the zero-based resource for our copy loop.
- `loop-` is concatenated with the result of the `copyIndex(1)` function to generate a unique iteration-based name for our resource, starting with `1`.

Our resources look like this:

```json
"resources": [
    {
        "type": "Microsoft.Resources/deployments",
        "apiVersion": "2015-01-01",
        "name": "loop-0",
        "properties": {
            "mode": "Incremental",
            "parameters": { },
            "template": {
                "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                "contentVersion": "1.0.0.0",
                "parameters": { },
                "variables": { },
                "resources": [ ],
                "outputs": {
                    "collection": {
                        "type": "array",
                        "value": "[parameters('state')]"
                    }
                }
            }
        }
    },
    {
        "type": "Microsoft.Resources/deployments",
        "apiVersion": "2015-01-01",
        "name": "[concat('loop-', copyindex(1))]",
        "copy": {
            "name": "iterator",
            "count": "[variables('count')]",
            "mode": "serial"
        },
        "dependsOn": [
            "loop-0"
        ],
        "properties": {
            "mode": "Incremental",
            "templateLink": { "uri": "[parameters('transformTemplateUri')]" },
            "parameters": {
                "source": { "value": "[parameters('source')[copyindex()]]" },
                "state": { "value": "[reference(concat('loop-', copyindex())).outputs.collection.value]" }
            }
        }
    }
]
```

Let's take a closer look at the parameters that we pass to our **transform template** in the nested template. Recall from earlier that our `source` parameter passes the current object in the `source` parameter object array. The `state` parameter is where the collection happens, because it takes the output of the previous iteration of our copy loop and passes it to the current iteration. Notice that the `reference()` function uses the `copyIndex()` function with no parameter to reference the `name` of our previous linked template object.

Finally, the `output` of our template returns the `output` of the last iteration of our **transform template**:

```json
"outputs": {
    "result": {
        "type": "array",
        "value": "[reference(concat('loop-', variables('count'))).outputs.collection.value]"
    }
}
```

It may seem counterintuitive to return the `output` of the last iteration of our **transform template** to our **calling template**, because it appears that we stored it in our `source` parameter. However, it's the last iteration of our **transform template** that holds the complete array of transformed property objects, and that's what we want to return.

Finally, let's take a look at how to call the **collector template** from our **calling template**.

## Calling template

Our **calling template** defines a single parameter named `networkSecurityGroupsSettings`:

```json
...
"parameters": {
    "networkSecurityGroupsSettings": {
        "type": "object"
    }
}
```

Next, our template defines a single variable named `collectorTemplateUri`:

```json
"variables": {
    "collectorTemplateUri": "[uri(deployment().properties.templateLink.uri, 'collector.template.json')]"
}
```

This is the URI for the **collector template** that's used by our linked template resource:

```json
{
    "apiVersion": "2020-06-01",
    "name": "collector",
    "type": "Microsoft.Resources/deployments",
    "properties": {
        "mode": "Incremental",
        "templateLink": {
            "uri": "[variables('collectorTemplateUri')]",
            "contentVersion": "1.0.0.0"
        },
        "parameters": {
            "source": {
                "value": "[parameters('networkSecurityGroupsSettings').securityRules]"
            },
            "transformTemplateUri": {
                "value": "[uri(deployment().properties.templateLink.uri, 'transform.json')]"
            }
        }
    }
}
```

We pass two parameters to the **collector template**:

- `source` is our property object array. In our example, it's our `networkSecurityGroupsSettings` parameter.
- `transformTemplateUri` is the variable that we just defined with the URI of our **collector template**.

Finally, our `Microsoft.Network/networkSecurityGroups` resource directly assigns the `output` of the `collector` linked template resource to its `securityRules` property:

```json
"resources": [
    {
        "apiVersion": "2020-05-01",
        "type": "Microsoft.Network/networkSecurityGroups",
        "name": "networkSecurityGroup1",
        "location": "[resourceGroup().location]",
        "properties": {
            "securityRules": "[reference('collector').outputs.result.value]"
        }
    }
],
"outputs": {
    "instance": {
        "type": "array",
        "value": "[reference('collector').outputs.result.value]"
    }
}
```

## Try the template

An example template is available on [GitHub][github]. To deploy the template, clone the repo and run the following [Azure CLI][cli] commands:

```azurecli
git clone https://github.com/mspnp/template-examples.git
cd template-examples/example4-collector
az group create --location <location> --name <resource-group-name>
az deployment group create -g <resource-group-name> \
    --template-uri https://raw.githubusercontent.com/mspnp/template-examples/master/example4-collector/deploy.json \
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

[objects-as-parameters]: ./objects-as-parameters.md
[nsg]: /azure/virtual-network/virtual-networks-nsg
[cli]: /cli/azure/
[github]: https://github.com/mspnp/template-examples
