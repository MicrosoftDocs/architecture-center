---
title: Choose a data analytics and reporting technology
description: Evaluate big data analytics technology options for Azure, including key selection criteria and a capability matrix.
author: martinekuan
ms.author: architectures
categories: azure
ms.date: 07/25/2022
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
azureCategories:
  - analytics
products:
  - power-bi
  - azure-notebooks
ms.custom:
  - data-analytics
  - guide
  - internal-intro
---

# Choose a data analytics and reporting technology in Azure

The goal of most big data solutions is to provide insights into the data through analysis and reporting. This can include preconfigured reports and visualizations, or interactive data exploration.

## What are your options when choosing a data analytics technology?

There are several options for analysis, visualizations, and reporting in Azure, depending on your needs:

- [Power BI](/power-bi/)
- [Jupyter Notebooks](https://jupyter.readthedocs.io/en/latest/index.html)
- [Zeppelin Notebooks](https://zeppelin.apache.org/)
- [Jupyter Notebooks in VS Code](https://code.visualstudio.com/docs/datascience/jupyter-notebooks)

### Power BI

[Power BI](/power-bi/) is a suite of business analytics tools. It can connect to hundreds of data sources, and can be used for ad hoc analysis. See [this list](/power-bi/desktop-data-sources) of the currently available data sources. Use [Power BI Embedded](https://azure.microsoft.com/services/power-bi-embedded/) to integrate Power BI within your own applications without requiring any additional licensing.

Organizations can use Power BI to produce reports and publish them to the organization. Everyone can create personalized dashboards, with governance and [security built in](/power-bi/service-admin-power-bi-security). Power BI uses [Azure Active Directory (Azure AD)](/azure/active-directory/) to authenticate users who log in to the Power BI service, and uses the Power BI login credentials whenever a user attempts to access resources that require authentication.

### Jupyter Notebooks

[Jupyter Notebooks](https://jupyter.readthedocs.io/en/latest/index.html) provide a browser-based shell that lets data scientists create *notebook* files that contain Python, Scala, or R code and markdown text, making it an effective way to collaborate by sharing and documenting code and results in a single document.

Most varieties of HDInsight clusters, such as Spark or Hadoop, come [preconfigured with Jupyter notebooks](/azure/hdinsight/spark/apache-spark-jupyter-notebook-kernels) for interacting with data and submitting jobs for processing. Depending on the type of HDInsight cluster you are using, one or more kernels will be provided for interpreting and running your code. For example, Spark clusters on HDInsight provide Spark-related kernels that you can select from to execute Python or Scala code using the Spark engine.

Jupyter notebooks provide a great environment for analyzing, visualizing, and processing your data prior to building more advanced visualizations with a BI/reporting tool like Power BI.

### Zeppelin Notebooks

[Zeppelin Notebooks](https://zeppelin.apache.org/) are another option for a browser-based shell, similar to Jupyter in functionality. Some HDInsight clusters come [preconfigured with Zeppelin notebooks](/azure/hdinsight/spark/apache-spark-zeppelin-notebook). However, if you are using an [HDInsight Interactive Query](/azure/hdinsight/interactive-query/apache-interactive-query-get-started) (Hive LLAP) cluster, [Zeppelin](/azure/hdinsight/hdinsight-connect-hive-zeppelin) is currently your only choice of notebook that you can use to run interactive Hive queries. Also, if you are using a [domain-joined HDInsight cluster](/azure/hdinsight/domain-joined/apache-domain-joined-introduction), Zeppelin notebooks are the only type that enables you to assign different user logins to control access to notebooks and the underlying Hive tables.

### Jupyter Notebooks in VS Code

VS Code is a free code editor and development platform that you can use locally or connected to remote compute. Combined with the Jupyter extension, it offers a full environment for Jupyter development that can be enhanced with additional language extensions. If you want a best-in-class, free Jupyter experience with the ability to leverage your compute of choice, this is a great option.
Using VS Code, you can develop and run notebooks against remotes and containers. To make the transition easier from Azure Notebooks, we have made the container image available so it can be used with VS Code too.

Jupyter (formerly IPython Notebook) is an open-source project that lets you easily combine Markdown text and executable Python source code on one canvas called a notebook. Visual Studio Code supports working with Jupyter Notebooks natively, and through Python code files.

## Key selection criteria

To narrow the choices, start by answering these questions:

- Do you need to connect to numerous data sources, providing a centralized place to create reports for data spread throughout your domain? If so, choose an option that allows you to connect to 100s of data sources.

- Do you want to embed dynamic visualizations in an external website or application? If so, choose an option that provides embedding capabilities.

- Do you want to design your visualizations and reports while offline? If yes, choose an option with offline capabilities.

- Do you need heavy processing power to train large or complex AI models or work with very large data sets? If yes, choose an option that can connect to a big data cluster.

## Capability matrix

The following tables summarize the key differences in capabilities.

### General capabilities

| Capability | Power BI | Jupyter Notebooks | Zeppelin Notebooks | Jupyter Notebooks in VS Code |
| --- | --- | --- | --- | --- |
| Connect to big data cluster for advanced processing | Yes | Yes | Yes | No |
| Managed service | Yes | Yes <sup>1</sup> | Yes <sup>1</sup> | Yes |
| Connect to 100s of data sources | Yes | No | No | No |
| Offline capabilities | Yes <sup>2</sup> | No | No | No |
| Embedding capabilities | Yes | No | No | No |
| Automatic data refresh | Yes | No | No | No |
| Access to numerous open source packages | No | Yes <sup>3</sup> | Yes <sup>3</sup> | Yes <sup>4</sup> |
| Data transformation/cleansing options | [Power Query](https://powerbi.microsoft.com/blog/getting-started-with-power-query-part-i/), R | 40 languages, including Python, R, Julia, and Scala | 20+ interpreters, including Python, JDBC, and R | Python, F#, R |
| Pricing | Free for Power BI Desktop (authoring), see [pricing](https://powerbi.microsoft.com/pricing/) for hosting options | Free | Free | Free |
| Multiuser collaboration | [Yes](/power-bi/service-how-to-collaborate-distribute-dashboards-reports) | Yes (through sharing or with a multiuser server like [JupyterHub](https://github.com/jupyterhub/jupyterhub)) | Yes | Yes (through sharing) |

[1] When used as part of a managed HDInsight cluster.

[2] With the use of Power BI Desktop.

[2] You can search the [Maven repository](https://search.maven.org/) for community-contributed packages.

[3] Python packages can be installed using either pip or conda. R packages can be installed from CRAN or GitHub. Packages in F# can be installed via nuget.org using the [Paket dependency manager](https://fsprojects.github.io/Paket/).

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Zoiner Tejada](https://www.linkedin.com/in/zoinertejada) | CEO and Architect

## Next steps

- [Get started with Jupyter notebooks for Python](/training/modules/python-create-run-jupyter-notebook)
- [Notebooks](/azure/databricks/notebooks)
- [Run Azure Databricks Notebooks with Azure Data Factory](/training/modules/run-azure-databricks-notebooks-azure-data-factory)
- [Run Jupyter notebooks in your workspace](/azure/machine-learning/how-to-run-jupyter-notebooks)
- [What is Power BI?](/power-bi/fundamentals/power-bi-overview)

## Related resources

- [Advanced analytics architecture](../../solution-ideas/articles/advanced-analytics-on-big-data.yml)
- [Data analysis and visualization in an Azure industrial IoT analytics solution](../../guide/iiot-guidance/iiot-data.yml)
- [Technology choices for Azure solutions](../../guide/technology-choices/technology-choices-overview.md)
