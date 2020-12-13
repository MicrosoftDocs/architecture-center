---
title: Confidential computing on a healthcare platform
titleSuffix: Azure Example Scenarios
description: Learn how to use confidential computing and containers to support a provider-hosted application. Securely collaborate with a hospital and a diagnostic provider.
author: agowdamsft
ms.author: amgowda
ms.date: 12/11/2020
ms.topic: example-scenario
ms.service: architecture-center
ms.subservice: example-scenario
ms.custom:
- fcp
---
# Confidential computing on a healthcare platform

Learn how to use confidential computing and containers to support a provider-hosted application. Securely collaborate with a hospital and a third-party diagnostic provider. Keep hospital data secure from the diagnostic provider. Let your application take advantage of the advanced analytics of the machine learning (ML) based applications that the diagnostic provider makes available as confidential computing services.

Your application uses software that applies Azure confidential computing (ACC). ACC lets you isolate the sensitive data of the hospital patients while the data is being processed in the cloud. Azure Kubernetes Service (AKS) hosts confidential computing nodes on its clusters, and Azure Attestation is used to establish trust with the diagnostic provider.

## Potential use cases

Many industries protect their data by using confidential computing for these purposes:

- Securing financial data
- Protecting patient information
- Running ML processes on sensitive information
- Performing algorithms on encrypted datasets from many sources

## Architecture

:::image type="content" source="./media/healthcaredemo-architecture.jpg" alt-text="Diagram of a confidential healthcare platform demonstration. The platform includes a hospital, medical platform provider, and diagnostic provider." border="false":::

1. A clerk for the hospital (*Lamna Hospital*) opens its Azure Blob storage static website to enter patient data.

2. The clerk enters data into the hospital's web portal, which your company (*Contoso Medical Platform Ltd*) powers with a Python Flask-based web API. A confidential node in the [SCONE](https://sconedocs.github.io/#scone-executive-summary) confidential computing software protects the patient data. SCONE works within an Azure Kubernetes Service (AKS) hosted cluster.

3. Within the SCONE confidential node in the Contoso AKS cluster, the Python code converts the patient data into confidential containers. The code stores the data in encrypted form in memory within the Redis Cache Service, using Microsoft Azure Attestation to establish trust.

4. 

5. The Contoso application sends the protected patient data from its AKS cluster to an enclave in the Open Neural Network Exchange (ONNX) runtime server. The *Fabrikam Diagnostic Provider* hosts this confidential inferencing server in the confidential node of the AKS cluster.

6. The Fabrikam machine learning-based application sends the diagnostic results from the confidential inferencing ONNX runtime server back to the confidential node in the Contoso AKS cluster.

7. The Contoso application sends the diagnostic results from the confidential node back to Lamna's client application.

### Components

- [Azure Blob Storage Static Website](/azure/storage/blobs/storage-blob-static-website) serves static content (HTML, CSS, JavaScript, and image files) directly from a storage container.

- [Microsoft Azure Attestation](/azure/attestation/) is a unified solution to remotely verify the trustworthiness of a platform. Azure Attestation also remotely verifies the integrity of the binaries that run in the platform. Use Azure Attestation to establish trust with the confidential application.

- [AKS Cluster - Hosted](/azure/aks/intro-kubernetes) simplifies the process of deploying a managed Azure Kubernetes Service (AKS) hosted cluster.

- [Confidential Node](/azure/confidential-computing/confidential-nodes-aks-overview) can run sensitive workloads on AKS within a hardware-based trusted execution environment (TEE) by allowing user-level code to allocate private regions of memory, known as enclaves. Confidential computing nodes can support confidential containers or enclave-aware containers.

