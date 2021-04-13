This reference implementation shows a set of best practices for building and running a microservices architecture on Microsoft Azure, using Kubernetes.

## Scenario

​Fabrikam, Inc. (a fictional company) is starting a drone delivery service. The company manages a fleet of drone aircraft. Businesses register with the service, and users can request a drone to pick up goods for delivery. When a customer schedules a pickup, a backend system assigns a drone and notifies the user of an estimated delivery time. While the delivery is in progress, the customer can track the drone's location with a continuously updated ETA.

The Drone Delivery application is a sample application that consists of several microservices. Because it's a sample, the functionality is simulated, but the APIs and microservices interactions are intended to reflect real-world design patterns.

![](./images/drone-architecture.png)

<nepeters note - are all of these services represented in the deployment>

- **Ingestion service**: receives client requests and buffers them.
- **Third-party Transportation service**: manages third-party transportation options. - is this the queue?
- **Package service**: manages packages.
- **Scheduler service**: dispatches client requests and manages the delivery workflow.
- **Delivery service**: manages deliveries that are scheduled or in transit.
- Supervisor service: monitors the workflow for failures and applies compensating transactions. - what is this?
- Account service: manages user accounts. - what is this?
- Drone service: schedules drones and monitors drones in flight. - what is this?
- Delivery History service: stores the history of completed deliveries. - what is this?

## Deployment prerequisites

Clone a copy of the drone service application to your development computer or cloud shell environment.

```azurecli-interactive
git clone https://github.com/mspnp/microservices-reference-implementation.git
```

