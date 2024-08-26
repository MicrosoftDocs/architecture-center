This article provides a basic architecture intended for learning about running chat applications that use [Azure OpenAI Service language models](/azure/ai-services/openai/concepts/models) in a single region. The architecture includes a client user interface running in Azure App Service and uses Azure Machine Learning prompt flow to orchestrate the workflow from incoming prompts out to data stores to fetch grounding data for the language model. The executable flow is deployed to a Machine Learning compute cluster behind a managed online endpoint.

> [!IMPORTANT]
> This architecture isn't meant to be used for production applications. It's intended to be an introductory architecture you can use for learning and proof of concept (POC) purposes. When designing your production enterprise chat applications, see the [Baseline OpenAI end-to-end chat reference architecture](./baseline-openai-e2e-chat.yml).

> [!IMPORTANT]
> ![GitHub logo](../../../_images/github.svg) The guidance is backed by an [example implementation](https://github.com/Azure-Samples/openai-end-to-end-basic) which showcases this basic end-to-end chat implementation on Azure. This implementation can be used as a basis for your POC to experience working with chat applications that use Azure OpenAI.

## Architecture

:::image type="complex" source="../_images/openai-end-to-end-basic.svg" lightbox="../_images/openai-end-to-end-basic.png" alt-text="Diagram that shows a basic end-to-end chat architecture.":::
    The diagram shows an Azure App Service connecting directly to an Azure Machine Learning managed online endpoint that is sitting in front of compute instances. There is an arrow from the compute instances to Azure AI Search and an arrow pointing to Azure OpenAI Service. The diagram also shows Azure App Insights and Azure Monitor, Azure Key Vault, Azure Container Registry, and Azure Storage.
:::image-end:::
*Figure 1: Basic end-to-end chat architecture with Azure OpenAI*

*Download a [Visio file](https://arch-center.azureedge.net/openai-end-to-end-basic.vsdx) of this architecture.*

