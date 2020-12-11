---
title: Confidential computing on a healthcare platform
titleSuffix: Azure Example Scenarios
description: Learn how to use confidential computing and containers to support a provider-hosted application that securely collaborates with a hospital and a diagnostic provider.
author: agowdamsft
ms.author: agowda
ms.date: 12/9/2020
ms.topic: example-scenario
ms.service: architecture-center
ms.subservice: example-scenario
ms.custom:
- fcp
---
# Confidential computing on a healthcare platform

Learn how to use confidential computing and containers to support a provider-hosted application that securely collaborates with a hospital and a third-party diagnostic provider. Keep hospital data secure from the diagnostic provider while your application leverages the advanced analytics of the machine learning (ML) based applications that the diagnostic provider makes available as confidential computing services.

Your application uses software that applies Azure confidential computing (ACC), which lets you isolate the sensitive data of the hospital patients while it's being processed in the cloud. Azure Kubernetes Service (AKS) hosts confidential computing nodes on its clusters, and Azure Attestation is used to establish trust with the diagnostic provider.

## Potential use cases

Many industries protect their data by using confidential computing for these purposes:

- Securing financial data
- Protecting patient information
- Running ML processes on sensitive information
- Performing algorithms on encrypted datasets from many sources

## Architecture

:::image type="content" source="./media/healthcaredemo-architecture.jpg" alt-text="Diagram of a confidential healthcare platform demonstration, involving a hospital, medical platform provider, and diagnostic provider." border="false":::

1. A clerk for the hospital (*Lamna Hospital*) opens its Azure Blob storage static website to enter patient data.

2. The clerk enters data into the hospital's web portal, which your company (*Contoso Medical Platform Ltd*) powers with a Python Flask-based web API. A confidential node in the [SCONE](https://sconedocs.github.io/#scone-executive-summary) confidential computing software protects the patient data. *SCONE* works within an Azure Kubernetes Service (AKS) hosted cluster.

3. Within the *SCONE* confidential node in the Contoso AKS cluster, the Python code converts the patient data into confidential containers and stores it in encrypted form in memory within the Redis Cache Service, using Microsoft Azure Attestation to establish trust.

4. 

5. The Contoso application sends the protected patient data from the confidential node in its AKS cluster to an enclave in the confidential inferencing Open Neural Network Exchange (ONNX) runtime server, which is hosted in the confidential node of the Fabrikam AKS cluster.

6. The Fabrikam machine learning-based application sends the diagnostic results from the confidential inferencing ONNX runtime server back to the confidential node in the Contoso AKS cluster.

7. The Contoso application sends the diagnostic results from the confidential node in its AKS cluster back to Lamna's client application.

### Components

- [Azure Blob Storage Static Website](/azure/storage/blobs/storage-blob-static-website) serves static content (HTML, CSS, JavaScript, and image files) directly from a storage container.

- [Microsoft Azure Attestation](/azure/attestation/) is a unified solution for remotely verifying the trustworthiness of a platform and the integrity of the binaries running inside of it. Use Azure Attestation to establish trust with the confidential application.

- [AKS Cluster - Hosted](/azure/aks/intro-kubernetes) simplifies the process of deploying a managed Azure Kubernetes Service (AKS) hosted cluster.

- [Confidential Node](/azure/confidential-computing/confidential-nodes-aks-overview) can run sensitive workloads on AKS within a hardware-based trusted execution environment (TEE) by allowing user-level code to allocate private regions of memory, known as enclaves. Confidential computing nodes can support confidential containers or enclave-aware containers.

