---
title: AKS triage—Admission controllers
titleSuffix: Azure Architecture Center
description: Learn how to validate that the admission controllers are working as expected, as part of a triage step for Azure Kubernetes Service (AKS) clusters.
author: kevingbb
ms.author: kevinhar
ms.date: 11/15/2023
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
azureCategories: compute
categories: compute
products:
  - azure-kubernetes-service
ms.custom:
  - e2e-aks
---

# Validate the admission controllers

_This article is part of a series. Start with the [overview](aks-triage-practices.md)._

Check whether the admission controllers are working as expected.

While issues caused by admission controllers are rare, it's crucial to consider and ensure their proper functionality. This article discusses various scenarios that can impact admission controllers and provides commands using `kubectl` to validate their performance. Here are some examples:

- **Mutating and validating webhooks**: When you incorporate mutating and validating webhooks in your Kubernetes cluster, it's imperative to ensure high availability. Unhealthy nodes shouldn't block API server requests. It's vital to monitor the admission control pipeline to prevent blocking a significant number of requests to the API server. The following are examples of webhooks that you should monitor:  

  - The [Azure Policy for Kubernetes clusters](/azure/governance/policy/concepts/policy-for-kubernetes), that extends [Gatekeeper v3](https://open-policy-agent.github.io/gatekeeper), an admission controller webhook for [Open Policy Agent](https://www.openpolicyagent.org), is an example of a webhook-based admission controller.
  - [Kyverno](https://kyverno.io) runs as a dynamic admission controller in a Kubernetes cluster. Kyverno receives validating and mutating admission webhook HTTP callbacks from the Kubernetes API server and applies matching policies to return results that enforce admission policies or reject requests.
- **Service meshes**: Service meshes, such as [Istio](https://istio.io/) and [Linkerd](https://linkerd.io/), use admission controllers to automate the injection of sidecar containers inside your pod, among other functionalities. Evaluate and verify the proper functioning of the admission controllers to ensure the seamless operation of the service mesh.

## Admission controllers

An [admission controller](https://kubernetes.io/docs/reference/access-authn-authz/admission-controllers) is a piece of code that intercepts requests to the Kubernetes API server prior to persistence of the object but after the request is authenticated and authorized.

Admission controllers can be *validating*, *mutating*, or a combination of both. *Mutating* controllers can modify related objects before admitting the request. *Validating* controllers solely ensure that requests meet specific predefined criteria.

One of the primary functions of admission controllers is to regulate requests for object creation, deletion, and modification. Additionally, admission controllers can restrict custom verbs, such as requesting a connection to a pod via an API server proxy. However, admission controllers can't block requests to read objects, including operations like get, watch, or list.

## Use `kubectl` to check the status of Azure Policy for Kubernetes clusters

If you installed the [Azure Policy add-on for AKS](/azure/governance/policy/concepts/policy-for-kubernetes), you can use the following `kubectl` commands to validate the installation and functionality of the Azure Policy admission controllers in your cluster:

```console
# Check Azure Policy pods are running.
kubectl get pod -n gatekeeper-system

# Sample output
...
NAME                                     READY   STATUS    RESTARTS   AGE
gatekeeper-audit-65844778cb-rkflg        1/1     Running   0          163m
gatekeeper-controller-78797d4687-4pf6w   1/1     Running   0          163m
gatekeeper-controller-78797d4687-splzh   1/1     Running   0          163m
...
```

Run the previous command to verify the availability of Azure Policy Agent pods in the `gatekeeper-system` namespace. If the output isn't what you expect, it might indicate an issue with an admission controller, API service, or Custom Resource Definition (CRD).

```console
# Check that all API resources are working correctly. The following command can be used to list all API resources.
kubectl api-resources

# Sample output
...
NAME                                     SHORTNAMES    APIGROUP                       NAMESPACED   KIND
bindings                                                                              true         Binding
componentstatuses                        cs                                           false        ComponentStatus
configmaps                               cm                                           true         ConfigMap
...
```

The previous command helps you verify that all API resources function correctly. Ensure that the output includes the expected resources without any errors or missing components. By using these `kubectl` commands, you can effectively check the status of AKS Policy and validate the functionality of admission controllers in your Kubernetes cluster. Regularly monitor admission controllers to ensure that they properly function so you can maintain the overall health and stability of your cluster.

Confirm that the policy assignments are applied to your cluster by using the following `kubectl get` command.

```console
kubectl get constrainttemplates
```

> [!NOTE]
> Policy assignments can take [up to 20 minutes to sync](/azure/governance/policy/concepts/policy-for-kubernetes#assign-a-policy-definition) into each cluster.

Your output should be similar to the following example output:

```output
NAME                                     AGE
k8sazureallowedcapabilities              23m
k8sazureallowedusersgroups               23m
k8sazureblockhostnamespace               23m
k8sazurecontainerallowedimages           23m
k8sazurecontainerallowedports            23m
k8sazurecontainerlimits                  23m
k8sazurecontainernoprivilege             23m
k8sazurecontainernoprivilegeescalation   23m
k8sazureenforceapparmor                  23m
k8sazurehostfilesystem                   23m
k8sazurehostnetworkingports              23m
k8sazurereadonlyrootfilesystem           23m
k8sazureserviceallowedports              23m
```

For more information, see:

- [Secure your AKS clusters with Azure Policy](/azure/aks/use-azure-policy)
- [Azure Policy built-in definitions for AKS](/azure/aks/policy-reference).

### Use `kubectl` to validate webhooks

To ensure that validating and mutating webhooks work as expected in a Kubernetes cluster, follow these steps:

Run the following command to list the validating webhooks in the cluster:

```console
kubectl get ValidatingWebhookConfiguration -o wide
```

  The command displays output similar to the following:

```output
NAME                         WEBHOOKS   AGE
aks-node-validating-webhook   1          249d
azure-policy-validating-webhook-configuration   1          249d
gatekeeper-validating-webhook-configuration     1          249d
```

Review the output to verify that the validating webhooks are present and their configurations are as expected. The output includes the name of each validating webhook, the number of webhooks, and the age of each webhook.

Run the following command to list the mutating webhooks in the cluster:

```console
kubectl get MutatingWebhookConfiguration -o wide
```

The command displays output similar to the following:

```output
NAME                         WEBHOOKS   AGE
aks-node-mutating-webhook    1          249d
azure-policy-mutating-webhook-configuration    1          249d
gatekeeper-mutating-webhook-configuration      1          249d
```

Check the output to ensure that the mutating webhooks are listed correctly and their configurations are as desired. The output includes the name of each mutating webhook, the number of webhooks, and the age of each webhook.

Run the following command to retrieve specific details for a particular admission controller:

```console
kubectl get MutatingWebhookConfiguration <mutating-webhook-name> -o yaml
```

Replace `<mutating-webhook-name>` with the actual name of the mutating webhook that you want to retrieve details for. Running this command displays the YAML representation of the specified mutating webhook configuration.

Run these commands and review the output so you can confirm that the validating and mutating webhooks in the Kubernetes cluster are present and configured as expected. This validation is essential to ensure the proper functioning and adherence to policies for validating and modifying resources in the cluster as required by the webhooks.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Kevin Harris](https://www.linkedin.com/in/kevbhar) | Principal Solution Specialist
- [Paolo Salvatori](https://www.linkedin.com/in/paolo-salvatori) | Principal Customer Engineer

Other contributors:

- [Francis Simy Nazareth](https://www.linkedin.com/in/francis-simy-nazereth-971440a) | Senior Technical Specialist

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Related resources

> [!div class="nextstepaction"]
> [Verify the connection to the container registry](aks-triage-container-registry.md)
