---
title: Team Data Science Process for data scientists
description: Training guidance on a set of objectives that are typically used to implement comprehensive data science solutions with Azure technologies using the Team Data Science Process and Azure Machine Learning.
author: marktab
manager: marktab
editor: marktab
services: architecture-center
ms.service: architecture-center
ms.subservice: azure-guide
ms.topic: conceptual
ms.collection: ce-skilling-ai-copilot
ms.date: 06/18/2024
ms.author: tdsp
ms.custom:
  - previous-author=deguhath
  - previous-ms.author=deguhath
products:
  - azure-machine-learning
categories:
  - ai-machine-learning
---

# Team Data Science Process for data scientists

This article provides training guidance for objectives that you set when you implement comprehensive data science solutions with Azure technologies. 

## Objectives for Data Scientists

This list describes the key objectives for data scientists using TDSP:

- Understanding an analytics workload.
- Using the Team Data Science Process (TDSP).
- Using Azure Machine Learning.
- Understanding the foundations of data transfer and storage.
- Providing data source documentation.
- Using tools for analytics processing.

The sequential list provided is crucial for preparing to use
Microsoft\'s Team Data Science Process (TDSP) because it outlines a
comprehensive approach to effectively managing and executing data
science projects. Here's why each step is important, along with a list of Azure resources:

**1. Understanding an Analytics Workload**

**Importance:**

-   **Identify Requirements:** This step involves understanding the
    specific needs and goals of the analytics workload. It helps in
    identifying the business questions to be answered and the problems
    to be solved.

-   **Define Scope:** Clearly defining the scope of the project ensures
    that the team focuses on relevant data and analytics tasks.

-   **Resource Allocation:** Understanding the workload helps in
    determining the resources required, such as computing power,
    storage, and human expertise.

**Recommended Azure Resources**

1. [Azure Monitor overview](/azure/azure-monitor/overview) - Provides an understanding of monitoring and analytics services in Azure.

2. [Introduction to Azure Synapse Analytics](/azure/synapse-analytics/overview-what-is) - Covers the basic concepts of analytics workloads within Azure Synapse.

3. [Cloud Adoption Framework: Innovation with AI](/azure/cloud-adoption-framework/innovate/ai/) - A collection of documentation, implementation guidance, best practices, and tools that are proven guidance from Microsoft designed to accelerate your cloud adoption lifecycle.

**2. Using the Team Data Science Process (TDSP)**

**Importance:**

-   **Structured Approach:** TDSP provides a structured framework for
    executing data science projects, ensuring a systematic and
    disciplined approach.

-   **Collaboration:** TDSP promotes collaboration among team members by
    defining clear roles and responsibilities.

-   **Best Practices:** It incorporates industry best practices,
    ensuring that projects are conducted efficiently and effectively.

**Recommended Azure Resources**

1. [Team Data Science Process overview](/azure/machine-learning/team-data-science-process/overview) - Introduces the TDSP and its lifecycle.

2. [TDSP lifecycle and key components](/azure/machine-learning/team-data-science-process/lifecycle) - Details the lifecycle stages and key components of TDSP.

**3. Using Azure Machine Learning**

**Importance:**

-   **Advanced Analytics:** Azure Machine Learning provides powerful
    tools and services for building, training, and deploying machine
    learning models.

-   **Scalability:** Azure ML offers scalable computing resources,
    allowing teams to handle large datasets and complex models.

-   **Integration:** It integrates well with other Azure services,
    facilitating a seamless workflow from data ingestion to deployment.

**Recommended Azure Resources**

1. [Azure Machine Learning documentation](/azure/machine-learning/) - The main documentation page for Azure Machine Learning.

2. [What is Azure Machine Learning?](/azure/machine-learning/overview-what-is-azure-machine-learning) - An overview description of Azure Machine Learning.

3. [Tutorial: Train a model](/azure/machine-learning/tutorial-1st-experiment-sdk-setup) - Walks through the process of training a machine learning model.

**4. Understanding the Foundations of Data Transfer and Storage**

**Importance:**

-   **Data Management:** Effective data transfer and storage are
    critical for managing large volumes of data securely and
    efficiently.

