---
title: Deploy highly available Kubernetes cluster on Azure Stack Hub
description: Learn how to deploy a Kubernetes cluster solution for high availability using Azure and Azure Stack Hub.
author: ronmiab
ms.author: robess
ms.service: architecture-center
ms.subservice: azure-guide
ms.topic: conceptual
ms.date: 12/03/2020
ms.lastreviewed: 12/03/2020
categories:
  - hybrid
  - compute
products:
  - azure-stack-hub
---

# Deploy a high availability Kubernetes cluster on Azure Stack Hub

This article will show you how to build a highly available Kubernetes cluster environment, deployed on multiple Azure Stack Hub instances, in different physical locations.

In this solution deployment guide, you learn how to:

> [!div class="checklist"]
>
> - Download and prepare the AKS Engine
> - Connect to the AKS Engine Helper VM
> - Deploy a Kubernetes cluster
> - Connect to the Kubernetes cluster
> - Connect Azure Pipelines to Kubernetes cluster
> - Configure monitoring
> - Deploy application
> - Autoscale application
> - Configure Traffic Manager
> - Upgrade Kubernetes
> - Scale Kubernetes
>
> [!Tip]
> ![Hybrid pillars](media/solution-deployment-guide-cross-cloud-scaling/hybrid-pillars.png)
> Microsoft Azure Stack Hub is an extension of Azure. Azure Stack Hub brings the agility and innovation of cloud computing to your on-premises environment, enabling the only hybrid cloud that allows you to build and deploy hybrid apps anywhere.  
>
> The article [Hybrid app design considerations](/hybrid/app-solutions/overview-app-design-considerations) reviews pillars of software quality (placement, scalability, availability, resiliency, manageability, and security) for designing, deploying, and operating hybrid apps. The design considerations assist in optimizing hybrid app design, minimizing challenges in production environments.

## Prerequisites

Before getting started with this deployment guide, make sure you:

- Review the [High availability Kubernetes cluster pattern](/hybrid/app-solutions/pattern-highly-available-kubernetes) article.
- Review the contents of the [companion GitHub repository](https://github.com/Azure-Samples/azure-intelligent-edge-patterns/tree/master/AKSe-on-AzStackHub), which contains additional assets referenced in this article.
- Have an account that can access the [Azure Stack Hub user portal](/azure-stack/user/azure-stack-use-portal), with at least ["contributor" permissions](/azure-stack/user/azure-stack-manage-permissions).

## Download and prepare AKS Engine

AKS Engine is a binary that can be used from any Windows or Linux host that can reach the Azure Stack Hub Azure Resource Manager endpoints. This guide describes deploying a new Linux (or Windows) VM on Azure Stack Hub. It will be used later when AKS Engine deploys the Kubernetes clusters.

> [!NOTE]
> You can also use an existing Windows or Linux VM to deploy a Kubernetes cluster on Azure Stack Hub using AKS Engine.

The step-by-step process and requirements for AKS Engine are documented here:

- [Install the AKS Engine on Linux in Azure Stack Hub](/azure-stack/user/azure-stack-kubernetes-aks-engine-deploy-linux) (or using [Windows](/azure-stack/user/azure-stack-kubernetes-aks-engine-deploy-windows))

AKS Engine is a helper tool to deploy and operate (unmanaged) Kubernetes clusters (in Azure and Azure Stack Hub).

The details and differences of AKS Engine on Azure Stack Hub are described here:

- [What is the AKS Engine on Azure Stack Hub?](/azure-stack/user/azure-stack-kubernetes-aks-engine-overview)
- [AKS Engine on Azure Stack Hub](https://github.com/Azure/aks-engine/blob/master/docs/topics/azure-stack.md) (on GitHub)

The sample environment will use Terraform to automate the deployment of the AKS Engine VM. You can find the [details and code in the companion GitHub repo](https://github.com/Azure-Samples/azure-intelligent-edge-patterns/blob/master/AKSe-on-AzStackHub/src/tf/aksengine/README.md).

The result of this step is a new resource group on Azure Stack Hub that contains the AKS Engine helper VM and related resources:

![AKS Engine VM Resources in Azure Stack Hub](media/solution-deployment-guide-highly-available-kubernetes/aks-engine-resources-on-azure-stack.png)

> [!NOTE]
> If you have to deploy AKS Engine in a disconnected air-gapped environment, review [Disconnected Azure Stack Hub Instances](https://github.com/Azure/aks-engine/blob/master/docs/topics/azure-stack.md#disconnected-azure-stack-hub-instances) to learn more.

In the next step, we'll use the newly deployed AKS Engine VM to deploy a Kubernetes cluster.

## Connect to the AKS Engine helper VM

First you must connect to the previously created AKS Engine helper VM.

The VM should have a Public IP Address and should be accessible via SSH (Port 22/TCP).

![AKS Engine VM Overview page](media/solution-deployment-guide-highly-available-kubernetes/aks-engine-vm-overview.png)

> [!TIP]
> You can use a tool of your choice like MobaXterm, puTTY or PowerShell in Windows 10 to connect to a Linux VM using SSH.

```console
ssh <username>@<ipaddress>
```

After connecting, run the command `aks-engine`. Go to [Supported AKS Engine Versions](https://github.com/Azure/aks-engine/blob/master/docs/topics/azure-stack.md#supported-aks-engine-versions) to learn more about the AKS Engine and Kubernetes versions.

![aks-engine command line example](media/solution-deployment-guide-highly-available-kubernetes/aks-engine-cmdline-example.png)

## Deploy a Kubernetes cluster

The AKS Engine helper VM itself hasn't created a Kubernetes cluster on our Azure Stack Hub, yet. Creating the cluster is the first action to take in the AKS Engine helper VM.

The step-by-step process is documented here:

* [Deploy a Kubernetes cluster with the AKS engine on Azure Stack Hub](/azure-stack/user/azure-stack-kubernetes-aks-engine-deploy-cluster)

The end result of the `aks-engine deploy` command and the preparations in the previous steps is a fully featured Kubernetes cluster deployed into the tenant space of the first Azure Stack Hub instance. The cluster itself consists of Azure IaaS components like VMs, load balancers, VNets, disks, and so on.

![Cluster IaaS components Azure Stack Hub portal](media/solution-deployment-guide-highly-available-kubernetes/aks-azure-stack-iaas-components.png)

1) Azure load balancer (K8s API Endpoint) 2) Worker Nodes (Agent Pool) 3) Master Nodes

The cluster is now up-and-running and in the next step we'll connect to it.

## Connect to the Kubernetes cluster

You can now connect to the previously created Kubernetes cluster, either via SSH (using the SSH key specified as part of the deployment) or via `kubectl` (recommended). The Kubernetes command-line tool `kubectl` is available for Windows, Linux, and macOS [here](https://kubernetes.io/docs/tasks/tools/install-kubectl/). It's already pre-installed and configured on the master nodes of our cluster:

```console
ssh azureuser@<k8s-master-lb-ip>
```

![Execute kubectl on master node](media/solution-deployment-guide-highly-available-kubernetes/k8s-kubectl-on-master-node.png)

It's not recommended to use the master node as a jumpbox for administrative tasks. The `kubectl` configuration is stored in `.kube/config` on the master node(s) as well as on the AKS Engine VM. You can copy the configuration to an admin machine with connectivity to the Kubernetes cluster and use the `kubectl` command there. The `.kube/config` file is also used later to configure a service connection in Azure Pipelines.

> [!IMPORTANT]
> Keep these files secure because they contain the credentials for your Kubernetes cluster. An attacker with access to the file has enough information to gain administrator access to it. All actions that are done using the initial `.kube/config` file are done using a cluster-admin account.

You can now try various commands using `kubectl` to check the status of your cluster. Here are example commands:

```console
kubectl get nodes
```

```output
NAME                       STATUS   ROLE     VERSION
k8s-linuxpool-35064155-0   Ready    agent    v1.14.8
k8s-linuxpool-35064155-1   Ready    agent    v1.14.8
k8s-linuxpool-35064155-2   Ready    agent    v1.14.8
k8s-master-35064155-0      Ready    master   v1.14.8
```

```console
kubectl cluster-info
```

```output
Kubernetes master is running at https://aks.***
CoreDNS is running at https://aks.***/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
kubernetes-dashboard is running at https://aks.***/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy
Metrics-server is running at https://aks.***/api/v1/namespaces/kube-system/services/https:metrics-server:/proxy
```

> [!IMPORTANT]
> Kubernetes has its own **Role-based Access Control (RBAC)** model that allows you to create fine-grained role definitions and role bindings. This is the preferable way to control access to the cluster instead of handing out cluster-admin permissions.

## Connect Azure Pipelines to Kubernetes clusters

To connect Azure Pipelines to the newly deployed Kubernetes cluster, we need its kubeconfig (`.kube/config`) file as explained in the previous step.

* Connect to one of the master nodes of your Kubernetes cluster.
* Copy the content of the `.kube/config` file.
* Go to Azure DevOps > Project Settings > Service Connections to create a new "Kubernetes" service connection (use KubeConfig as Authentication method)

> [!IMPORTANT]
> Azure Pipelines (or its build agents) must have access to the Kubernetes API. If there is an Internet connection from Azure Pipelines to the Azure Stack Hub Kubernetes cluster, you'll need to deploy a self-hosted Azure Pipelines Build Agent.

When deploying self-hosted Agents for Azure Pipelines, you may deploy either on Azure Stack Hub, or on a machine with network connectivity to all required management endpoints. See the details here:

* [Azure Pipelines agents](/azure/devops/pipelines/agents/agents) on [Windows](/azure/devops/pipelines/agents/v2-windows) or [Linux](/azure/devops/pipelines/agents/v2-linux)

The pattern [Deployment (CI/CD) considerations](/hybrid/app-solutions/pattern-highly-available-kubernetes#deployment-cicd-considerations) section contains a decision flow that helps you to understand whether to use Microsoft-hosted agents or self-hosted agents:

[![Diagram that shows a decision flow of self hosted agents.](media/solution-deployment-guide-highly-available-kubernetes/aks-on-stack-self-hosted-build-agents-yes-or-no.svg)](media/solution-deployment-guide-highly-available-kubernetes/aks-on-stack-self-hosted-build-agents-yes-or-no.svg#lightbox)

*Download a [Visio file](https://arch-center.azureedge.net/solution-deployment-guide-highly-available-kubernetes.vsdx) of all diagrams in this article.*

In this sample solution, the topology includes a self-hosted build agent on each Azure Stack Hub instance. The agent can access the Azure Stack Hub Management Endpoints and the Kubernetes cluster API endpoints.

[![Diagram that shows outbound traffic.](media/solution-deployment-guide-highly-available-kubernetes/azure-stack-architecture-only-outbound-traffic.svg)](media/solution-deployment-guide-highly-available-kubernetes/azure-stack-architecture-only-outbound-traffic.svg#lightbox)

*Download a [Visio file](https://arch-center.azureedge.net/solution-deployment-guide-highly-available-kubernetes.vsdx) of all diagrams in this article.*

This design fulfills a common regulatory requirement, which is to have only outbound connections from the application solution.

## Configure monitoring

You can use [Azure Monitor](/azure/azure-monitor/) for containers to monitor the containers in the solution. This points Azure Monitor to the AKS Engine-deployed Kubernetes cluster on Azure Stack Hub.

There are two ways to enable Azure Monitor on your cluster. Both ways require you to set up a Log Analytics workspace in Azure.

* [Method one](/azure-stack/user/kubernetes-aks-engine-azure-monitor#method-one) uses a Helm Chart
* [Method two](/azure-stack/user/kubernetes-aks-engine-azure-monitor#method-two) as part of the AKS Engine cluster specification

In the sample topology, "Method one" is used, which allows automation of the process and updates can be installed more easily.

For the next step, you need an Azure LogAnalytics Workspace (ID and Key), `Helm` (version 3), and `kubectl` on your machine.

Helm is a Kubernetes package manager, available as a binary that is runs on macOS, Windows, and Linux. It can be downloaded at [helm.sh](https://helm.sh/docs/intro/quickstart). Helm relies on the Kubernetes configuration file used for the `kubectl` command:

```bash
helm repo add incubator https://kubernetes-charts-incubator.storage.googleapis.com/
helm repo update

helm install incubator/azuremonitor-containers \
--set omsagent.secret.wsid=<your_workspace_id> \
--set omsagent.secret.key=<your_workspace_key> \
--set omsagent.env.clusterName=<my_prod_cluster> \
--generate-name
```

This command will install the Azure Monitor agent on your Kubernetes cluster:

```bash
kubectl get pods -n kube-system
```

```output
NAME                                       READY   STATUS
omsagent-8qdm6                             1/1     Running
omsagent-r6ppm                             1/1     Running
omsagent-rs-76c45758f5-lmc4l               1/1     Running
```

The Operations Management Suite (OMS) Agent on your Kubernetes cluster will send monitoring data to your Azure Log Analytics Workspace (using outbound HTTPS). You can now use Azure Monitor to get deeper insights about your Kubernetes clusters on Azure Stack Hub. This design is a powerful way to demonstrate the power of analytics that can be automatically deployed with your application's clusters.

[![Azure Stack Hub clusters in Azure monitor](media/solution-deployment-guide-highly-available-kubernetes/azure-monitor-on-stack-1.png)](media/solution-deployment-guide-highly-available-kubernetes/azure-monitor-on-stack-1.png#lightbox)

[![Azure Monitor cluster details](media/solution-deployment-guide-highly-available-kubernetes/azure-monitor-on-stack-2.png)](media/solution-deployment-guide-highly-available-kubernetes/azure-monitor-on-stack-2.png#lightbox)

> [!IMPORTANT]
> If Azure Monitor does not show any Azure Stack Hub data, please make sure that you have followed the instructions on [how to add AzureMonitor-Containers solution to an Azure Log Analytics workspace](https://github.com/Microsoft/OMS-docker/blob/ci_feature_prod/docs/solution-onboarding.md) carefully.

## Deploy the application

Before installing our sample application, there's another step to configure the nginx-based Ingress controller on our Kubernetes cluster. The Ingress controller is used as a layer 7 load balancer to route traffic in our cluster based on host, path, or protocol. Nginx-ingress is available as a Helm Chart. For detailed instructions, refer to the [Helm Chart GitHub repository](https://github.com/helm/charts/tree/master/stable/nginx-ingress).

Our sample application is also packaged as a Helm Chart, like the [Azure Monitoring Agent](#configure-monitoring) in the previous step. As such, it's straightforward to deploy the application onto our Kubernetes cluster. You can find the [Helm Chart files in the companion GitHub repo](https://github.com/Azure-Samples/azure-intelligent-edge-patterns/tree/master/AKSe-on-AzStackHub/application/helm)

The sample application is a three tier application, deployed onto a Kubernetes cluster on each of two Azure Stack Hub instances. The application uses a MongoDB database. You can learn more about how to get the data replicated across multiple instances in the pattern [Data and Storage considerations](/hybrid/app-solutions/pattern-highly-available-kubernetes#data-and-storage-considerations).

After deploying the Helm Chart for the application, you'll see all three tiers of your application represented as deployments and stateful sets (for the database) with a single pod:

```console
kubectl get pod,deployment,statefulset
```

```output
NAME                                         READY   STATUS
pod/ratings-api-569d7f7b54-mrv5d             1/1     Running
pod/ratings-mongodb-0                        1/1     Running
pod/ratings-web-85667bfb86-l6vxz             1/1     Running

NAME                                         READY
deployment.extensions/ratings-api            1/1
deployment.extensions/ratings-web            1/1

NAME                                         READY
statefulset.apps/ratings-mongodb             1/1
```

On the services, side you'll find the nginx-based Ingress Controller and its public IP address:

```console
kubectl get service
```

```output
NAME                                         TYPE           CLUSTER-IP     EXTERNAL-IP   PORT(S)
kubernetes                                   ClusterIP      10.0.0.1       <none>        443/TCP
nginx-ingress-1588931383-controller          LoadBalancer   10.0.114.180   *public-ip*   443:30667/TCP
nginx-ingress-1588931383-default-backend     ClusterIP      10.0.76.54     <none>        80/TCP
ratings-api                                  ClusterIP      10.0.46.69     <none>        80/TCP
ratings-web                                  ClusterIP      10.0.161.124   <none>        80/TCP
```

The "External IP" address is our "application endpoint". It's how users will connect to open the application and will also be used as the endpoint for our next step [Configure Traffic Manager](#configure-traffic-manager).

## Autoscale the application

You can optionally configure the [Horizontal Pod Autoscaler](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale-walkthrough/) to scale up or down based on certain metrics like CPU utilization. The following command will create a Horizontal Pod Autoscaler that maintains 1 to 10 replicas of the Pods controlled by the ratings-web deployment. HPA will increase and decrease the number of replicas (via the deployment) to maintain an average CPU utilization across all Pods of 80%:

```kubectl
kubectl autoscale deployment ratings-web --cpu-percent=80 --min=1 --max=10
```

You may check the current status of autoscaler by running this command:

```console
kubectl get hpa
```

```output
NAME          REFERENCE                      TARGET    MINPODS   MAXPODS   REPLICAS   AGE
ratings-web   Deployment/ratings-web/scale   0% / 80%  1         10        1          18s
```

## Configure Traffic Manager

To distribute traffic between two (or more) deployments of the application, we'll use [Azure Traffic Manager](/azure/traffic-manager/traffic-manager-overview). Azure Traffic Manager is a DNS-based traffic load balancer in Azure.

> [!NOTE]
> Traffic Manager uses DNS to direct client requests to the most appropriate service endpoint, based on a traffic-routing method and the health of the endpoints.

Instead of using Azure Traffic Manager you can also use other global load-balancing solutions hosted on-premises. In the sample scenario, we'll use Azure Traffic Manager to distribute traffic between two instances of our application. They can run on Azure Stack Hub instances in the same or different locations:

![Diagram that shows an on-premises traffic manager.](media/solution-deployment-guide-highly-available-kubernetes/aks-azure-traffic-manager-on-premises.svg)

*Download a [Visio file](https://arch-center.azureedge.net/solution-deployment-guide-highly-available-kubernetes.vsdx) of all diagrams in this article.*

In Azure, we configure Traffic Manager to point to the two different instances of our application:

[![TM endpoint profile](media/solution-deployment-guide-highly-available-kubernetes/traffic-manager-endpoint-profile-1.png)](media/solution-deployment-guide-highly-available-kubernetes/traffic-manager-endpoint-profile-1.png#lightbox)

As you can see, the two endpoints point to the two instances of the deployed application from the [previous section](#deploy-the-application).

At this point:

- The Kubernetes infrastructure has been created, including an ingress controller.
- Clusters have been deployed across two Azure Stack Hub instances.
- Monitoring has been configured.
- Azure Traffic Manager will load balance traffic across the two Azure Stack Hub instances.
- On top of this infrastructure, the sample three-tier application has been deployed in an automated way using Helm Charts.

The solution should now be up and accessible to users!

There are also some post-deployment operational considerations worth discussing, which are covered in the next two sections.

## Upgrade Kubernetes

Consider the following topics when upgrading the Kubernetes cluster:

- Upgrading a Kubernetes cluster is a complex Day 2 operation that can be done using AKS Engine. For more information, see [Upgrade a Kubernetes cluster on Azure Stack Hub](/azure-stack/user/azure-stack-kubernetes-aks-engine-upgrade).
- AKS Engine allows you to upgrade clusters to newer Kubernetes and base OS image versions. For more information, see [Steps to upgrade to a newer Kubernetes version](/azure-stack/user/azure-stack-kubernetes-aks-engine-upgrade#steps-to-upgrade-to-a-newer-kubernetes-version).
- You can also upgrade only the underlying nodes to newer base OS image versions. For more information, see [Steps to only upgrade the OS image](/azure-stack/user/azure-stack-kubernetes-aks-engine-upgrade#steps-to-only-upgrade-the-os-image).

Newer base OS images contain security and kernel updates. It's the cluster operator's responsibility to monitor the availability of newer Kubernetes Versions and OS Images. The operator should plan and execute these upgrades using AKS Engine. The base OS images must be downloaded from the Azure Stack Hub Marketplace by the Azure Stack Hub Operator.

## Scale Kubernetes

Scale is another Day 2 operation that can be orchestrated using AKS Engine.

The scale command reuses your cluster configuration file (apimodel.json) in the output directory, as input for a new Azure Resource Manager deployment. AKS Engine executes the scale operation against a specific agent pool. When the scale operation is complete, AKS Engine updates the cluster definition in that same apimodel.json file. The cluster definition reflects the new node count in order to reflect the updated, current cluster configuration.

- [Scale a Kubernetes cluster on Azure Stack Hub](/azure-stack/user/azure-stack-kubernetes-aks-engine-scale)

## Next steps

- Learn more about [Hybrid app design considerations](/hybrid/app-solutions/overview-app-design-considerations).
- Review and propose improvements to [the code for this sample on GitHub](https://github.com/Azure-Samples/azure-intelligent-edge-patterns/tree/master/AKSe-on-AzStackHub).
