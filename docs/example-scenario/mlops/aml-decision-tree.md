---
title: Azure Machine Learning Development - Decision Guide for Optimal Tool Selection
titleSuffix: Technical White Paper
description: How to choose the best services for building an end-to-end machine learning pipeline from experimentation to deployment.
author: Dan Azlin (v-daazli@microsoft.com)
ms.date: 06/01/2020
ms.topic: MLOps, MLOps Maturity Model
ms.service: architecture-center
ms.subservice: example-scenario
ms.custom:
    - fcp
    - cse
ms.category:
    - developer-tools
    - hybrid
social_image_url: /azure/architecture/example-scenario/serverless/media/mlops.png

---

<!-- cSpell:ignore Apigee -->

# Azure Machine Learning Development: Decision Guide for Optimal Tool Selection

## Introduction

Microsoft Azure offers a myriad of services and capabilities. Building an end-to-end machine learning pipeline from experimentation to deployment often requires bringing together a set of services from across Azure. While it may be possible to have one pipeline “do it all,” so to speak, there are tradeoffs when not utilizing the services for what they are best at.

So, when is it worth it to adopt each service for your use case? The answer is that it often depends on a variety of factors that are not necessarily related to the functional requirements. The main factors are:

* The skillsets on the team
* How the Azure service plugs into the existing architecture in place
* The maintainability of the solution build using this service
* The cost of these services at scale

### Scope

The scope of this document is focused on Azure services that are used to support data or machine learning workloads. This document does not consider third-party solutions available through Azure Marketplace. While not exhaustive, this document covers the most popular options on Azure for supporting the end to end workflow:

1. Experimentation
2. Overall Orchestration/Scheduling
3. Data Transfer
4. Data Transformation
5. Model Training
6. Model Deployment
7. Monitoring

## Options Considered

As mentioned, Azure offers many services and capabilities but this document is not exhaustive. Listed below are the Azure services options that were considered under each category.

TABLE 1 - OPTIONS CONSIDERED

<table class=MsoTableGrid border=1 cellspacing=0 cellpadding=0 style='border-collapse:collapse;border:none;width:90%;'>
 <thead>
  <tr>
   <td valign=top style='width:35%;border:solid windowtext 1.0pt;background:#D9E2F3;padding:0in 5.4pt 4pt 5.4pt'>
   <p align=center style='margin-bottom:0in;margin-bottom:.0001pt;text-align:center;line-height:normal'><b>Category</b></p>
   </td>
   <td valign=top style='border:solid windowtext 1.0pt;border-left:none;background:#D9E2F3;padding:0in 5.4pt 4pt 5.4pt'>
   <p align=center style='margin-bottom:0in;margin-bottom:.0001pt;text-align:center;line-height:normal;font-weight: bold;'><span style='color:black'>Options</span></p>
   </td>
  </tr>
 </thead>
 <tr>
  <td valign=top style='border:solid windowtext 1.0pt;border-top:none;padding:0in 5.4pt 4pt 5.4pt'>
  <p style='margin-bottom:0in;margin-bottom:.0001pt;line-height:normal;font-weight: bold;'>Experimentation</p>
  </td>
  <td  valign=top style='border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 5.4pt 4pt 5.4pt'>
  <ul style="">
  <li style='margin-bottom:0in;margin-bottom:.0001pt;line-height:normal'><a
  href="https://azure.microsoft.com/en-us/blog/three-things-to-know-about-azure-machine-learning-notebook-vm/">Azure Machine Learning Notebook VMs</a></li>
  <li style='margin-bottom:0in;margin-bottom:.0001pt;line-height:normal'><a href="https://docs.databricks.com/notebooks/index.html">Databricks Notebooks</a></li>
  <li style='margin-bottom:0in;margin-bottom:.0001pt;line-height:normal'><a
  href="https://docs.microsoft.com/en-us/python/api/overview/azure/ml/?view=azure-ml-py">Azure Machine Learning Experiment for Python SDK</a></li>
  <li style='margin-bottom:0in;margin-bottom:.0001pt;line-height:normal'><a
  href="https://docs.microsoft.com/en-us/azure/machine-learning/data-science-virtual-machine/">DSVM</a></li></ul>
  </td>
 </tr>
 <tr>
  <td valign=top style='border:solid windowtext 1.0pt;border-top:none;padding:0in 5.4pt 4pt 5.4pt'>
  <p style='margin-bottom:0in;margin-bottom:.0001pt;line-height:normal;font-weight: bold;'>Overall Orchestration / Scheduling</p>
  </td>
  <td  valign=top style='border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 5.4pt 4pt 5.4pt'>
  <ul>
  <li style='margin-bottom:0in;margin-bottom:.0001pt;line-height:normal'><a href="https://docs.microsoft.com/en-us/azure/logic-apps/logic-apps-overview">Logic Apps</a></li>
  <li style='margin-bottom:0in;margin-bottom:.0001pt;line-height:normal'><a
  href="https://docs.microsoft.com/en-us/azure/data-factory/introduction">Azure Data Factory</a></li>
  <li style='margin-bottom:0in;margin-bottom:.0001pt;line-height:normal'><a
  href="https://docs.microsoft.com/en-us/azure/machine-learning/concept-ml-pipelines">Azure Machine Learning Pipelines</a></li>
  <li style='margin-bottom:0in;margin-bottom:.0001pt;line-height:normal'><a href="https://docs.microsoft.com/en-us/azure/devops/?view=azure-devops">Azure DevOps</a></li></ul>
  </td>
 </tr>
 <tr>
  <td valign=top style='border:solid windowtext 1.0pt;border-top:none;padding:0in 5.4pt 4pt 5.4pt'>
  <p style='margin-bottom:0in;margin-bottom:.0001pt;line-height:normal;font-weight:bold;'>Data Transfer</p>
  </td>
  <td  valign=top style='border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0in 5.4pt 4pt 5.4pt'>
  <ul>
  <li style='margin-bottom:0in;margin-bottom:.0001pt;line-height:normal'><a href="https://docs.microsoft.com/en-us/azure/data-factory/copy-activity-overview">Azure Data Factory Copy Activity</a></li>
  <li style='margin-bottom:0in;margin-bottom:.0001pt;line-height:normal'><a href="https://docs.microsoft.com/en-us/python/api/azureml-pipeline-steps/azureml.pipeline.steps.data_transfer_step.datatransferstep?view=azure-ml-py">Azure Machine Learning DataTransferStep</a></li></ul>
  </td>
 </tr>
 <tr>
  <td valign=top style='border:solid windowtext 1.0pt;border-top:none;padding:0in 5.4pt 4pt 5.4pt'>
  <p style='margin-bottom:0in;margin-bottom:.0001pt;line-height:normal;font-weight:bold;'>Compute</p>
  </td>
  <td  valign=top style='border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 5.4pt 4pt 5.4pt'>
  <ul>
  <li style='margin-bottom:0in;margin-bottom:.0001pt;line-height:normal'><a href="https://docs.microsoft.com/en-us/azure/azure-databricks/what-is-azure-databricks">Databricks</a></li>
  <li style='margin-bottom:0in;margin-bottom:.0001pt;line-height:normal'><a href="https://docs.microsoft.com/en-us/azure/machine-learning/concept-compute-instance">Azure Machine Learning Compute</a></li></ul>
  </td>
 </tr>
 <tr>
  <td valign=top style='border:solid windowtext 1.0pt;border-top:none;padding:0in 5.4pt 4pt 5.4pt'>
  <p style='margin-bottom:0in;margin-bottom:.0001pt;line-height:normal;font-weight:bold;'>Tracking / Versioning options</p>
  <p style='margin-bottom:0in;margin-bottom:.0001pt;line-height:normal;font-weight:bold;'>&nbsp;</p>
  </td>
  <td  valign=top style='border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 5.4pt 4pt 5.4pt'>
  <ul>
  <li style='margin-bottom:0in;margin-bottom:.0001pt;line-height:normal'>Experiment/Hyper-tuning Tracking:</li>
  <ul>
  <li><a href="https://docs.microsoft.com/en-us/azure/machine-learning/studio/create-experiment">Azure Machine Learning Experiments</a></li>
  <li><a href="https://docs.databricks.com/applications/mlflow/quick-start.html">Databricks &amp; MLFLow Tracking</a></li></ul>
  <li style='margin-bottom:0in;margin-bottom:.0001pt;line-height:normal'><a href="https://docs.microsoft.com/en-us/azure/machine-learning/how-to-version-track-datasets">Data Versioning/Data Drift: Azure Machine Learning Datasets</a></li>
  <li style='margin-bottom:0in;margin-bottom:.0001pt;line-height:normal'>Model Versioning:</li>
  <ul>
  <li><a href="https://docs.microsoft.com/en-us/azure/machine-learning/concept-model-management-and-deployment">Azure Machine Learning Model Management Service</a></li>
  <li><a href="https://databricks.com/blog/2019/10/17/introducing-the-mlflow-model-registry.html">Databricks &amp; MLFlow Model Registry</a></li></ul></ul>
  </td>
 </tr>
 <tr>
  <td valign=top style='border:solid windowtext 1.0pt;border-top:none;padding:0in 5.4pt 4pt 5.4pt'>
  <p style='margin-bottom:0in;margin-bottom:.0001pt;line-height:normal;font-weight:bold;'>Model Training</p>
  </td>
  <td  valign=top style='border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 5.4pt 4pt 5.4pt'>
  <ul>
  <li style='margin-bottom:0in;margin-bottom:.0001pt;line-height:normal'><a href="https://docs.microsoft.com/en-us/azure/machine-learning/concept-ml-pipelines">Azure Machine Learning Pipelines</a></li>
  <li style='margin-bottom:0in;margin-bottom:.0001pt;line-height:normal'><a href="https://docs.databricks.com/data/index.html">Databricks</a></li></ul>
  </td>
 </tr>
 <tr>
  <td valign=top style='border:solid windowtext 1.0pt;border-top:none;padding:0in 5.4pt 4pt 5.4pt'>
  <p style='margin-bottom:0in;margin-bottom:.0001pt;line-height:normal;font-weight:bold;'>Model Deployment</p>
  </td>
  <td  valign=top style='border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 5.4pt 4pt 5.4pt'>
  <ul>
  <li style='margin-bottom:0in;margin-bottom:.0001pt;line-height:normal'><a href="https://docs.microsoft.com/en-us/azure/machine-learning/tutorial-pipeline-batch-scoring-classification">Batch Scoring in Azure Machine Learning Pipeline</a></li>
  <li style='margin-bottom:0in;margin-bottom:.0001pt;line-height:normal'><a href="https://docs.microsoft.com/en-us/azure/machine-learning/how-to-deploy-and-where">Real-time Deployment in Azure Machine Learning Service</a></li>
  <ul>
  <li><a href="https://docs.microsoft.com/en-us/azure/aks/intro-kubernetes">AKS (Azure Kubernetes Service)</a></li>
  <li><a href="https://docs.microsoft.com/en-us/azure/container-instances/">Azure Container Instance</a></li>
  <li><a href="https://docs.microsoft.com/en-us/azure/app-service/">Azure App Service</a></li>
  <li><a href="https://docs.microsoft.com/en-us/azure/azure-functions/">Azure Functions</a></li>
  <li><a href="https://docs.microsoft.com/en-us/azure/iot-edge/about-iot-edge">IoT Edge</a></li>
  <li><a href="https://docs.microsoft.com/en-us/azure/machine-learning/how-to-deploy-and-where#choose-a-compute-target">and
  more</a></li></ul></ul>
  </td>
 </tr>
 <tr>
  <td valign=top style='border:solid windowtext 1.0pt;border-top:none;padding:0in 5.4pt 4pt 5.4pt'>
  <p style='margin-bottom:0in;margin-bottom:.0001pt;line-height:normal;font-weight:bold;'>Monitoring</p>
  </td>
  <td  valign=top style='border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 5.4pt 4pt 5.4pt'>
  <ul>
  <li style='margin-bottom:0in;margin-bottom:.0001pt;line-height:normal'><a
  href="https://docs.microsoft.com/en-us/azure/azure-monitor/overview">Azure Monitor</a></li>
  <ul>
  <li><a href="https://docs.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview">Application Insights</a></li>
  <li><a href="https://docs.microsoft.com/en-us/azure/azure-monitor/learn/tutorial-app-dashboards">Azure Dashboards</a></li></ul>
  <li style='margin-bottom:0in;margin-bottom:.0001pt;line-height:normal'><a href="https://docs.microsoft.com/en-us/power-bi/service-azure-and-power-bi">Power BI</a></li></ul>
  </td>
 </tr>