Generate an SSH RSA key pair. These keys are used when deploying the AKS cluster. The SSH rsa key pair can be generated using ssh-keygen, among other tools, on Linux, Mac, or Windows. If you already have an ~/.ssh/id_rsa.pub file, you could provide the same later on. For more information on creating an SSH RSA key pair, see [How to create and use an SSH key pair](https://docs.microsoft.com/azure/virtual-machines/linux/mac-create-ssh-keys).

```azurecli-interactive
ssh-keygen -m PEM -t rsa -b 4096
```

Create a service principal.

```azurecli-interactive
export SP_DETAILS=$(az ad sp create-for-rbac --role="Contributor" -o json) && \
export SP_APP_ID=$(echo $SP_DETAILS | jq ".appId" -r) && \
export SP_CLIENT_SECRET=$(echo $SP_DETAILS | jq ".password" -r) && \
export SP_OBJECT_ID=$(az ad sp show --id $SP_APP_ID -o tsv --query objectId)
```

Populate several environment variables, these valuse are used throughout the application deployment.

```azurecli-interactive
export SSH_PUBLIC_KEY_FILE="~/.ssh/id_rsa.pub"
export LOCATION="eastus"
export RESOURCE_GROUP="aks-microservices-001"
export SUBSCRIPTION_ID=$(az account show --query id --output tsv)
export SUBSCRIPTION_NAME=$(az account show --query name --output tsv)
export TENANT_ID=$(az account show --query tenantId --output tsv)
export DEPLOYMENT_SUFFIX=$(date +%S%N)
export PROJECT_ROOT=.
export K8S=$PROJECT_ROOT/k8s
export HELM_CHARTS=./charts
```

## Deployment

This template created a few resource groups and managed identities that are used throughout the reference implementation.

```azurecli-interactive
export DEV_PREREQ_DEPLOYMENT_NAME=azuredeploy-prereqs-${DEPLOYMENT_SUFFIX}-dev

az deployment sub create --name $DEV_PREREQ_DEPLOYMENT_NAME --location $LOCATION --template-file ${PROJECT_ROOT}/azuredeploy-prereqs.json --parameters resourceGroupName=$RESOURCE_GROUP resourceGroupLocation=$LOCATION
```

In the last step, several managed identities were deployed and are used throughout this implementation. Run these commands to store details about these identities for use throughout the remaining steps.

```azurecli-interactive
export IDENTITIES_DEPLOYMENT_NAME=$(az deployment sub show -n $DEV_PREREQ_DEPLOYMENT_NAME --query properties.outputs.identitiesDeploymentName.value -o tsv) && \
export DELIVERY_ID_NAME=$(az deployment group show -g $RESOURCE_GROUP -n $IDENTITIES_DEPLOYMENT_NAME --query properties.outputs.deliveryIdName.value -o tsv) && \
export DELIVERY_ID_PRINCIPAL_ID=$(az identity show -g $RESOURCE_GROUP -n $DELIVERY_ID_NAME --query principalId -o tsv) && \
export DRONESCHEDULER_ID_NAME=$(az deployment group show -g $RESOURCE_GROUP -n $IDENTITIES_DEPLOYMENT_NAME --query properties.outputs.droneSchedulerIdName.value -o tsv) && \
export DRONESCHEDULER_ID_PRINCIPAL_ID=$(az identity show -g $RESOURCE_GROUP -n $DRONESCHEDULER_ID_NAME --query principalId -o tsv) && \
export WORKFLOW_ID_NAME=$(az deployment group show -g $RESOURCE_GROUP -n $IDENTITIES_DEPLOYMENT_NAME --query properties.outputs.workflowIdName.value -o tsv) && \
export WORKFLOW_ID_PRINCIPAL_ID=$(az identity show -g $RESOURCE_GROUP -n $WORKFLOW_ID_NAME --query principalId -o tsv) && \
export RESOURCE_GROUP_ACR=$(az deployment group show -g $RESOURCE_GROUP -n $IDENTITIES_DEPLOYMENT_NAME --query properties.outputs.acrResourceGroupName.value -o tsv)
```

<nepeters - can we remove this step>

```azurecli-interactive
until az ad sp show --id ${DELIVERY_ID_PRINCIPAL_ID} &> /dev/null ; do echo "Waiting for AAD propagation" && sleep 5; done
until az ad sp show --id ${DRONESCHEDULER_ID_PRINCIPAL_ID} &> /dev/null ; do echo "Waiting for AAD propagation" && sleep 5; done
until az ad sp show --id ${WORKFLOW_ID_PRINCIPAL_ID} &> /dev/null ; do echo "Waiting for AAD propagation" && sleep 5; done
```

Get the latest Kubernetes version available in the region into which you are creating the AKS cluster.

```azurecli-interactive
export KUBERNETES_VERSION=$(az aks get-versions -l $LOCATION --query "orchestrators[?default!=null].orchestratorVersion" -o tsv)
```

Deploy the AKS cluster.

<nepeters - cat ssh, how is this suposed to work>

```azurecli-interactive
export DEV_DEPLOYMENT_NAME=azuredeploy-${DEPLOYMENT_SUFFIX}-dev

az deployment group create -g $RESOURCE_GROUP --name $DEV_DEPLOYMENT_NAME --template-file ${PROJECT_ROOT}/azuredeploy.json \
--parameters servicePrincipalClientId=${SP_APP_ID} \
            servicePrincipalClientSecret=${SP_CLIENT_SECRET} \
            servicePrincipalId=${SP_OBJECT_ID} \
            kubernetesVersion=${KUBERNETES_VERSION} \
            sshRSAPublicKey="$(cat ~/.ssh/id_rsa.pub)" \
            deliveryIdName=${DELIVERY_ID_NAME} \
            deliveryPrincipalId=${DELIVERY_ID_PRINCIPAL_ID} \
            droneSchedulerIdName=${DRONESCHEDULER_ID_NAME} \
            droneSchedulerPrincipalId=${DRONESCHEDULER_ID_PRINCIPAL_ID} \
            workflowIdName=${WORKFLOW_ID_NAME} \
            workflowPrincipalId=${WORKFLOW_ID_PRINCIPAL_ID} \
            acrResourceGroupName=${RESOURCE_GROUP_ACR}
```

Finally, collect a few values that are used throughout the remainder of this reference implementation.

```azurecli-interactive
export ACR_NAME=$(az group deployment show -g $RESOURCE_GROUP -n $DEV_DEPLOYMENT_NAME --query properties.outputs.acrName.value -o tsv) && \
export ACR_SERVER=$(az acr show -n $ACR_NAME --query loginServer -o tsv) && \
export CLUSTER_NAME=$(az group deployment show -g $RESOURCE_GROUP -n $DEV_DEPLOYMENT_NAME --query properties.outputs.aksClusterName.value -o tsv)
```

## Prepare Kubernetes environment

```azurecli-interactive
az aks install-cli
```

```azurecli-interactive
az aks get-credentials --resource-group=$RESOURCE_GROUP --name=$CLUSTER_NAME
```

```azurecli-interactive
kubectl create namespace backend-dev
```

```azurecli-interactive
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
```

<nepeters - what is this step>

```azurecli-interactive
kubectl apply -f $K8S/k8s-rbac-ai.yaml
```

## Configure AAD pod identity and key vault flexvol infrastructure

Instal the AAD POD identity Helm Chart.

```azuercli-interactive
helm repo add aad-pod-identity https://raw.githubusercontent.com/Azure/aad-pod-identity/master/charts
helm install aad-pod-identity aad-pod-identity/aad-pod-identity --set=installCRDs=true --set nmi.allowNetworkPluginKubenet=true --namespace kube-system
```

Install flexvol.

```azuercli-interactive
kubectl create -f https://raw.githubusercontent.com/Azure/kubernetes-keyvault-flexvol/master/deployment/kv-flexvol-installer.yaml
```

## Install ingress controller

```azuercli-interactive
helm install nginx-ingress-dev stable/nginx-ingress --namespace ingress-controllers --set rbac.create=true --set controller.ingressClass=nginx-dev --version 1.24.7 --create-namespace
```

Obtain the load balancer ip address and assign a domain name.

```azurecli-interactive
until export INGRESS_LOAD_BALANCER_IP=$(kubectl get services/nginx-ingress-dev-controller -n ingress-controllers -o jsonpath="{.status.loadBalancer.ingress[0].ip}" 2> /dev/null) && test -n "$INGRESS_LOAD_BALANCER_IP"; do echo "Waiting for load balancer deployment" && sleep 20; done
export INGRESS_LOAD_BALANCER_IP_ID=$(az network public-ip list --query "[?ipAddress!=null]|[?contains(ipAddress, '$INGRESS_LOAD_BALANCER_IP')].[id]" --output tsv)
export EXTERNAL_INGEST_DNS_NAME="${RESOURCE_GROUP}-ingest-dev"
export EXTERNAL_INGEST_FQDN=$(az network public-ip update --ids $INGRESS_LOAD_BALANCER_IP_ID --dns-name $EXTERNAL_INGEST_DNS_NAME --query "dnsSettings.fqdn" --output tsv)
```

Create a self-signed certificate for TLS.

```azurecli-interactive
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -out ingestion-ingress-tls.crt -keyout ingestion-ingress-tls.key -subj "/CN=${EXTERNAL_INGEST_FQDN}/O=fabrikam"
```

## Setup cluster resource quota

```azurecli-interactive
kubectl apply -f $K8S/k8s-resource-quotas-dev.yaml
```

## Deploy the Delivery service

Extract resource details from deployment.

```azurecli-interactive
export COSMOSDB_NAME=$(az deployment group show -g $RESOURCE_GROUP -n $DEV_DEPLOYMENT_NAME --query properties.outputs.deliveryCosmosDbName.value -o tsv) && \
export DATABASE_NAME="${COSMOSDB_NAME}-db" && \
export COLLECTION_NAME="${DATABASE_NAME}-col" && \
export DELIVERY_KEYVAULT_URI=$(az deployment group show -g $RESOURCE_GROUP -n $DEV_DEPLOYMENT_NAME --query properties.outputs.deliveryKeyVaultUri.value -o tsv)
```

Build the Delivery service.

```azurecli-interactive
export DELIVERY_PATH=$PROJECT_ROOT/src/shipping/delivery
```

<nepeters - can we use ACR Build here>

Build and publish the container image.

```azurecli-interactive
docker build --pull --compress -t $ACR_SERVER/delivery:0.1.0 $DELIVERY_PATH/.
az acr login --name $ACR_NAME
docker push $ACR_SERVER/delivery:0.1.0
```

New commands:

```azurecli-interactive
az acr build -r $ACR_NAME -t $ACR_SERVER/delivery:0.1.0 ./src/shipping/delivery/.
```

Deploy the Delivery service.

```azurecli-interactive
export DELIVERY_PRINCIPAL_RESOURCE_ID=$(az group deployment show -g $RESOURCE_GROUP -n $IDENTITIES_DEPLOYMENT_NAME --query properties.outputs.deliveryPrincipalResourceId.value -o tsv) && \
export DELIVERY_PRINCIPAL_CLIENT_ID=$(az identity show -g $RESOURCE_GROUP -n $DELIVERY_ID_NAME --query clientId -o tsv)
export DELIVERY_INGRESS_TLS_SECRET_NAME=delivery-ingress-tls
```

```azurecli-interactive
helm install delivery-v0.1.0-dev $HELM_CHARTS/delivery/ \
     --set image.tag=0.1.0 \
     --set image.repository=delivery \
     --set dockerregistry=$ACR_SERVER \
     --set ingress.hosts[0].name=$EXTERNAL_INGEST_FQDN \
     --set ingress.hosts[0].serviceName=delivery \
     --set ingress.hosts[0].tls=true \
     --set ingress.hosts[0].tlsSecretName=$DELIVERY_INGRESS_TLS_SECRET_NAME \
     --set ingress.tls.secrets[0].name=$DELIVERY_INGRESS_TLS_SECRET_NAME \
     --set ingress.tls.secrets[0].key="$(cat ingestion-ingress-tls.key)" \
     --set ingress.tls.secrets[0].certificate="$(cat ingestion-ingress-tls.crt)" \
     --set identity.clientid=$DELIVERY_PRINCIPAL_CLIENT_ID \
     --set identity.resourceid=$DELIVERY_PRINCIPAL_RESOURCE_ID \
     --set cosmosdb.id=$DATABASE_NAME \
     --set cosmosdb.collectionid=$COLLECTION_NAME \
     --set keyvault.uri=$DELIVERY_KEYVAULT_URI \
     --set reason="Initial deployment" \
     --set tags.dev=true \
     --namespace backend-dev
```