- Secure Container Environment ([SCONE](https://sconedocs.github.io/)) supports the execution of confidential applications in containers that run inside a Kubernetes cluster.

- [ONNX RT - Enclave](https://github.com/microsoft/onnx-server-openenclave) (Confidential Inferencing ONNX Runtime Server Enclave) is a host that restricts the machine learning hosting party from accessing both the inferencing request and its corresponding response.

### Alternatives

- [Fortanix](https://www.fortanix.com) can be used instead of SCONE to deploy confidential containers to use with your containerized application. Fortanix provides the flexibility to run and manage the broadest set of applications: existing applications, new enclave-native applications, and pre-packaged applications.

- [Graphene](https://graphene.readthedocs.io/en/latest/cloud-deployment.html#azure-kubernetes-service-aks) is a lightweight, open-source guest OS. Graphene can run a single Linux application in an isolated environment with benefits comparable to running a complete OS. It has good tooling support for converting existing Docker container applications to Graphene Shielded Containers (GSC).

## Considerations

### Availability, scalability, and security

The available sizes for Azure confidential computing virtual machines (VMs) are the 2nd-generation D family sizes for general purpose needs, known collectively as D-Series v2 or DCsv2 series. This scenario uses Intel SGX-enabled DCs_v2-series virtual machines with Gen2 operating system (OS) images. The specific available sizes are **DC1s_v2**, **DC2s_v2**, **DC4s_V2**, and **DC8_v2**, where the numerals represent the number of virtual CPUs (vCPUs). You may deploy these sizes only in certain regions. For more information, see [Quickstart: Deploy an Azure Confidential Computing VM in the Marketplace](/azure/confidential-computing/quick-create-marketplace) and [Products available by region](https://azure.microsoft.com/global-infrastructure/services/?products=virtual-machines).

## Deploy this scenario

This scenario involves a [confidential Flask-based application](https://sconedocs.github.io/flask_demo/) example adapted from the SCONE website. The Python code, which uses the SCONE Flask web API, executes in an Intel Software Guard Extensions (SGX) enclave.

To begin scenario deployment, clone the example code to your local computer, and then go to the root folder:

```bash
git clone https://github.com/Azure-Samples/confidential-container-samples.git
cd confidential-container-samples/confidential-healthcare-scone-confinf-onnx
```

### Deploy the confidential inference server

To get ready to deploy the confidential inference server, prepare the inference model by running the model script:

```bash
cd model
./run.sh
```

The model script creates the ONNX model file (*unet.onnx*). This file is used as part of the deployment of an ONNX runtime confidential inference server. To complete the deployment of the confidential inference server, see the [confidential ONNX inference server](https://github.com/microsoft/onnx-server-openenclave) project on GitHub. Note the server address, API key, and deployment directory that you use, because you'll need them in the next section.

### Run and test the service

To get the Flask-based service running and tested on your local SGX-enabled computer:

1. In the shell commands below, replace the confidential ONNX placeholders with actual values for the server address, API key, and directory that you used to deploy the confidential inference server. Also replace the placeholders for the object ID and password of the Azure application. Then run a script that creates an encrypted image and generates some environment variables to store and load. Finally, start the Flask-based service and the Redis Cache Service by running `docker-compose`:

    ```bash
    export CONFONNX_URL=<your deployment server address>
    export CONFONNX_API_KEY=<your deployment API key>
    export CONFONNX_DIR=<path to your deployment server directory, such as /path/to/confonnx/repo>
    export AZ_APP_ID=<Azure application ID>
    export AZ_APP_PWD=<Azure application password>

    cd ..
    ./create_image.sh
    source myenv
    docker-compose up
    ```

1. Retrieve the API certificate from the SCONE configuration and attestation service (CAS) by using the Client URL command (`cURL`) and the `jq` filtering command:

    ```bash
    source myenv
    curl -k -X GET "https://${SCONE_CAS_ADDR-cas}:8081/v1/values/session=$FLASK_SESSION" | jq -r .values.api_ca_cert.value > cacert.pem
    ```

1. Set the URL name. The API certificates are given the host name `api`, so you have to use that string.

    ```bash
    export URL=https://api:4996
    ```

1. Execute test queries with the `cURL` command, using the `--resolve` option to point to the actual address. (Also, you can edit your */etc/hosts* file instead.)

    ```bash
    curl --cacert cacert.pem -X POST ${URL}/patient/patient_3 -d "fname=Jane&lname=Doe&address='123 Main Street'&city=Richmond&state=Washington&ssn=123-223-2345&email=nr@aaa.com&dob=01/01/2010&contactphone=123-234-3456&drugallergies='Sulpha, Penicillin, Tree Nut'&preexistingconditions='diabetes, hypertension, asthma'&dateadmitted=01/05/2010&insurancedetails='Primera Blue Cross'" --resolve api:4996:127.0.0.1
    curl --cacert cacert.pem -X GET ${URL}/patient/patient_3 --resolve api:4996:127.0.0.1
    curl --cacert cacert.pem -X GET ${URL}/score/patient_3 --resolve api:4996:127.0.0.1
    curl --cacert cacert.pem -X POST ${URL}/delineate -F img=@model/brain-segmentation-pytorch/assets/TCGA_CS_4944.png
    ```

    You might see output similar to the following text:

    ```console
    $ curl --cacert cacert.pem -X POST https://localhost:4996/patient/patient_3 -d "fname=Jane&lname=Doe&address='123 Main Street'&city=Richmond&state=Washington&ssn=123-223-2345&email=nr@aaa.com&dob=01/01/2010&contactphone=123-234-3456&drugallergies='Sulpha, Penicillin, Tree Nut'&preexistingconditions='diabetes, hypertension, asthma'&dateadmitted=01/05/2010&insurancedetails='Primera Blue Cross'" --resolve api:4996:127.0.0.1
    {"address":"'123 Main Street'","city":"Richmond","contactphone":"123-234-3456","dateadmitted":"01/05/2010","dob":"01/01/2010","drugallergies":"'Sulpha, Penicillin, Tree Nut'","email":"nr@aaa.com","fname":"Jane","id":"patient_3","insurancedetails":"'Primera Blue Cross'","lname":"Doe","preexistingconditions":"'diabetes, hypertension, asthma'","score":0.1168424489618366,"ssn":"123-223-2345","state":"Washington"}
    $ curl --cacert cacert.pem -X GET localhost:4996/patient/patient_3 --resolve api:4996:127.0.0.1
    {"address":"'123 Main Street'","city":"Richmond","contactphone":"123-234-3456","dateadmitted":"01/05/2010","dob":"01/01/2010","drugallergies":"'Sulpha, Penicillin, Tree Nut'","email":"nr@aaa.com","fname":"Jane","id":"patient_3","insurancedetails":"'Primera Blue Cross'","lname":"Doe","preexistingconditions":"'diabetes, hypertension, asthma'","score":0.1168424489618366,"ssn":"123-223-2345","state":"Washington"}
    $ curl --cacert cacert.pem -X GET localhost:4996/score/patient_3 --resolve api:4996:127.0.0.1
    {"id":"patient_3","score":0.2781606437899131}
    ```

### Execute on a Kubernetes cluster and AKS

Before executing on a Kubernetes cluster, you need to get access to [curated confidential applications called SconeApps](https://sconedocs.github.io/helm/), which the procedure here leads you through. SconeApps are available on a private GitHub repository that currently is available only for commercial customers, through SCONE Standard Edition. Go to the [SCONE website](https://scontain.com/) and contact the company directly to get this service level.

You also need to use Helm, which manages Kubernetes packages. If Helm isn't already installed, you can go to the [Helm website](https://helm.sh/) to install it.

#### Install and run SCONE services

SCONE services that you'll install include the SCONE local attestation service (LAS), the SCONE configuration and attestation service (CAS), and the SGX device plug-in for Kubernetes. To install and run SCONE services:

1. If you don't already have a GitHub personal access token (PAT), go to the [New personal access token](https://github.com/settings/tokens/new) site on GitHub. Next, enter a **Note**, and select **Generate new token** to create a new one. Then copy the new personal access token that appears (a 40-digit hexadecimal number).

1. Paste the GitHub personal access token into the `GH_TOKEN` placeholder and run the shell commands below:

    ```bash
    export GH_TOKEN=<your GitHub personal access token>
    helm repo add sconeapps https://${GH_TOKEN}@raw.githubusercontent.com/scontain/sconeapps/master/
    helm repo update
    ```

1. If you don't already have a Docker Hub personal access token, go to [Managing access tokens](https://docs.docker.com/docker-hub/access-tokens/) on the Docker documentation website. Follow the instructions to create and copy an access token.

1. In the shell commands below, replace the Docker Hub placeholders for the user name, access token, and email address. Then run the shell commands to give SconeApps access to private Docker images:

    ```bash
    export DOCKER_HUB_USERNAME=<your Docker Hub user name>
    export DOCKER_HUB_ACCESS_TOKEN=<your Docker Hub access token>
    export DOCKER_HUB_EMAIL=<your Docker Hub email address>
    
    kubectl create secret docker-registry sconeapps \
        --docker-server=index.docker.io/v1/ \
        --docker-username=$DOCKER_HUB_USERNAME \
        --docker-password=$DOCKER_HUB_ACCESS_TOKEN \
        --docker-email=$DOCKER_HUB_EMAIL
    ```

1. Use Helm to install and start the SCONE LAS and CAS:

    ```bash
    helm install las sconeapps/las --set service.hostPort=true
    helm install cas sconeapps/cas
    ```

1. Use Helm to install the SGX device plug-in for Kubernetes:

    ```bash
    helm install sgxdevplugin sconeapps/sgxdevplugin
    ```

#### Run and test the application

To run and test the Flask-based application:

1. In the following shell commands, replace the `IMAGE` placeholder with the repository address to put the image in (for example, `myregistry.azurecr.io/flask_restapi_image`). Then run the shell commands, which create a Docker image and set its name:

    ```bash
    export IMAGE=<your repository address for the image>
    # Optional: export FLASK_HOSTNAME=<name>.<location>.cloudapp.azure.com
    # Optional: export LETSENCRYPT_CERT_DIR=<certificate directory path, such as /path/to/certs>
    ./create_image.sh
    source myenv
    docker push $IMAGE
    ```

1. Use the Helm chart from the *deploy/helm* repository directory to deploy the application to a Kubernetes cluster:

    ```bash
    helm install api-v1 deploy/helm \
       --set image=$IMAGE \
       --set scone.cas=$SCONE_CAS_ADDR \
       --set scone.flask_session=$FLASK_SESSION/flask_restapi \
       --set scone.redis_session=$REDIS_SESSION/redis \
       --set service.type=LoadBalancer
    ```

    Setting `service.type` to `LoadBalancer` allows the application to get traffic from the internet through a managed load balancer.

1. After all resources are running, use Helm to test the API:

    ```bash
    helm test api-v1
    ```

#### Access the application

To access the confidential Flask-based application:

1. If the application is exposed to the world through a load balancer service type, you can retrieve its CA certificate from the configuration and attestation service:

    ```bash
    source myenv
    curl -k -X GET "https://${SCONE_CAS_ADDR-cas}:8081/v1/values/session=$FLASK_SESSION" | jq -r .values.api_ca_cert.value > cacert.pem
    ```

1. Retrieve the public IP address of the service:

    ```bash
    export SERVICE_IP=$(kubectl get svc --namespace default api-v1-example \
        --template "{{ range (index .status.loadBalancer.ingress 0) }}{{.}}{{ end }}")
    ```

1. Set the URL name. The API certificates are given the host name `api`, so you have to use that string.

    ```bash
    export URL=https://api
    ```

1. Execute test queries with the `cURL` command, using the `--resolve` option to point to the actual address. (Also, you can edit your */etc/hosts* file instead.)

    ```bash
    curl --cacert cacert.pem \
        -X POST ${URL}/patient/patient_3 \
        -d "fname=Jane&lname=Doe&address='123 Main Street'&city=Richmond&state=Washington&ssn=123-223-2345&email=nr@aaa.com&dob=01/01/2010&contactphone=123-234-3456&drugallergies='Sulpha, Penicillin, Tree Nut'&preexistingconditions='diabetes, hypertension, asthma'&dateadmitted=01/05/2010&insurancedetails='Primera Blue Cross'" \
        --resolve api:443:${SERVICE_IP}
    curl --cacert cacert.pem \
        -X POST ${URL}/delineate \
        -F img=@model/brain-segmentation-pytorch/assets/TCGA_CS_4944.png \
        --resolve api:443:${SERVICE_IP}
    ```

#### Deploy and access the web client

To access the deployed enclave service, see the *web_client* folder, which contains a basic static website. Deploy the static website directly to Azure Blob storage, which doesn't have a back-end component. Replace the server URL before you deploy the website.

You can use a [sample brain segmentation image](https://github.com/mateuszbuda/brain-segmentation-pytorch/blob/master/assets/TCGA_CS_4944.png) to try the delineation function that invokes the deployed confidential inference server.

### Clean up resources

To uninstall the resources used to run the confidential healthcare platform, run these shell commands:

```bash
helm delete cas
helm delete las
helm delete sgxdevplugin
helm delete api-v1
kubectl delete pod api-v1-example-test-api
```

## Pricing

To explore the cost of running this scenario, all of the Azure services are preconfigured in the cost calculator. To see how the pricing would change for your particular use case, change the appropriate variables to match your expected traffic.

The following three sample cost profiles are based on the VM size that you select:

- [Small](https://azure.com/e/67f57cced64540dbb8a764c175145c8c): This pricing example correlates to the **DC2s_v2** VM size, which contains two vCPUs.
- [Medium](https://azure.com/e/ddcc24e2e16848388c3556efd8dd3c57): This pricing example correlates to the **DC4s_V2** VM size, which contains four vCPUs.
- [Large](https://azure.com/e/d1732c48c782466b8fa302dfbd4a9887): This pricing example correlates to the **DC8_v2** VM size, which contains eight vCPUs.

## Next steps

[Learn more about Azure confidential computing](/azure/confidential-computing/)

## Related resources

- [Confidential containers on AKS](/azure/confidential-computing/confidential-containers)
- [Official ONNX runtime website](https://www.onnxruntime.ai/)
- [Confidential ONNX inference server (GitHub sample)](https://github.com/microsoft/onnx-server-openenclave)