</table>

## Decision Tree

### Code or No Code

The first decision is whether to use a No Code implementation approach or the traditional Code approach. Each has its own tradeoffs.

### No Code

For those who do not want to code their own solutions, a set of tools is available for building workflows without writing any code. These include:
* For Experimentation, use Azure Machine Learning Designer. 
* For Overall Orchestration/Scheduling, use Logic Apps, especially if integrating to Office 365 suite (Outlook, etc.)
* For Data Transfer and Data Transformation, use Data Factory Data Flows. If datasets are very simple and smaller scale, they can also be handled in Azure Machine Learning Designer.
* For Model Training and Model Deployment, use Azure Machine Learning Designer. It supports both real-time and batch deployments.
* For Monitoring, use Azure Monitor with Azure Dashboards, which lets you click to pin visuals and set up alerts without code. For more configuration, Power BI can also be used to create historical dashboards.
The primary issue you’ll encounter here is that you must work within the constraints of the tools. However, if your use case fits within these limitations, this could be a good solution.
These tools are evolving, and their capabilities will expand over time. So you should familiarize yourself with their latest features at the time you consider them. Figure 1 summarizes the process for the No Code option.

:::row:::
    :::column span="3":::
        :::image type="content" source="./media/dt-no-code-option.png" alt-text="no code option process diagram":::
    :::column-end:::
    :::column:::
        
    :::column-end:::
:::row-end:::



<p style="text-align:center;font-style:italic;" tag="caption">FIGURE 1 - NO CODE OPTION</p>

### Code

For those who want to code or need the flexibility that a coded solution offers, all the options described have a “code-like” interface. Or, at least a representation of processing logic that can be exported to JSON or YAML format and can be checked into a code repository. From there, deployment can be handled through Azure DevOps or scripts. Figure 2 summarizes the Code option process.

:::image type="content" source="./media/dt-code-option.png" alt-text="code option process diagram":::

<p style="text-align:center;font-style:italic;" tag="caption">FIGURE 2 - CODE OPTION</p>

## Experimentation: Notebooks vs. Python/R Scripts

