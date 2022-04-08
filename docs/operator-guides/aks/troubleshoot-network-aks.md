# Troubleshooting Kubernetes network problems

Network problems can appear in new installations of Kubernetes or when you increase the Kubernetes load. You might also run into problems that relate back to networking problems. Always check the [AKS Troubleshooting](/azure/aks/troubleshooting) guide to see if your problem is described there. This article describes additional details and considerations from a networking troubleshooting perspective and specific problems that might arise.  

## Client can't reach the API server 

These errors involve connection problems to an Azure Kubernetes Service (AKS) cluster when you can't reach the cluster's API server through the Kubernetes cluster command-line tool (kubectl) or any other tool, like the REST API via a programming language. 

**Error** 

You might see errors that look like these:

```
Unable to connect to the server: dial tcp <API-server-IP>:443: i/o timeout 
```

```
Unable to connect to the server: dial tcp <API-server-IP>:443: connectex: A connection attempt
failed because the connected party did not properly respond after a period, or established 
connection failed because connected host has failed to respond. 
```
**Cause 1** 

It's possible that IP ranges authorized by the API server are enabled on the cluster's API server, but the client's IP address isn't included in the IP ranges. To determine whether IP ranges are enabled, use the following `az aks show` command in Azure CLI. If the IP ranges are enabled, the command will produce a list of IP ranges. 

```
az aks show --resource-group <cluster-resource-group> \ 
    --name <cluster-name> \ 
    --query apiServerAccessProfile.authorizedIpRanges 
```

**Solution 1**

Ensure that your client's IP address is within the ranges authorized by the cluster's API server.  

