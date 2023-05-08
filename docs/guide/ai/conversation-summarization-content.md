Most businesses provide customer service support to help customers with product queries, troubleshooting, and maintaining or upgrading features or the product itself. To provide a satisfactory resolution, customer support specialists must respond quickly with accurate information. OpenAI can help organizations with customer support in a variety of ways.

This guide describes how to generate summaries of customer–agent interactions by using the Azure OpenAI GPT-3 model. It contains an end-to-end sample architecture that illustrates the key components involved in getting a summary of a text input. The generation of the text input is outside the scope of this guide. The focus of this guide is to describe the process of implementing the summarization of a set of sample agent-customer conversations and analyze the outcomes of various approaches to summarization.

## Conversation scenarios

- **Self-service chatbots** (fully automated). In this scenario, customers can interact with a chatbot that's powered by GPT-3 and trained on industry-specific data. These chatbots can understand customer questions and answer appropriately based on responses learned from a knowledge base.  
- **Chatbot with agent intervention** (semi-automated). Questions posed by customers are sometimes complex and necessitate human intervention. In such cases, GPT-3 can provide a summary of the customer-chatbot conversation and help the agent with quick searches for additional information from a large knowledge base.
- **Summarizing transcripts** (fully or semi-automated). In most customer support centers, agents are required to summarize conversations for record keeping, future follow-ups, training, and other internal processes. GPT-3 can provide automated or semi-automated summaries that capture salient details of conversations for further use. 

This guide focuses on the process for summarizing transcripts by using Azure OpenAI GPT-3.

On average, it takes an agent 5 to 6 minutes to summarize a single agent-customer conversation. Given the high volumes of requests service teams handle on any given day, this additional task can overburden the team. OpenAI is a good way to help agents with summarization-related activities. It can improve the efficiency of the customer support process and provide better precision. Conversation summarization can be applied to any customer support business that involves agent-customer interaction. 