- [SCONE](https://sconedocs.github.io/) (Secure Container Environment) supports the execution of confidential applications inside of containers running inside a Kubernetes cluster.

- [ONNX RT - Enclave](https://github.com/microsoft/onnx-server-openenclave) (Confidential Inferencing ONNX Runtime Server Enclave) is a host that restricts the machine learning hosting party from accessing both the inferencing request and its corresponding response.

### Alternatives

- [Fortanix](https://www.fortanix.com) can be used instead of SCONE to deploy confidential containers to use with your containerized application. Fortanix provides the flexibility to run and manage the broadest set of applications, including existing applications, new enclave-native applications, and pre-packaged applications.

- [Graphene](https://graphene.readthedocs.io/en/latest/cloud-deployment.html#azure-kubernetes-service-aks) is a lightweight, open-source guest OS that can run a single Linux application in an isolated environment with benefits comparable to running a complete OS. It has good tooling support for converting existing docker container applications to Graphene Shielded Containers (GSC).

## Considerations

### Availability, scalability, and security

The available sizes for Azure confidential computing virtual machines are **DC1s_v2**, **DC2s_v2**, **DC4s_V2**, and **DC8_v2**. You may deploy these sizes only in certain regions. For more information, see [Quickstart: Deploy an Azure Confidential Computing VM in the Marketplace](/azure/confidential-computing/quick-create-marketplace) and [Products available by region](https://azure.microsoft.com/global-infrastructure/services/?products=virtual-machines).

This scenario uses Intel SGX-enabled DCs_v2-series (Gen2) virtual machines. 

## Deploy this scenario

This scenario involves a [confidential Flask-based application](https://sconedocs.github.io/flask_demo/) example adapted from the SCONE website. The Python code, which uses the SCONE Flask web API, executes inside of an Intel Software Guard Extensions (SGX) enclave.

### Set up for inference server deployment

To get ready to deploy the confidential inference server deployment, follow these steps:

1. Clone the example code to your local computer, and then go to the root folder:

    ```bash
    git clone https://github.com/Azure-Samples/confidential-container-samples.git
    cd confidential-container-samples/confidential-healthcare-scone-confinf-onnx
    ```

1. Prepare the inference model by running the model script:

    ```bash
    cd model
    ./run.sh
    ```

    The model script creates the ONNX model file (*unet.onnx*), which is used as part of the deployment of an ONNX runtime confidential inference server.

### Run and test the service

To get the Flask-based service running and tested on your local SGX-enabled computer, follow these steps:

1. Fill in the confidential ONNX deployment's server address and API key, and the Azure application's ID and password. Then run a script that creates an encrypted image and generates some environment variables to store and load. Finally, start the Flask-based service and the Redis Cache Service  using `docker-compose`:

    ```bash
    export CONFONNX_URL=<your deployment server address>
    export CONFONNX_API_KEY=<your deployment API key>
    export CONFONNX_DIR=/path/to/confonnx/repo
    export AZ_APP_ID=<Azure application ID>
    export AZ_APP_PWD=<Azure application password>
    ./create_image.sh
    source myenv
    docker-compose up
    ```

1. Retrieve the API certificate from the SCONE Configuration and Attestation Service) (CAS):

    ```bash
    source myenv
    curl -k -X GET "https://${SCONE_CAS_ADDR-cas}:8081/v1/values/session=$FLASK_SESSION" | jq -r .values.api_ca_cert.value > cacert.pem
    ```

    SCONE CAS issues API certificates to the host name `api`, so we have to use that as the URL name.

    ```bash
    export URL=https://api:4996
    ```

1. To point to the actual address, use the Client URL command (`cURL`). Alternatively, you can edit your */etc/hosts* file.

    ```bash
    curl --cacert cacert.pem -X POST ${URL}/patient/patient_3 -d "fname=Jane&lname=Doe&address='123 Main Street'&city=Richmond&state=Washington&ssn=123-223-2345&email=nr@aaa.com&dob=01/01/2010&contactphone=123-234-3456&drugallergies='Sulpha, Penicillin, Tree Nut'&preexistingconditions='diabetes, hypertension, asthma'&dateadmitted=01/05/2010&insurancedetails='Primera Blue Cross'" --resolve api:4996:127.0.0.1
    curl --cacert cacert.pem -X GET ${URL}/patient/patient_3 --resolve api:4996:127.0.0.1
    curl --cacert cacert.pem -X GET ${URL}/score/patient_3 --resolve api:4996:127.0.0.1
    curl --cacert cacert.pem -X POST ${URL}/delineate -F img=@model/brain-segmentation-pytorch/assets/TCGA_CS_4944.png
    ```

    You might see output similar to the following:

    ```console
    $ curl --cacert cacert.pem -X POST https://localhost:4996/patient/patient_3 -d "fname=Jane&lname=Doe&address='123 Main Street'&city=Richmond&state=Washington&ssn=123-223-2345&email=nr@aaa.com&dob=01/01/2010&contactphone=123-234-3456&drugallergies='Sulpha, Penicillin, Tree Nut'&preexistingconditions='diabetes, hypertension, asthma'&dateadmitted=01/05/2010&insurancedetails='Primera Blue Cross'" --resolve api:4996:127.0.0.1
    {"address":"'123 Main Street'","city":"Richmond","contactphone":"123-234-3456","dateadmitted":"01/05/2010","dob":"01/01/2010","drugallergies":"'Sulpha, Penicillin, Tree Nut'","email":"nr@aaa.com","fname":"Jane","id":"patient_3","insurancedetails":"'Primera Blue Cross'","lname":"Doe","preexistingconditions":"'diabetes, hypertension, asthma'","score":0.1168424489618366,"ssn":"123-223-2345","state":"Washington"}
    $ curl --cacert cacert.pem -X GET localhost:4996/patient/patient_3 --resolve api:4996:127.0.0.1
    {"address":"'123 Main Street'","city":"Richmond","contactphone":"123-234-3456","dateadmitted":"01/05/2010","dob":"01/01/2010","drugallergies":"'Sulpha, Penicillin, Tree Nut'","email":"nr@aaa.com","fname":"Jane","id":"patient_3","insurancedetails":"'Primera Blue Cross'","lname":"Doe","preexistingconditions":"'diabetes, hypertension, asthma'","score":0.1168424489618366,"ssn":"123-223-2345","state":"Washington"}
    $ curl --cacert cacert.pem -X GET localhost:4996/score/patient_3 --resolve api:4996:127.0.0.1
    {"id":"patient_3","score":0.2781606437899131}
    ```

### Execute on a Kubernetes cluster

## Pricing



## Next steps



## Related resources