Based on the skillsets or comfort level of your team’s data scientists/engineers with notebooks or plain scripts, there are choices for experimentation that support both options.

TABLE 2 - NOTEBOOKS

<table border=1 cellspacing=0 cellpadding=0
 style='border-collapse:collapse;border:none;width:90%'>
 <tr>
  <td valign=top style='border:solid #BDD6EE 1.0pt;
  border-bottom:solid #9CC2E5 1.5pt;background:#8EAADB;padding:0in 5.4pt 4pt 5.4pt;width:35%;'>
  <p style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
  normal;font-weight:bold;'>Type</b></p>
  </td>
  <td  valign=top style='border-top:solid #BDD6EE 1.0pt;border-left:none;border-bottom:solid #9CC2E5 1.5pt;border-right:solid #BDD6EE 1.0pt;background:#8EAADB;padding:0in 5.4pt 4pt 5.4pt'>
  <p style='margin-bottom:0in;margin-bottom:.0001pt;line-height:normal;font-weight:bold;'><span style='color:black'>Description</span></b></p>
  </td>
 </tr>
 <tr>
  <td  valign=top style='border:solid #BDD6EE 1.0pt;border-top:none;padding:0in 5.4pt 4pt 5.4pt'>
  <p style='margin-top:4.0pt;margin-right:0in;margin-bottom:0in;margin-left:0in;margin-bottom:.0001pt;line-height:normal'><b>Azure Machine Learning Notebook VMs</b></p>
  </td>
  <td  valign=top style='border-top:none;border-left:none;border-bottom:solid #BDD6EE 1.0pt;border-right:solid #BDD6EE 1.0pt;padding:0in 5.4pt 4pt 5.4pt'>
  <p style='margin-top:4.0pt;margin-right:0in;margin-bottom:0in;margin-left:0in;margin-bottom:.0001pt;line-height:normal'>These are managed by Azure ML, and the data scientist only navigates to the link to interact with Jupyter notebooks. Backed by 1 VM that can be stopped and started. Use Azure ML SDKs to interact with data stored in Azure. This option allows you to pick the <i>compute instance</i> needed for experimentation based on memory, CPU, or GPU needs. </p>
  </td>
 </tr>
 <tr>
  <td  valign=top style='border:solid #BDD6EE 1.0pt;border-top:none;padding:0in 5.4pt 4pt 5.4pt'>
  <p style='margin-top:4.0pt;margin-right:0in;margin-bottom:0in;margin-left:0in;margin-bottom:.0001pt;line-height:normal'><b>Databricks Notebooks</b></p>
  </td>
  <td  valign=top style='border-top:none;border-left:none;border-bottom:solid #BDD6EE 1.0pt;border-right:solid #BDD6EE 1.0pt;padding:0in 5.4pt 4pt 5.4pt'>
  <p style='margin-top:4.0pt;margin-right:0in;margin-bottom:0in;margin-left:0in;margin-bottom:.0001pt;line-height:normal'>These are stored in Azure Databricks workspace with Git integration. Requires setting up cluster to run notebooks. Use built-in <i>dbutils</i> to access data stored in Azure. Costs more.</p>
  </td>
 </tr>
 <tr>
  <td  valign=top style='border:solid #BDD6EE 1.0pt;border-top:none;padding:0in 5.4pt 4pt 5.4pt'>
  <p style='margin-top:4.0pt;margin-right:0in;margin-bottom:0in;margin-left:0in;margin-bottom:.0001pt;line-height:normal'><b>Jupyter Notebook</b></p>
  </td>
  <td  valign=top style='border-top:none;border-left:none;border-bottom:solid #BDD6EE 1.0pt;border-right:solid #BDD6EE 1.0pt;padding:0in 5.4pt 4pt 5.4pt'>
  <p style='margin-top:4.0pt;margin-right:0in;margin-bottom:0in;margin-left:0in;margin-bottom:.0001pt;line-height:normal'>See <i>Azure Machine Learning Notebook VMs</i> above.</p>
  </td>
 </tr>
</table>

TABLE 3 - PYTHON/R SCRIPTS

<table border=1 cellspacing=0 cellpadding=0 style='border-collapse:collapse;border:none;width:90%'>
 <thead>
  <tr>
   <td valign=top style='border:solid #BDD6EE 1.0pt;border-bottom:solid #9CC2E5 1.5pt;background:#8EAADB;padding:0in 5.4pt 4pt 5.4pt;width:35%;'>
   <p style='margin-bottom:0in;margin-bottom:.0001pt;line-height:normal;font-weight:bold;'>Type</p>
   </td>
   <td valign=top style='border-top:solid #BDD6EE 1.0pt;border-left:none;border-bottom:solid #9CC2E5 1.5pt;border-right:solid #BDD6EE 1.0pt;background:#8EAADB;padding:0in 5.4pt 4pt 5.4pt'>
   <p style='margin-bottom:0in;margin-bottom:.0001pt;line-height:normal;font-weight:bold;'><span style='color:black'>Description</span></p>
   </td>
  </tr>
 </thead>
 <tr>
  <td  valign=top style='border:solid #BDD6EE 1.0pt;border-top:none;padding:0in 5.4pt 4pt 5.4pt'>
  <p style='margin-top:4.0pt;margin-right:0in;margin-bottom:0in;margin-left:0in;margin-bottom:.0001pt;line-height:normal'><b><i>Azure Machine Learning Experiment from Python SDK</i></b></p>
  </td>
  <td  valign=top style='border-top:none;border-left:none;border-bottom:solid #BDD6EE 1.0pt;border-right:solid #BDD6EE 1.0pt;padding:0in 5.4pt 4pt 5.4pt'>
  <p style='margin-top:4.0pt;margin-right:0in;margin-bottom:0in;margin-left:0in;margin-bottom:.0001pt;line-height:normal'>If using Python or scripts, they can be directly submitted to Azure ML as steps in a pipeline. You can technically also run a Databricks Notebook or other method of stepping through this method, but the actual pipeline creation still needs to be done using scripts of some kind. Requires upskilling engineer in Azure ML Pipelines. Can leverage dataset connections to existing data in Azure.</p>
  <p style='margin-top:4.0pt;margin-right:0in;margin-bottom:0in;margin-left:0in;margin-bottom:.0001pt;line-height:normal'><i>Pipeline startup cost can be prohibitive to iterating quickly.</i></p>
  </td>
 </tr>
 <tr>
  <td  valign=top style='border:solid #BDD6EE 1.0pt;border-top:none;padding:0in 5.4pt 4pt 5.4pt'>
  <p style='margin-top:4.0pt;margin-right:0in;margin-bottom:0in;margin-left:0in;margin-bottom:.0001pt;line-height:normal'><b><i>DSVM</i></b></p>
  </td>
  <td  valign=top style='border-top:none;border-left:none;border-bottom:solid #BDD6EE 1.0pt;border-right:solid #BDD6EE 1.0pt;padding:0in 5.4pt 4pt 5.4pt'>
  <p style='margin-top:4.0pt;margin-right:0in;margin-bottom:0in;margin-left:0in;margin-bottom:.0001pt;line-height:normal'>This is a *catch all* for those who want to have a GPU or non-GPU VM with standard machine learning frameworks pre-installed, but full flexibility in what tooling to use for coding. Low amount of upskilling needed.</p>
  </td>
 </tr>
 <tr>
  <td  valign=top style='border:solid #BDD6EE 1.0pt;border-top:none;padding:0in 5.4pt 4pt 5.4pt'>
  <p style='margin-top:4.0pt;margin-right:0in;margin-bottom:0in;margin-left:0in;margin-bottom:.0001pt;line-height:normal'><b><i>Locally</i></b></p>
  </td>
  <td  valign=top style='border-top:none;border-left:none;border-bottom:solid #BDD6EE 1.0pt;border-right:solid #BDD6EE 1.0pt;padding:0in 5.4pt 4pt 5.4pt'>
  <p style='margin-top:4.0pt;margin-right:0in;margin-bottom:0in;margin-left:0in;margin-bottom:.0001pt;line-height:normal'>If not requiring compute power in the cloud, local experimentation is also an
  option.</p>
  </td>
 </tr>
