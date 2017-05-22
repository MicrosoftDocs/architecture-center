---
title: Using an object as a parameter in an Azure resource manager template
description: Describes how to extend the functionality of Azure Resource Manager templates to use objects as parameters
author: petertay
ms.date: 05/03/2017

---

# Using an object as a parameter in an Azure resource manager template

When you [author Azure resource manager templates][azure-resource-manager-create-template], you can either specify resource property values directly or specify that the value of a parameter be substituted instead. If parameters are used, their values are typically specified in a separate file provided to resource manager during deployment. 

For small deployments, you can use one parameter for one property value. However, there is a limit of 255 parameters per deployment. Once you get to larger and more complex deployments you may run out of parameters.

## Create object as parameter

One way to solve this problem is to use an object as a parameter. To do this, specify an object as a parameter in your template, then provide the object as a value or an array of values. You then refer to its subproperties using the [`parameter()` function][azure-resource-manager-functions] and dot operator. For example, consider the following parameter named `VNetSettings`:

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters":{ 
      "VNetSettings":{
          "value":{
              "name":"VNet1",
              "addressPrefixes": [
                  { 
                      "name": "firstPrefix",
                      "addressPrefix": "10.0.0.0/22"
                  }
              ],
              "subnets":[
                  {
                      "name": "firstSubnet",
                      "addressPrefix": "10.0.0.0/24"
                  },
                  {
                      "name":"secondSubnet",
                      "addressPrefix":"10.0.1.0/24"
                  }
              ]
          }
      }
  }
}
```

The value of `VNetSettings` is a JSON object with three properties: `name`, `addressPrefixes`, and `subnets`. The followng template demonstrates how to access the value of these properties during deployment:

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
      "VNetSettings":{"type":"object"}
  },
  "variables": {},
  "resources": [
    {
      "apiVersion": "2015-06-15",
      "type": "Microsoft.Network/virtualNetworks",
      "name": "[parameters('VNetSettings').name]",
      "location":"[resourceGroup().location]",
      "properties": {
          "addressSpace":{
              "addressPrefixes": [
                  "[parameters('VNetSettings').addressPrefixes[0].addressPrefix]"
              ]
          },
          "subnets":[
              {
                  "name":"[parameters('VNetSettings').subnets[0].name]",
                  "properties": {
                      "addressPrefix": "[parameters('VNetSettings').subnets[0].addressPrefix]"
                  }
              },
              {
                  "name":"[parameters('VNetSettings').subnets[1].name]",
                  "properties": {
                      "addressPrefix": "[parameters('VNetSettings').subnets[1].addressPrefix]"
                  }
              }
          ]
        }
    }
  ],          
  "outputs": {}
}

```

Note the use of the `parameters()` function with both the `[]` array indexer and the dot operator to access the values of the sub-properties in the `VNetSettings` parameter. You can use this technique to create as complex of an object as necessary to hold your resource's property values. There is also no requirement that these values be used for a single resource - you can share the object's values across multiple resources if necessary.

## Use an object instead of multiple arrays

You may be familiar with using a [copy loop][azure-resource-manager-create-multiple-instances] to deploy multiple instances of a resource. To do this, you provide a JSON array of resource property values. The copy loop iterates through it and selects values to apply to the resource's properties. It is possible to iterate over multiple parallel arrays of values, as in the following example: 

```json
"variables": {
    "firstProperty": [
        {
            "name": "A",
            "type": "typeA"
        },
        {
            "name": "B",
            "type": "typeB"
        },
        {
            "name": "C",
            "type": "typeC"
        }
    ],
    "secondProperty": [
        "one","two", "three"
    ]
}
```