-   **Accessibility:** Ensures that data is easily accessible to team
    members and analytical tools, which is essential for collaboration
    and real-time processing.

-   **Compliance and Security:** Understanding these foundations helps
    in ensuring that data handling complies with legal and regulatory
    requirements and that sensitive data is protected.

**Recommended Azure Resources**

1. [Data transfer options](/azure/architecture/data-guide/scenarios/data-transfer) - Discusses various data transfer and storage technologies in Azure.

2. [Azure Storage documentation](/azure/storage/) - Comprehensive documentation on Azure Storage services.

3. [Azure Database Migration Service](/azure/architecture/data-guide/scenarios/data-transfer) - Azure Database Migration Service enables seamless migrations from multiple database sources to Azure Data platforms with minimal downtime.

4.  **Related to Azure Machine Learning**: [Tutorial: Upload, access and explore your data in Azure Machine Learning](/azure/machine-learning/tutorial-explore-data) - Instruction on how to upload data and create an Azure Machine Learning data asset.

**5. Providing Data Source Documentation**

**Importance:**

-   **Data Transparency:** Documentation of data sources ensures
    transparency about where data comes from, its quality, and its
    limitations.

-   **Reproducibility:** Proper documentation allows other team members
    or stakeholders to understand and reproduce the data science
    process.

-   **Data Integration:** Helps in integrating various data sources
    effectively by providing a clear understanding of the data's origin
    and structure.

**Recommended Azure Resources**

1. [Azure Data Catalog documentation](/azure/data-catalog/) - Covers how to document and manage data sources using Azure Data Catalog.

2. [Azure Purview documentation](/azure/purview/) - Documentation for Azure Purview, a data governance solution.

3.  [Data concepts in Azure Machine Learning](/azure/machine-learning/concept-data) - Explains key Azure Machine Learning data concepts, for use in documentation.

**6. Using Tools for Analytics Processing**

**Importance:**

-   **Efficiency:** Utilizing the right tools for analytics processing
    enhances the efficiency and speed of data analysis.

-   **Capabilities:** Different tools offer various capabilities, such
    as data visualization, statistical analysis, and machine learning,
    which are essential for comprehensive data science.

-   **Productivity:** Using specialized tools can significantly improve
    the productivity of data scientists by automating repetitive tasks
    and providing advanced analytical functions.

**Recommended Azure Resources**

1. [Azure Synapse Analytics documentation](/azure/synapse-analytics/) - Comprehensive documentation for Azure Synapse Analytics.

2.  [Azure Data Factory documentation](/azure/data-factory/) - Information on using Azure Data Factory for data integration and analytics processing.

3.  [Apache Spark in Azure Machine Learning](/azure/machine-learning/apache-spark-azure-ml-concepts) - Azure Machine Learning integration with Azure Synapse Analytics provides easy access to distributed computation resources through the Apache Spark framework.

**Summary**

Following this sequential list ensures a comprehensive preparation for
using TDSP by:

-   Establishing a clear understanding of the project requirements and
    scope.

-   Adopting a structured and collaborative approach to project
    execution.

-   Leveraging advanced tools and services for machine learning and
    analytics.

-   Ensuring efficient and secure data management.

-   Maintaining transparency and reproducibility through documentation.

-   Utilizing appropriate tools to enhance the efficiency and
    effectiveness of data processing.

This preparation is critical for delivering successful data science
projects that meet business objectives and adhere to best practices.

## Training paths on Microsoft Learn

Whether you're just starting a career, or you are an experienced professional, our self-directed approach helps you arrive at your goals faster, with more confidence and at your own pace. Develop skills through interactive modules and paths or learn from an instructor. Learn and grow your way.

Microsoft Learn organizes its training content into three skill levels:
beginner, intermediate, and advanced. Understanding these distinctions
is essential for selecting the appropriate learning paths to match your
skill level and career goals.

### Beginner

**Description:**

-   **Target Audience:** Individuals who are new to the technology or
    concept being covered.

-   **Content:** Basic introductions to concepts, fundamental skills,
    and initial steps required to get started. It typically covers core
    principles and foundational knowledge.

**Purpose:**