</table>

## Overall Orchestration/Scheduling

Table 4 lists which systems are best for supported trigger options while Table 5 adds scheduling options.

TABLE 4 - TRIGGER OPTIONS

<table border=1 cellspacing=0 cellpadding=0 style='width:90%;border-collapse:collapse;border:none'>
 <tr>
  <td width=0 style='width:35%;border:solid #BDD6EE 1.0pt;border-bottom:solid #9CC2E5 1.5pt;background:#8EAADB;padding:4.3pt 5.75pt 4.3pt 5.75pt'>
  <p style='margin-bottom:0in;margin-bottom:.0001pt;line-height:normal;font-weight:bold;'>Triggered by</b></p>
  </td>
  <td width=0 style='border-top:solid #BDD6EE 1.0pt;border-left:none;border-bottom:solid #9CC2E5 1.5pt;border-right:solid #BDD6EE 1.0pt;background:#8EAADB;padding:4.3pt 5.75pt 4.3pt 5.75pt'>
  <p style='margin-bottom:0in;margin-bottom:.0001pt;line-height:normal;font-weight:bold;'><span style='color:black'>Service/System</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=0 style='border:solid #BDD6EE 1.0pt;border-top:none;padding:4.3pt 5.75pt 4.3pt 5.75pt'>
  <p style='margin-bottom:0in;margin-bottom:.0001pt;line-height:normal;font-weight:bold;'>Code</b></p>
  </td>
  <td width=0 style='border-top:none;border-left:none;border-bottom:solid #BDD6EE 1.0pt;border-right:solid #BDD6EE 1.0pt;padding:4.3pt 5.75pt 4.3pt 5.75pt'>
  <p style='margin-bottom:0in;margin-bottom:.0001pt;line-height:normal'>Azure DevOps</p>
  </td>
 </tr>
 <tr>
  <td width=0 style='border:solid #BDD6EE 1.0pt;border-top:none;padding:4.3pt 5.75pt 4.3pt 5.75pt'>
  <p style='margin-bottom:0in;margin-bottom:.0001pt;line-height:normal;font-weight:bold;'>Schedule</b></p>
  </td>
  <td width=0 style='border-top:none;border-left:none;border-bottom:solid #BDD6EE 1.0pt;border-right:solid #BDD6EE 1.0pt;padding:4.3pt 5.75pt 4.3pt 5.75pt'>
  <p style='margin-bottom:0in;margin-bottom:.0001pt;line-height:normal'>Azure Machine Learning Pipelines <br>(can only trigger itself)</p>
  </td>
 </tr>
 <tr>
  <td width=0 style='border:solid #BDD6EE 1.0pt;border-top:none;padding:4.3pt 5.75pt 4.3pt 5.75pt'>
  <p style='margin-bottom:0in;margin-bottom:.0001pt;line-height:normal;font-weight:bold;'>Data/schedule</b></p>
  </td>
  <td width=0 style='border-top:none;border-left:none;border-bottom:solid #BDD6EE 1.0pt;border-right:solid #BDD6EE 1.0pt;padding:4.3pt 5.75pt 4.3pt 5.75pt'>
  <p style='margin-bottom:0in;margin-bottom:.0001pt;line-height:normal'>Azure Data Factory</p>
  </td>
 </tr>
 <tr>
  <td width=0 style='border:solid #BDD6EE 1.0pt;border-top:none;padding:4.3pt 5.75pt 4.3pt 5.75pt'>
  <p style='margin-bottom:0in;margin-bottom:.0001pt;line-height:normal;font-weight:bold;'>Events/alerts/other non-Azure products</b></p>
  </td>
  <td width=0 style='border-top:none;border-left:none;border-bottom:solid #BDD6EE 1.0pt;border-right:solid #BDD6EE 1.0pt;padding:4.3pt 5.75pt 4.3pt 5.75pt'>
  <p style='margin-bottom:0in;margin-bottom:.0001pt;line-height:normal'>Logic Apps</p>
  </td>
 </tr>
</table>

TABLE 5 - TRIGGERS/SCHEDULING

