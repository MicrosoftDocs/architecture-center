# Bursting the workload in VIrtual Node using AKS

## Introduction

To rapidly scale application workloads in an AKS cluster, you can use virtual nodes. With virtual nodes, you have quick provisioning of pods, and only pay per second for their execution time. You don't need to wait for Kubernetes cluster autoscaler to deploy VM compute nodes to run the additional pods. Virtual nodes are only supported with Linux pods and nodes. For more details on availability , please visit https://docs.microsoft.com/en-us/azure/aks/virtual-nodes

<br/>

## Known Limitations

Virtaul node is fairly a new concept that is getting developed & has few limitations. Before taking the decision around whether Virtual Node can be the best-fit for your workload , please also go through https://docs.microsoft.com/en-us/azure/aks/virtual-nodes#known-limitations

<br/>

## Virtual Node In Action

1. Start ahead with creation of virtual nodes 
    - [Create virtual nodes using Azure CLI](https://docs.microsoft.com/en-us/azure/aks/virtual-nodes-cli)
    - [Create virtual nodes using the portal in Azure Kubernetes Services (AKS)](https://docs.microsoft.com/en-us/azure/aks/virtual-nodes-portal)
2. Now verify that your virtaul node is enabled
```console
kubectl get nodes
```

The following example output shows the single VM node created and then the virtual node for Linux, *virtual-node-aci-linux*:

```output
NAME                           STATUS    ROLES     AGE       VERSION
virtual-node-aci-linux         Ready     agent     28m       v1.11.2
aks-agentpool-14693408-0       Ready     agent     32m       v1.11.2
```

3. Now, its time to deploy the SampleApp
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: aci-helloworld
spec:
  replicas: 1
  selector:
    matchLabels:
      app: aci-helloworld
  template:
    metadata:
      labels:
        app: aci-helloworld
    spec:
      containers:
      - name: aci-helloworld
        image: mcr.microsoft.com/azuredocs/aci-helloworld
        ports:
        - containerPort: 80
      nodeSelector:
        kubernetes.io/role: agent
        beta.kubernetes.io/os: linux
        type: virtual-kubelet
      tolerations:
      - key: virtual-kubelet.io/provider
        operator: Exists
      - key: azure.com/aci
        effect: NoSchedule
```

4. There could be scenarios where you're looking to split the workoad across the agentpools & Virtual nodes  , therefore you can also use pod-affinity that can help in splitting the workload however that can only be possible if your workload does not fall under the known limitations today (https://docs.microsoft.com/en-us/azure/aks/virtual-nodes#known-limitations)