-   To build a solid foundation in a new area.

-   To ensure learners understand basic concepts and terminologies.

-   To prepare learners for more complex topics.

**Learning Paths**

- [Copilot foundations](/training/paths/copilot-foundations/)
- [Deploy and consume models with Azure Machine Learning](/training/paths/deploy-consume-models-azure-machine-learning/)
- [Design a machine learning solution](/training/paths/design-machine-learning-solution/)
- [Experiment with Azure Machine Learning](/training/paths/automate-machine-learning-model-selection-azure-machine-learning/)
- [Explore and configure the Azure Machine Learning workspace](/training/paths/explore-azure-machine-learning-workspace/)
- [Implement a data science and machine learning solution for AI in Microsoft Fabric](/training/paths/implement-data-science-machine-learning-fabric/)
- [Manage and review models in Azure Machine Learning](/training/paths/manage-review-models-azure-machine-learning/)
- [Optimize model training with Azure Machine Learning](/training/paths/use-azure-machine-learning-pipelines-for-automation/)
- [Predict rocket launch delays with machine learning](/training/paths/machine-learning-predict-launch-delay-nasa/)
- [Train and manage a machine learning model with Azure Machine Learning](/training/paths/train-deploy-machine-learning-model/)
- [Train models with scripts in Azure Machine Learning](/training/paths/train-models-scripts-azure-machine-learning/)
- [Understand data science for machine learning](/training/paths/understand-machine-learning/)
- [Use notebooks for experimentation in Azure Machine Learning](/training/paths/use-notebooks-for-experimentation-azure-machine-learning/)
- [Work with compute in Azure Machine Learning](/training/paths/work-compute-azure-machine-learning/)
- [Work with data in Azure Machine Learning](/training/paths/work-data-azure-machine-learning/)


### Intermediate

**Description:**

-   **Target Audience:** Individuals who have a basic understanding of
    the technology and are looking to deepen their knowledge.

-   **Content:** More detailed and practical skills, including hands-on
    exercises and real-world scenarios. It involves a deeper dive into
    the subject matter.

**Purpose:**

-   To bridge the gap between basic understanding and advanced
    proficiency.

-   To enable learners to handle more complex tasks and scenarios.

-   To prepare learners for certification exams or specialized roles.

**Learning Paths**

- [Create custom copilots with Azure AI Studio](/training/paths/create-custom-copilots-ai-studio/)
- [Create machine learning models](/training/paths/create-machine-learn-models/)
- [Develop custom object detection models with NVIDIA and Azure Machine Learning](/training/paths/develop-custom-object-detection-models-with-nvidia-and-azure-machine-learning/)
- [End-to-end machine learning operations (MLOps) with Azure Machine Learning](/training/paths/build-first-machine-operations-workflow/)
- [Implement a Machine Learning solution with Azure Databricks](/training/paths/build-operate-machine-learning-solutions-azure-databricks/)
- [Train models in Azure Machine Learning with the CLI (v2)](/training/paths/train-models-azure-machine-learning-cli-v2/)
- [Work with generative artificial intelligence (AI) models in Azure Machine Learning](/training/paths/work-with-generative-models-azure-machine-learning/)

### Advanced

**Description:**

-   **Target Audience:** Experienced professionals who are looking to
    master their skills and tackle complex, high-level tasks.

-   **Content:** In-depth technical training, advanced techniques, and
    comprehensive coverage of specialized topics. It often includes
    expert-level problem-solving and optimization strategies.

**Purpose:**

-   To provide expertise in a specific area.

-   To prepare learners for expert-level certifications and advanced
    career roles.

-   To enable learners to lead projects and innovate within their field.

**Learning Path(s)**

- [Train compute-intensive models with Azure Machine Learning](/training/paths/train-compute-intensive-models-azure-machine-learning/)

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Mark Tabladillo](https://www.linkedin.com/in/marktab) | Senior Cloud Solution Architect

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

Continue your AI journey in the [AI learning hub](/ai/).

## Related resources

- [Data science and machine learning with Azure Databricks](../solution-ideas/articles/azure-databricks-data-science-machine-learning.yml)
- [What is the Team Data Science Process?](overview.yml)
