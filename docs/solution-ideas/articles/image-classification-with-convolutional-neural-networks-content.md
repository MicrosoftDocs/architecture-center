[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

With the rise of technologies, such as the internet of things (IoT) and artificial intelligence (AI), the world is generating large amounts of data. Extracting relevant information from the data has become a major challenge. Image classification is a relevant solution to identifying what an image represents. Image classification can help you bucket high volumes of images. Convolutional neural networks (CNNs) render good performance on image datasets. CNNs have played a major role in the development of modern state-of-the-art image classification solutions.

There are three main types of layers in CNNs:

- Convolutional layer
- Pooling layer
- Fully connected (FC) layer

The convolutional layer is the first layer of a convolutional network. These layers can follow another convolutional layer or pooling layers. In general, the fully connected layer is the final layer in the network. With the increase in the number of layers, the complexity of the model increases and can help identify bigger portions of the image. The beginning layers are focused on simple features, such as edges. As the image data advances through the layers of the CNN, the network starts recognizing more sophisticated elements or shapes of the object, and finally, it identifies the expected object.

## Potential use cases

- This solution can help automate failure detection (instead of relying solely on human operators), improve the identification of faulty electronic components, and boost productivity.
- Lean manufacturing, cost control, and waste reduction are imperative for manufacturing to remain competitive. In circuit-board manufacturing, faulty boards can cost manufacturers money and productivity. Assembly lines rely on human operators to quickly review and validate boards, which are flagged as potentially faulty by assembly-line test machines.
- Image classification is ideal for the healthcare industry. It helps detect anomalies in tissues, bone cracks, and various types of cancer. You can also use image classification to flag irregularities that can indicate the presence of disease. An image classification model can improve the accuracy of the MRIs.
- In the agriculture domain, image classification solutions help identify plant diseases and plants that require water and reduce human intervention.

## Architecture

![Architecture diagram: image classification with convolutional neural networks and Azure Machine Learning.](../media/image-classification-with-convolutional-neural-networks.png)
*Download an [SVG file](../media/image-classification-with-convolutional-neural-networks.svg) of this architecture.*

### Dataflow

1. Image uploads to Azure Blob Storage are ingested to Azure Machine Learning.
2. Since the solution follows a supervised learning approach and needs data labeling to train the model, the ingested images can be labeled in Machine Learning.
3. The convolutional neural network model is trained and validated in the Machine Learning notebook. Several pre-trained image classification models are available. You can use them by using a transfer learning approach. For information about some variants of pre-trained CNNs, see [Advancements in image classification using convolutional neural networks](https://arxiv.org/pdf/1905.03288.pdf). These image classification models can be downloaded and customized on your labeled data.
4. Post-training, the model is stored in a model register in Machine Learning.
5. The model can be deployed through batch managed endpoints.
6. The model results can be written to Azure Cosmos DB and consumed through the front-end application.

### Components

- [Blob Storage](https://azure.microsoft.com/services/storage/blobs) is a service that's part of [Azure Storage](https://azure.microsoft.com/products/category/storage). Blob Storage offers optimized cloud object storage for large amounts of unstructured data.
- [Machine Learning](https://azure.microsoft.com/services/machine-learning) is a cloud-based environment that you can use to train, deploy, automate, manage, and track machine learning models. You can use the models to forecast future behavior, outcomes, and trends.
- [Azure Cosmos DB](https://azure.microsoft.com/services/cosmos-db) is a globally distributed, multi-model database. With Azure Cosmos DB, your solutions can elastically scale throughput and storage across any number of geographic regions.
- [Azure Container Registry](https://azure.microsoft.com/services/container-registry) builds, stores, and manages container images and can store containerized machine learning models.

## Next steps

- To learn more about Blob Storage, see [Introduction to Azure Blob Storage](/azure/storage/blobs/storage-blobs-introduction).
- To learn more about Container Registry, see [Introduction to Container registries in Azure](/azure/container-registry/container-registry-intro).
- To learn more about model management (MLOps), see [MLOps: Model management, deployment, lineage, and monitoring with Azure Machine Learning](/azure/machine-learning/concept-model-management-and-deployment).
- To browse an implementation of this solution idea on GitHub, see [Synapse Machine Learning](https://github.com/azure/mmlspark).
- To explore a Microsoft Learn module that includes a section on CNNs, see [Train and evaluate deep learning models](/learn/modules/train-evaluate-deep-learn-models).

## Related resources

- [Real-time scoring of machine learning models in Python](../../reference-architectures/ai/real-time-scoring-machine-learning-models.yml)
- [Visual search in retail with Azure Cosmos DB](../../industries/retail/visual-search-use-case-overview.yml)
- [Distributed training of deep learning models on Azure](../../reference-architectures/ai/training-deep-learning.yml)
