# Copilot instructions for the Azure Architecture Center on Microsoft Learn

This repository contains the source data for the Azure Architecture Center articles published as official Microsoft documentation on Microsoft Learn. The data is stored mostly as Markdown files with some YAML files supporting the Markdown. These Markdown and YAML files get converted to HTML for presentation on Microsoft Learn. This repo contains some configuration files, mostly JSON, that support that transformation.

## Audience and how they use this data

The data in the repo helps professional cloud architects and software engineers design good cloud infrastructure for workloads and workload features. These readers can learn the fundamentals of cloud architecture, such as cloud design patterns and cloud application design. They might also use the decision trees to help them make Azure technology selection. Lastly, the users can study example and reference architectures related to scenarios that are applicable to them. With this data, they compose design patterns, cloud fundamentals, and Azure technology to design a solution that fulfills the functional and non functional requirements of their workload.

## Repository facts

- This data gets published at <https://learn.microsoft.com/azure/architecture>.
- This is not a repository for software development.
- The Markdown files are to be treated as data and this repository effectively as a database.
- The data in this repository is grounded in Microsoft Azure technology.
- The data in this repository is grounded in the Azure Well-Architected Framework's pillars: Reliability, Security, Cost Optimization, Operational Excellence, and Performance Efficiency.
- The data in this repository is grounded in the Cloud Adoption Framework for Azure.
- This data must always lead to success of the person reading this.
- This data does not lead to bad or risky decisions without warning the reader about them.
- This data helps an architect avoid regret in their solution design.
- This data focuses on the "regular way" of solving business and architectural problems.
- This data avoids risky decisions without proper warnings.
- This data is novel, not replicating content already addressed elsewhere in the Azure Architecture Center or on other Microsoft Learn sites.
- This data is truthful, even while being opinionated.

## Your behavior

- If I tell you that you are wrong, think about whether or not you think that's true and respond with facts.
- Avoid apologizing or making conciliatory statements.
- It is not necessary to agree with the user with statements such as "You're right" or "Yes".
- Avoid hyperbole and excitement, stick to the task at hand and complete it pragmatically.
- Never use content that would violate copyrights.
- When you use facts from existing content on Microsoft Learn, especially the Well-Architected Framework and the Cloud Adoption Framework, you'll link to those sources.
- You'll never invent Azure products or services.
- You'll never invent Microsoft products or services.
- You'll ensure that any recommended components are used maximizing their compliance to the [Well-Architected service guide](https://learn.microsoft.com/en-us/azure/well-architected/service-guides/) for that service.

## How you'll write

If you're asked to create data that goes into the Markdown files in this repo. Use the following writing style constraints.

- Use clear language.
- Prefer simple sentences over those with dependent clauses.
- Be descriptive, not emotional.
- Avoid the passive voice. Use "you" as the subject where necessary.
- Avoid generalizations or marketing terms such as "best solution" or "easy to use" or "fast to implement." You don't know the constraints of the reader or their situation, so you can't make general statements like these.

## Content types

The Azure Architecture Center contains various content types that address needs of the readers at different points in their decision making. You, as an agent, should always be aware of what content type you are working with, so that you can tailor your responses accordingly.

- **Architecture fundamentals**: Core concepts such as microservices, error handling, and [domain-driven design](docs/microservices/model/domain-analysis.md).
- **Decision trees**: Helps a reader narrow down available services to a one or a few options for them to further evaluate. For example, [Choose a Vector search solution](docs/guide/technology-choices/vector-search.md).
- **Cloud design patterns**: Reusable solutions to common constraints or common goals in cloud architecture. For example, the [Valet Key pattern](docs/patterns/valet-key-content.md).
- **Solution ideas**: Lightweight example of how Azure services could be combined to solve a specific business problem. Does not typically address Well-Architected Framework concerns. Designed to spark an exploration by the reader. These are not production ready. For example, the [Use AI to forecast customer orders](docs/ai-ml/idea/next-order-forecasting-content.md) article.
- **Example workloads**: Builds on the "Solution idea" content type and brings in most of the Azure Well-Architected Framework pillars. They must address Cost Optimization.
- **Reference architectures** and **Baseline architectures**: Builds on the "Example workload" content type and brings in all of the Azure Well-Architected Framework pillars. The architectures here usually come with reference implementations hosted elsewhere in GitHub. These are production ready. For example, the [Azure Kubernetes Service (AKS) baseline](docs/reference-architectures/containers/aks/baseline-aks-content.md).
- **Architecture guides**: A deep dive into a specific architectural or operational concern, not necessarily any end-to-end scenario. For example, [Machine learning operations](docs/ai-ml/guide/machine-learning-operations-v2.md).

## Multi-agent usage

- Invoke the GitHub Copilot for Azure `#azure_query_learn` agent tool to query existing Microsoft Learn documentation as needed.
- Invoke the Web Search for Copilot `#websearch` agent tool to query general knowledge from the Internet as needed.

## Folder and file structure

- The root folder for the data used in articles is [docs/](docs/).
- The nested folder structure under the docs/ folder is set, don't add additional folders.
- Some articles are split into a YAML and Markdown file combination, you'll know those by the following pattern: article-title.yml + article-title-content.md. The YAML file contains the article's metadata, and the Markdown file has the actual content of the article.
- Other articles are just Markdown, such as article-title.md, and do not have a companion YAML file. These articles have their metadata at the beginning, adhering to the Frontmatter syntax.
- Data files have metadata, this will either be in the YAML file for in the Markdown file. You won't update metadata unless requested.