<table border=1 cellspacing=0 cellpadding=0 style='width:90.0%;border-collapse:collapse;border:none'>
 <thead>
  <tr style='height:19.3pt'>
   <td valign=top style='width:21.78%;border:solid #BDD6EE 1.0pt;border-bottom:solid #9CC2E5 1.5pt;background:#8EAADB;padding:0in 5.4pt 4pt 5.4pt;height:19.3pt'>
   <p style='margin-bottom:0in;margin-bottom:.0001pt;line-height:normal'><b>&nbsp;</b></p>
   </td>
   <td style='width:20.32%;border-top:solid #BDD6EE 1.0pt;border-left:none;border-bottom:solid #9CC2E5 1.5pt;border-right:solid #BDD6EE 1.0pt;background:#8EAADB;padding:0in 5.4pt 4pt 5.4pt;height:19.3pt'>
   <p style='margin-bottom:0in;margin-bottom:.0001pt;line-height:normal'><b><span style='color:black'>Azure DevOps</span></b></p>
   </td>
   <td style='width:19.92%;border-top:solid #BDD6EE 1.0pt;border-left:none;border-bottom:solid #9CC2E5 1.5pt;border-right:solid #BDD6EE 1.0pt;background:#8EAADB;padding:0in 5.4pt 4pt 5.4pt;height:19.3pt'>
   <p style='margin-bottom:0in;margin-bottom:.0001pt;line-height:normal'><b><span style='color:black'>Azure ML Pipeline</span></b></p>
   </td>
   <td style='width:20.02%;border-top:solid #BDD6EE 1.0pt;border-left:none;border-bottom:solid #9CC2E5 1.5pt;border-right:solid #BDD6EE 1.0pt;background:#8EAADB;padding:0in 5.4pt 4pt 5.4pt;height:19.3pt'>
   <p style='margin-bottom:0in;margin-bottom:.0001pt;line-height:normal'><b><span style='color:black'>Azure Data Factory</span></b></p>
   </td>
   <td style='width:17.94%;border-top:solid #BDD6EE 1.0pt;border-left:none;border-bottom:solid #9CC2E5 1.5pt;border-right:solid #BDD6EE 1.0pt;background:#8EAADB;padding:0in 5.4pt 4pt 5.4pt;height:19.3pt'>
   <p style='margin-bottom:0in;margin-bottom:.0001pt;line-height:normal'><b><span style='color:black'>Logic Apps</span></b></p>
   </td>
  </tr>
  <tr style='height:37.7pt'>
   <td width="21%" valign=top style='width:21.78%;border-top:none;border-left:solid #BDD6EE 1.0pt;border-bottom:solid #9CC2E5 1.5pt;border-right:solid #BDD6EE 1.0pt;padding:0in 5.4pt 4pt 5.4pt;height:37.7pt'>
   <p style='margin-bottom:0in;margin-bottom:.0001pt;line-height:normal'><b>Schedule</b></p>
   </td>
   <td width="20%" valign=top style='width:20.32%;border-top:none;border-left:none;border-bottom:solid #9CC2E5 1.5pt;border-right:solid #BDD6EE 1.0pt;padding:0in 5.4pt 4pt 5.4pt;height:37.7pt'>
   <p style='margin-bottom:0in;margin-bottom:.0001pt;line-height:normal'>Cron schedule</p>
   </td>
   <td width="19%" valign=top style='width:19.92%;border-top:none;border-left:none;border-bottom:solid #9CC2E5 1.5pt;border-right:solid #BDD6EE 1.0pt;padding:0in 5.4pt 4pt 5.4pt;height:37.7pt'>
   <p style='margin-bottom:0in;margin-bottom:.0001pt;line-height:normal'>Recurrence-Based (run at these hours on these days)</p>
   </td>
   <td width="20%" valign=top style='width:20.02%;border-top:none;border-left:none;border-bottom:solid #9CC2E5 1.5pt;border-right:solid #BDD6EE 1.0pt;padding:0in 5.4pt 4pt 5.4pt;height:37.7pt'>
   <p style='margin-bottom:0in;margin-bottom:.0001pt;line-height:normal'>Recurrence-Based + Additional Support for Tumbling
   Windows</p>
   </td>
   <td width="17%" valign=top style='width:17.94%;border-top:none;border-left:none;border-bottom:solid #9CC2E5 1.5pt;border-right:solid #BDD6EE 1.0pt;padding:0in 5.4pt 4pt 5.4pt;height:37.7pt'>
   <p style='margin-bottom:0in;margin-bottom:.0001pt;line-height:normal'>Recurrence-Based</p>
   </td>
  </tr>
  <tr style='height:37.7pt'>
   <td width="21%" valign=top style='width:21.78%;border-top:none;border-left:solid #BDD6EE 1.0pt;border-bottom:solid #9CC2E5 1.5pt;border-right:solid #BDD6EE 1.0pt;padding:0in 5.4pt 4pt 5.4pt;height:37.7pt'>
   <p style='margin-bottom:0in;margin-bottom:.0001pt;line-height:normal'><b>Event Based Trigger</b></p>
   </td>
   <td width="20%" valign=top style='width:20.32%;border-top:none;border-left:none;border-bottom:solid #9CC2E5 1.5pt;border-right:solid #BDD6EE 1.0pt;padding:0in 5.4pt 4pt 5.4pt;height:37.7pt'>
   <p style='margin-bottom:0in;margin-bottom:.0001pt;line-height:normal'>Pull request, branch and build completion triggers. Artifact triggers not available in new YAML builds.</p>
   </td>
   <td width="19%" valign=top style='width:19.92%;border-top:none;border-left:none;border-bottom:solid #9CC2E5 1.5pt;border-right:solid #BDD6EE 1.0pt;padding:0in 5.4pt 4pt 5.4pt;height:37.7pt'>
   <p style='margin-bottom:0in;margin-bottom:.0001pt;line-height:normal'>None.</p>
   </td>
   <td width="20%" valign=top style='width:20.02%;border-top:none;border-left:none;border-bottom:solid #9CC2E5 1.5pt;border-right:solid #BDD6EE 1.0pt;padding:0in 5.4pt 4pt 5.4pt;height:37.7pt'>
   <p style='margin-bottom:0in;margin-bottom:.0001pt;line-height:normal'>Blob creation and blob deletion events only.</p>
   </td>
   <td width="17%" valign=top style='width:17.94%;border-top:none;border-left:none;border-bottom:solid #9CC2E5 1.5pt;border-right:solid #BDD6EE 1.0pt;padding:0in 5.4pt 4pt 5.4pt;height:37.7pt'>
   <p style='margin-bottom:0in;margin-bottom:.0001pt;line-height:normal'>Many triggers from Microsoft and non-Microsoft services. Twitter, Dropbox, SharePoint, etc.</p>
   </td>
  </tr>
  <tr style='height:37.7pt'>
   <td width="21%" valign=top style='width:21.78%;border-top:none;border-left:solid #BDD6EE 1.0pt;border-bottom:solid #9CC2E5 1.5pt;border-right:solid #BDD6EE 1.0pt;padding:0in 5.4pt 4pt 5.4pt;height:37.7pt'>
   <p style='margin-bottom:0in;margin-bottom:.0001pt;line-height:normal'><b>Manual Intervention or Approval Based</b></p>
   </td>
   <td width="20%" valign=top style='width:20.32%;border-top:none;border-left:none;border-bottom:solid #9CC2E5 1.5pt;border-right:solid #BDD6EE 1.0pt;padding:0in 5.4pt 4pt 5.4pt;height:37.7pt'>
   <p style='margin-bottom:0in;margin-bottom:.0001pt;line-height:normal'>Yes, limited.</p>
   </td>
   <td width="19%" valign=top style='width:19.92%;border-top:none;border-left:none;border-bottom:solid #9CC2E5 1.5pt;border-right:solid #BDD6EE 1.0pt;padding:0in 5.4pt 4pt 5.4pt;height:37.7pt'>
   <p style='margin-bottom:0in;margin-bottom:.0001pt;line-height:normal'>No.</p>
   </td>
   <td width="20%" valign=top style='width:20.02%;border-top:none;border-left:none;border-bottom:solid #9CC2E5 1.5pt;border-right:solid #BDD6EE 1.0pt;padding:0in 5.4pt 4pt 5.4pt;height:37.7pt'>
   <p style='margin-bottom:0in;margin-bottom:.0001pt;line-height:normal'>No.</p>
   </td>
   <td width="17%" valign=top style='width:17.94%;border-top:none;border-left:none;border-bottom:solid #9CC2E5 1.5pt;border-right:solid #BDD6EE 1.0pt;padding:0in 5.4pt 4pt 5.4pt;height:37.7pt'>
   <p style='margin-bottom:0in;margin-bottom:.0001pt;line-height:normal'>Yes.</p>
   </td>
  </tr>
  <tr style='height:37.7pt'>
   <td width="21%" valign=top style='width:21.78%;border-top:none;border-left:solid #BDD6EE 1.0pt;border-bottom:solid #9CC2E5 1.5pt;border-right:solid #BDD6EE 1.0pt;padding:0in 5.4pt 4pt 5.4pt;height:37.7pt'>
   <p style='margin-bottom:0in;margin-bottom:.0001pt;line-height:normal'><b>Integration with Other Orchestrators</b></p>
   </td>
   <td width="20%" valign=top style='width:20.32%;border-top:none;border-left:none;border-bottom:solid #9CC2E5 1.5pt;border-right:solid #BDD6EE 1.0pt;padding:0in 5.4pt 4pt 5.4pt;height:37.7pt'>
   <p style='margin-bottom:0in;margin-bottom:.0001pt;line-height:normal'>Yes, limited. Supports deployment to most Azure Services. Can call and wait Azure ML Pipeline from Agentless task.</p>
   </td>
   <td width="19%" valign=top style='width:19.92%;border-top:none;border-left:none;border-bottom:solid #9CC2E5 1.5pt;border-right:solid #BDD6EE 1.0pt;padding:0in 5.4pt 4pt 5.4pt;height:37.7pt'>
   <p style='margin-bottom:0in;margin-bottom:.0001pt;line-height:normal'>No built-in support for Azure DevOps, Azure Data Factory, or Logic Apps.</p>
   </td>
   <td width="20%" valign=top style='width:20.02%;border-top:none;border-left:none;border-bottom:solid #9CC2E5 1.5pt;border-right:solid #BDD6EE 1.0pt;padding:0in 5.4pt 4pt 5.4pt;height:37.7pt'>
   <p style='margin-bottom:0in;margin-bottom:.0001pt;line-height:normal'>Yes, limited. Can run Azure ML Pipeline.</p>
   </td>
   <td width="17%" valign=top style='width:17.94%;border-top:none;border-left:none;border-bottom:solid #9CC2E5 1.5pt;border-right:solid #BDD6EE 1.0pt;padding:0in 5.4pt 4pt 5.4pt;height:37.7pt'>
   <p style='margin-bottom:0in;margin-bottom:.0001pt;line-height:normal'>Yes, limited. Can trigger Azure DevOps build. Can fire and forget trigger Azure Data Factory. No integration with Azure ML Pipeline.</p>
   </td>
  </tr>
 </thead>
