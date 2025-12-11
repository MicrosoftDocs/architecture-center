---
title: Choose a Data Analytics and Reporting Technology in Azure
description: Evaluate big data analytics technology options for Azure. Use key selection criteria and a capability matrix to help you choose a data analytics technology.
author: claytonsiemens77
ms.author: pnp
ms.date: 07/25/2022
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom: arb-data
---

# Choose a data analytics and reporting technology in Azure

The goal of most big data solutions is to provide insights into the data through analysis and reporting. Analysis and reporting can include preconfigured reports and visualizations or interactive data exploration.

## Data analytics technology options

There are several options for analysis, visualizations, and reporting in Azure, depending on your needs:

- [Power BI](/power-bi/)
- [Jupyter notebooks](https://jupyter.readthedocs.io/en/latest/index.html)
- [Zeppelin notebooks](https://zeppelin.apache.org/)
- [Jupyter notebooks in Visual Studio Code (VS Code)](https://code.visualstudio.com/docs/datascience/jupyter-notebooks)

### Power BI

[Power BI](/power-bi/) is a suite of business analytics tools. It can [connect to hundreds of data sources](/power-bi/desktop-data-sources#connect-to-a-data-source), and you can use it for unplanned analysis. Use [Power BI Embedded](https://azure.microsoft.com/services/power-bi-embedded/) to integrate Power BI within your own applications without requiring any extra licensing.

Organizations can use Power BI to produce reports and publish them to the organization. Everyone can create personalized dashboards, with governance and [security built in](/power-bi/service-admin-power-bi-security). Power BI uses [Microsoft Entra ID](/entra/identity/) to authenticate users who sign in to the Power BI service. It uses the Power BI credentials when a user attempts to access resources that require authentication.

### Jupyter notebooks

[Jupyter notebooks](https://jupyter.readthedocs.io/en/latest/index.html) provide a browser-based shell that lets data scientists create *notebook* files that contain Python, Scala, or R code and Markdown text. These capabilities make notebooks an effective way to collaborate by sharing and documenting code and results in a single document.

Most varieties of HDInsight clusters, such as Spark or Hadoop, are [preconfigured with Jupyter notebooks](/azure/hdinsight/spark/apache-spark-jupyter-notebook-kernels) for interacting with data and submitting jobs for processing. Depending on the type of HDInsight cluster that you use, one or more kernels are provided to interpret and run your code. For example, Spark clusters on HDInsight provide Spark-related kernels that you can select to run Python or Scala code by using the Spark engine.

Jupyter notebooks provide an effective environment for analyzing, visualizing, and processing your data before you build more advanced visualizations by using a BI reporting tool like Power BI.

### Zeppelin notebooks

[Zeppelin notebooks](https://zeppelin.apache.org/) also provide a browser-based shell that has similar functionality to Jupyter notebooks. Some HDInsight clusters are [preconfigured with Zeppelin notebooks](/azure/hdinsight/spark/apache-spark-zeppelin-notebook). However, if you use an [HDInsight Interactive Query](/azure/hdinsight/interactive-query/apache-interactive-query-get-started) (also called Apache Hive LLAP) cluster, [Zeppelin](/azure/hdinsight/hdinsight-connect-hive-zeppelin) is the only notebook that you can use to run interactive Hive queries. Also, if you use a [domain-joined HDInsight cluster](/azure/hdinsight/domain-joined/apache-domain-joined-introduction), Zeppelin notebooks are the only type of notebooks that enable you to assign different user logins to control access to notebooks and the underlying Hive tables.

### Jupyter notebooks in VS Code

VS Code is a free code editor and development platform that you can use locally or connected to remote compute. When you use VS Code with the Jupyter extension, it provides a fully integrated environment for Jupyter development that can be enhanced with more language extensions. Choose this option if you want a best-in-class, free Jupyter experience and to be able to use your compute of choice. 

By using VS Code, you can develop and run notebooks against remotes and containers. To simplify the transition from Azure notebooks, the container image is also available for you to use with VS Code.

Jupyter (formerly IPython Notebook) is an open-source project that lets you easily combine Markdown text and executable Python source code on one canvas called a notebook. VS Code supports working with Jupyter notebooks natively and through Python code files.

## Key selection criteria

Start narrowing your choices by answering the following questions:

- Do you need to connect to numerous data sources and provide a centralized place to create reports for data spread throughout your domain? If you do, choose an option that allows you to connect to hundreds of data sources.

- Do you want to embed dynamic visualizations in an external website or application? If you do, choose an option that provides embedding capabilities.

- Do you want to design your visualizations and reports while offline? If you do, choose an option that has offline capabilities.

- Do you need heavy processing power to train large or complex AI models or work with large data sets? If you do, choose an option that can connect to a big data cluster.

## Capability matrix

The following table summarizes the key differences in capabilities.

### General capabilities

| Capability | Power BI | Jupyter notebooks | Zeppelin notebooks | Jupyter notebooks in VS Code |
| --- | --- | --- | --- | --- |
| Connect to big data clusters for advanced processing | Yes | Yes | Yes | No |
| Managed service | Yes | Yes <sup>1</sup> | Yes <sup>1</sup> | Yes |
| Connect to hundreds of data sources | Yes | No | No | No |
| Offline capabilities | Yes <sup>2</sup> | No | No | No |
| Embedding capabilities | Yes | No | No | No |
| Automatic data refresh | Yes | No | No | No |
| Access to numerous open-source packages | No | Yes <sup>3</sup> | Yes <sup>3</sup> | Yes <sup>4</sup> |
| Data transformation or cleansing options | [Power Query](https://powerbi.microsoft.com/blog/getting-started-with-power-query-part-i/), R | 40 languages, including Python, R, Julia, and Scala | More than 20 interpreters, including Python, JDBC, and R | Python, F#, R |
| Pricing | Free for Power BI Desktop (authoring). See [Power BI pricing](https://powerbi.microsoft.com/pricing/) for hosting options. | Free | Free | Free |
| Multiuser collaboration | [Yes](/power-bi/service-how-to-collaborate-distribute-dashboards-reports) | Yes (via sharing or with a multiuser server like [JupyterHub](https://jupyterhub.readthedocs.io/en/stable/)) | Yes | Yes (via sharing) |

[1] When used as part of a managed HDInsight cluster.

[2] With the use of Power BI Desktop.

[3] You can search the [Maven repository](https://search.maven.org/) for community-contributed packages.

[4] You can install Python packages by using either pip or Conda. You can install R packages from CRAN or GitHub. You can install packages in F# via nuget.org by using the [Paket dependency manager](https://fsprojects.github.io/Paket/).

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Zoiner Tejada](https://www.linkedin.com/in/zoinertejada) | CEO and Architect

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Introduction to Databricks notebooks](/azure/databricks/notebooks)
- [Run Azure Databricks notebooks with Azure Data Factory](/training/modules/run-azure-databricks-notebooks-azure-data-factory)
- [Run Jupyter notebooks in your workspace](/azure/machine-learning/how-to-run-jupyter-notebooks)
- [What is Power BI?](/power-bi/fundamentals/power-bi-overview)

## Related resource

- [Technology choices for Azure solutions](../../guide/technology-choices/technology-choices-overview.md)
