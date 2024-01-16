---
title: The Team Data Science Process lifecycle
description: The Team Data Science Process (TDSP) provides a recommended lifecycle that you can use to structure your data-science projects.
author: marktab
manager: marktab
editor: marktab
services: architecture-center
ms.service: architecture-center
ms.subservice: azure-guide
ms.topic: conceptual
ms.date: 01/15/2024
ms.author: tdsp
ms.custom:
  - previous-author=deguhath
  - previous-ms.author=deguhath
products:
  - azure-machine-learning
categories:
  - ai-machine-learning
---
# The Team Data Science Process lifecycle

The Team Data Science Process (TDSP) provides a recommended lifecycle that your team may use to structure your data-science projects. The lifecycle outlines the complete steps that successful projects follow. If you use another data-science lifecycle, such as the Cross Industry Standard Process for Data Mining [(CRISP-DM)](https://wikipedia.org/wiki/Cross_Industry_Standard_Process_for_Data_Mining), Knowledge Discovery in Databases [(KDD)](https://wikipedia.org/wiki/Data_mining#Process), or your organization's own custom process, your team may still use the task-based TDSP.

This lifecycle is designed for data-science projects that are intended to ship as part of intelligent applications. These applications deploy machine learning or artificial intelligence models for predictive analytics. Exploratory data-science projects and improvised analytics projects may also benefit from the use of this process. But for those projects, some of the steps described here might not be needed.

The supporting links provide additional guidance especially on how to apply TDSP within Microsoft Azure.

## Purpose and Impact

The purpose of TDSP is to streamline and standardize the approach to data science and artificial intelligence projects.  The methodology is structured, has been used in hundreds of projects at Microsoft, and has been studied in the peer-reviewed literature.  The broad applicability and academic framework provide assurance of the utility of this architectural framework.

## Five lifecycle stages

The TDSP lifecycle is composed of five major stages that are executed iteratively. These stages include:

1. [Business understanding](lifecycle-business-understanding.md)
2. [Data acquisition and understanding](lifecycle-data.md)
3. [Modeling](lifecycle-modeling.md)
4. [Deployment](lifecycle-deployment.md)
5. [Customer acceptance](lifecycle-acceptance.md)

Here is a visual representation of the TDSP lifecycle:

![TDSP lifecycle](./media/lifecycle/tdsp-lifecycle2.png)

The TDSP lifecycle is modeled as a sequence of iterated steps that provide guidance on the tasks needed to use predictive models. Your team deploys the predictive models in the production environment that you plan to use to build the intelligent applications. The goal of this process lifecycle is to continue to move a data science project toward a clear engagement end point. Data science is an exercise in research and discovery. The ability to communicate tasks to your team and your customers by using a well-defined process increases the chance of the successful completion of a complex data science project.

For each stage, we provide the following information:

* **Goals**: The specific objectives.
* **How to do it**: An outline of the specific tasks and guidance on how to complete them.
* **Artifacts**: The deliverables and the support to produce them.

## Peer-Reviewed Citations

Researchers publish on TDSP in the peer-reviewed literature.  These citations provide an opportunity to investigate TDSP features and applications.

Amershi, S., Begel, A., Bird, C., DeLine, R., Gall, H., Kamar, E., Nagappan, N., Nushi, B., & Zimmermann, T. (2019). Software Engineering for Machine Learning: A Case Study. 2019 IEEE/ACM 41st International Conference on Software Engineering: Software Engineering in Practice (ICSE-SEIP), 291–300. https://doi.org/10.1109/ICSE-SEIP.2019.00042

Biswas, S., Wardat, M., & Rajan, H. (2022). The art and practice of data science pipelines: A comprehensive study of data science pipelines in theory, in-the-small, and in-the-large. Proceedings of the 44th International Conference on Software Engineering, 2091–2103. https://doi.org/10.1145/3510003.3510057

De Silva, D., & Alahakoon, D. (2022). An artificial intelligence life cycle: From conception to production. Patterns, 3(6), 100489. https://doi.org/10.1016/j.patter.2022.100489

Díaz Álvarez, Y., Hidalgo Reyes, M. Á., Lagunes Barradas, V., Pichardo Lagunas, O., & Martínez Seis, B. (2022). A Hybrid Methodology Based on CRISP-DM and TDSP for the Execution of Preprocessing Tasks in Mexican Environmental Laws. In O. Pichardo Lagunas, J. Martínez-Miranda, & B. Martínez Seis (Eds.), Advances in Computational Intelligence (Vol. 13613, pp. 68–82). Springer Nature Switzerland. https://doi.org/10.1007/978-3-031-19496-2_6

Karlsruhe Institute of Technology (KIT) / IBM, Kühl, N., Hirt, R., Karlsruhe Institute of Technology (KIT) / Prenode, Baier, L., Karlsruhe Institute of Technology (KIT), Schmitz, B., Karlsruhe Institute of Technology (KIT) / IBM, Satzger, G., & Karlsruhe Institute of Technology (KIT) / IBM. (2021). How to Conduct Rigorous Supervised Machine Learning in Information Systems Research: The Supervised Machine Learning Report Card. Communications of the Association for Information Systems, 48(1), 589–615. https://doi.org/10.17705/1CAIS.04845

Lu, J., Cairns, L., & Smith, L. (2021). Data science in the business environment: Customer analytics case studies in SMEs. Journal of Modelling in Management, 16(2), 689–713. https://doi.org/10.1108/JM2-11-2019-0274

Martinez-Plumed, F., Contreras-Ochando, L., Ferri, C., Hernandez-Orallo, J., Kull, M., Lachiche, N., Ramirez-Quintana, M. J., & Flach, P. (2021). CRISP-DM Twenty Years Later: From Data Mining Processes to Data Science Trajectories. IEEE Transactions on Knowledge and Data Engineering, 33(8), 3048–3061. https://doi.org/10.1109/TKDE.2019.2962680

Özsu, M. T. (2023). Data Science—A Systematic Treatment. Communications of the ACM, 66(7), 106–116. https://doi.org/10.1145/3582491

Schlegel, M., & Sattler, K.-U. (2023). Management of Machine Learning Lifecycle Artifacts: A Survey. ACM SIGMOD Record, 51(4), 18–35. https://doi.org/10.1145/3582302.3582306

Siebert, J., Joeckel, L., Heidrich, J., Trendowicz, A., Nakamichi, K., Ohashi, K., Namba, I., Yamamoto, R., & Aoyama, M. (2022). Construction of a quality model for machine learning systems. Software Quality Journal, 30(2), 307–335. https://doi.org/10.1007/s11219-021-09557-y

Yablonsky, S. (2021, June 20). Machine Learning-driven Innovation Management: Conceptional Framework. Event Proceedings: LUT Scientific and Expertise Publications: ISBN 978-952-335-467-8. The ISPIM Innovation Conference – Innovating Our Common Future, Berlin, Germany on 20-23 June 2021, Berlin, Germany.

## Next steps

For the first element of the lifecycle, see [Business Understanding](/azure/architecture/data-science-process/lifecycle-business-understanding).

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.* 

Principal author:

 - [Mark Tabladillo](https://www.linkedin.com/in/marktab/) | Senior Cloud Solution Architect
 
*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Related resources

- [What is the Team Data Science Process?](/azure/architecture/data-science-process/overview)
- [Compare the machine learning products and technologies from Microsoft](/azure/architecture/data-guide/technology-choices/data-science-and-machine-learning)
