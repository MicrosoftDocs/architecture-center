---
title: Troubleshoot network problems in AKS clusters
description: Learn about steps to take to troubleshoot network problems in Azure Kubernetes Service (AKS) clusters.
author: mosabami
ms.author: miwalters
ms.date: 04/15/2022
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
  - azure-kubernetes-service
categories:
  - containers
ms.custom: fcp
---

# Troubleshoot network problems in AKS clusters

Network problems can occur in new installations of Kubernetes or when you increase the Kubernetes load. Other problems that relate back to networking problems might also occur. Always check the [AKS troubleshooting](/azure/aks/troubleshooting) guide to see whether your problem is described there. This article describes additional details and considerations from a network troubleshooting perspective and specific problems that might arise.  

## Client can't reach the API server

These errors involve connection problems that occur when you can't reach an Azure Kubernetes Service (AKS) cluster's API server through the Kubernetes cluster command-line tool (kubectl) or any other tool, like the REST API via a programming language.

**Error** 

You might see errors that look like these:

```output
Unable to connect to the server: dial tcp <API-server-IP>:443: i/o timeout 
```

```output
Unable to connect to the server: dial tcp <API-server-IP>:443: connectex: A connection attempt
failed because the connected party did not properly respond after a period, or established 
connection failed because connected host has failed to respond. 
```

**Cause 1** 

It's possible that IP ranges authorized by the API server are enabled on the cluster's API server, but the client's IP address isn't included in those IP ranges. To determine whether IP ranges are enabled, use the following `az aks show` command in Azure CLI. If the IP ranges are enabled, the command will produce a list of IP ranges. 

```azurecli
az aks show --resource-group <cluster-resource-group> \ 
    --name <cluster-name> \ 
    --query apiServerAccessProfile.authorizedIpRanges 
```

**Solution 1**

Ensure that your client's IP address is within the ranges authorized by the cluster's API server:

1. Find your local IP address. For information on how to find it on Windows and Linux, see [How to find my IP](/azure/aks/api-server-authorized-ip-ranges#how-to-find-my-ip-to-include-in---api-server-authorized-ip-ranges).

1. Update the range that's authorized by the API server by using the `az aks update` command in Azure CLI. Authorize your client's IP address. For instructions, see [Update a cluster's API server authorized IP ranges](/azure/aks/api-server-authorized-ip-ranges#update-a-clusters-api-server-authorized-ip-ranges).  

**Cause 2**

If your AKS cluster is a private cluster, the API server endpoint doesn't have a public IP address. You need to use a VM that has network access to the AKS cluster's virtual network.  

**Solution 2**

For information on how to resolve this problem, see [options for connecting to a private cluster](/azure/aks/private-clusters#options-for-connecting-to-the-private-cluster).

## Pod fails to allocate the IP address

**Error**

The Pod is stuck in the `ContainerCreating` state, and its events report a `Failed to allocate address` error:

```output
Normal   SandboxChanged          5m (x74 over 8m)    kubelet, k8s-agentpool-00011101-0 Pod sandbox
changed, it will be killed and re-created. 

  Warning  FailedCreatePodSandBox  21s (x204 over 8m)  kubelet, k8s-agentpool-00011101-0 Failed 
create pod sandbox: rpc error: code = Unknown desc = NetworkPlugin cni failed to set up pod 
"deployment-azuredisk6-874857994-487td_default" network: Failed to allocate address: Failed to 
delegate: Failed to allocate address: No available addresses 
```

Check the allocated IP addresses in the plugin IPAM store. You might find that all IP addresses are allocated, but the number is much less than the number of running Pods:

```bash
# Kubenet, for example. The actual path of the IPAM store file depends on network plugin implementation. 
cd /var/lib/cni/networks/kubenet 
ls -al|wc -l 
258 

docker ps | grep POD | wc -l 
7 
```

**Cause 1**

This error can be caused by a bug in the network plugin. The plugin can fail to deallocate the IP address when a Pod is terminated.  

**Solution 1**

Contact Microsoft for a workaround or fix.  

**Cause 2**

Pod creation is much faster than garbage collection of terminated Pods.

**Solution 2**

Configure fast garbage collection for the kubelet. For instructions, see [the Kubernetes garbage collection documentation](https://kubernetes.io/docs/concepts/architecture/garbage-collection/#containers-images).  

## Service not accessible within Pods

The first step to resolving this problem is to check whether endpoints have been created automatically for the service:

```bash
kubectl get endpoints <service-name> 
```

If you get an empty result, your service's label selector might be wrong. Confirm that the label is correct:

```bash
# Query Service LabelSelector. 
kubectl get svc <service-name> -o jsonpath='{.spec.selector}' 

# Get Pods matching the LabelSelector and check whether they're running. 
kubectl get pods -l key1=value1,key2=value2 
```

If the preceding steps return expected values:

- Check whether the Pod `containerPort` is the same as the service `containerPort`. 
- Check whether `podIP:containerPort` is working:

   ```bash
   # Testing via cURL. 
   curl -v telnet ://<Pod-IP>:<containerPort>

   # Testing via Telnet. 
   telnet <Pod-IP>:<containerPort> 
   ```

These are some other potential causes of service problems:

- The container isn't listening to the specified `containerPort`. (Check the Pod description.)
- A CNI plugin error or network route error is occurring.
- kube-proxy isn't running or iptables rules aren't configured correctly.
- Network Policies is dropping traffic. For information on applying and testing Network Policies, see [Azure Kubernetes Network Policies overview](/azure/virtual-network/kubernetes-network-policies).
  - If you're using Calico as your network plugin, you can capture network policy traffic as well. For information on configuring that, see the [Calico site](https://projectcalico.docs.tigera.io/security/calico-network-policy#generate-logs-for-specific-traffic).

## Nodes can't reach the API server

Many add-ons and containers need to access the Kubernetes API (for example, kube-dns and operator containers). If errors occur during this process, the following steps can help you determine the source of the problem.  

First, confirm whether the Kubernetes API is accessible within Pods:

```bash
kubectl run curl --image=mcr.microsoft.com/azure-cli -i -t --restart=Never --overrides='[{"op":"add","path":"/spec/containers/0/resources","value":{"limits":{"cpu":"200m","memory":"128Mi"}}}]' --override-type json --command -- sh
```

Then execute the following from within the container that you now are shelled into.

```bash
# If you don't see a command prompt, try selecting Enter. 
KUBE_TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token) 
curl -sSk -H "Authorization: Bearer $KUBE_TOKEN" https://$KUBERNETES_SERVICE_HOST:$KUBERNETES_SERVICE_PORT/api/v1/namespaces/default/pods
```

Healthy output will look similar to the following.

```output
{ 
  "kind": "PodList", 
  "apiVersion": "v1", 
  "metadata": { 
    "selfLink": "/api/v1/namespaces/default/pods", 
    "resourceVersion": "2285" 
  }, 
  "items": [ 
   ... 
  ] 
} 
```

If an error occurs, check whether the `kubernetes-internal` service and its endpoints are healthy:

```bash
kubectl get service kubernetes-internal
```

```output
NAME                TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE 
kubernetes-internal ClusterIP   10.96.0.1    <none>        443/TCP   25m 
```

```bash
kubectl get endpoints kubernetes-internal
```

```output
NAME                ENDPOINTS          AGE 
kubernetes-internal 172.17.0.62:6443   25m 
```

If both tests return responses like the preceding ones, and the IP and port returned match the ones for your container, it's likely that kube-apiserver isn't running or is blocked from the network.

There are four main reasons why the access might be blocked:

- Your network policies. They might be preventing access to the API management plane. For information on testing Network Policies, see [Network Policies overview](/azure/virtual-network/kubernetes-network-policies).
- Your API's allowed IP addresses. For information about resolving this problem, see [Update a cluster's API server authorized IP ranges](/azure/aks/api-server-authorized-ip-ranges#update-a-clusters-api-server-authorized-ip-ranges).
- Your private firewall. If you route the AKS traffic through a private firewall, make sure there are outbound rules as described in [Required outbound network rules and FQDNs for AKS clusters](/azure/aks/limit-egress-traffic#required-outbound-network-rules-and-fqdns-for-aks-clusters).  
- Your private DNS. If you're hosting a private cluster and you're unable to reach the API server, your DNS forwarders might not be configured properly. To ensure proper communication, complete the steps in [Hub and spoke with custom DNS](/azure/aks/private-clusters#hub-and-spoke-with-custom-dns).  

You can also check kube-apiserver logs by using Container insights. For information on querying kube-apiserver logs, and many other queries, see [How to query logs from Container insights](/azure/azure-monitor/containers/container-insights-log-query#resource-logs).

Finally, you can check the kube-apiserver status and its logs on the cluster itself:

```bash
# Check kube-apiserver status. 
kubectl -n kube-system get pod -l component=kube-apiserver 

# Get kube-apiserver logs. 
PODNAME=$(kubectl -n kube-system get pod -l component=kube-apiserver -o jsonpath='{.items[0].metadata.name}')
kubectl -n kube-system logs $PODNAME --tail 100
```

If a `403 - Forbidden` error returns, kube-apiserver is probably configured with role-based access control (RBAC) and your container's `ServiceAccount` probably isn't authorized to access resources. In this case, you should create appropriate `RoleBinding` and `ClusterRoleBinding` objects. For information about roles and role bindings, see [Access and identity](/azure/aks/concepts-identity#roles-and-clusterroles). For examples of how to configure RBAC on your cluster, see [Using RBAC Authorization](https://kubernetes.io/docs/reference/access-authn-authz/rbac).

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Michael Walters](https://www.linkedin.com/in/mrwalters1988/) | Senior Consultant

Other contributors:

- [Mick Alberts](https://www.linkedin.com/in/mick-alberts-a24a1414) | Technical Writer
- [Ayobami Ayodeji](https://www.linkedin.com/in/ayobamiayodeji) | Senior Program Manager
- [Bahram Rushenas](https://www.linkedin.com/in/bahram-rushenas-306b9b3) | Architect

## Next steps

- [Network concepts for applications in AKS](/azure/aks/concepts-network)
- [Troubleshoot Applications](https://kubernetes.io/docs/tasks/debug/debug-application/)
- [Debug Services](https://kubernetes.io/docs/tasks/debug/debug-application/debug-service/)
- [Kubernetes Cluster Networking](https://kubernetes.io/docs/concepts/cluster-administration/networking)
- [Choose the best networking plugin for AKS](/training/modules/choose-network-plugin-aks)

## Related resources

- [AKS architecture design](../../reference-architectures/containers/aks-start-here.md)
- [Lift and shift to containers with AKS](/azure/cloud-adoption-framework/migrate/)
- [Baseline architecture for an AKS cluster](/azure/architecture/reference-architectures/containers/aks/baseline-aks)
- [AKS baseline for multiregion clusters](../../reference-architectures/containers/aks-multi-region/aks-multi-cluster.yml)
- [AKS day-2 operations guide](../../operator-guides/aks/day-2-operations-guide.md)
  - [Triage practices](../../operator-guides/aks/aks-triage-practices.md)
  - [Patching and upgrade guidance](../../operator-guides/aks/aks-upgrade-practices.md)
  - [Monitoring AKS with Azure Monitor](/azure/aks/monitor-aks)