</table>

TABLE 6 - DATA TRANSFER OPTIONS

<table border=1 cellspacing=0 cellpadding=0
 style='border-collapse:collapse;border:none;width:90%;'>
 <tr>
  <td valign=top style='width:35%;border:solid #BDD6EE 1.0pt;border-bottom:solid #9CC2E5 1.5pt;background:#8EAADB;padding:0in 5.4pt 4pt 5.4pt'>
  <p style='margin-bottom:0in;margin-bottom:.0001pt;line-height:normal;font-weight:bold;'>Type</p>
  </td>
  <td valign=top style='border-top:solid #BDD6EE 1.0pt;border-left:none;border-bottom:solid #9CC2E5 1.5pt;border-right:solid #BDD6EE 1.0pt;background:#8EAADB;padding:0in 5.4pt 4pt 5.4pt'>
  <p style='margin-bottom:0in;margin-bottom:.0001pt;line-height:normal;font-weight:bold;'><span style='color:black'>Description</span></p>
  </td>
 </tr>
 <tr>
  <td  valign=top style='border:solid #BDD6EE 1.0pt;border-top:none;padding:0in 5.4pt 4pt 5.4pt'>
  <p style='margin-top:6.0pt;margin-right:0in;margin-bottom:0in;margin-left:0in;margin-bottom:.0001pt;line-height:normal'><b><i>Azure Data Factory Copy Activity</i></b></p>
  </td>
  <td  valign=top style='border-top:none;border-left:none;border-bottom:solid #BDD6EE 1.0pt;border-right:solid #BDD6EE 1.0pt;padding:0in 5.4pt 4pt 5.4pt'>
  <p style='margin-top:6.0pt;margin-right:0in;margin-bottom:0in;margin-left:0in;margin-bottom:.0001pt;line-height:normal'>Large Scale (GBs to TBs) &amp; more options for source and sinks.</p>
  </td>
 </tr>
 <tr>
  <td  valign=top style='border:solid #BDD6EE 1.0pt;border-top:none;padding:0in 5.4pt 4pt 5.4pt'>
  <p style='margin-top:6.0pt;margin-right:0in;margin-bottom:0in;margin-left:0in;margin-bottom:.0001pt;line-height:normal'><b><i>Azure Machine Learning DataTransferStep</i></b></p>
  </td>
  <td  valign=top style='border-top:none;border-left:none;border-bottom:solid #BDD6EE 1.0pt;border-right:solid #BDD6EE 1.0pt;padding:0in 5.4pt 4pt 5.4pt'>
  <p style='margin-top:6.0pt;margin-right:0in;margin-bottom:0in;margin-left:0in;margin-bottom:.0001pt;line-height:normal'>Smaller Scale (MBs to GBs) with limited options for source and sinks.</p>
  </td>
 </tr>
</table>

TABLE 7 - COMPUTE OPTIONS

<table border=1 cellspacing=0 cellpadding=0
 style='border-collapse:collapse;border:none;width:90%'>
 <tr>
  <td  valign=top style='width:35%;border:solid #BDD6EE 1.0pt;border-bottom:solid #9CC2E5 1.5pt;background:#8EAADB;padding:0in 5.4pt 4pt 5.4pt'>
  <p style='margin-bottom:0in;margin-bottom:.0001pt;line-height:normal;font-weight:bold;'>Type</b></p>
  </td>
  <td  valign=top style='border-top:solid #BDD6EE 1.0pt;border-left:none;border-bottom:solid #9CC2E5 1.5pt;border-right:solid #BDD6EE 1.0pt;background:#8EAADB;padding:0in 5.4pt 4pt 5.4pt'>
  <p style='margin-bottom:0in;margin-bottom:.0001pt;line-height:normal;font-weight:bold;'><span style='color:black'>Description</span></b></p>
  </td>
 </tr>
 <tr>
  <td  valign=top style='border:solid #BDD6EE 1.0pt;border-top:none;padding:0in 5.4pt 4pt 5.4pt'>
  <p style='margin-top:6.0pt;margin-right:0in;margin-bottom:0in;margin-left:0in;margin-bottom:.0001pt;line-height:normal'><b><i>Azure
  Machine Learning Compute</i></b></p>
  </td>
  <td  valign=top style='border-top:none;border-left:none;border-bottom:solid #BDD6EE 1.0pt;border-right:solid #BDD6EE 1.0pt;padding:0in 5.4pt 4pt 5.4pt'>
  <p style='margin-top:6.0pt;margin-right:0in;margin-bottom:0in;margin-left:0in;margin-bottom:.0001pt;line-height:normal'>Scalable compute that works for GPU or non-GPU cluster. Python or R code is run in
  configurable Conda environments managed by Azure ML. Helps scale out multiple jobs but does not handle distributed data partitioning/execution except in unique cases. </p>
  </td>
 </tr>
 <tr>
  <td  valign=top style='border:solid #BDD6EE 1.0pt;border-top:none;padding:0in 5.4pt 4pt 5.4pt'>
  <p style='margin-top:6.0pt;margin-right:0in;margin-bottom:0in;margin-left:0in;margin-bottom:.0001pt;line-height:normal'><b><i>Databricks</i></b></p>
  </td>
  <td  valign=top style='border-top:none;border-left:none;border-bottom:solid #BDD6EE 1.0pt;border-right:solid #BDD6EE 1.0pt;
  padding:0in 5.4pt 4pt 5.4pt'>
  <p style='margin-top:6.0pt;margin-right:0in;margin-bottom:0in;margin-left:0in;margin-bottom:.0001pt;line-height:normal'>Scalable compute that handles distributed data partitioning/job execution on top of Spark. Big data jobs will likely execute faster on Databricks. Dependency and environments are managed by user. Compute for Databricks is more expensive.</p>
  </td>
 </tr>
 <tr>
  <td  valign=top style='border:solid #BDD6EE 1.0pt;border-top:none;padding:0in 5.4pt 4pt 5.4pt'>
  <p style='margin-top:6.0pt;margin-right:0in;margin-bottom:0in;margin-left:0in;margin-bottom:.0001pt;line-height:normal'><b><i>Azure Synapse (preview)</i></b></p>
  </td>
  <td  valign=top style='border-top:none;border-left:none;border-bottom:solid #BDD6EE 1.0pt;border-right:solid #BDD6EE 1.0pt;
  padding:0in 5.4pt 4pt 5.4pt'>
  <p style='margin-top:6.0pt;margin-right:0in;margin-bottom:0in;margin-left:0in;margin-bottom:.0001pt;line-height:normal'>Open source Spark/RDD processing, distributed. (Big Data Analytics)</p>
  </td>
 </tr>
 <tr>
  <td  valign=top style='border:solid #BDD6EE 1.0pt;border-top:none;padding:0in 5.4pt 4pt 5.4pt'>
  <p style='margin-top:6.0pt;margin-right:0in;margin-bottom:0in;margin-left:0in;margin-bottom:.0001pt;line-height:normal'><b><i>Big Data
  Cluster/SQL 2019 </i></b></p>
  </td>
  <td  valign=top style='border-top:none;border-left:none;border-bottom:solid #BDD6EE 1.0pt;border-right:solid #BDD6EE 1.0pt;
  padding:0in 5.4pt 4pt 5.4pt'>
  <p style='margin-top:6.0pt;margin-right:0in;margin-bottom:0in;margin-left:0in;margin-bottom:.0001pt;line-height:normal'>Big Data
  Analytics</p>
  </td>
 </tr>
