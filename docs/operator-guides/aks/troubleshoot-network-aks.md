# Troubleshooting Kubernetes network problems

Network problems can appear in new installations of Kubernetes or when you increase the Kubernetes load. You might also run into problems that relate back to networking problems. Always check the [AKS Troubleshooting](/azure/aks/troubleshooting) guide to see if your problem is described there. This article describes additional details and considerations from a networking troubleshooting perspective and specific problems that might arise.  

## Client can't reach the API server 

Below covers connection problems to an Azure Kubernetes Service (AKS) cluster when you cannot reach the cluster's API server through the Kubernetes cluster command-line tool (kubectl) or any other tool, such as using REST API through a programming language. 

Error 

The errors you may see will look like the below 

```
Unable to connect to the server: dial tcp <API-SERVER-IP>:443: i/o timeout 

Unable to connect to the server: dial tcp <API-SERVER-IP>:443: connectex: A connection attempt failed because the connected party did not properly respond after a period, or established connection failed because connected host has failed to respond. 
```
Cause 1:  

API server-authorized IP ranges may have been enabled on the cluster's API server, but the client's IP address was not included in the IP ranges. To check whether this feature has been enabled, see if the following az aks show command in Azure CLI produces a list of IP ranges: 

```
az aks show --resource-group <cluster-resource-group> \ 
    --name <cluster-name> \ 
    --query apiServerAccessProfile.authorizedIpRanges 
```
Solution 1:  

Look at the cluster's API server-authorized ranges, and add your client's IP address within that range.  

1. Find your local IP address. Details on how to achieve this in both Windows and Linux can be [found here](/azure/aks/api-server-authorized-ip-ranges#how-to-find-my-ip-to-include-in---api-server-authorized-ip-ranges). 

2. Update the API server-authorized range with the az aks update command in Azure CLI, using your client IP address. Instructions to update that range can be [found here](/azure/aks/api-server-authorized-ip-ranges#update-a-clusters-api-server-authorized-ip-ranges).  

Cause 2:  

If your AKS Cluster is a Private Cluster, the API server endpoint has no public IP address. You will need to use a VM with network access to the AKS cluster’s virtual network.  

Solution 2:  

For solutions for connecting to a private cluster, please see [options for connecting to the private cluster](/azure/aks/private-clusters#options-for-connecting-to-the-private-cluster) 
 
## Pod failed to allocate IP address 

Error 

Pod stuck on ContainerCreating state, and its events report `Failed to allocate address` error: 

```
Normal   SandboxChanged          5m (x74 over 8m)    kubelet, k8s-agentpool-00011101-0 Pod sandbox changed, it will be killed and re-created. 

  Warning  FailedCreatePodSandBox  21s (x204 over 8m)  kubelet, k8s-agentpool-00011101-0 Failed create pod sandbox: rpc error: code = Unknown desc = NetworkPlugin cni failed to set up pod "deployment-azuredisk6-874857994-487td_default" network: Failed to allocate address: Failed to delegate: Failed to allocate address: No available addresses 
```
Check the allocated IP addresses in the plugin IPAM store, you may find that all IP addresses have been allocated, but the number is much less than the number of running Pods: 

```
# Kubenet for example. The real path of IPAM store file depends on network plugin implementation. 
$ cd /var/lib/cni/networks/kubenet 
$ ls -al|wc -l 
258 

$ docker ps | grep POD | wc -l 
7 
```

Cause 1:  

This can be caused by a bug in the network plugin, which can forget to deallocate the IP address when Pods are terminated.  

Solution 1:  

Contacting Microsoft for a workaround or fix is the best route.  

Cause 2:  

Pod creation is much faster than garbage collection of terminated Pods 

Solution 2:  

A fast garbage collection could be configured for the kubelet. For details on how to do this, please see [the kubernetes garbage collection documentation](https://kubernetes.io/docs/concepts/architecture/garbage-collection/#containers-images).  

## Service not accessible within Pods 

The first step is checking whether endpoints have been created automatically for the service 

```
kubectl get endpoints <service-name> 
```

If you got an empty result, it is possible that your service's label selector is wrong. Confirm it as follows: 

```
# Query Service LabelSelector 
kubectl get svc <service-name> -o jsonpath='{.spec.selector}' 
# Get Pods matching the LabelSelector and check whether they are running 
kubectl get pods -l key1=value1,key2=value2 
```

If all above steps return expected values, confirm further by 
- checking whether Pod containerPort is same with Service containerPort 
- checking whether `podIP:containerPort` is working 

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

## See also
- [Troubleshoot Applications](https://kubernetes.io/docs/tasks/debug-application-cluster/debug-application)
- [Debug Services](https://kubernetes.io/docs/tasks/debug-application-cluster/debug-service) 
- [Kubernetes Cluster Networking](https://kubernetes.io/docs/concepts/cluster-administration/networking) 
