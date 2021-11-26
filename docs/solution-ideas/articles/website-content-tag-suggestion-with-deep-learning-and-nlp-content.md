[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Social sites, forums, and other text-heavy Q&A services rely heavily on content tagging, which enables good indexing and user search. Often, however, content tagging is left to users' discretion. Because users don't have lists of commonly searched terms or a deep understanding of the site structure, they frequently mislabel content. Mislabeled content is difficult or impossible to find when it's needed later.

## Potential use cases

By combining deep learning and natural language processing (NLP) with data on site-specific search terms, this solution helps greatly improve content tagging accuracy on a site. As users type content, this solution offers highly used terms as suggested content tags, which makes it easier for others to find the information.

## Architecture

![Architecture diagram: overview of using Azure Machine Learning to help suggest content tags for websites.](../media/website-content-tag-suggestion-with-deep-learning-and-nlp.png)

*Download an [SVG](../media/website-content-tag-suggestion-with-deep-learning-and-nlp.svg) of this architecture.*

### Workflow

* Data is stored, structured, and indexed using Microsoft SQL Server.
* Model training, including hyperparameter tuning, and deployment of the final model, including scaling out to a Kubernetes-managed Azure cluster.
* The core development environment for this solution is a customized VM image on the Azure cloud platform built specifically for doing data science.
* Jupyter Notebooks can be used as the base integrated development environment (IDE) for the model.
* Stores real-time web services as Docker containers. These containers are uploaded and registered via Azure Container Registry.
* Deployment for this solution uses Azure Kubernetes Service running a Kubernetes-managed cluster. The containers are deployed from images stored in Azure Container Registry.

### Components

* [Microsoft SQL Server](/sql/)
* [Azure Machine Learning](https://azure.microsoft.com/en-us/services/machine-learning/)
* [Azure Data Science Virtual Machine](/azure/machine-learning/data-science-virtual-machine/)
* [Jupyter Notebooks on Azure Data Science VM](/azure/machine-learning/data-science-virtual-machine/reference-ubuntu-vm)
* [Azure Container Registry](/azure/container-registry/)
* [Azure Kubernetes Service (AKS)](https://azure.microsoft.com/services/kubernetes-service)

## Next steps

See product documentation:

* [Azure Machine Learning](/azure/machine-learning)
* [Azure Kubernetes Service](/azure/aks/intro-kubernetes)
* [Learn more about Azure Container Registry](/azure/container-registry/container-registry-intro)
* [Microsoft SQL Server](https://www.microsoft.com/sql-server/sql-server-2017)
* [Learn more about Jupyter Notebooks](https://jupyter.org)

Try these Microsoft Learn modules:

* [Introduction to Natural Language Processing with PyTorch](/learn/modules/intro-natural-language-processing-pytorch/)
* [Train and evaluate deep learning models](/learn/modules/train-evaluate-deep-learn-models/)
* [Create and connect to a Data Science Virtual Machine](/learn/modules/intro-to-azure-data-science-virtual-machine/)
* [Implement knowledge mining with Azure Cognitive Search](/learn/paths/implement-knowledge-mining-azure-cognitive-search/)
