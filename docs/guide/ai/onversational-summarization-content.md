# Conversational Summarization

Most businesses provide customer service support to assist customers with product queries, troubleshooting, and maintaining or upgrading certain features or the product itself. To provide a satisfactory resolution, customer support specialists **must respond quickly with accurate information**. OpenAI can be used in a variety of ways for customer support services.

This guide describes how to generate summaries of customer–agent interactions by using Azure OpenAI's GPT-3 model. It contains an end-to-end example architecture with the key components involved in obtaining summary of a text input. The generation of the text input is outside the scope of this guide. The focus of this guide is a walkthrough of the implementation process of summarizing a set of sample agent-customer conversations and analyzing the outcomes of different approaches used for summarization.

## Conversational workflow

1.	**Self-service chatbots** (fully automated) - In this scenario, customers can interact with a GPT-3 powered chatbot, trained on industry specific data. These chatbots can understand customer questions and answer appropriately based on responses learnt from the knowledgebase (automated).  
2.	**Enable agent responses** (semi-automated) – Sometimes, questions posed by customers are complex and requires human intervention. In such cases, GPT-3 can be used to deliver a summary of the customer-chatbot conversation and help the agent with quick lookups for additional information within a large knowledge base (semi-automated).
3.	**Summarizing transcripts** (can be fully or partially automated) – In most customer support centers, agents are required to summarize conversations for record keeping, future follow-ups, training, and other internal processes. GPT-3 can be leveraged to provide automated or semi-automated summaries that captures salient details of the conversation for further use. 

In this guide, we will focus on the process for summarizing transcripts using Azure OpenAI’s GPT-3. 

Businesses consume roughly 5-6 minutes on average to summarize a single agent-customer conversation. This can overload the service team considering the high volumes of requests they must deal with on any given day. OpenAI is a good way to help the agents with summarization related activities, which can improve the efficiency of customer support process while delivering solutions with higher precision. Conversational summarization can be applied to any customer support business that involves agent-customer interaction. 

This guide includes a Jupyter Notebook that demonstrates how to use the Azure OpenAI's GPT-3 model for conversational summarization. Use this notebook to experiment with summarization on your datasets. 

### Conversational summarization service

Conversational summarization suitable in scenarios where the customer support conversations follow a question-answer format. 

Some of the key benefits of using a summarization service are:

1.	Increased efficiency: It allows customer service agents to quickly summarize customer conversations, eliminating the need for lengthy back-and-forth exchanges. This helps speed up resolving customer issues. 
2.	Superior customer service: By having a summary of the conversation, customer service agents can easily access it in all future interactions to quickly find any relevant information needed to accurately resolve customer concerns.
3.	Improved knowledge sharing: Conversation summarization can help customer service teams to share knowledge quickly and effectively with each other. This enables customer service teams to be equipped with better resolutions and simultaneously provide faster support to customers.

## Architecture