</table>

TABLE 8 - TRACKING/VERSIONING

<table border=1 cellspacing=0 cellpadding=0
 style='border-collapse:collapse;border:none;width:90%;'>
 <tr>
  <td  valign=top style='width:35%;border:solid #BDD6EE 1.0pt;
  border-bottom:solid #9CC2E5 1.5pt;background:#8EAADB;padding:0in 5.4pt 4pt 5.4pt'>
  <p style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
  normal;font-weight:bold;'>Type</b></p>
  </td>
  <td  valign=top style='border-top:solid #BDD6EE 1.0pt;
  border-left:none;border-bottom:solid #9CC2E5 1.5pt;border-right:solid #BDD6EE 1.0pt;
  background:#8EAADB;padding:0in 5.4pt 4pt 5.4pt'>
  <p style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
  normal;font-weight:bold;'><span style='color:black'>Description</span></b></p>
  </td>
 </tr>
 <tr>
  <td  valign=top style='border:solid #BDD6EE 1.0pt;
  border-top:none;padding:0in 5.4pt 4pt 5.4pt'>
  <p style='margin-top:6.0pt;margin-right:0in;margin-bottom:
  0in;margin-left:0in;margin-bottom:.0001pt;line-height:normal;font-weight:bold;'>Experiment/Hyper-tuning
  Tracking</p>
  </td>
  <td  valign=top style='border-top:none;border-left:
  none;border-bottom:solid #BDD6EE 1.0pt;border-right:solid #BDD6EE 1.0pt;
  padding:0in 5.4pt 4pt 5.4pt'>
  <ul>
  <li style='margin-top:6.0pt;margin-right:0in;
  margin-bottom:0in;margin-left:.1in;margin-bottom:.0001pt;
  line-height:normal;'><span style='color:windowtext'>Azure Machine Learning
  Experiments</span></li>
  <li style='margin-top:6.0pt;margin-right:0in;
  margin-bottom:0in;margin-left:.1in;margin-bottom:.0001pt;
  line-height:normal'><span style='color:windowtext'>Databricks &amp; MLFLow Tracking</span></li></ul>
  </td>
 </tr>
 <tr>
  <td  valign=top style='border:solid #BDD6EE 1.0pt;
  border-top:none;padding:0in 5.4pt 4pt 5.4pt'>
  <p style='margin-top:6.0pt;margin-right:0in;margin-bottom:
  0in;margin-left:0in;margin-bottom:.0001pt;line-height:normal'><b>Data
  Versioning/Data Drift</b></p>
  </td>
  <td  valign=top style='border-top:none;border-left:
  none;border-bottom:solid #BDD6EE 1.0pt;border-right:solid #BDD6EE 1.0pt;
  padding:0in 5.4pt 4pt 5.4pt'>
  <ul>
  <li style='margin-top:6.0pt;margin-right:0in;
  margin-bottom:0in;margin-left:.1in;margin-bottom:.0001pt;
  line-height:normal'><span style='color:windowtext'>Azure Machine Learning Datasets</span></li></ul>
  </td>
 </tr>
 <tr>
  <td  valign=top style='border:solid #BDD6EE 1.0pt;
  border-top:none;padding:0in 5.4pt 4pt 5.4pt'>
  <p style='margin-top:6.0pt;margin-right:0in;margin-bottom:
  0in;margin-left:0in;margin-bottom:.0001pt;line-height:normal'><b>Model
  Versioning</b></p>
  </td>
  <td  valign=top style='border-top:none;border-left:
  none;border-bottom:solid #BDD6EE 1.0pt;border-right:solid #BDD6EE 1.0pt;
  padding:0in 5.4pt 4pt 5.4pt'>
  <ul>
  <li style='margin-top:6.0pt;margin-right:0in;
  margin-bottom:0in;margin-left:.1in;margin-bottom:.0001pt;
  line-height:normal'><span style='color:windowtext'>Azure Machine Learning Model
  Management Service</span></li>
  <li style='margin-top:6.0pt;margin-right:0in;
  margin-bottom:0in;margin-left:.1in;margin-bottom:.0001pt;
  line-height:normal'><span style='color:windowtext'>Databricks &amp; MLFlow Model
  Registry</span></li></ul>
  </td>
 </tr>
</table>

TABLE 9 - MODEL TRAINING OPTIONS

<table border=1 cellspacing=0 cellpadding=0
 style='border-collapse:collapse;border:none;width:90%;'>
 <tr>
  <td  valign=top style='width:35%;border:solid #BDD6EE 1.0pt;
  border-bottom:solid #9CC2E5 1.5pt;background:#8EAADB;padding:0in 5.4pt 4pt 5.4pt'>
  <p style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
  normal;font-weight:bold;'>Type</b></p>
  </td>
  <td  valign=top style='border-top:solid #BDD6EE 1.0pt;
  border-left:none;border-bottom:solid #9CC2E5 1.5pt;border-right:solid #BDD6EE 1.0pt;
  background:#8EAADB;padding:0in 5.4pt 4pt 5.4pt'>
  <p style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
  normal;font-weight:bold;'><span style='color:black'>Description</span></b></p>
  </td>
 </tr>
 <tr>
  <td  valign=top style='border:solid #BDD6EE 1.0pt;
  border-top:none;padding:0in 5.4pt 4pt 5.4pt'>
  <p style='margin-top:6.0pt;margin-right:0in;margin-bottom:
  0in;margin-left:0in;margin-bottom:.0001pt;line-height:normal'><b>Option 1</b></p>
  </td>
  <td  valign=top style='border-top:none;border-left:
  none;border-bottom:solid #BDD6EE 1.0pt;border-right:solid #BDD6EE 1.0pt;
  padding:0in 5.4pt 4pt 5.4pt'>
  <p style='margin-top:6.0pt;margin-right:0in;margin-bottom:
  0in;margin-left:0in;margin-bottom:.0001pt;line-height:normal'>Azure Machine
  Learning Pipelines</p>
  </td>
 </tr>
 <tr>
  <td  valign=top style='border:solid #BDD6EE 1.0pt;
  border-top:none;padding:0in 5.4pt 4pt 5.4pt'>
  <p style='margin-top:6.0pt;margin-right:0in;margin-bottom:
  0in;margin-left:0in;margin-bottom:.0001pt;line-height:normal'><b>Option 2</b></p>
  </td>
  <td  valign=top style='border-top:none;border-left:
  none;border-bottom:solid #BDD6EE 1.0pt;border-right:solid #BDD6EE 1.0pt;
  padding:0in 5.4pt 4pt 5.4pt'>
  <p style='margin-top:6.0pt;margin-right:0in;margin-bottom:
  0in;margin-left:0in;margin-bottom:.0001pt;line-height:normal'>Databricks</p>
  </td>
 </tr>