1. Find your local IP address. For information on how to find it on Windows and Linux, see [How to find my IP](/azure/aks/api-server-authorized-ip-ranges#how-to-find-my-ip-to-include-in---api-server-authorized-ip-ranges). 

2. Update the range that's authorized by the API server by using the `az aks update` command in Azure CLI. Authorize your client's IP address. For instructions, see [Update a cluster's API server authorized IP ranges](/azure/aks/api-server-authorized-ip-ranges#update-a-clusters-api-server-authorized-ip-ranges).  

**Cause 2**

If your AKS cluster is a private cluster, the API server endpoint doesn't have a public IP address. You need to use a VM that has network access to the AKS cluster's virtual network.  

**Solution 2**

For information on how to resolve this problem, see [options for connecting to a private cluster](/azure/aks/private-clusters#options-for-connecting-to-the-private-cluster). 
 
## Pod fails to allocate the IP address 

**Error**

The Pod is stuck in the `ContainerCreating` state, and its events report a `Failed to allocate address` error: 

```
Normal   SandboxChanged          5m (x74 over 8m)    kubelet, k8s-agentpool-00011101-0 Pod sandbox
changed, it will be killed and re-created. 

  Warning  FailedCreatePodSandBox  21s (x204 over 8m)  kubelet, k8s-agentpool-00011101-0 Failed 
create pod sandbox: rpc error: code = Unknown desc = NetworkPlugin cni failed to set up pod 
"deployment-azuredisk6-874857994-487td_default" network: Failed to allocate address: Failed to 
delegate: Failed to allocate address: No available addresses 
```
Check the allocated IP addresses in the plugin IPAM store. You might find that all IP addresses are allocated, but the number is much less than the number of running Pods: 

```
# Kubenet, for example. The actual path of the IPAM store file depends on network plugin implementation. 
$ cd /var/lib/cni/networks/kubenet 
$ ls -al|wc -l 
258 

$ docker ps | grep POD | wc -l 
7 
```

**Cause 1**

This error can be caused by a bug in the network plugin. The plugin can fail to deallocate the IP address when Pods are terminated.  

**Solution 1**

Contact Microsoft for a workaround or fix.  

**Cause 2**

Pod creation is much faster than garbage collection of terminated Pods. 

**Solution 2**

You can configure fast garbage collection for the kubelet. For instructions, see [the Kubernetes garbage collection documentation](https://kubernetes.io/docs/concepts/architecture/garbage-collection/#containers-images).  

## Service not accessible within Pods 

The first step is to check whether endpoints have been created automatically for the service:

```
kubectl get endpoints <service-name> 
```

If you get an empty result, your service's label selector might be wrong. Confirm that the label is correct: 

```
# Query Service LabelSelector. 
kubectl get svc <service-name> -o jsonpath='{.spec.selector}' 
# Get Pods matching the LabelSelector and check whether they're running. 
kubectl get pods -l key1=value1,key2=value2 
```

If the preceding steps return expected values: 
- Check whether the Pod `containerPort` is the same as the service `containerPort`. 
- Check whether `podIP:containerPort` is working. 

```
# Testing via cURL 
curl -v telnet ://<PodIP>:<ContainerPort> 
# Testing via Telnet 
telnet <PodIP>:<ContainerPort> 
```

Further, there are also other reasons that could cause service problems. Reasons include: 
- container is not listening to specified containerPort (check pod description again) 
- CNI plugin error or network route error 
- kube-proxy is not running or iptables rules are not configured correctly 
- Network Policies may be dropping traffic. More information on applying and testing Network Policies can be found [here](/azure/virtual-network/kubernetes-network-policies). 
   - If you are using Calico as your network plugin, it is possible to capture the network policy traffic as well. Information on setting this up can be found on the [Calico site](https://projectcalico.docs.tigera.io/security/calico-network-policy#generate-logs-for-specific-traffic). 

## Nodes cannot reach the API Server 

Many addons and containers need to access the Kubernetes API for assorted reasons. (e.g. kube-dns and operator containers). If such errors happen, the steps below can help isolate where the issue resides.  

Confirm whether Kubernetes API is accessible within Pods first: 

```
$ kubectl run curl --image=appropriate/curl -i -t --restart=Never --overrides='[{"op":"add","path":"/spec/containers/0/resources","value":{"limits":{"cpu":"200m","memory":"128Mi"}}}]' --override-type json --command -- sh 
# If you do not see a command prompt, try pressing enter. 
/ # 
/ # KUBE_TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token) 
/ # curl -sSk -H "Authorization: Bearer $KUBE_TOKEN" https://$KUBERNETES_SERVICE_HOST:$KUBERNETES_SERVICE_PORT/api/v1/namespaces/default/pods 
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

If a timeout error is reported, confirm whether the `kubernetes-internal` service and its endpoints are healthy:

```
$ kubectl get service kubernetes-internal 
NAME                TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE 
kubernetes-internal ClusterIP   10.96.0.1    <none>        443/TCP   25m 
$ kubectl get endpoints kubernetes-internal 
NAME                ENDPOINTS          AGE 
kubernetes-internal 172.17.0.62:6443   25m 
```

If both look like the above response and coincide with the correct IP and port for your container, then it is more than likely that kube-apiserver is not running or is blocked from the network. 

There are four locations that the access may be blocked:  
- Your network policies may be preventing the access to the API management plane. Information on testing Network Policies can be found [here](/azure/virtual-network/kubernetes-network-policies). 
- Your API's Allowed IPs. To update your allowed IPs, follow the instructions [found here](https://docs.microsoft.com/en-us/azure/aks/api-server-authorized-ip-ranges#update-a-clusters-api-server-authorized-ip-ranges). 
- Your private firewall. If you route the AKS traffic through a private firewall, you must ensure there are outbound allowances as [outlined here](https://docs.microsoft.com/en-us/azure/aks/limit-egress-traffic#required-outbound-network-rules-and-fqdns-for-aks-clusters).  
- Your private DNS. If you are hosting a private cluster and you’re unable to reach the API server, your DNS forwarders may not be configured properly. Follow the [steps here](https://docs.microsoft.com/en-us/azure/aks/private-clusters#hub-and-spoke-with-custom-dns) to ensure communication can continue.  

You can also check kube-apiserver logs using Container Insights. A guide on how to query kube-apiserver logs as well as many other queries are [documented here](https://docs.microsoft.com/en-us/azure/azure-monitor/containers/container-insights-log-query#resource-logs).   

You can also check kube-apiserver status and its logs on the cluster itself: 

```
# Check kube-apiserver status 
kubectl -n kube-system get pod -l component=kube-apiserver 

# Get kube-apiserver logs 
PODNAME=$(kubectl -n kube-system get pod -l component=kube-apiserver -o jsonpath='{.items[0].metadata.name}') 
kubectl -n kube-system logs $PODNAME --tail 100 
```

If `403 - Forbidden` error is reported, then kube-apiserver is more than likely configured with RBAC and your container's ServiceAccount is not authorized to resources. For such cases, you should create proper RoleBindings and ClusterRoleBindings. For more information surrounding Roles and Role Bindings, please refer to [Access and Identity](https://docs.microsoft.com/en-us/azure/aks/concepts-identity#roles-and-clusterroles). For detailed examples of how to configure RBAC on your cluster, please also see [this Kubernetes document](https://kubernetes.io/docs/reference/access-authn-authz/rbac). 

## Next steps
- [Troubleshoot Applications](https://kubernetes.io/docs/tasks/debug-application-cluster/debug-application)
- [Debug Services](https://kubernetes.io/docs/tasks/debug-application-cluster/debug-service) 
- [Kubernetes Cluster Networking](https://kubernetes.io/docs/concepts/cluster-administration/networking) 