A typical architecture for a **conversational summarizer** service has three main stages: pre-processing, summarization, and post-processing. In case the input contains a verbal conversation or any form of speech, the speech needs to be transcribed to text. Please refer to [Azure Speech-to-text service](https://azure.microsoft.com/products/cognitive-services/speech-to-text/) for more details. 

image

link 

Figure 1: Conversational Summarizer sample architecture 

### Workflow

1.	Gathering input data: Relevant input data is fed into the pipeline. In case the source is an audio file, it has to be converted to text using a TTS service such as [Azure Text-To-Speech](/azure/cognitive-services/speech-service/text-to-speech). 
2.	Pre-process the data: Confidential information and any unimportant conversation is removed from the data. 
3.	Feed the data into the summarizer model: The data is passed within the prompt by using Azure OpenAI’s APIs, which could one of three approaches for [in-context learning, be zero-shot, few-shot or a custom model](/azure/cognitive-services/openai/overview).
4.	Generate a summary: The model generates a summary of the conversations.
5.	Post-Process: The summary is cleared by using profanity filter and validation checks. Sensitive or confidential data that was removed during the pre-process step is added back to the summary. 
6.	Evaluation of the results: Results are reviewed and evaluated. This can help identify areas where the model needs to be improved, and find errors that might have been missed.

In the following sections, we’ll describe the details of the three main stages.

### Pre-Process

The goal of pre-processing is to make sure that the information provided to the summarizer service is relevant and doesn’t have any sensitive or confidential information. 

Here are some pre-processing steps that will help condition your raw data. You may need to apply one or many steps, depending on the use case.

1.	**Removing Personal Identification Information (PII)** – The [Conversational PII API](/azure/cognitive-services/language-service/personally-identifiable-information/overview) (preview) can be used to scrub out PII from transcribed or written text. This example shows the output after PII information has been removed using the API.

    ```
    Document text: Parker Doe has repaid all of their loans as of
          2020-04-25. Their SSN is 999-99-9999. To contact them, use 
          their phone number 555-555-5555. They are originally from 
          Brazil and have Brazilian CPF number 998.214.865-68 
    Redacted document text: ******* has repaid all of their
          loans as of *******. Their SSN is *******. To contact 
          them, use their phone number *******. They are originally from Brazil and have Brazilian CPF number 998.214.865-68

    ...Entity ‘Parker Doe’ with category ‘Person’ got redacted
    ...Entity ‘2020-04-25’ with category ‘DateTime’ got redacted
    ...Entity ‘999-99-9999’ with category ‘USSocialSecurityNumber’ got redacted
    ...Entity ‘555-555-5555’ with category ‘PhoneNumber’ got redacted
    ```

2.	**Removing extraneous information** – Customer agents start conversations with casual exchange that’s outside the scope of relevant information. A trigger can be marked within the conversation to identify the point where the concern/relevant question is first addressed. By removing that exchange from the context, the accuracy of the summarizer service is improved because the model is only fine-tuned on the most relevant information of the conversation.  GPT-3 based Curie is a popular choice because it’s vastly trained from the internet for identifying chit-chat.

3.	**Removing overly negative conversations** – Conversations can also involve negative sentiments from unhappy customers. Using Azure-based Content Filtering methods, such as Azure Moderator, conversations that contain insensitive information can be removed from analysis.  Alternatively, OpenAI offers a moderation endpoint, a tool that allows users to check whether content complies with OpenAI's content policy.

Summarizer model

OpenAI’s text-completion API endpoint called the completion endpoint requires natural language instructions to identify the task being asked and the prompt required to start the text-completion process. This concept used in large language models is called Prompt Engineering, wherein the first part of the prompt includes natural language instructions and/or examples of the specific task desired (in our case, summarization). Prompts allow developers to provide some context to the API, which can help it generate more relevant and accurate text completions. The model then completes the task by predicting the most probable next text. This technique is known as "in-context" learning.

There are three main approaches for training models for in-context learning: Zero-shot, Few-shot and Fine tuning. These approaches vary based on the amount of task-specific data that is given to the model:

- **Zero-shot**: In this case, no examples are provided to the model, only the task request is given as input. In Zero-shot learning, the models depend on previously trained concepts and tries to relate the given task to existing categories that it has already learned about and responds accordingly.
- **Few-shot**:  Here, the user includes several examples in the prompt that demonstrate the expected answer format and content. Here the model is fed with very small amount of training data to guide its predictions. This enables the model to generalize, and understand related but previously unseen tasks, with just a few examples. Creating these few-shot examples can be tricky, since you need to articulate the “task” you want the model to perform through them. One commonly observed issue is that models are sensitive to the writing style used in the training examples, especially the smaller models.
- **Fine-Tuning**: Fine Tuning lets you tailor the models to get precise desired outcome from your personal datasets. This customization step will let you get more out of the service by:

   - Including a relatively larger set of example data (at least 500 and above). 
   - Traditional optimization techniques are used with Back Propagation to re-adjust the weights of the model -- this enables higher quality results than mere Zero-Shot or Few-Shot. 
   - Improving the Few-Shot learning approach by training the model weights using specific prompts and structure. This lets you achieve better results on a wider number of tasks without needing to provide examples in the prompt. The result is less text sent and fewer tokens.

In this guide we demonstrate Curie-Instruct/Text-Curie-001 and Davinci-Instruct/Text-Davinci-001 engines for summarization. (These engines go through frequent iterations and the version that you use might be different in future.)

### Post-Process

It’s recommended that you checking the validity of results provided by GPT-3. Apply validity checks through a programmatic approach, or through classifiers depending on the use case. Here are some critical checks:

1.	Verify that no significant point is missed.
2.	Check for factual inaccuracies.
3.	Check for any bias occurred due to the training data used on the model.
4.	Validate that model did change the text by adding a new idea or point, also known as hallucination.
5.	Check grammatical and spelling errors.
6.	Apply content profanity filter like [Azure Content Moderator]() to ensure that no inappropriate or irrelevant verbose is included. 

Finally, reintroduce any vital information previously removed from the summary, such as for confidential information. 

In some cases, a summary of the conversation is also sent to the customer, along with the original transcript. In this case, post processing involves appending the transcript into the summary. It can also include adding lead-in sentences such as "Please find summary below:" to the beginning of the summary, before sending it out to the customer. 

### Considerations

It’s most important to fine-tune our base models with an industry specific training dataset and the change size of available datasets. Fine-tuned models perform best when the size of training data is over 1000 datapoints, while ensuring that the ground truth (human generated summaries) used to train our model is of high quality. 

The tradeoff is cost. The process of labeling and cleaning datasets can be expensive. To ensure high quality training data, manual inspection of ground truth summaries and rewriting low-quality summaries may be required. Consider the following points for the summarization stage:

1.	Prompt Engineering: Davinci can do well with lesser instruction than other models. Experiment with different prompts for different models to optimize results.
2.	Token size: GPT-3 based summarizer is limited to 4098 tokens, which includes prompt and completion. To summarize larger text passages, break down the text into several chunks that conform the token length size. Summarize each individually and collect the results as a super summary.
3.	Garbage in, Garbage out: Trained models will only be as good as the training data provided. Make sure that the ground truth summaries in the training data are well suited to the information you eventually want to summarize in your dialogue. 
4.	Stopping point: The model stops summarizing when it reaches a natural stopping point or reaches a user-provided stop sequence. Test this parameter to choose between multiple completions or if the summary looks incomplete.

## Example scenarios

### Use Case -Summarizing transcripts in call centers

This article demonstrates how Azure OpenAI’s summarization feature can help the customer service agents with their summarization tasks. We will explore the zero-shot, few-shot and fine-tuning approaches and compare their results against the human generated summaries, referred to as ground truth.
 
The dataset used is a set of hypothetical conversations between customer and agent within the Microsoft Xbox customer support center about various Xbox products and services. Hypothetical chat is labeled as **Prompt**; human-written abstractive summary as **Completion**, for our summarization test-completion task. 

*Note on Abstractive and extractive summaries*: Extractive summarization aims at identifying, extracting salient information, and grouping together that information to produce a concise direct extractive summary without understanding the meaning or context (direct extraction from original text). Abstractive summary generation rewrites the dialogue by building internal semantic representation, and then a summary is created using natural language processing, which involves paraphrasing.

|Prompt|	Completion|
|-|-|
|Customer: Question on XAIL<br>Agent: Hello! How can I help you today?<br>Customer: Hi, I have a question about the Accessibility insider ring<br>Agent: Okay. I can certainly assist you with that.<br>Customer: Do I need to sign up for the preview ring to join the accessibility league?<br>Agent: No. You can leave your console out of Xbox Preview rings and still join the League. However, note that some experiences made available to you may require that you join an Xbox Preview ring.<br>Customer: Okay. And I can just sign up for preview ring later yeah?<br>Agent: That is correct.<br>Customer: Sweet.|	Customer wants to know if they need to sign up for preview rings to join Xbox Accessibility Insider League. Agent responds that it is not mandatory, but that some experiences may require it.|

**Ideal Output** – Our goal is to create summaries that follow the format: "Customer said ABC. Agent responded DEF." Additionally, we want to capture salient features of the dialogue, such as the customer complaint, suggested resolution, further follow-up, etc. 
This is an example of a customer support interaction, and a comprehensive human-written summary of same.

**Dialogue**

Customer: Hello. I have a question about the game pass.

Agent: Hello. How are you doing today?

Customer: I’m good.

Agent. I see that you need help with the Xbox Game Pass.

Customer: Yes. I wanted to know how long can I access the games after they leave game pass?

Agent: Once a game leaves the Xbox Game Pass catalog, you’ll need to purchase a digital copy from the Xbox app for Windows or the Microsoft Store, play from a disc, or obtain another form of entitlement to continue playing the game. Remember, Xbox will notify members prior to a game leaving the Xbox Game Pass catalog.
And, as a member, you can purchase any game in the catalog for up to 20% off (or the best available discounted price) to continue playing a game once it leaves the catalog.

Customer: Got it, thanks

**Ground Truth summary**

Customer wants to know how long they can access games after they have left game pass. Agent informs customer that they would need to purchase the game to continue having access.

#### Zero-Shot

Zero-Shot learning is the process where we get auto generated summaries from GPT3 without offering any labelled data. We rely on instructions that we would pass within the prompt, and the data that GPT3 is pre-trained on (which is most of the internet). This method is useful when there is a lack of ample labelled training data (in our case, it is the lack of ground truth summaries). It is important to design prompts carefully to extract relevant information. To extract general summaries from customer-agent chats, we will be using the following format:

prefix = "Please provide a summary of the conversation below: "

suffix = "The summary is as follows: "

Below is a sample on how to execute a zero-shot model.

```python
rouge = Rouge()
# run zeroshot prediction for all the engines of interest
deploymentNames = [“curie-instruct”,”davinci-instruct”] # aka text-davinci/text-instruct
for deployment in deploymentNames:
url = openai.api_base + “openai/deployments/” + deployment + “/completions?api-version=2022-12-01-preivew”
response_list = []
rouge_list = []
print(“calling…” + deployment)
for i in range(len(test)):
response_i = openai.Completion.create(
engine = deployment,
prompt = build_prompt(prefix, [test[‘prompt’][i]], suffix),
temperature = 0.0,
max_tokens = 400,
top_p = 1.0,
frequence_penalty = 0.5,
persence_penalty = 0.0,
stop=[“end”] # It is recommended to change the stop sequence according to the dataset
)
scores = rouge.get_scores(normalize_text(response_i[‘choices’][ 0][‘text’]),test[‘completion’][i])
rouge_list += [scores[0][‘rouge-1’][‘f’]],
response_list += [response_i]
summary_list = [normalize_text(i[‘choices’][0][‘text’]) for i in response_list]
test[deployment + “_zeroshotsummary”] = summary_list
test[deployment + “_zeroshotroguescore”] = rouge_list
```

**Zero-Shot Results and observations**

Zero-shot model’s output is produced directly from the base model. Here, we find that both Curie and Davinci capture the summaries fairly well. The only noticeable difference is that Curie model captured a little less detail than Davinci.

(“customer asks the agent about the xbox game pass” vs “customer asked how long they could access games after they leave the xbox game pass catalog”)

Dialogue

customer: hello. I have a question about the game pass. 
agent: hello. How are you doing?
customer: I’m good. 
agent: I see that you need help with the Xbox game pass. 
customer: yes. I wanted to know how long can I access the games after they leave game pass 
agent: once a game leaves the Xbox game pass catalog you’ll need to purchase a digital copy from the Xbox app for windows or the Microsoft store play from a disc or obtain another form of entitlement to continue playing the game. Remember, Xbox will notify members prior to a game leaving the Xbox game pass catalog. and as a member you can purchase any game in the catalog for up to 20 off or the best available discounted price to continue playing a game once it leaves the catalog.

----------------------------------------

Ground Truth

customer wants to know how long they can access games after they have left game pass. agent informs customer that they would need to purchase the game to continue having access.

----------------------------------------

Davinci Zero-Shot

The customer asked how long they could access games after they leave the Xbox game pass catalog. The agent told them that they would need to purchase a digital copy of the game from the Xbox app for windows or the Microsoft store in order to continue playing it. The agent also reminded the customer that they would be notified prior to a game leaving the Xbox game pass catalog. as a member the customer could purchase any game in the catalog for up to 20 off or the best available discounted price.

----------------------------------------

Curie Zero-Shot
The customer asks the agent about the Xbox game pass. the agent tells the customer that once a game leaves the Xbox game pass catalog the customer will need to purchase a digital copy from the Xbox app for windows or the Microsoft store play from a disc or obtain another form of entitlement to continue playing the game. The agent also reminds the customer that Xbox will notify members prior to a game leaving the Xbox game pass catalog.

#### Few-Shot

Few-shot learning is when the model is provided with examples during inference to guide predictions in a certain format or learn certain context. However, updating weights of the pre-trained model is not allowed. The main advantages of few-shot are a major reduction in the need for task-specific data and reduced potential to learn an overly narrow distribution from a large but narrow fine-tuning dataset (Ref: Language Models are few-shot learners).

prefix = "Please provide a summary of the conversation below: "

suffix = "The summary is as follows: "

Below is a sample on how to execute a zero-shot model.

```python
rouge = Rouge()
# run zeroshot prediction for all the engines of interest
deploymentNames = [“curie-instruct”,”davinci-instruct”] # aka text-davinci/text-instruct
for deployment in deploymentNames:
url = openai.api_base + “openai/deployments/” + deployment + “/completions?api-version=2022-12-01-preivew”
response_list = []
rouge_list = []
print(“calling…” + deployment)
for i in range(len(test)):
response_i = openai.Completion.create(
engine = deployment,
prompt = build_prompt(prefix, [test[‘prompt’][i]], suffix),
temperature = 0.0,
max_tokens = 400,
top_p = 1.0,
frequence_penalty = 0.5,
persence_penalty = 0.0,
stop=[“end”] # It is recommended to change the stop sequence according to the dataset
)
scores = rouge.get_scores(normalize_text(response_i[‘choices’][ 0][‘text’]),test[‘completion’][i])
rouge_list += [scores[0][‘rouge-1’][‘f’]],
response_list += [response_i]
summary_list = [normalize_text(i[‘choices’][0][‘text’]) for i in response_list]
test[deployment + “_zeroshotsummary”] = summary_list
test[deployment + “_zeroshotroguescore”] = rouge_list
```

**Zero-Shot Results and observations**

Zero-shot model’s output is produced directly from the base model. Here, we find that both Curie and Davinci capture the summaries fairly well. The only noticeable difference is that Curie model captured a little less detail than Davinci.

(“customer asks the agent about the xbox game pass” vs “customer asked how long they could access games after they leave the xbox game pass catalog”)

Dialogue

customer: hello. I have a question about the game pass. 
agent: hello. How are you doing?
customer: I’m good. 
agent: I see that you need help with the Xbox game pass. 
customer: yes. I wanted to know how long can I access the games after they leave game pass 
agent: once a game leaves the Xbox game pass catalog you’ll need to purchase a digital copy from the Xbox app for windows or the Microsoft store play from a disc or obtain another form of entitlement to continue playing the game. Remember, Xbox will notify members prior to a game leaving the Xbox game pass catalog. and as a member you can purchase any game in the catalog for up to 20 off or the best available discounted price to continue playing a game once it leaves the catalog.

----------------------------------------

Ground Truth
customer wants to know how long they can access games after they have left game pass. agent informs customer that they would need to purchase the game to continue having access.

----------------------------------------

Davinci Zero-Shot
The customer asked how long they could access games after they leave the Xbox game pass catalog. The agent told them that they would need to purchase a digital copy of the game from the Xbox app for windows or the Microsoft store in order to continue playing it. The agent also reminded the customer that they would be notified prior to a game leaving the Xbox game pass catalog. as a member the customer could purchase any game in the catalog for up to 20 off or the best available discounted price.

----------------------------------------
Curie Zero-Shot
The customer asks the agent about the Xbox game pass. the agent tells the customer that once a game leaves the Xbox game pass catalog the customer will need to purchase a digital copy from the Xbox app for windows or the Microsoft store play from a disc or obtain another form of entitlement to continue playing the game. The agent also reminds the customer that Xbox will notify members prior to a game leaving the Xbox game pass catalog.

#### Fine Tuning

Fine Tuning involves updating the weights of a pre-trained model by training on a supervised dataset specific to the desired task. Typically, thousands to hundreds of thousands of labeled examples are used. The main advantage of fine-tuning is strong performance on many benchmarks. The disadvantages are the need for a large new dataset for every task, the potential for poor generalization out-of-distribution and the possibility to exploit spurious features of the training data, thereby resulting in high chances of unfair comparison with human performance.

Creating a dataset for model customization is different from designing your prompts for use with any of the base models. Prompts for completion calls often use either detailed instructions or few-shot learning techniques and consist of multiple examples. For fine-tuning, we recommend that each training example consist of a single input example and its desired output. You do not need to give detailed instructions or examples in the same prompt.

The more training examples you have, the better. We recommend having at least a couple of hundred examples. In general, we've found that each doubling of the dataset size leads to a linear increase in model quality.

Here is an example format:

```
{"prompt": "<prompt text>", "completion": "<ideal generated text>"}
{"prompt": "<prompt text>", "completion": "<ideal generated text>"}
{"prompt": "<prompt text>", "completion": "<ideal generated text>"}
```
Executing a fine-tuning model

Fine-tuned models involve re-training a model on new data before deployment. A thorough run down on this multi-step process can be found [here](/azure/cognitive-services/openai/how-to/fine-tuning?pivots=programming-language-studio).

Fine tuning results and observations

We found that a fine tune Curie model has comparable results to a Davinci few shot model. Both summaries capture the customer’s question and the agent’s answer, without capturing the additional details (on discounts) or without assuming pointers and is similar to the ground truth.

Dialogue

customer: Hello. I have a question about the game pass. 
customer: I’m good. agent. I see that you need help with the xbox game pass. 
customer: yes. I wanted to know how long can I access the games after they leave game pass 
agent: once a game leaves the Xbox game pass catalog you’ll need to purchase a digital copy from the Xbox app for windows or the Microsoft store play from a disc or obtain another form of entitlement to continue playing the game. Remember, Xbox will notify members prior to a game leaving the Xbox game pass catalog. and as a member you can purchase any game in the catalog for up to 20 off or the best available discounted price to continue playing a game once it leaves the catalog.

----------------------------------------

Ground Truth

customer wants to know how long they can access games after they have left game pass. agent informs customer that they would need to purchase the game to continue having access.

----------------------------------------
Curie Fine Tuning Result
customer wants to know how long they can access the games after they leave game pass. agent explains that once a game leaves the Xbox game 
pass catalog they’ll need to purchase a digital copy from the Xbox app for windows or the Microsoft store play from a disc or obtain another form of entitlement to continue playing the game.

## Conclusions

Generally, Davinci model performs tasks with fewer instructions than its counterparts, such as Curie. Davinci is better suited for summarizing text that requires understanding context or specific language. Because Davinci is the most complex model, its latency will be higher than its counterparts. Curie is faster than Davinci and is capable of summarizing conversations.

With our experiments, we were able to generate better summaries as we provide more instruction to the model (through few shot or fine tuning). Fine-tuned models are better at conforming to the structure and context learned from the training dataset. This is especially useful when summaries are domain specific (E.g.- Capturing summaries from Doctors Notes/Online prescription customer support). With fine-tuning, the end user has more control over the type of summaries they want to see, depending on their use case.

Ground Truth
customer wants to know how long they can access games after they have left game pass. agent informs customer that they would need to purchase the game to continue having access.

----------------------------------------
Davinci Zero Shot
The customer asked how long they could access games after they leave the Xbox game pass catalog. The agent told them that they would need to purchase a digital copy of the game from the Xbox app for windows or the Microsoft store in order to continue playing it. The agent also reminded the customer that they would be notified prior to a game leaving the Xbox game pass catalog. As a member the customer could purchase any game in the catalog for up to 20 off or the best available discounted price.

----------------------------------------
Curie Zero-Shot
The customer asks the agent about the Xbox game pass. the agent tells the customer that once a game leaves the Xbox game pass catalog the customer will need to purchase a digital copy from the Xbox app for windows or the Microsoft store play from a disc or obtain another form of entitlement to continue playing the game. The agent also reminds the customer that Xbox will notify members prior to a game leaving the Xbox game pass catalog.

----------------------------------------
Davinci Few-Shot
customer wanted to know how long they could access games after they leave game pass. Agent informs that once a game leaves the Xbox game pass catalog the customer would need to purchase a digital copy or obtain another form of entitlement to continue playing the game.

----------------------------------------

Curie Few-Shot

customer has a question about the game pass. customer is good. agent needs help with the Xbox game pass. customer asks how long they can access the games after they leave the game pass catalog. Agent informs that once a game leaves the Xbox game pass catalog the customer will need to purchase a digital copy from the Xbox app for windows or the Microsoft store play from a disc or obtain another form of entitlement to continue playing the game. customer is happy to hear this and thanks agent.

----------------------------------------

Curie Fine Tuning Result
customer wants to know how long they can access the games after they leave game pass. agent explains that once a game leaves the Xbox game. 
pass catalog they’ll need to purchase a digital copy from the Xbox app for windows or the Microsoft store play from a disc or obtain another form of entitlement to continue playing the game.

### Evaluating Summarization

There are multiple techniques to evaluate the performance of summarization models. Below are a few methods: 

**ROUGE (Recall-Oriented Understudy for Gisting Evaluation)** It includes measures to automatically determine the quality of a summary by comparing it to other (ideal) summaries created by humans. The measures count the number of overlapping units such as n-gram, word sequences, and word pairs between the computer-generated summary to be evaluated and the ideal summaries created by humans. 

```python
reference_summary = "The cat ison porch by the tree"
generated_summary = "The cat is by the tree on the porch"
rouge = Rouge()
rouge.get_scores(generated_summary, reference_summary)
[{'rouge-1': {'r':1.0, 'p': 1.0, 'f': 0.999999995},
  'rouge-2': {'r': 0.5714285714285714, 'p': 0.5, 'f': 0.5333333283555556},
  'rouge-1': {'r': 0.75, 'p': 0.75, 'f': 0.749999995}}]
```
Figure 3: Rouge score example

**BertScore** (Zhang et al., 2020) computes similarity scores by aligning generated and reference summaries on a token-level. Token alignments are computed greedily to maximize the cosine similarity between contextualized token embeddings from BERT. 

```python
  import torchmetrics
  from torchmetrics.text.bert import BERTScore
  preds = "You should have ice cream in the summer"
  target = "Ice creams are great when the weather is hot"
  bertscore = BERTScore()
  score = bertscore(preds, target)
  print(score)
```

Figure 4: BERT score example

**Similarity Matrix** is a representation of the similarities between different entities in summarization evaluation. It is used to compare different summaries of the same text and measure their similarity and is represented by a two-dimensional grid, where each cell contains a measure of the similarity between two summaries. The similarity can be measured using a variety of methods, such as cosine similarity, Jaccard similarity, and edit distance. The matrix is then used to compare the summaries and determine which summary is the most accurate representation of the original text.

Following is a sample command to get the similarity matrix of BertScore comparing 2 similar sentences.

```python
bert-score-show --lang en -r "The cat is on the porch by the tree"
                          -c "The cat is by the tree on the porch"
                          -f out.png
```

The first sentence “The cat is on the porch by the tree” is referred as the candidate and the second one “The cat is by the tree on the porch” is referred as the reference and the command is using BertScore to compare both sentences for generating the matrix. 

Figure 4: Similarity matrix example - displays the output matrix generated by above command.

image 

Figure 5: Similarity matrix example

For a more comprehensive list and unified metrics in Pypi package, please refer to the following paper: https://direct.mit.edu/tacl/article/doi/10.1162/tacl_a_00373/100686/SummEval-Re-evaluating-Summarization-Evaluation and 
https://pypi.org/project/summ-eval/ 

### Responsible Use

While GPT can produce excellent results, it is imperative to check the output for social, ethical, and legal biases/safety. While fine tuning models, it is important to remove any data-points that may be harmful for the model to learn. Red teaming can be leveraged to identify any harmful outputs from the model. This can be done manually and can be supported with semi- automated methods (Generate test cases uses language models and use a classifier to detect harmful behavior on test cases). Finally, a manual check of the generated summary should be done to ensure that the summaries are ready to be used.

Read more on the DeepMind paper [here].

## Contributors

Meghna Jani

## Next steps

- Jupyter notebook with technical details and execution of the use case described in this newsletter can be found at: Azure/openai-samples at conversational-summarization-v0 (github.com)
- Further information on Azure OpenAI can be found here.
- ROUGE reference paper can be found here.

## Related resources 