</table>

TABLE 10 - MODEL DEPLOYMENT OPTIONS

<table border=1 cellspacing=0 cellpadding=0
 style='border-collapse:collapse;border:none;width:90%;'>
 <tr>
  <td  valign=top style='width:35%;border:solid #BDD6EE 1.0pt;
  border-bottom:solid #9CC2E5 1.5pt;background:#8EAADB;padding:0in 5.4pt 4pt 5.4pt'>
  <p style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
  normal;font-weight:bold;'>Type</p>
  </td>
  <td  valign=top style='border-top:solid #BDD6EE 1.0pt;
  border-left:none;border-bottom:solid #9CC2E5 1.5pt;border-right:solid #BDD6EE 1.0pt;
  background:#8EAADB;padding:0in 5.4pt 4pt 5.4pt'>
  <p style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
  normal;font-weight:bold;'><span style='color:black'>Description</span></b></p>
  </td>
 </tr>
 <tr>
  <td  valign=top style='border:solid #BDD6EE 1.0pt;
  border-top:none;padding:0in 5.4pt 4pt 5.4pt'>
  <p style='margin-top:6.0pt;margin-right:0in;margin-bottom:
  0in;margin-left:0in;margin-bottom:.0001pt;line-height:normal'><b>Batch
  Scoring in Azure ML Pipeline</b></p>
  </td>
  <td  valign=top style='border-top:none;border-left:
  none;border-bottom:solid #BDD6EE 1.0pt;border-right:solid #BDD6EE 1.0pt;
  padding:0in 5.4pt 4pt 5.4pt'>
  <p style='margin-top:6.0pt;margin-right:0in;margin-bottom:
  0in;margin-left:0in;margin-bottom:.0001pt;line-height:normal'>Batch Deployment
  &amp; Scoring in Azure Machine Learning Pipeline</p>
  </td>
 </tr>
 <tr>
  <td  valign=top style='border:solid #BDD6EE 1.0pt;
  border-top:none;padding:0in 5.4pt 4pt 5.4pt'>
  <p style='margin-top:6.0pt;margin-right:0in;margin-bottom:
  0in;margin-left:0in;margin-bottom:.0001pt;line-height:normal;font-weight:bold;'>Real-time Deployment
  in Azure ML Service</p>
  </td>
  <td  valign=top style='border-top:none;border-left:
  none;border-bottom:solid #BDD6EE 1.0pt;border-right:solid #BDD6EE 1.0pt;
  padding:0in 5.4pt 4pt 5.4pt'>
  <p style='margin-top:6.0pt;margin-right:0in;margin-bottom:
  0in;margin-left:0in;margin-bottom:.0001pt;line-height:normal'>Azure Machine
  Learning Service supports real-time deployment and scoring using</p>
  <ul>
  <li style='margin-top:6.0pt;margin-right:0in;
  margin-bottom:0in;margin-left:.1in;margin-bottom:.0001pt;
  line-height:normal'>AKS (Azure Kubernetes Service)</li>
  <li style='margin-top:6.0pt;margin-right:
  0in;margin-bottom:0in;margin-left:.1in;margin-bottom:.0001pt;line-height:normal'>Azure Container Instance</li>
  <li style='margin-top:6.0pt;margin-right:
  0in;margin-bottom:0in;margin-left:.1in;margin-bottom:.0001pt;line-height:normal'>Azure App Service</li>
  <li style='margin-top:6.0pt;margin-right:
  0in;margin-bottom:0in;margin-left:.1in;margin-bottom:.0001pt;line-height:normal'>Azure Functions</li>
  <li style='margin-top:6.0pt;margin-right:
  0in;margin-bottom:0in;margin-left:.1in;margin-bottom:.0001pt;line-height:normal'>IoT Edge</li>
  <li style='margin-top:6.0pt;margin-right:0in;
  margin-bottom:0in;margin-left:.1in;margin-bottom:.0001pt;
  line-height:normal'><a
  href="https://docs.microsoft.com/en-us/azure/machine-learning/how-to-deploy-and-where#choose-a-compute-target">and
  more</a></li></ul>
  </td>
 </tr>
</table>

TABLE 11 - MONITORING

<table border=1 cellspacing=0 cellpadding=0
 style='border-collapse:collapse;border:none;width:90%;'>
 <tr>
  <td  valign=top style='width:35%;border:solid #BDD6EE 1.0pt;
  border-bottom:solid #9CC2E5 1.5pt;background:#8EAADB;padding:0in 5.4pt 4pt 5.4pt'>
  <p style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
  normal;font-weight:bold;'>Type</p>
  </td>
  <td  valign=top style='border-top:solid #BDD6EE 1.0pt;
  border-left:none;border-bottom:solid #9CC2E5 1.5pt;border-right:solid #BDD6EE 1.0pt;
  background:#8EAADB;padding:0in 5.4pt 4pt 5.4pt'>
  <p style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
  normal;font-weight:bold;'><span style='color:black'>Description</span></b></p>
  </td>
 </tr>
 <tr>
  <td  valign=top style='border:solid #BDD6EE 1.0pt;
  border-top:none;padding:0in 5.4pt 4pt 5.4pt'>
  <p style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
  normal;font-weight:bold;'>Azure Monitor</b></p>
  </td>
  <td  valign=top style='border-top:none;border-left:
  none;border-bottom:solid #BDD6EE 1.0pt;border-right:solid #BDD6EE 1.0pt;
  padding:0in 5.4pt 4pt 5.4pt'>
  <ul>
  <li style='margin-bottom:0in;margin-bottom:
  .0001pt;line-height:normal'>Application Insights</li>
  <li style='margin-bottom:0in;margin-bottom:
  .0001pt;line-height:normal'>Azure Dashboards</li></ul>
  </td>
 </tr>
 <tr>
  <td  valign=top style='border:solid #BDD6EE 1.0pt;
  border-top:none;padding:0in 5.4pt 4pt 5.4pt'>
  <p style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
  normal;font-weight:bold;'>Power BI</p>
  </td>
  <td  valign=top style='border-top:none;border-left:
  none;border-bottom:solid #BDD6EE 1.0pt;border-right:solid #BDD6EE 1.0pt;
  padding:0in 5.4pt 4pt 5.4pt'>
  <ul>
  <li style='margin-bottom:0in;margin-bottom:.0001pt;
  line-height:normal'>Analytics &amp; Reports</li></ul>
  </td>
 </tr>
</table>

## Resources

* [Technical White Paper: MLOps Framework for Upscaling ML Lifecycle with Azure ML](./mlops-white-paper.md)
* Reference Architecture Document: MLOps Framework for Upscaling ML Lifecycle with Azure ML
* [MLOps Maturity Model](./mlops-maturity-model.md)

## Credits

Xinyi Joffre  
