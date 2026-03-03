---
title: AKS triage—Admission controllers
description: Learn how to verify that the admission controllers are working as expected. This step is part of the triage practices for AKS clusters.
author: francisnazareth
ms.author: fnazaret
ms.date: 01/20/2025
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom:
  - e2e-aks
  - arb-containers
---

# Validate admission controllers

*This article is part of a series. Start with the [overview](aks-triage-practices.md).*

Admission controllers rarely cause problems, but it's crucial to ensure their proper functionality. This article discusses how admission controllers can affect other components when they don't function properly. It also describes commands that you can use to validate admission controller performance.

## Admission controller

An [admission controller](https://kubernetes.io/docs/reference/access-authn-authz/admission-controllers) is code that intercepts requests to the Kubernetes API server after authentication and authorization, but before an object is persisted.

Admission controllers can be *validating*, *mutating*, or a combination of both. *Mutating* controllers can modify related objects before admitting a request. *Validating* controllers solely ensure that requests meet specific predefined criteria.

One of the primary functions of admission controllers is to regulate requests for object creation, deletion, and modification. Additionally, admission controllers can restrict custom verbs, such as requesting a connection to a pod via an API server proxy. However, admission controllers can't block requests to read objects, including operations like `get`, `watch`, or `list`.

Some components can affect admission controllers, such as *mutating and validating webhooks*. When you incorporate mutating and validating webhooks in your Kubernetes cluster, it's imperative to ensure high availability. Unhealthy nodes shouldn't block API server requests. It's vital to monitor the admission control pipeline so requests to the API server aren't blocked. Unhealthy admission controllers can affect mutating and validating webhooks. Webhook-based admission controllers that you should monitor include:  

- [The Azure Policy add-on for Azure Kubernetes Service (AKS) clusters](/azure/governance/policy/concepts/policy-for-kubernetes), which extends [Gatekeeper](https://open-policy-agent.github.io/gatekeeper). Gatekeeper is an admission controller webhook for [Open Policy Agent](https://www.openpolicyagent.org).
  
- [Kyverno](https://kyverno.io), which runs as a dynamic admission controller in a Kubernetes cluster. Kyverno receives validating and mutating admission webhook HTTP callbacks from the Kubernetes API server and applies matching policies to return results that enforce admission policies or reject requests. For troubleshooting reference (such as *APIServer failing webhook calls*), see the [Kyverno troubleshooting documentation](https://kyverno.io/docs/troubleshooting/#api-server-is-blocked).

Alternatively, admission controllers that aren't functioning properly can affect various components, such as *service meshes*. Service meshes, such as [Istio](https://istio.io) and [Linkerd](https://linkerd.io), use admission controllers to automate the injection of sidecar containers inside a pod, among other functionalities. It's important to evaluate and verify that admission controllers function properly to support the consistent operation of a service mesh.

## Check the status of the Azure Policy add-on for AKS clusters

If you install the [Azure Policy add-on for AKS](/azure/governance/policy/concepts/policy-for-kubernetes), you can use the following kubectl commands to validate the installation and functionality of Azure Policy admission controllers in your cluster:

```console
# Verify that Azure Policy pods are running.
kubectl get pod -n gatekeeper-system

# Sample output
...
NAME                                     READY   STATUS    RESTARTS   AGE
gatekeeper-audit-65844778cb-rkflg        1/1     Running   0          163m
gatekeeper-controller-78797d4687-4pf6w   1/1     Running   0          163m
gatekeeper-controller-78797d4687-splzh   1/1     Running   0          163m
...
```

Run the previous command to verify the availability of Azure Policy agent pods in the *gatekeeper-system* namespace. If the output isn't what you expect, it might indicate an issue with an admission controller, API service, or custom resource definition (CRD).

```console
# Check that all API resources are working correctly. Use the following command to list all API resources.
kubectl api-resources

# Sample output
...
NAME                                     SHORTNAMES    APIGROUP                       NAMESPACED   KIND
bindings                                                                              true         Binding
componentstatuses                        cs                                           false        ComponentStatus
configmaps                               cm                                           true         ConfigMap
...
```

The previous command helps you verify that all API resources function correctly. Ensure that the output includes the expected resources without any errors or missing components. Use the `kubectl get pod` and `kubectl api-resources` commands to check the status of the Azure Policy add-on for AKS, and validate the functionality of admission controllers in your Kubernetes cluster. Regularly monitor admission controllers to ensure that they properly function so you can maintain the overall health and stability of your cluster.

Use the following `kubectl get` command to confirm that policy assignments are applied to your cluster:

```console
kubectl get constrainttemplates
```

> [!NOTE]
> Policy assignments can take [up to 20 minutes to sync](/azure/governance/policy/concepts/policy-for-kubernetes#assign-a-policy-definition) with each cluster.

Your output should be similar to the following example:

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

For more information, see the following resources:

- [Secure your AKS clusters with Azure Policy](/azure/aks/use-azure-policy)
- [Azure Policy built-in definitions for AKS](/azure/aks/policy-reference)

### Validate webhooks

To ensure that validating and mutating webhooks work as expected in your Kubernetes cluster, follow these steps.

1. Run the following command to list the validating webhooks in the cluster:

   ```console
   kubectl get ValidatingWebhookConfiguration -o wide
   ```

   Your output should be similar to the following example:

   ```output
   NAME                         WEBHOOKS   AGE
   aks-node-validating-webhook   1          249d
   azure-policy-validating-webhook-configuration   1          249d
   gatekeeper-validating-webhook-configuration     1          249d
   ```

   Review the output to verify that the validating webhooks are present and their configurations are as expected. The output includes the name of each validating webhook, the number of webhooks, and the age of each webhook.

1. Run the following command to list the mutating webhooks in the cluster:

   ```console
   kubectl get MutatingWebhookConfiguration -o wide
   ```

   Your output should be similar to the following example:

   ```output
   NAME                         WEBHOOKS   AGE
   aks-node-mutating-webhook    1          249d
   azure-policy-mutating-webhook-configuration    1          249d
   gatekeeper-mutating-webhook-configuration      1          249d
   ```

   Check the output to ensure that the mutating webhooks are listed correctly and their configurations are as desired. The output includes the name of each mutating webhook, the number of webhooks, and the age of each webhook.

1. Run the following command to retrieve specific details for a particular admission controller:

   ```console
   kubectl get MutatingWebhookConfiguration <mutating-webhook-name> -o yaml
   ```

   Replace `<mutating-webhook-name>` with the name of the mutating webhook that you want to retrieve details for. The output of this command displays the YAML representation of the specified mutating webhook configuration.

Run the commands in this section, and review the output so you can confirm that the validating and mutating webhooks in the Kubernetes cluster are present and configured as expected. This validation is essential to ensure proper functioning. It's also important for ensuring that the webhooks adhere to policies for validating and modifying resources in the cluster.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Paolo Salvatori](https://www.linkedin.com/in/paolo-salvatori) | Principal Customer Engineer

Other contributors:

- [Francis Simy Nazareth](https://www.linkedin.com/in/francis-simy-nazereth-971440a) | Senior Technical Specialist

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Related resources

> [!div class="nextstepaction"]
> [Verify the connection to the container registry](aks-triage-container-registry.md)