The property value is selected from the array using the `variables()` function indexed by the result of the `copyIndex()` function. For example:

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    ...
    "copy": {
        "name": "copyLoop1",
        "count": "[length(variables('firstProperty'))]"
    },
    ...
    "properties": {
        "name": { "value": "[variables('firstProperty')[copyIndex()].name]" },
        "type": { "value": "[variables('firstProperty')[copyIndex()].type]" },
        "number": { "value": "[variables('secondProperty')[copyIndex()]]" }
    }
}
```

Notice that the `count` of the copy loop is based on the number of properties in the `firstProperty` array. However, if there is not the same number of properties in the `secondProperty` array, the template will fail validation. It's better practice to include all the properties in a single object because it is much easier to see when a value is missing. For example:

```json
"variables": {
    "propertyObject": [
        {
            "name": "A",
            "type": "typeA",
            "number": "one"
        },
        {
            "name": "B",
            "type": "typeB",
            "number": "two"
        },
        {
            "name": "C",
            "type": "typeC"
        }
    ]
}
```

## Use with serial copy

This becomes even more useful when combined with the [serial copy loop](./sequential-loop.md), particularly for deploying child resources. The following example template deploys a network security group (NSG) with two security rules. The first resource named `NSG1` deploys the NSG. The second resource group named `loop-0` performs two functions: first, it `dependsOn` the NSG so its deployment doesn't begin until `NSG1` is completed, and it is the first iteration of the sequential loop. The third resource is a nested template that deploys the security rules using an object for its parameter values as in the last example.

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
      "networkSecurityGroupsSettings": {"type":"object"}
  },
  "variables": {},
  "resources": [
    {
      "apiVersion": "2015-06-15",
      "type": "Microsoft.Network/networkSecurityGroups",
      "name": "NSG1",
      "location":"[resourceGroup().location]",
      "properties": {
          "securityRules":[]
      }
    },
    {
        "apiVersion": "2015-01-01",
        "type": "Microsoft.Resources/deployments",
        "name": "loop-0",
        "dependsOn": [
            "NSG1"
        ],
        "properties": {
            "mode":"Incremental",
            "parameters":{},
            "template": {
                "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                "contentVersion": "1.0.0.0",
                "parameters": {},
                "variables": {},
                "resources": [],
                "outputs": {}
            }
        }       
    },
    {
        "apiVersion": "2015-01-01",
        "type": "Microsoft.Resources/deployments",
        "name": "[concat('loop-', copyIndex(1))]",
        "dependsOn": [
          "[concat('loop-', copyIndex())]"
        ],
        "copy": {
          "name": "iterator",
          "count": "[length(parameters('networkSecurityGroupsSettings').securityRules)]"
        },
        "properties": {
          "mode": "Incremental",
          "template": {
            "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
            "contentVersion": "1.0.0.0",
           "parameters": {},
            "variables": {},
            "resources": [
                {
                    "name": "[concat('NSG1/' , parameters('networkSecurityGroupsSettings').securityRules[copyIndex()].name)]",
                    "type": "Microsoft.Network/networkSecurityGroups/securityRules",
                    "apiVersion": "2016-09-01",
                    "location":"[resourceGroup().location]",
                    "properties":{
                        "description": "[parameters('networkSecurityGroupsSettings').securityRules[copyIndex()].description]",
                        "priority":"[parameters('networkSecurityGroupsSettings').securityRules[copyIndex()].priority]",
                        "protocol":"[parameters('networkSecurityGroupsSettings').securityRules[copyIndex()].protocol]",
                        "sourcePortRange": "[parameters('networkSecurityGroupsSettings').securityRules[copyIndex()].sourcePortRange]",
                        "destinationPortRange": "[parameters('networkSecurityGroupsSettings').securityRules[copyIndex()].destinationPortRange]",
                        "sourceAddressPrefix": "[parameters('networkSecurityGroupsSettings').securityRules[copyIndex()].sourceAddressPrefix]",
                        "destinationAddressPrefix": "[parameters('networkSecurityGroupsSettings').securityRules[copyIndex()].destinationAddressPrefix]",
                        "access":"[parameters('networkSecurityGroupsSettings').securityRules[copyIndex()].access]",
                        "direction":"[parameters('networkSecurityGroupsSettings').securityRules[copyIndex()].direction]"
                        }
                  }
            ],
            "outputs": {}
          }
        }
    }
  ],          
  "outputs": {}
}

```

The corresponding parameter file looks like this:

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
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

## Try the template

If you would like to experiment with these templates, follow these steps:

1.	Go to the Azure portal, select the "+" icon, and search for the "template deployment" resource type. When you find it in the search results, select it.
2.	When you get to the "template deployment" page, select the **create** button. This button opens the "custom deployment" blade.
3.	Select the **edit template** button.
4.	Delete the empty template in the right-hand pane.
5.	Copy and paste the sample template into the right-hand pane.
6.	Select the **save** button.
7.	When you are returned to the "custom deployment" pane, select the **edit parameters** button.
8.  On the "edit parameters" blade, delete the existing template.
9.  Copy and paste the sample parameter template from above.
10. Select the **save** button, which returns you to the "custom deployment" blade.
11. On the "custom deployment" blade, select your subscription, either create new or use existing resource group, and select a location. Review the terms and conditions, and select the "I agree" checkbox.
12.	Select the **purchase** button.

## Next steps

* You can expand upon these techniques to implement a [property object transformer and collector](./collector.md). The transformer and collector techniques are more general and can be linked from your templates.
* For an introduction to the `parameter()` function and using arrays, see [Azure Resource Manager template functions](/azure/azure-resource-manager/resource-group-template-functions.md).
* This technique is also implemented in the [template building blocks project](https://github.com/mspnp/template-building-blocks) and the [Azure reference architectures](/azure/architecture/reference-architectures/). You can review our templates to see how we've implemented this technique.

<!-- links -->

[azure-resource-manager-create-template]: azure/azure-resource-manager/resource-manager-create-first-template
[azure-resource-manager-create-multiple-instances]: azure/azure-resource-manager/resource-group-create-multiple
[azure-resource-manager-functions]: /azure/azure-resource-manager/resource-group-template-functions-resource