# Scaling AKS using Virtual Nodes


Sometimes, there are scenarios where you cannot predict or anticipate the the workload that is going to be scheduled for your cluster & that could be related to several events like an Ecommerce website is hosting a <i>Sale</i> or <i>Events booking</i>s & there can be other scenarios as well.
Therefore , to handle these situations you might need rapid scaling .

To rapidly scale application workloads in an AKS cluster, you can use virtual nodes. With virtual nodes, you have qu]ick provisioning of pods, and only pay per second for their execution time. You don't need to wait for Kubernetes cluster autoscaler to deploy VM compute nodes to run the additional pods. Virtual nodes are only supported with Linux pods and nodes. 

Below Architecture can show on how Application pods are scaled
<br/>

![image](https://user-images.githubusercontent.com/50182145/155973004-19c3e845-aa3a-42bf-a85e-ebd626832a2e.png)

<br/>

You can deploy the virtual nodes with AKS using the below links
- [Create virtual nodes using Azure CLI](https://docs.microsoft.com/en-us/azure/aks/virtual-nodes-cli)
- [Create virtual nodes using the portal in Azure Kubernetes Services (AKS)](https://docs.microsoft.com/en-us/azure/aks/virtual-nodes-portal)


Virtual nodes uses ACI instances to rapidly spin up the pods depending upon the conditions that you add in the deployment manifest.


Adding code for SampleApp that helps in provisioning of the pods on Virtual nodes (Refer https://docs.microsoft.com/en-us/azure/aks/virtual-nodes-cli)

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: aci-helloworld
spec:
  replicas: 10
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

If your workload does not fall under the known limitations today (https://docs.microsoft.com/en-us/azure/aks/virtual-nodes#known-limitations), you might want to consider to spliting the workoad across the agentpools & Virtual nodes. Node-affinity can help in the management of the workload across these options. 
