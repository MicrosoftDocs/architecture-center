[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

With the rise of technologies, such as the internet of things (IoT) and artificial intelligence (AI), the world is generating large amounts of data. Extracting relevant information from the data has become a major challenge. Image classification is a relevant solution to identifying what an image represents. Image classification can help you bucket high volumes of images. Convolutional neural networks (CNNs) render good performance on image datasets. CNNs have played a major role in the development of modern state-of-the-art image classification solutions.

There are three main types of layers in CNNs:

* Convolutional layer
* Pooling layer
* Fully-connected (FC) layer

The convolutional layer is the first layer of a convolutional network. These layers can follow another convolutional layer or pooling layers. In general, the fully-connected layer is the final layer in the network. With the increase in the number of layers, the complexity of the model increases and can help identify bigger portions of the image. The beginning layers are focused on simple features, such as edges. As the image data advances through the layers of the CNN, the network starts recognizing more sophisticated elements or shapes of the object, and finally, it identifies the expected object.

## Potential use cases

* This solution can help automate failure detection (instead of relying solely on human operators), improve the identification of faulty electronic components, and boost productivity.
* Lean manufacturing, cost control, and waste reduction are imperative for manufacturing to remain competitive. In circuit-board manufacturing, faulty boards can cost manufacturers money and productivity. Assembly lines rely on human operators to quickly review and validate boards, which are flagged as potentially faulty by assembly-line test machines.
* Image classification is ideal for the healthcare industry. It helps detect anomalies in tissues, bone cracks, and various types of cancer. Image classification capabilities can also be used to flag potential irregularities, which can indicate certain diseases and subsequently inform the person, in case they need to seek medical advice. An image classification model could be helpful to improve the accuracy of the interpretation of MRI results, which would expedite the diagnosis with more accurate results.
* In the agriculture domain, image classification solutions help identify plant diseases and plants that require water and reduce human intervention.

## Architecture

![Architecture diagram: image classification with convolutional neural networks and Azure Machine Learning.](../media/image-classification-with-convolutional-neural-networks.png)
*Download an [SVG file](../media/image-classification-with-convolutional-neural-networks.svg) of this architecture.*

### Dataflow

1. Image uploads to the blob storage are ingested to Azure Machine Learning (AML).
2. Since the solution follows a supervised learning approach and needs data labeling to train the model, the ingested images can be labeled in AML.
3. The convolutional neural network model is trained and validated in the AML notebook. Several pre-trained image classification models are already available and can be leveraged using transfer learning approach. Some variants of pre-trained CNNs are mentioned [here](https://arxiv.org/pdf/1905.03288.pdf). These image classification models can be downloaded and customized on your labeled data.
4. Post-training, the model is stored in a model register in Azure ML.
5. The model can be deployed through batch managed endpoints.
6. The model results can be written to Cosmos DB and consumed through the front-end application.

## Next steps

* [Learn more about Azure Blob Storage](https://azure.microsoft.com/services/storage/blobs)
* [Learn more about Azure Container Registry](https://azure.microsoft.com/services/container-registry)
* [Learn more about Model Management (MLOps)](/azure/machine-learning/concept-model-management-and-deployment)
* [Browse an implementation of this solution idea on GitHub](https://github.com/azure/mmlspark)
* Try the Microsoft Learn module [Train and evaluate deep learning models](/learn/modules/train-evaluate-deep-learn-models), which includes a section on CNNs.
