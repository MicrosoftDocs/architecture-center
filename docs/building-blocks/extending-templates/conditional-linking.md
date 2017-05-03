---
title: Extending Azure Resource Manager Template functionality - Conditional Template Linking
description: Describes how to extend the functionality of Azure Resource Manager templates to implement conditional template linking
author: petertay
ms.service: guidance
ms.topic: article
ms.date: 05/03/2017
ms.author: pnp

---
# Extending Azure Resource Manager template functionality - Conditional Template Linking

Azure Resource Manager templates support linking from one template file to another using the `Microsoft.Resources/deployments` resource type. You can specify resources in a seperate template and link to them using the `templateLink` property. This is great for managing templates and making deployment more easily configurable.

However, there is a limitation in that templates can only be statically linked when you create the main template. If you want to have two sets of similar resources, specify them in separate templates, and deploy one or the other under certain conditions, you must determine the condition in advance and manually change the path to the linked template before deployment begins.

For example, for some deployments you may require a VNet with an external domain name server (DNS) but for others require Azure DNS. To do this, you'd have to specify each VNet in a separate template file and manually edit the main template to link to one or the other based on which you want to deploy.

The problem is that resource manager does not include functionality to conditionally link templates using parameters. But there is a way to implement this using existing resource manager functions.

In the following template, a variable includes an object with two or more properties. The two or more properties specify the `uri` of a template. Then, a `Microsoft.Resources/deployments` resource type is specified with a `templateLink` property whose `uri` is the variable object indexed by a parameter value. Another template specifies a value for the parameter, and during deployment this parameter value changes the index and this in turn changes the `uri`. 

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "condition": {
      "type": "string"
    }
  },
  "variables": {
    "conditions": {
      "no": "[uri(deployment().properties.templateLink.uri, '../Parameters/noDeploy.parameters.json')]",
      "yes": "[uri(deployment().properties.templateLink.uri, '../Parameters/deploy.parameters.json')]"
    }
  },
  "resources": [
    {
      "apiVersion": "2015-01-01",
      "type": "Microsoft.Resources/deployments",
      "name": "[concat('conditional-resource-',parameters('condition'))]",
      "properties": {
        "mode": "Incremental",
        "parameters": {},
        "templateLink": { "uri": "[variables('conditions')[tolower(parameters('condition'))]]" }

      }
    }
  ],
  "outputs": {}
}
```

During deployment, the `condition` parameter is typically specified in a parameter file as follows:

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "condition": { "value": "yes" }
  }
}
```
If `condition` is set to `yes`, the template named `deploy.parameters.json` is linked. If `condition` is set to `no`, the template named `noDeploy.parameters.json` is linked. Note that while there two conditions here, you can include as many values as you require and can link to any number of templates. You can use conditions `1`, `2`, and `3` to link to three different templates, or you can use conditions `AzureDNS`, `externalDNS`, or `internalDNS` to link to templates that specify the appropriate deployment.

It's also possible to implement `optional` linking using some creative math. The modulo operation represents the remainder after dividing a dividend by a divisor. One of the properties of the modulo operation is that for any given `n`, `(n+2) mod (n+1)` equals `1` for every value of `n` greater than `0`. By substituting the length of an array or a string for `n` the result is a boolean operator for the presence of either. If the result is `0`, you can link to a template that doesn't deploy anything and if it's `1` you can link to a template that deploys the intended resource. 

This is demonstrated in the template below:

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "optionalArray": {
      "type": "array",
      "defaultValue": []
    }
  },
  "variables": {
    "optionalParameterArray": [
      "[uri(deployment().properties.templateLink.uri, '../Parameters/noDeploy.parameters.json')]",
      "[uri(deployment().properties.templateLink.uri, '../Parameters/deploy.parameters.json')]"
    ],
    "templateToInvoke": "[variables('optionalParameterArray')[mod(add(length(parameters('optionalArray')), 2), add(length(parameters('optionalArray')), 1))]]"
  },
  "resources": [
    {
      "apiVersion": "2015-01-01",
      "type": "Microsoft.Resources/deployments",
      "name": "[concat('number-of-array-elements-',length(parameters('optionalArray')))]",
      "properties": {
        "mode": "Incremental",
        "parameters": {},
        "templateLink": { "uri": "[variables('templateToInvoke')]" }
      }
    }

  ],
  "outputs": {}
}
```

During deployment, the `optionalArray` parameter can be specified in parameter file as follows:

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
      "optionalArray": { "value": []}
  }
}
```

As with the previous template, a variable object includes one or more `uri` strings. There's also a `templateToInvoke` variable that implements the modulo operation. If the `optionalArray` is empty, the `length()` function evaluates to `0`, and the first `uri` of the `optionalParameterArray` is selected. If the `optionalArray` includes any number of values, the `length()` function evalates to greater than `0`, the modulo operation evaluates to `1`, and the second `uri` of the `optionalParameterArray` is selected. 

The is simliar for an "optional" string parameter:

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "optionalString": {
      "type": "string",
      "defaultValue": ""
    }
  },
  "variables": {
    "optionalParameter": [
      "[uri(deployment().properties.templateLink.uri, '../Parameters/noDeploy.parameters.json')]",
      "[uri(deployment().properties.templateLink.uri, '../Parameters/deploy.parameters.json')]"
    ],
    "templateToInvoke": "[variables('optionalParameter')[mod(add(length(parameters('optionalString')), 2), add(length(parameters('optionalString')), 1))]]"
  },
  "resources": [
    {
      "apiVersion": "2015-01-01",
      "type": "Microsoft.Resources/deployments",
      "name": "[concat('number-of-parameters-',length(parameters('optionalString')))]",
      "properties": {
        "mode": "Incremental",
        "parameters": {},
        "templateLink": { "uri": "[variables('templateToInvoke')]" }
      }
    }
  ],
  "outputs": {}
}
```

During deployment, the `optionalArray` parameter can be specified in parameter file as follows:

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
      "optionalString": { "value": "deploy" }
  }
}
```

In this example, the `templateToInvoke` modulo operation evaluates the length of the string. If there is no string, the modulo operation evaluates to `0`, while a string of any length evaluates to `1`. As before, this becomes the index into the `optionalParameter` object and selects either the first or second `uri` for the resource's `templateLink` property. In this case, the value of `optionalString` is `deploy`, so the `deploy.parameters.json` template will be linked during deployment.

# Next Steps

You can use this pattern in your templates by implementing the patterns above in your main template and creating a set of linked templates that deploy your resources. Specify the conditional parameters in an external template and change the value to control deployment.

This pattern is implemented in the [template building blocks project](https://github.com/mspnp/template-building-blocks) and the [Azure reference architectures](https://docs.microsoft.com/azure/architecture/reference-architectures/). You can either build your own deployment with the template building blocks or deploy an existing reference architecture by clicking on the links.