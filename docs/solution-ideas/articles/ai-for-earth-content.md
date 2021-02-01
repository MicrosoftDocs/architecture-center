

The earth currently faces urgent and accelerating environmental challenges. Climate change, biodiversity and habitat loss, pollution, overpopulation, and food and fresh water shortages need quick and comprehensive mitigation, but can seem so overwhelming that philosopher Timothy Morton calls them *hyperobjects*, entities so vast and distributed that they're difficult to fully define or comprehend.

Technology may have contributed to many of these issues, but we need technology to be able to conceptualize or solve them. Artificial intelligence (AI) is one tool that can help us both understand and potentially mitigate global environmental issues.

AI approaches to environmental challenges require substantial amounts of data, computing power, specialized tools, and expertise. The Microsoft [AI for Earth](https://www.microsoft.com/ai/ai-for-earth) initiative provides people and organizations with AI and cloud tools like open data sets, cloud compute grants, open-source APIs, and education to help them address global environmental challenges.

This article showcases the public Microsoft [AI for Earth APIs](https://www.microsoft.com/ai/ai-for-earth-tech-resources), and how they can work with Azure services and resources to help provide conservation solutions.

## Use cases

AI for Earth [projects](https://www.microsoft.com/ai/ai-for-earth-projects?activetab=pivot1%3aprimaryr2) are helping the environment today.

### Basemap

[SilviaTerra](https://www.silviaterra.com/) used the [Land Cover Mapping API](https://aiforearth.portal.azure-api.net/docs/services/ai-for-earth-land-cover-mapping-api-v2/operations/post-landcover-classify) to help develop a high-resolution inventory for every forested acre in the continental US. [Basemap](https://www.silviaterra.com/basemap) plots tree coverage, tree species and size, tree value, carbon sequestration, and habitat suitability, delivering insight to forest stakeholders from governments and conservation groups to large and small landowners.

Through an [AI for Earth grant](https://ai4edatasetspublicassets.blob.core.windows.net/grantee-profiles/SilviaTerra_US_Ag_AI4E%20Grantee%20Profile.pdf), Microsoft AI for Earth worked with SilviaTerra to combine their forestry expertise with Azure Open Datasets, Azure Storage, and Azure Machine Learning, and scale their coverage to hundreds of millions of acres. With better inventories, it's easier for conservationists to target their efforts, and frequent updates make short-term conservation projects and commitments feasible.

### Wildbook

[Wild Me](https://www.microsoft.com/ai/ai-for-earth-Wild-Me) used the [Species Classification API](https://aiforearth.portal.azure-api.net/docs/services/species-classification-v2/operations/predict), computer vision, and deep learning algorithms to create the open-source [Wildbook](http://wildbook.org/doku.php) platform. Fighting species extinction from poaching, habitat loss, and climate change requires huge amounts of data on population counts, location, birth rates, and migration patterns. Gathering and annotating this data manually is time- and cost-prohibitive, making citizen engagement critical to data collection. On Wildbooks like the [Wildbook for Whale Sharks](https://www.whaleshark.org/), the public can report their observations, and adopt and follow individual animals. Scientists can use the aggregated data to help inform conservation decisions.

Microsoft hosts Wildbook on Azure and makes Wild Me's open-source algorithms available as APIs. AI for Earth worked with Wild Me to scale Wildbook to the Azure cloud, allowing them to handle an ever-increasing number of supported species.

For more information about Wildbook, see the following links:

- [Video: Fighting extinction with Microsoft AI and citizen science](https://youtu.be/rQqao37u1wU)
- [Wildbook open-source code projects](https://github.com/WildMeOrg/Wildbook)

## Architecture

![Azure architecture to run AI for Earth APIs](../media/wildbook-network-diagram.png)

1. Species observations come from biologists and citizen scientists.
1. Observational data, datasets, AI data, and third-party data feed into data management servers in the cloud.
1. From the data servers, the latest data and AI models update the image analysis server, which applies constantly retrained cognitive skills.
1. All communication is bi-directional, feeding back to data collection and user interface enhancements.

## Components

The [AI for Earth APIs](https://www.microsoft.com/ai/ai-for-earth-tech-resources) work with Azure components to provide solutions.

### Land Cover Mapping API

Environmental scientists use satellite and aerial imagery to understand land use patterns. Strategic conservation planning depends on understanding land use, in particular the impacts of climate change and human population expansion on natural resources. However, distilling imagery into actionable data in the form of land cover maps has required extensive manual annotation. [Land Cover Mapping](https://www.microsoft.com/research/project/land-cover-mapping/) uses computer vision and machine learning to classify imagery into natural or human-made terrain types, providing high-resolution land cover information for precision conservation planning.

The public [Land Cover Mapping API](https://aiforearth.portal.azure-api.net/docs/services/ai-for-earth-land-cover-mapping-api-v2/operations/post-landcover-classify) can take a supplied TIFF or JPEG 1 meter-resolution aerial or satellite image, or any United States latitude and longitude data, and return an image file showing land cover classifications. The land cover classification image shows areas classified into water, forest, field, or built coverage. You can analyze and make decisions based on the land cover predicted in the image. The API also allows you to train your model by correcting the predictions and adding and training new classifications.

- [Land Cover training demo](https://aka.ms/landcoverdemo)
- [Land Cover Mapping video](https://www.youtube.com/watch?v=9aFUzUlHQVc)
- [Land Cover Mapping source code](https://github.com/Microsoft/landcover)

### Species Classification API

The Species Classification API lets developers use deep learning models for recognizing plants and animals.

Wildlife conservation depends on accurate, up-to-date wildlife population estimates, but population surveys often depend on humans to annotate millions of images. The public [Species Classification API](https://aiforearth.portal.azure-api.net/docs/services/species-classification-v2/operations/predict) helps automate citizen-scientist observations by identifying plants and animals in images from over 5000 species. The API has a single endpoint that takes an image as input and returns a predicted species and the confidence of the prediction.

- [Species Classification API demo](https://speciesclassification.westus2.cloudapp.azure.com/).
- [Species Classification source code](https://github.com/Microsoft/speciesclassification)

### Azure Open Datasets

[Azure Open Datasets](https://azure.microsoft.com/services/open-datasets/) are free, curated public datasets that help you train machine learning models and enrich predictive solutions. The datasets cover public-domain weather, census, holidays, public safety, and location data. You can share or request other public datasets through Azure Open Datasets. 

Azure Open Datasets preprocesses data to save you time. At regular intervals, Open Datasets pulls data from the sources, such as by an FTP connection to the National Oceanic and Atmospheric Administration (NOAA). After parsing the data into a structured format, Open Datasets enriches it with features like ZIP Code or location of the nearest weather station.

With an Azure account, you can access Open Datasets through the Azure portal or through APIs. Colocating with Azure compute and other services makes access and manipulation easier. Open Datasets are also available through the Azure Machine Learning UI and SDK. Open Datasets also provides Azure Notebooks and Azure Databricks notebooks you can use to connect data to Azure Machine Learning and Azure Databricks. You can also access Open Datasets through a Python SDK.

You don't need an Azure account to get Open Datasets. You can access them from any Python environment, with or without Spark.

- [Overview of Azure Open Datasets](/azure/open-datasets/overview-what-are-open-datasets)
- [Full catalog of Azure Open Datasets](https://azure.microsoft.com/services/open-datasets/catalog/)

### Azure Notebooks

[Azure Notebooks](https://notebooks.azure.com/) is a free service for anyone to develop and run code in their browser using Jupyter. [Jupyter](https://jupyter.org/) is an open-source project that enables combining markdown prose, executable code, and graphics onto a single canvas called a notebook. Notebooks are an excellent way for data scientists and AI engineers to share and collaborate in the cloud.

### Other components

These Azure components can contribute to an AI for Earth solution:

- [Azure Blob Storage](https://azure.microsoft.com/services/storage/blobs/) stores raw or preprocessed data.
- Cognitive Service APIs like [Computer Vision](/azure/cognitive-services/computer-vision/) extract and process structured data and text from unstructured sources.
- High-performing Linux [virtual machines](https://azure.microsoft.com/services/virtual-machines/) (VMs) scale out to process and analyze data as needed. [Data Science Virtual Machines](https://azure.microsoft.com/services/virtual-machines/data-science-virtual-machines/) come preconfigured with data science modeling and machine learning tools.
- [Azure Backup](https://azure.microsoft.com/services/backup/) backs up VMs and protects critical data.
- [Container Registry](https://azure.microsoft.com/services/container-registry/) stores containers for apps and data.
- [Application Insights](/azure/azure-monitor/app/app-insights-overview) monitors servers and services for performance and outages.
- [Azure DevOps](https://azure.microsoft.com/services/devops/) monitors and manages operations during development.

## Issues and considerations

- Azure Open Datasets can consume hundreds of terabytes of resources, so it's best to perform large-scale processing in the same Azure datacenter where you store the data. If you're using Open Datasets for environmental science applications, consider applying for an [AI for Earth grant](https://www.microsoft.com/ai/ai-for-earth-grants) to support your compute requirements.
- Azure Notebooks is currently in public preview. The preview version doesn't have a service level agreement, and isn't recommended for production workloads. The preview version doesn't support some features, and may have constrained capabilities.
- Some US addresses might not work in the demo Land Cover Mapping Notebook. If the address you supply doesn't work, try another address.
- The Species Classification API version in the demo notebook might misidentify some species. The current version of the API is 2.0.

## Deployment

The hands-on demo Azure Notebooks showcase the AI for Earth **Land Cover Mapping** and **Species Classification** APIs.

### Prerequisites

- Get keys for the Land Cover Mapping and Species Classification APIs by emailing [aiforearthapi@microsoft.com](mailto:aiforearthapi@microsoft.com).
- Have a Microsoft or Azure DevOps organizational account.

To run the demo Notebooks:

1. Open the [Land Cover Mapping](https://notebooks.azure.com/operations-manager/projects/ai-for-earth) or [Species Classification](https://notebooks.azure.com/operations-manager/projects/ai-for-earth-apis) project.
2. Select **Sign in** at upper right, and after signing in with your Microsoft or Azure account, select **Clone**.
3. On the pop-up screen, select **I trust the contents of this project**, and then select **Clone** again.
4. After you clone the project, select **Run on Free Compute**.
5. On the next screen, select the *.ipynb* file. 
6. In the Notebook, paste the API Key you received into the appropriate placeholder.
7. Select each cell in turn, and then select **Run** to run the cell. You can ignore any `pip` warnings that appear when installing packages.
8. Follow the prompts to enter different addresses for the Land Cover Mapping demo, or different species for the Species Classification demo, and see the APIs in action.

## Next steps

- If you have an idea for an environmental solution, consider applying for a Microsoft AI for Earth grant. The four focus areas for AI for Earth grants are agriculture, biodiversity, climate change, and water issues. Grants are for Azure compute credits or for data labeling services, an important prerequisite for most AI projects. Grantees can also get technical advice and support, online Azure training materials, and networking and educational opportunities. For more information, see [AI for Earth's grant process and details](https://www.microsoft.com/ai/ai-for-earth-grants).

- See the other initiatives in [Microsoft AI for Good](https://www.microsoft.com/ai/ai-for-good), providing technology, resources, and expertise to help solve humanitarian issues and create a more sustainable and accessible world.