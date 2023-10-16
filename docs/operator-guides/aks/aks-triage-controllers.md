---
title: AKS triage - admission controllers
titleSuffix: Azure Architecture Center
description: Learn to validate that the admission controllers are working as expected, as part of a triage step for Azure Kubernetes Service (AKS) clusters.
author: kevingbb
ms.date: 10/12/2020
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

# Validate the admission controllers are working as expected

Check whether the admission controllers are working as expected.

_This article is part of a series. Read the introduction [here](aks-triage-practices.md)._

While issues caused by admission controllers are rare, it is crucial to consider and ensure their proper functionality. This article discusses various scenarios that can impact admission controllers and provides commands using `kubectl` to validate their performance. Here are some examples:

- **Mutating and validating webhooks**: When incorporating mutating and validating webhooks in your Kubernetes cluster, it is imperative to ensure their high availability. Unhealthy nodes should not block API server requests. For instance, the [Azure Policy for Kubernetes clusters](/azure/governance/policy/concepts/policy-for-kubernetes), that extends [Gatekeeper v3](https://open-policy-agent.github.io/gatekeeper), an admission controller webhook for [Open Policy Agent](https://www.openpolicyagent.org/), is an example of a webhook-based admission controller. Similarly, [Kyverno](https://kyverno.io/) runs as a dynamic admission controller in a Kubernetes cluster. Kyverno receives validating and mutating admission webhook HTTP callbacks from the Kubernetes API server and applies matching policies to return results that enforce admission policies or reject requests. It's vital to monitor the admission control pipeline to prevent blocking a significant number of requests to the API server.
- **Service Meshes**: Service meshes, such as [Istio](https://istio.io/) and [Linkerd](https://linkerd.io/), utilize admission controllers to automate the injection of sidecar containers inside your pod, among other functionalities. It's essential  to evaluate and verify the proper functioning of these admission controllers to ensure the seamless operation of the service mesh.

## Admission Controllers

An [admission controller](https://kubernetes.io/docs/reference/access-authn-authz/admission-controllers/) is a piece of code that intercepts requests to the Kubernetes API server prior to persistence of the object, but after the request is authenticated and authorized.

Admission controllers can be either *validating*, *mutating*, or a combination of both. *Mutating* controllers have the ability to modify related objects before admitting the request, while *validating* controllers solely ensure that requests meet specific predefined criteria.

One of the primary functions of admission controllers is to regulate requests involving object creation, deletion, and modification. Additionally, admission controllers have the capacity to restrict custom verbs, such as requesting a connection to a Pod via an API server proxy. However, admission controllers cannot block requests to read objects, including operations like get, watch, or list.

## Using `kubectl` to Azure Policy for Kubernetes clusters

The following commands using `kubectl` enable you to check the status of the [Azure Policy for Kubernetes clusters](/azure/governance/policy/concepts/policy-for-kubernetes) and validate the functionality of admission controllers in your cluster:

```console
# Check Azure Policy pods are running.
kubectl get pod -n gatekeeper-system

# Sample Output
...
NAME                                     READY   STATUS    RESTARTS   AGE
gatekeeper-audit-65844778cb-rkflg        1/1     Running   0          163m
gatekeeper-controller-78797d4687-4pf6w   1/1     Running   0          163m
gatekeeper-controller-78797d4687-splzh   1/1     Running   0          163m
...
```

Running the above command allows you to verify the availability of Azure Policy Agent pods in the `gatekeeper-system` namespace. If the output is not as expected, it may indicate an issue with an admission controller, API service, or Custom Resource Definition (CRD).

```console
# Check that all API Resources are working correctly. The following command can be used to list all API resources.
kubectl api-resources

# Sample Output
...
NAME                                     SHORTNAMES    APIGROUP                       NAMESPACED   KIND
bindings                                                                              true         Binding
componentstatuses                        cs                                           false        ComponentStatus
configmaps                               cm                                           true         ConfigMap
...
```

The above command helps you verify that all API resources are functioning correctly. Ensure that the output includes the expected resources without any errors or missing components. By using these `kubectl` commands, you can effectively check the status of AKS Policy and validate the functionality of admission controllers in your Kubernetes cluster. Regularly monitoring and ensuring the proper functioning of admission controllers is crucial for maintaining the overall health and stability of your cluster.

Confirm the policy assignments are applied to your cluster using the following `kubectl get` command.

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

- [Secure your Azure Kubernetes Service (AKS) clusters with Azure Policy](/azure/aks/use-azure-policy)
- [Azure Policy built-in definitions for Azure Kubernetes Service](/azure/aks/policy-reference).

### Using `kubectl` to validate Webhooks

To ensure that validating and mutating webhooks work as expected in a Kubernetes cluster, follow these steps:

List the validating webhooks in the cluster by running the following command:

```console
kubectl get ValidatingWebhookConfiguration -o wide
```

  The command will display output similar to the following:

```output
NAME                         WEBHOOKS   AGE
aks-node-validating-webhook   1          249d
azure-policy-validating-webhook-configuration   1          249d
gatekeeper-validating-webhook-configuration     1          249d
```

Review the output to verify that the validating webhooks are present and their configurations are as expected. The output includes the name of each validating webhook, the number of webhooks, and the age of each webhook.

List the mutating webhooks in the cluster by running the following command:

```console
kubectl get MutatingWebhookConfiguration -o wide
```

The command will display output similar to the following:

```output
NAME                         WEBHOOKS   AGE
aks-node-mutating-webhook    1          249d
azure-policy-mutating-webhook-configuration    1          249d
gatekeeper-mutating-webhook-configuration      1          249d
```

Check the output to ensure that the mutating webhooks are listed correctly and their configurations are as desired. The output includes the name of each mutating webhook, the number of webhooks, and the age of each webhook.

Retrieve specific details for a particular admission controller by running the following command:

```console
kubectl get MutatingWebhookConfiguration <mutating-webhook-name> -o yaml
```

Replace `<mutating-webhook-name>` with the actual name of the mutating webhook you want to retrieve details for. Running this command will display the YAML representation of the specified mutating webhook configuration.

By executing these commands and reviewing the output, you can confirm that the validating and mutating webhooks in the Kubernetes cluster are present and configured as expected. This validation is essential to ensure the proper functioning and adherence to policies for validating and modifying resources in the cluster as required by the webhooks.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Paolo Salvatori](https://www.linkedin.com/in/paolo-salvatori) | Principal Customer Engineer
- [Kevin Harris](https://www.linkedin.com/in/kevbhar) | Principal Solution Specialist

Other contributors:

- [Francis Simy Nazareth](https://www.linkedin.com/in/francis-simy-nazereth-971440a) | Senior Technical Specialist

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

> [!div class="nextstepaction"]
> [Verify the connection to the container registry](aks-triage-container-registry.md)
