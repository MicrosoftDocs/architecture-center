---
title: Azure Reference Architectures
description: Reference architectures and implementation guidance for common workloads on Azure.
layout: LandingPage
ms.topic: landing-page
ms.date: 05/12/2019
---
<!-- This file is generated! -->
<!-- See the templates in ./build/reference-architectures  -->
<!-- See data in index.json -->

# Azure Reference Architectures

Our reference architectures are arranged by scenario. Each architecture includes recommended practices, along with considerations for scalability, availability, manageability, and security. Most also include a deployable solution or reference implementation.

Jump to: [AI](#ai-and-machine-learning) | [Big data](#big-data-solutions) | [IoT](#internet-of-things) | [Microservices](#microservices) | [Serverless](#serverless-applications) | [Virtual networks](#virtual-networks) | [VM workloads](#vm-workloads) | [SAP](#sap) | [Active Directory](#extend-on-premises-active-directory-to-azure) | [Web apps](#web-applications)

<!-- markdownlint-disable MD033 -->

## AI and machine learning

<ul  class="panelContent cardsF">
<!-- Training of Python scikit-learn models -->
<li style="display: flex; flex-direction: column;">
    <a href="./ai/training-python-models.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardImageOuter">
                        <div class="cardImage">
                            <img src="../_images/icons/python-powered-h.svg" height="140px" />
                        </div>
                    </div>
                    <div class="cardText">
                        <h3>Training of Python scikit-learn models</h3>
                        <p>Recommended practices for tuning the hyperparameters of a scikit-learn Python model.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
<!-- Distributed training of deep learning models -->
<li style="display: flex; flex-direction: column;">
    <a href="./ai/training-deep-learning.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardImageOuter">
                        <div class="cardImage">
                            <img src="../_images/icons/batch-ai.svg" height="140px" />
                        </div>
                    </div>
                    <div class="cardText">
                        <h3>Distributed training of deep learning models</h3>
                        <p>Run distributed training of deep learning models across clusters of GPU-enabled VMs.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
<!-- Batch scoring of Python models -->
<li style="display: flex; flex-direction: column;">
    <a href="./ai/batch-scoring-python.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardImageOuter">
                        <div class="cardImage">
                            <img src="../_images/icons/python-powered-h.svg" height="140px" />
                        </div>
                    </div>
                    <div class="cardText">
                        <h3>Batch scoring of Python models</h3>
                        <p>Batch score many Python models in parallel on a schedule using Azure Machine Learning.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
<!-- Batch scoring for deep learning models -->
<li style="display: flex; flex-direction: column;">
    <a href="./ai/batch-scoring-deep-learning.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardImageOuter">
                        <div class="cardImage">
                            <img src="../_images/icons/batch-ai.svg" height="140px" />
                        </div>
                    </div>
                    <div class="cardText">
                        <h3>Batch scoring for deep learning models</h3>
                        <p>Automate running batch jobs that apply neural style transfer to a video.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
<!-- Real-time scoring of Python and deep learning models -->
<li style="display: flex; flex-direction: column;">
    <a href="./ai/realtime-scoring-python.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardImageOuter">
                        <div class="cardImage">
                            <img src="../_images/icons/python-powered-h.svg" height="140px" />
                        </div>
                    </div>
                    <div class="cardText">
                        <h3>Real-time scoring of Python and deep learning models</h3>
                        <p>Deploy Python models as web services to make real-time predictions, using regular Python models or deep learning models.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
<!-- MLOps for Python models using Azure Machine Learning -->
<li style="display: flex; flex-direction: column;">
    <a href="./ai/mlops-python.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardImageOuter">
                        <div class="cardImage">
                            <img src="../_images/icons/python-powered-h.svg" height="140px" />
                        </div>
                    </div>
                    <div class="cardText">
                        <h3>MLOps for Python models using Azure Machine Learning</h3>
                        <p>Implement a CI/CD and retraining pipeline using Azure DevOps and Azure Machine Learning.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
<!-- Batch scoring of R machine learning models -->
<li style="display: flex; flex-direction: column;">
    <a href="./ai/batch-scoring-R-models.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardImageOuter">
                        <div class="cardImage">
                            <img src="../_images/icons/logo-r.svg" height="140px" />
                        </div>
                    </div>
                    <div class="cardText">
                        <h3>Batch scoring of R machine learning models</h3>
                        <p>Perform batch scoring of R models using Azure Batch.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
<!-- Real-time scoring of R machine learning models -->
<li style="display: flex; flex-direction: column;">
    <a href="./ai/realtime-scoring-r.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardImageOuter">
                        <div class="cardImage">
                            <img src="../_images/icons/logo-r.svg" height="140px" />
                        </div>
                    </div>
                    <div class="cardText">
                        <h3>Real-time scoring of R machine learning models</h3>
                        <p>Implement a real-time prediction service in R using Microsoft Machine Learning Server running in Azure Kubernetes Service (AKS).</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
<!-- Batch scoring of Spark models on Azure Databricks -->
<li style="display: flex; flex-direction: column;">
    <a href="./ai/batch-scoring-databricks.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardImageOuter">
                        <div class="cardImage">
                            <img src="../_images/icons/databricks.png" height="140px" />
                        </div>
                    </div>
                    <div class="cardText">
                        <h3>Batch scoring of Spark models on Azure Databricks</h3>
                        <p>Build a scalable solution for batch scoring an Apache Spark classification model using Azure Databricks.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
<!-- Real-time recommendation API -->
<li style="display: flex; flex-direction: column;">
    <a href="./ai/real-time-recommendation.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardImageOuter">
                        <div class="cardImage">
                            <img src="../_images/icons/machine-learning.svg" height="140px" />
                        </div>
                    </div>
                    <div class="cardText">
                        <h3>Real-time recommendation API</h3>
                        <p>Train a recommendation model using Azure Databricks and deploy it as an API using Azure Machine Learning.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
<!-- Enterprise-grade conversational bot -->
<li style="display: flex; flex-direction: column;">
    <a href="./ai/conversational-bot.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardImageOuter">
                        <div class="cardImage">
                            <img src="../_images/icons/bot-services.svg" height="140px" />
                        </div>
                    </div>
                    <div class="cardText">
                        <h3>Enterprise-grade conversational bot</h3>
                        <p>How to build an enterprise-grade conversational bot using the Azure Bot Framework.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
</ul>

## Big data solutions

<ul  class="panelContent cardsF">
<!-- Enterprise BI with SQL Data Warehouse -->
<li style="display: flex; flex-direction: column;">
    <a href="./data/enterprise-bi-sqldw.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardImageOuter">
                        <div class="cardImage">
                            <img src="../_images/icons/data-guide.svg" height="140px" />
                        </div>
                    </div>
                    <div class="cardText">
                        <h3>Enterprise BI with SQL Data Warehouse</h3>
                        <p>ELT (extract-load-transform) pipeline to move data from an on-premises database into SQL Data Warehouse.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
<!-- Automated enterprise BI with Azure Data Factory -->
<li style="display: flex; flex-direction: column;">
    <a href="./data/enterprise-bi-adf.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardImageOuter">
                        <div class="cardImage">
                            <img src="../_images/icons/data-guide.svg" height="140px" />
                        </div>
                    </div>
                    <div class="cardText">
                        <h3>Automated enterprise BI with Azure Data Factory</h3>
                        <p>Automate an ELT pipeline to perform incremental loading from an on-premises database.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
<!-- Stream processing with Azure Databricks -->
<li style="display: flex; flex-direction: column;">
    <a href="./data/stream-processing-databricks.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardImageOuter">
                        <div class="cardImage">
                            <img src="../_images/icons/databricks.png" height="140px" />
                        </div>
                    </div>
                    <div class="cardText">
                        <h3>Stream processing with Azure Databricks</h3>
                        <p>Stream processing pipeline that joins records from two streams, enriches the result, and calculates a rolling average.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
<!-- Stream processing with Azure Stream Analytics -->
<li style="display: flex; flex-direction: column;">
    <a href="./data/stream-processing-stream-analytics.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardImageOuter">
                        <div class="cardImage">
                            <img src="../_images/icons/azure-analysis-service.svg" height="140px" />
                        </div>
                    </div>
                    <div class="cardText">
                        <h3>Stream processing with Azure Stream Analytics</h3>
                        <p>End-to-end stream processing pipeline that correlates records from two data streams to calculate a rolling average.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
</ul>

## Internet of Things

<ul  class="panelContent cardsF">
<!-- Azure IoT reference architecture -->
<li style="display: flex; flex-direction: column;">
    <a href="./iot/index.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardImageOuter">
                        <div class="cardImage">
                            <img src="./iot/_images/iot.svg" height="140px" />
                        </div>
                    </div>
                    <div class="cardText">
                        <h3>Azure IoT reference architecture</h3>
                        <p>Recommended architecture for IoT applications on Azure using PaaS (platform-as-a-service) components.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
</ul>

## Microservices

<ul  class="panelContent cardsF">
<!-- Microservices on Azure Kubernetes Service (AKS) -->
<li style="display: flex; flex-direction: column;">
    <a href="./microservices/aks.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardImageOuter">
                        <div class="cardImage">
                            <img src="../_images/icons/aks.svg" height="140px" />
                        </div>
                    </div>
                    <div class="cardText">
                        <h3>Microservices on Azure Kubernetes Service (AKS)</h3>
                        <p>Recommended architecture for deploying microservices on AKS.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
<!-- Microservices architecture on Azure Service Fabric -->
<li style="display: flex; flex-direction: column;">
    <a href="./microservices/service-fabric.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardImageOuter">
                        <div class="cardImage">
                            <img src="../_images/icons/sf.svg" height="140px" />
                        </div>
                    </div>
                    <div class="cardText">
                        <h3>Microservices architecture on Azure Service Fabric</h3>
                        <p>Recommended architecture for microservices on Service Fabric.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
</ul>

## Serverless applications

<ul  class="panelContent cardsF">
<!-- Serverless web application -->
<li style="display: flex; flex-direction: column;">
    <a href="./serverless/web-app.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardImageOuter">
                        <div class="cardImage">
                            <img src="../_images/icons/functions.svg" height="140px" />
                        </div>
                    </div>
                    <div class="cardText">
                        <h3>Serverless web application</h3>
                        <p>A serverless web application that serves static content from Blob Storage and implements an API using Azure Functions.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
<!-- Event processing using Azure Functions -->
<li style="display: flex; flex-direction: column;">
    <a href="./serverless/event-processing.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardImageOuter">
                        <div class="cardImage">
                            <img src="../_images/icons/functions.svg" height="140px" />
                        </div>
                    </div>
                    <div class="cardText">
                        <h3>Event processing using Azure Functions</h3>
                        <p>An event-driven architecture that ingests a stream of data and uses Functions to processes the data.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
</ul>

## Virtual networks

<ul  class="panelContent cardsF">
<!-- Hybrid network using a virtual private network (VPN) -->
<li style="display: flex; flex-direction: column;">
    <a href="./hybrid-networking/vpn.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardImageOuter">
                        <div class="cardImage">
                            <img src="../_images/icons/vpn.svg" height="140px" />
                        </div>
                    </div>
                    <div class="cardText">
                        <h3>Hybrid network using a virtual private network (VPN)</h3>
                        <p>Connect an on-premises network to an Azure virtual network.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
<!-- Hybrid network using ExpressRoute -->
<li style="display: flex; flex-direction: column;">
    <a href="./hybrid-networking/expressroute.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardImageOuter">
                        <div class="cardImage">
                            <img src="../_images/icons/expressroute.svg" height="140px" />
                        </div>
                    </div>
                    <div class="cardText">
                        <h3>Hybrid network using ExpressRoute</h3>
                        <p>Use a private, dedicated connection to extend an on-premises network to Azure.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
<!-- Hybrid network using ExpressRoute with VPN failover -->
<li style="display: flex; flex-direction: column;">
    <a href="./hybrid-networking/expressroute-vpn-failover.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardImageOuter">
                        <div class="cardImage">
                            <img src="../_images/icons/expressroute.svg" height="140px" />
                        </div>
                    </div>
                    <div class="cardText">
                        <h3>Hybrid network using ExpressRoute with VPN failover</h3>
                        <p>Use ExpressRoute with a VPN as a failover connection for high availability.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
<!-- Hub-spoke network topology -->
<li style="display: flex; flex-direction: column;">
    <a href="./hybrid-networking/hub-spoke.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardImageOuter">
                        <div class="cardImage">
                            <img src="../_images/icons/gateway.svg" height="140px" />
                        </div>
                    </div>
                    <div class="cardText">
                        <h3>Hub-spoke network topology</h3>
                        <p>Create a central point of connectivity to your on-premises network, while isolating workloads.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
<!-- Hub-spoke topology with shared services -->
<li style="display: flex; flex-direction: column;">
    <a href="./hybrid-networking/shared-services.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardImageOuter">
                        <div class="cardImage">
                            <img src="../_images/icons/gateway.svg" height="140px" />
                        </div>
                    </div>
                    <div class="cardText">
                        <h3>Hub-spoke topology with shared services</h3>
                        <p>Extend a hub-spoke topology by including shared services such as Active Directory.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
<!-- DMZ between Azure and on-premises -->
<li style="display: flex; flex-direction: column;">
    <a href="./dmz/secure-vnet-hybrid.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardImageOuter">
                        <div class="cardImage">
                            <img src="../_images/icons/vnet.svg" height="140px" />
                        </div>
                    </div>
                    <div class="cardText">
                        <h3>DMZ between Azure and on-premises</h3>
                        <p>Use network virtual appliances to create a secure hybrid network.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
<!-- DMZ between Azure and the Internet -->
<li style="display: flex; flex-direction: column;">
    <a href="./dmz/secure-vnet-dmz.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardImageOuter">
                        <div class="cardImage">
                            <img src="../_images/icons/vnet.svg" height="140px" />
                        </div>
                    </div>
                    <div class="cardText">
                        <h3>DMZ between Azure and the Internet</h3>
                        <p>Use network virtual appliances to create a secure network that accepts Internet traffic.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
<!-- Highly available network virtual appliances -->
<li style="display: flex; flex-direction: column;">
    <a href="./dmz/nva-ha.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardImageOuter">
                        <div class="cardImage">
                            <img src="../_images/icons/vnet.svg" height="140px" />
                        </div>
                    </div>
                    <div class="cardText">
                        <h3>Highly available network virtual appliances</h3>
                        <p>Deploy a set of network virtual appliances (NVAs) for high availability in Azure.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
</ul>

## VM workloads

<ul  class="panelContent cardsF">
<!-- N-tier application with SQL Server -->
<li style="display: flex; flex-direction: column;">
    <a href="./n-tier/n-tier-sql-server.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardImageOuter">
                        <div class="cardImage">
                            <img src="../_images/icons/windows.svg" height="140px" />
                        </div>
                    </div>
                    <div class="cardText">
                        <h3>N-tier application with SQL Server</h3>
                        <p>Virtual machines configured for an N-tier application using SQL Server on Windows.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
<!-- Multi-region N-tier application -->
<li style="display: flex; flex-direction: column;">
    <a href="./n-tier/multi-region-sql-server.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardImageOuter">
                        <div class="cardImage">
                            <img src="../_images/icons/windows.svg" height="140px" />
                        </div>
                    </div>
                    <div class="cardText">
                        <h3>Multi-region N-tier application</h3>
                        <p>N-tier application in two regions for high availability, using SQL Server Always On availability groups.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
<!-- N-tier application with Cassandra -->
<li style="display: flex; flex-direction: column;">
    <a href="./n-tier/n-tier-cassandra.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardImageOuter">
                        <div class="cardImage">
                            <img src="../_images/icons/linux-penguin.svg" height="140px" />
                        </div>
                    </div>
                    <div class="cardText">
                        <h3>N-tier application with Cassandra</h3>
                        <p>Virtual machines configured for an N-tier application using Apache Cassandra on Linux.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
<!-- SharePoint Server 2016 farm -->
<li style="display: flex; flex-direction: column;">
    <a href="./sharepoint/index.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardImageOuter">
                        <div class="cardImage">
                            <img src="../_images/icons/sharepoint.svg" height="140px" />
                        </div>
                    </div>
                    <div class="cardText">
                        <h3>SharePoint Server 2016 farm</h3>
                        <p>Highly available SharePoint Server 2016 farm on Azure with SQL Server Always On availability groups.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
</ul>

## SAP

<ul  class="panelContent cardsF">
<!-- SAP NetWeaver -->
<li style="display: flex; flex-direction: column;">
    <a href="./sap/sap-netweaver.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardImageOuter">
                        <div class="cardImage">
                            <img src="../_images/icons/sap.svg" height="140px" />
                        </div>
                    </div>
                    <div class="cardText">
                        <h3>SAP NetWeaver</h3>
                        <p>SAP NetWeaver on Windows, in a high availability environment that supports disaster recovery.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
<!-- SAP S/4HANA -->
<li style="display: flex; flex-direction: column;">
    <a href="./sap/sap-s4hana.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardImageOuter">
                        <div class="cardImage">
                            <img src="../_images/icons/sap.svg" height="140px" />
                        </div>
                    </div>
                    <div class="cardText">
                        <h3>SAP S/4HANA</h3>
                        <p>SAP S/4HANA on Linux, in a high availability environment that supports disaster recovery.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
<!-- SAP HANA on Azure Large Instances -->
<li style="display: flex; flex-direction: column;">
    <a href="./sap/hana-large-instances.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardImageOuter">
                        <div class="cardImage">
                            <img src="../_images/icons/sap.svg" height="140px" />
                        </div>
                    </div>
                    <div class="cardText">
                        <h3>SAP HANA on Azure Large Instances</h3>
                        <p>HANA Large Instances are deployed on physical servers in Azure regions.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
</ul>

## Extend on-premises Active Directory to Azure

<ul  class="panelContent cardsF">
<!-- Integrate with Azure Active Directory -->
<li style="display: flex; flex-direction: column;">
    <a href="./identity/azure-ad.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardImageOuter">
                        <div class="cardImage">
                            <img src="../_images/icons/azure-active-directory.svg" height="140px" />
                        </div>
                    </div>
                    <div class="cardText">
                        <h3>Integrate with Azure Active Directory</h3>
                        <p>Integrate on-premises AD domains with Azure Active Directory.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
<!-- Extend an on-premises Active Directory domain to Azure -->
<li style="display: flex; flex-direction: column;">
    <a href="./identity/adds-extend-domain.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardImageOuter">
                        <div class="cardImage">
                            <img src="../_images/icons/active-directory-vm.svg" height="140px" />
                        </div>
                    </div>
                    <div class="cardText">
                        <h3>Extend an on-premises Active Directory domain to Azure</h3>
                        <p>Deploy Active Directory Domain Services (AD DS) in Azure to extend your on-premises domain.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
<!-- Create an AD DS forest in Azure -->
<li style="display: flex; flex-direction: column;">
    <a href="./identity/adds-forest.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardImageOuter">
                        <div class="cardImage">
                            <img src="../_images/icons/active-directory-vm.svg" height="140px" />
                        </div>
                    </div>
                    <div class="cardText">
                        <h3>Create an AD DS forest in Azure</h3>
                        <p>Create a separate AD domain in Azure that is trusted by your on-premises AD forest.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
<!-- Extend Active Directory Federation Services (AD FS) to Azure -->
<li style="display: flex; flex-direction: column;">
    <a href="./identity/adfs.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardImageOuter">
                        <div class="cardImage">
                            <img src="../_images/icons/active-directory-vm.svg" height="140px" />
                        </div>
                    </div>
                    <div class="cardText">
                        <h3>Extend Active Directory Federation Services (AD FS) to Azure</h3>
                        <p>Use AD FS for federated authentication and authorization for components running in Azure.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
</ul>

## Web applications

<ul  class="panelContent cardsF">
<!-- Basic web application -->
<li style="display: flex; flex-direction: column;">
    <a href="./app-service-web-app/basic-web-app.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardImageOuter">
                        <div class="cardImage">
                            <img src="../_images/icons/app-service.svg" height="140px" />
                        </div>
                    </div>
                    <div class="cardText">
                        <h3>Basic web application</h3>
                        <p>Web application with Azure App Service and Azure SQL Database.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
<!-- Highly scalable web application -->
<li style="display: flex; flex-direction: column;">
    <a href="./app-service-web-app/scalable-web-app.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardImageOuter">
                        <div class="cardImage">
                            <img src="../_images/icons/app-service.svg" height="140px" />
                        </div>
                    </div>
                    <div class="cardText">
                        <h3>Highly scalable web application</h3>
                        <p>Proven practices for improving scalability in a web application.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
<!-- Highly available web application -->
<li style="display: flex; flex-direction: column;">
    <a href="./app-service-web-app/multi-region.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardImageOuter">
                        <div class="cardImage">
                            <img src="../_images/icons/app-service.svg" height="140px" />
                        </div>
                    </div>
                    <div class="cardText">
                        <h3>Highly available web application</h3>
                        <p>Run an App Service web app in multiple regions to achieve high availability.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
<!-- Web application monitoring on Azure -->
<li style="display: flex; flex-direction: column;">
    <a href="./app-service-web-app/app-monitoring.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardImageOuter">
                        <div class="cardImage">
                            <img src="../_images/icons/app-service.svg" height="140px" />
                        </div>
                    </div>
                    <div class="cardText">
                        <h3>Web application monitoring on Azure</h3>
                        <p>Monitor a web application hosted in Azure App Service.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
</ul>