For a demonstration of how to use the Azure OpenAI GPT-3 model for conversation summarization, see this [Jupyter Notebook](https://github.com/Azure/openai-solutions/tree/conversational-summarization-v0/Solution_Notebooks/Conversational%20Summarization). You can use the notebook to experiment with summarization on your datasets.

### Conversation summarization service

Conversation summarization is suitable in scenarios where customer support conversations follow a question-and-answer format.

Some benefits of using a summarization service are:

- Increased efficiency: It allows customer service agents to quickly summarize customer conversations, eliminating the need for long back-and-forth exchanges. This efficiency helps to speed up the resolution of customer problems.
- Improved customer service: Agents can use summaries of conversations in future interactions to quickly find the information needed to accurately resolve customer concerns.
- Improved knowledge sharing: Conversation summarization can help customer service teams share knowledge with each other quickly and effectively. It equips customer service teams with better resolutions and helps them provide faster support.

## Architecture

A typical architecture for a conversation summarizer has three main stages: pre-processing, summarization, and post-processing. If the input contains a verbal conversation or any form of speech, the speech needs to be transcribed to text. For more information, see [Azure Speech-to-text service](https://azure.microsoft.com/products/cognitive-services/speech-to-text/). 

Here's a sample architecture: 

:::image type="content" source="media/conversation-summarization-overview.png" alt-text="Diagram that shows an architecture for conversation summarization." lightbox="media/conversation-summarization-overview.png" border="false":::

*Download a [PowerPoint file](https://arch-center.azureedge.net/conversation-summarization-overview.pptx) of this architecture.*

### Workflow

1.	Gather input data: Relevant input data is fed into the pipeline. If the source is an audio file, you need to convert it to text by using a TTS service like [Azure text-to-speech](/azure/cognitive-services/speech-service/text-to-speech). 
2.	Pre-process the data: Confidential information and any unimportant conversation is removed from the data. 
3.	Feed the data into the summarizer: The data is passed in the prompt via Azure OpenAI APIs. In-context learning models include [zero-shot, few-shot, or a custom model](/azure/cognitive-services/openai/overview#in-context-learning).
4.	Generate a summary: The model generates a summary of the conversations.
5.	Post-process the data: A profanity filter and various validation checks are applied to the summary. Sensitive or confidential data that was removed during the pre-process step is added back to the summary. 
6.	Evaluate the results: Results are reviewed and evaluated. This step can help you identify areas where the model needs to be improved and find errors that might have been missed.

The following sections provide more details about the three main stages.

### Pre-process

The goal of pre-processing is to ensure that the data provided to the summarizer service is relevant and doesn't include sensitive or confidential information.

Here are some pre-processing steps that can help condition your raw data. You might need to apply one or many steps, depending on the use case.

-	**Remove personally identifiable information (PII)**. You can use the [Conversational PII API](/azure/cognitive-services/language-service/personally-identifiable-information/overview) (preview) to remove PII from transcribed or written text. This example shows the output after the API has removed PII:

    ```
    Document text: Parker Doe has repaid all of their loans as of
          2020-04-25. Their SSN is 999-99-9999. To contact them, use 
          their phone number 555-555-0100. They are originally from 
          Brazil and have Brazilian CPF number 998.214.865-68 
    Redacted document text: ******* has repaid all of their
          loans as of *******. Their SSN is *******. To contact 
          them, use their phone number *******. They are originally from Brazil and have Brazilian CPF number 998.214.865-68

    ...Entity 'Parker Doe' with category 'Person' got redacted
    ...Entity '2020-04-25' with category 'DateTime' got redacted
    ...Entity '999-99-9999' with category 'USSocialSecurityNumber' got redacted
    ...Entity '555-555-0100' with category 'PhoneNumber' got redacted
    ```

-	**Remove extraneous information**. Customer agents start conversations with casual exchanges that don't include relevant information. A trigger can be added a conversation to identify the point where the concern or relevant question is first addressed. Removing that exchange from the context can improve the accuracy of the summarizer service because the model is then fine-tuned on the most relevant information of the conversation. The Curie GPT-3 engine is a popular choice for this task because it's trained extensively, via content from the internet, to identify this type of casual conversation.

-	**Remove excessively negative conversations**. Conversations can also include negative sentiments from unhappy customers. You can use Azure content-filtering methods like Azure Content Moderator to remove conversations that contain sensitive information from analysis. Alternatively, OpenAI offers a moderation endpoint, a tool that you can use to check whether content complies with OpenAI's content policies.

### Summarizer

OpenAI's text-completion API endpoint is called the *completions endpoint*. To start the text-completion process, it requires a prompt. *Prompt engineering* is a process used in large language models. The first part of the prompt includes natural language instructions and/or examples of the specific task requested (in this scenario, summarization). Prompts allow developers to provide some context to the API, which can help it generate more relevant and accurate text completions. The model then completes the task by predicting the most probable next text. This technique is known as *in-context* learning.

> [!Note]
> *Extractive summarization* attempts to identify and extract salient information from a text and group it to produce a concise summary without understanding the meaning or context. 
>
> *Abstractive summarization* rewrites a text by first creating an internal semantic representation and then creating a summary by using natural language processing. This process involves paraphrasing.

There are three main approaches for training models for in-context learning: zero-shot, few-shot and fine-tuning. These approaches vary based on the amount of task-specific data that's provided to the model.

- **Zero-shot**: In this approach, no examples are provided to the model. The task request is the only input. In zero-shot learning, the model relies on data that GPT-3 is already trained on (almost all available data from the internet). It attempts to relate the given task to existing categories that it has already learned about and responds accordingly.
- **Few-shot**: When you use this approach, you include a small number of examples in the prompt that demonstrate the expected answer format and the context. The model is provided with a very small amount of training data, typically just a few examples, to guide its predictions. Training with a small set of examples enables the model to generalize and understand related but previously unseen tasks. Creating these few-shot examples can be challenging because they need to clarify the task you want the model to perform. One commonly observed problem is that models, especially small ones, are sensitive to the writing style that's used in the training examples. 

   With this approach, you can't update the weights of the pretrained model. 

   The main advantages of this approach are a major reduction in the need for task-specific data and reduced potential to learn an excessively narrow distribution from a large but narrow fine-tuning dataset. For more information, see [Language Models are few-shot learners](https://arxiv.org/pdf/2005.14165.pdf).
- **Fine-tuning**: Fine-tuning is the process of tailoring models to get a specific desired outcome from your own datasets. It involves retraining models on new data. For more information, see [Learn how to customize a model for your application](/azure/cognitive-services/openai/how-to/fine-tuning?pivots=programming-language-studio).
  
  You can use this customization step to improve your process by:

   - Including a larger set of example data. 
   - Using traditional optimization techniques with backpropagation to readjust the weights of the model. These techniques enable higher quality results than the zero-shot or few-shot approaches provide by themselves. 
   - Improving the few-shot learning approach by training the model weights with specific prompts and a specific structure. This technique enables you to achieve better results on a wider number of tasks without needing to provide examples in the prompt. The result is less text sent and fewer tokens.
   
  Disadvantages include the need for a large new dataset for every task, the potential for poor generalization out of distribution, and the possibility to exploit spurious features of the training data, resulting in high chances of unfair comparison with human performance.

  Creating a dataset for model customization is different from designing prompts for use with the other models. Prompts for completion calls often use either detailed instructions or few-shot learning techniques and consist of multiple examples. For fine-tuning, we recommend that each training example consists of a single input example and its desired output. You don't need to provide detailed instructions or examples in the prompt.

  As you increase the number of training examples, your results improve. We recommend including at least a 500 examples. It's typical to use between thousands and hundreds of thousands of labeled examples. Testing indicates that each doubling of the dataset size leads to a linear increase in model quality.

This guide demonstrates the curie-instruct/text-curie-001 and davinci-instruct/text-davinci-001 engines. These engines are frequently updated. The version you use might be different.

### Post-process

We recommend that you check the validity of the results that you get from GPT-3. Implement validity checks by using a programmatic approach or classifiers, depending on the use case. Here are some critical checks:

- Verify that no significant points are missed.
- Check for factual inaccuracies.
- Check for any bias introduced by the training data used on the model.
- Verify that the model doesn't change text by adding new ideas or points. This problem is known as *hallucination*.
- Check for grammatical and spelling errors.
- Use a content profanity filter like [Content Moderator](https://azure.microsoft.com/products/cognitive-services/content-moderator/) to ensure that no inappropriate or irrelevant content is included. 

Finally, reintroduce any vital information that was previously removed from the summary, like confidential information. 

In some cases, a summary of the conversation is also sent to the customer, along with the original transcript. In these cases, post-processing involves appending the transcript to the summary. It can also include adding lead-in sentences like "Please see the summary below:" before sending the summary to the customer. 

### Considerations

It's important to fine-tune your base models with an industry-specific training dataset and change the size of available datasets. Fine-tuned models perform best when the training data includes at least 1,000 datapoints and the ground truth (human-generated summaries) used to train the models is of high quality. 

The tradeoff is cost. The process of labeling and cleaning datasets can be expensive. To ensure high-quality training data, you might need to manually inspect ground truth summaries and rewrite low-quality summaries. Consider the following points about the summarization stage:

- Prompt engineering: When provided with little instruction, Davinci often performs better than other models. To optimize results, experiment with different prompts for different models.
- Token size: A summarizer that's based on GPT-3 is limited to a total of 4,098 tokens, including the prompt and completion. To summarize larger passages, separate the text into parts that conform to these constraints. Summarize each part individually and then collect the results in a final summary.
- Garbage in, garbage out: Trained models are only as good as the training data that you provide. Be sure that the ground truth summaries in the training data are well suited to the information that you eventually want to summarize in your dialogues. 
- Stopping point: The model stops summarizing when it reaches a natural stopping point or a stop sequence that you provide. Test this parameter to choose among multiple summaries and to check whether summaries look incomplete.

## Example scenario: Summarizing transcripts in call centers

This scenario demonstrates how the Azure OpenAI summarization feature can help customer service agents with summarization tasks. It tests the zero-shot, few-shot, and fine-tuning approaches and compares the results against human-generated summaries.
 
The dataset used in this scenario is a set of hypothetical conversations between customers and agents in the Xbox customer support center about various Xbox products and services. The hypothetical chat is labeled with *Prompt*. The human-written abstractive summary is labeled with *Completion*.

|Prompt|	Completion|
|-|-|
|Customer: Question on XAIL<br>Agent: Hello! How can I help you today?<br>Customer: Hi, I have a question about the Accessibility insider ring<br>Agent: Okay. I can certainly assist you with that.<br>Customer: Do I need to sign up for the preview ring to join the accessibility league?<br>Agent: No. You can leave your console out of Xbox Preview rings and still join the League. However, note that some experiences made available to you may require that you join an Xbox Preview ring.<br>Customer: Okay. And I can just sign up for preview ring later yeah?<br>Agent: That is correct.<br>Customer: Sweet.|	Customer wants to know if they need to sign up for preview rings to join Xbox Accessibility Insider League. Agent responds that it is not mandatory, but that some experiences may require it.|

**Ideal output**. The goal is to create summaries that follow this format: "Customer said *x*. Agent responded *y*." Another goal is to capture salient features of the dialogue, like the customer complaint, suggested resolution, and follow-up actions.

Here's an example of a customer support interaction, followed by a comprehensive human-written summary of it:

**Dialogue**

Customer: Hello. I have a question about the game pass.

Agent: Hello. How are you doing today?

Customer: I'm good.

Agent. I see that you need help with the Xbox Game Pass.

Customer: Yes. I wanted to know how long can I access the games after they leave game pass?

Agent: Once a game leaves the Xbox Game Pass catalog, you'll need to purchase a digital copy from the Xbox app for Windows or the Microsoft Store, play from a disc, or obtain another form of entitlement to continue playing the game. Remember, Xbox will notify members prior to a game leaving the Xbox Game Pass catalog. And, as a member, you can purchase any game in the catalog for up to 20% off (or the best available discounted price) to continue playing a game once it leaves the catalog.

Customer: Got it, thanks

**Ground truth summary**

Customer wants to know how long they can access games after they have left Game Pass. Agent informs customer that they would need to purchase the game to continue having access.

### Zero-shot

The [zero-shot](#summarizer) approach is useful when you don't have ample labeled training data. In this case, there aren't enough ground truth summaries. It's important to design prompts carefully to extract relevant information. The following format is used to extract general summaries from customer-agent chats:

`prefix = "Please provide a summary of the conversation below: "`

`suffix = "The summary is as follows: "`

Here's a sample that shows how to run a zero-shot model:

```python
rouge = Rouge()
# Run zero-shot prediction for all engines of interest
deploymentNames = ["curie-instruct","davinci-instruct"] # also known as text-davinci/text-instruct
for deployment in deploymentNames:
url = openai.api_base + "openai/deployments/" + deployment + "/completions?api-version=2022-12-01-preivew"
response_list = []
rouge_list = []
print("calling…" + deployment)
for i in range(len(test)):
response_i = openai.Completion.create(
engine = deployment,
prompt = build_prompt(prefix, [test['prompt'][i]], suffix),
temperature = 0.0,
max_tokens = 400,
top_p = 1.0,
frequence_penalty = 0.5,
persence_penalty = 0.0,
stop=["end"] # We recommend that you adjust the stop sequence based on the dataset
)
scores = rouge.get_scores(normalize_text(response_i[‘choices’][ 0]['text']),test['completion'][i])
rouge_list += [scores[0]['rouge-1']['f']],
response_list += [response_i]
summary_list = [normalize_text(i[‘choices’][0][‘text’]) for i in response_list]
test[deployment + "_zeroshotsummary"] = summary_list
test[deployment + "_zeroshotroguescore"] = rouge_list
```

#### Results and observations

The zero-shot model's output is produced directly from the base model. In this case, both Curie and Davinci summarize the dialogue fairly well. The only noticeable difference is that Curie model provides a little less detail. Curie starts the summary with "customer asks the agent about the Xbox game pass." The corresponding sentence in Davinci is "customer asked how long they could access games after they leave the Xbox game pass catalog."

**Dialogue**

customer: hello. I have a question about the game pass. 

agent: hello. How are you doing?

customer: I'm good. 

agent: I see that you need help with the Xbox game pass. 

customer: Yes. I wanted to know how long can I access the games after they leave game pass 

agent: Once a game leaves the Xbox game pass catalog you'll need to purchase a digital copy from the Xbox app for windows or the Microsoft store play from a disc or obtain another form of entitlement to continue playing the game. Remember, Xbox will notify members prior to a game leaving the Xbox game pass catalog. And as a member you can purchase any game in the catalog for up to 20 off or the best available discounted price to continue playing a game once it leaves the catalog.

**Ground truth**

Customer wants to know how long they can access games after they have left Game Pass. Agent informs customer that they would need to purchase the game to continue having access.

**Davinci result** 

The customer asked how long they could access games after they leave the Xbox game pass catalog. The agent told them that they would need to purchase a digital copy of the game from the Xbox app for windows or the Microsoft store in order to continue playing it. The agent also reminded the customer that they would be notified prior to a game leaving the Xbox game pass catalog. as a member the customer could purchase any game in the catalog for up to 20 off or the best available discounted price.

**Curie result**

The customer asks the agent about the Xbox game pass. the agent tells the customer that once a game leaves the Xbox game pass catalog the customer will need to purchase a digital copy from the Xbox app for windows or the Microsoft store play from a disc or obtain another form of entitlement to continue playing the game. The agent also reminds the customer that Xbox will notify members prior to a game leaving the Xbox game pass catalog.

### Few-shot

When you use the [few-shot](#summarizer) approach, the model is provided with a small number of examples. 

`context_primer = "Below are examples of conversations and their corresponding summaries:"` 

`prefix = "Please provide a summary of the conversation below: "`

`suffix = "The summary is as follows: "`

Here's a sample that shows how to run a few-shot model:

```python
train_small = train[]
train_small_json = train_small.to_dict(orient='records')
compiled_train_prompt = build_prompt_fewshot(prefix,context_primer, train_small_json, suffix)

for deployment in deploymentNames:
url = openai.api_base + "openai/deployments/" + deployment + "/completions?api-version=2022-12-01-preivew"
response_list = []
rouge_list = []
print("calling…" + deployment)
for i in range(len(test)):
response_i = openai.Completion.create(
engine = deployment,
prompt = compiled_train_prompt+build_prompt(prefix, [test['prompt'][i]], suffix),
temperature = 0.0,
max_tokens = 400,
top_p = 1.0,
frequence_penalty = 0.5,
persence_penalty = 0.0,
stop=["end"] # We recommend that you adjust the stop sequence based on the dataset
)
scores = rouge.get_scores(normalize_text(response_i['choices'][ 0]['text']),test['completion'][i])
rouge_list += [scores[0]['rouge-1']['f']],
response_list += [response_i]
summary_list = [normalize_text(i['choices'][0]['text']) for i in response_list]
test[deployment + "_fewshot"] = summary_list
test[deployment + "_FSscore1"] = rouge_list
```

#### Results and observations

With the few-shot approach, the summaries continue to capture salient features of the conversation. The Davinci summary is more compact and closer to the ground truth. Curie fabricates some trivial details.

**Dialogue**

customer: Hello. I have a question about the game pass.

agent: Hello. How are you doing? 

customer: I'm good. 

agent: I see that you need help with the xbox game pass. 

customer: yes. I wanted to know how long can I access the games after they leave game pass. 

agent: once a game leaves the Xbox game pass catalog you'll need to purchase a digital copy from the Xbox app for Windows or the Microsoft store play from a disc or obtain another form of entitlement to continue playing the game. Remember, Xbox will notify members prior to a game leaving the Xbox game pass catalog. And as a member you can purchase any game in the catalog for up to 20 off or the best available discounted price to continue playing a game once it leaves the catalog.

**Ground truth**

Customer wants to know how long they can access games after they have left Game Pass. Agent informs customer that they would need to purchase the game to continue having access.

**Davinci result**

customer wanted to know how long they could access games after they leave game pass. Agent informs that once a game leaves the Xbox game pass catalog the customer would need to purchase a digital copy or obtain another form of entitlement to continue playing the game.

**Curie result**

customer has a question about the game pass. customer is good. agent needs help with the Xbox game pass. customer asks how long they can access the games after they leave the game pass catalog. Agent informs that once a game leaves the Xbox game pass catalog the customer will need to purchase a digital copy from the Xbox app for windows or the Microsoft store play from a disc or obtain another form of entitlement to continue playing the game. customer is happy to hear this and thanks agent.

#### Fine-tuning

[Fine-tuning](#summarizer) is the process of tailoring models to get a specific desired outcome from your own datasets. 

Here's an example format:

```
{"prompt": "<prompt text>", "completion": "<ideal generated text>"}
{"prompt": "<prompt text>", "completion": "<ideal generated text>"}
{"prompt": "<prompt text>", "completion": "<ideal generated text>"}
```

#### Results and observations

Testing suggests that a fine-tuned Curie model leads to results that are  comparable to those of a Davinci few-shot model. Both summaries capture the customer's question and the agent's answer without capturing the details about discounts and without adding content. Both summaries are similar to the ground truth.

**Dialogue**

customer: Hello. I have a question about the game pass. 

agent: Hello. How are you doing? 

customer: I'm good. 

agent: I see that you need help with the xbox game pass. 

customer: Yes. I wanted to know how long can I access the games after they leave game pass.

agent: Once a game leaves the Xbox game pass catalog you'll need to purchase a digital copy from the Xbox app for windows or the Microsoft store play from a disc or obtain another form of entitlement to continue playing the game. Remember, Xbox will notify members prior to a game leaving the Xbox game pass catalog. And as a member you can purchase any game in the catalog for up to 20 off or the best available discounted price to continue playing a game once it leaves the catalog.

**Ground truth**

Customer wants to know how long they can access games after they have left game pass. Agent informs customer that they would need to purchase the game to continue having access.

**Curie result**

customer wants to know how long they can access the games after they leave game pass. agent explains that once a game leaves the Xbox game 
pass catalog they'll need to purchase a digital copy from the Xbox app for windows or the Microsoft store play from a disc or obtain another form of entitlement to continue playing the game.

## Conclusions

Generally, the Davinci model requires fewer instructions to perform tasks than other models, like Curie. Davinci is better suited for summarizing text that requires an understanding of context or specific language. Because Davinci is the most complex model, its latency is higher than that of other models. Curie is faster than Davinci and is capable of summarizing conversations.

These tests suggest that you can generate better summaries when you provide more instruction to the model via few-shot or fine-tuning. Fine-tuned models are better at conforming to the structure and context learned from the training dataset. This capability is especially useful when summaries are domain specific (for example, generating summaries from a doctor's notes or online prescription customer support). If you use fine-tuning, you have more control over the types of summaries that you see.

For the sake of easy comparison, here's a summary of the results that are presented earlier:

**Ground truth**

Customer wants to know how long they can access games after they have left Game Pass. Agent informs customer that they would need to purchase the game to continue having access.

**Davinci zero-shot result**

The customer asked how long they could access games after they leave the Xbox game pass catalog. The agent told them that they would need to purchase a digital copy of the game from the Xbox app for windows or the Microsoft store in order to continue playing it. The agent also reminded the customer that they would be notified prior to a game leaving the Xbox game pass catalog. As a member the customer could purchase any game in the catalog for up to 20 off or the best available discounted price.

**Curie zero-shot result**

The customer asks the agent about the Xbox game pass. the agent tells the customer that once a game leaves the Xbox game pass catalog the customer will need to purchase a digital copy from the Xbox app for windows or the Microsoft store play from a disc or obtain another form of entitlement to continue playing the game. The agent also reminds the customer that Xbox will notify members prior to a game leaving the Xbox game pass catalog.

**Davinci few-shot result**

customer wanted to know how long they could access games after they leave game pass. Agent informs that once a game leaves the Xbox game pass catalog the customer would need to purchase a digital copy or obtain another form of entitlement to continue playing the game.

**Curie few-shot result**

customer has a question about the game pass. customer is good. agent needs help with the Xbox game pass. customer asks how long they can access the games after they leave the game pass catalog. Agent informs that once a game leaves the Xbox game pass catalog the customer will need to purchase a digital copy from the Xbox app for windows or the Microsoft store play from a disc or obtain another form of entitlement to continue playing the game. customer is happy to hear this and thanks agent.
 
**Curie fine-tuning result** 

customer wants to know how long they can access the games after they leave game pass. agent explains that once a game leaves the Xbox game. 
pass catalog they’ll need to purchase a digital copy from the Xbox app for windows or the Microsoft store play from a disc or obtain another form of entitlement to continue playing the game.

### Evaluating summarization

There are multiple techniques for evaluating the performance of summarization models.

Here are a few:

**ROUGE (Recall-Oriented Understudy for Gisting Evaluation)**. This technique includes measures for automatically determining the quality of a summary by comparing it to ideal summaries created by humans. The measures count the number of overlapping units, like n-gram, word sequences, and word pairs, between the computer-generated summary that's being evaluated and the ideal summaries.

Here's an example:

```python
reference_summary = "The cat ison porch by the tree"
generated_summary = "The cat is by the tree on the porch"
rouge = Rouge()
rouge.get_scores(generated_summary, reference_summary)
[{'rouge-1': {'r':1.0, 'p': 1.0, 'f': 0.999999995},
  'rouge-2': {'r': 0.5714285714285714, 'p': 0.5, 'f': 0.5333333283555556},
  'rouge-1': {'r': 0.75, 'p': 0.75, 'f': 0.749999995}}]
```

**BertScore**. This technique computes similarity scores by aligning generated and reference summaries on a token level. Token alignments are computed greedily to maximize the cosine similarity between contextualized token embeddings from BERT. 

Here's an example:

```python
  import torchmetrics
  from torchmetrics.text.bert import BERTScore
  preds = "You should have ice cream in the summer"
  target = "Ice creams are great when the weather is hot"
  bertscore = BERTScore()
  score = bertscore(preds, target)
  print(score)
```

**Similarity matrix**. A similarity matrix is a representation of the similarities between different entities in summarization evaluation. You can use it to compare different summaries of the same text and measure their similarity. It's represented by a two-dimensional grid, where each cell contains a measure of the similarity between two summaries. You can measure the similarity by using a variety of methods, like cosine similarity, Jaccard similarity, and edit distance. You then use the matrix to compare the summaries and determine which one is the most accurate representation of the original text.

Here's a sample command that gets the similarity matrix of a BERTScore comparison of two similar sentences:

```python
bert-score-show --lang en -r "The cat is on the porch by the tree"
                          -c "The cat is by the tree on the porch"
                          -f out.png
```

The first sentence "The cat is on the porch by the tree" is referred to as the *candidate*. The second sentence is referred as the *reference*. The command uses BERTScore to compare the sentences and generate a matrix. 

This following matrix displays the output that's generated by the preceding command:

:::image type="content" source="media/similarity-matrix-conversation.png " alt-text="Diagram that shows a similarity matrix." lightbox="media/similarity-matrix-conversation.png" border="false":::

For more information, see [SummEval: Reevaluating Summarization Evaluation](https://direct.mit.edu/tacl/article/doi/10.1162/tacl_a_00373/100686/SummEval-Re-evaluating-Summarization-Evaluation). For a PyPI toolkit for summarization, see [summ-eval 0.892](https://pypi.org/project/summ-eval/).

### Responsible use

GPT can produce excellent results, but you need to check the output for social, ethical, and legal biases and harmful results. When you fine- tune models, you need to remove any data points that might be harmful for the model to learn. You can use red teaming to identify any harmful outputs from the model. You can implement this process manually and support it by using semi-automated methods. You can generate test cases by using language models and then use a classifier to detect harmful behavior in the test cases. Finally, you should perform a manual check of generated summaries to ensure that they're ready to be used.

For more information, see [Red Teaming Language Models with Language Models](https://arxiv.org/pdf/2202.03286.pdf).

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Meghna Jani](https://www.linkedin.com/in/meghnajani/) | Data & Applied Scientist II 

Other contributors:
- [Mick Alberts](https://www.linkedin.com/in/mick-alberts-a24a1414/) | Technical Writer

## Next steps

- [Jupyter Notebook with technical details and execution of the use case described in this article](https://github.com/Azure/openai-solutions/tree/conversational-summarization-v0/Solution_Notebooks/Conversational%20Summarization)
- [More information about Azure OpenAI](/azure/cognitive-services/openai/)
- [ROUGE reference article](https://aclanthology.org/W04-1013.pdf)
- [Training module: Introduction to Azure OpenAI Service](/training/modules/explore-azure-openai/)
- [Learning path: Develop AI solutions with Azure OpenAI](/training/paths/develop-ai-solutions-azure-openai/) 

## Related resources 

- [Query-based document summarization](../../guide/ai/query-based-summarization.md)
- [Choose a Microsoft cognitive services technology](../../data-guide/technology-choices/cognitive-services.md)
- [Natural language processing technology](../../data-guide/technology-choices/natural-language-processing.yml)