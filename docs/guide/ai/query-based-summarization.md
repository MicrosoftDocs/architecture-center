This guide shows how to perform document summarization by using the Azure OpenAI GPT-3 model. It descibes concepts that are related to the document summarization process, approaches to the process, and recommendations on which model to use for a specific use case. Finally, it presents two use cases, together with sample code snippets, to help you understand key concepts.

## Architecture

The following diagram shows how a user query fetches relevant data. The summarizer generates a summary of the text extracted from the most relevant document by using GPT-3 endpoints. In this architecture, the endpoint is used to summarize the extracted text. 

image 

alt text Diagram that shows a user search and summarization that uses GPT-3 endpoints.

link 

### Workflow

This workflow occurs in near-real time.

- A user sends a query. For example, an employee of a manufacturing company searches for specific information about a machine part on the company portal. The query is first processed by an intent recognizer like [conversational language understanding](/azure/cognitive-services/language-service/conversational-language-understanding/overview). The relevant entities or concepts in the user query are used to select and present a subset of documents from a knowledge base that's populated offline (in this case, the company's knowledge base database). The output is fed into a search and analysis engine like [Azure Elastic Search](https://www.elastic.co/partners/microsoft-azure) for document filtering, which filters the number of relevant documents, resulting in a document set of hundreds instead of thousands or tens of thousands.
- The user query is applied again on a search endpoint like [Cognitive Search](/rest/api/searchservice/) to rank the retrieved document set in order of relevance (page ranking). Based on the ranking, the top document is selected.
- The selected document is scanned for relevant sentences. This scanning process uses either a coarse method like extracting all sentences that contain the user query or a more sophisticated method like GPT-3 based embeddings to find semantically similar material in the document.
- After the relevant text is extracted, the GPT-3 Completions endpoint with the summarizer summarizes the extracted content. (In this example, the summary of important details about the part that the employee specified in the query are returned.)

This article focuses on the summarizer component of the architecture.

## Scenario details

Enterprises frequently create and maintain a knowledge base about business processes, customers, products, and information. However, returning relevant content based on a user query of a large dataset is often challenging. The user can query the knowledge base and find an applicable document by using methods like page rank, but delving further into the document to search for relevant information typically becomes a manual task that takes time. However, with recent advances in foundation transformer models like the one developed by OpenAI, the query mechanism has been refined by semantic search methods that use encoding information like embeddings to find relevant information. This has enabled the ability to summarize content and present it to the user in a concise and succinct way.

*Document summarization* is the process of creating summaries from large volumes of data while maintaining significant informational elements and content value. This article demonstrates how to use [Azure OpenAI Service](https://azure.microsoft.com/products/cognitive-services/openai-service/) GPT-3 capabilities for your specific use case. GPT-3 is a powerful tool that you can use for a range of natural language processing tasks, including language translation, chatbots, text summarization, and content creation. The methods and architecture described here are customizable and can be applied to many datasets. Azure OpenAI Service brings Azure enterprise-level improved security, compliance, and regional availability to the OpenAI API.

### Potential use cases

Document summarization applies to any business domain that requires users to search large amounts of reference data and generate a summary that concisely describes relevant information. Typical business and organizational settings include legal, financial, news, healthcare, and academic institutions. Potential use cases of summarization are:

- Generating summaries to highlight key insights about news, financial reporting, and so on.
- Creating quick a reference to support an argument, for example, in legal proceedings.
- Providing context for a paper's thesis, as in academic settings.
- Writing literature reviews.
- Annotating a bibliography.

Some benefits of using summarization service for any use case are:

- Reduced reading time.
- More effective searching of large volumes of disparate data.
- Reduced chance of bias from human summarization techniques. (This benefit depends on how unbiased the training data is.)
- Enables employees and users to focus on more in-depth analysis.

### In-context learning

Azure OpenAI Service uses generative completion models. that uses Natural Language (NL) instructions to identify the task at hand and the skill required - aka Prompt Engineering. In this approach, the first part of the prompt includes NL instructions and/or examples of the desired task. The model then completes the task by predicting the most probable next text. This technique is known as *in-context learning*. 

> [!note] 
> In-context learning is a method of using language models to learn tasks from few examples. It consists of providing the language model with a prompt containing a list of input-output pairs that demonstrate a task, followed by a test input. The model is then able to make a prediction by conditioning on the prompt and predicting the next tokens.

There are three main approaches for in-context learning: **Zero-Shot** examples, **Few-shot** prompt engineering examples and **Fine-tuning** methods to change and improve the output summaries. These approaches vary based on the amount of task-specific data that is given to the model.

**Zero-Shot:** In this case, no examples are provided to the model and only the task request is given as input. In Zero-Shot learning, the models depend on previously trained concepts and only knows how to respond based on the data it was trained on. Though it doesn't necessarily understand the semantic meaning but understands statistically based on everything it has learnt over the internet about what it thinks should be generated next. The model tries to relate the given task to existing categories that it has already learnt about and responds accordingly.

**Few-shot:** In this case, a user includes several examples in the call prompt that demonstrate the expected answer format and content. The model in this case is provided with a very small training dataset to guide its predictions. Training with a small set of examples enables the model to generalize and understand unrelated, but previously unseen tasks. Creating these Few-Shot examples can be tricky, since you need to be accurate on how you articulate the “task” that you want the model to perform. One commonly observed issue is that models are sensitive to the writing style used in the training examples, especially the smaller models. 

**Fine-Tuning:** Fine tuning lets you tailor the models to your personal datasets. This customization step will let you get more out of the service by: 

- Including a relatively larger set of example data (at least 500 and above). 
- Traditional optimization techniques are used with Back Propagation to re-adjust the weights of the model -- this enables higher quality results than mere Zero-Shot or Few-Shot. 
- Improving the Few-shot learning approach by training the model weights using specific prompts and structure. This lets you achieve better results on a wider number of tasks without needing to provide examples in the prompt. The result is less text sent and fewer tokens.

While creating any GPT-3 solution, the primary effort is the considerations of the design and content of the training prompt. 

### Prompt Engineering

Prompt engineering is an NL processing concept that involves discovering inputs that yield desirable or useful outputs. When the user *prompts* the machine, the content expression can dramatically change the output. This process is called *Prompt Design*. Prompt Design thus becomes the most significant process in priming the GPT-3 model to give a favourable and contextual response. Here in this guide, we will be using the Completion Endpoint for summarization. Completion endpoint refers to a [Cognitive Services API](/azure/cognitive-services/openai/how-to/completions) that accepts a partial prompt or context as input and returns one or more text completions that continue or complete the input text. The user provides input text as a prompt and the model generates text that attempts to match the context or pattern that was provided to the model. Designing the appropriate prompt is very task and data dependent. Injecting prompt engineering into a fine-tuning dataset and investigating what works best before taking it to production requires a lot of time and effort.

#### Prompt Design

GPT-3 models can perform multiple tasks. However, that introduces the need to be explicit in the goals of this design. The models work their way estimating and guessing the desired output based on the provided prompt. 

For instance, if one sends the words "Give me a list of cat breeds", the model wouldn't automatically assume that you're asking for a list of cat breeds. You could just as easily be asking the model to continue a conversation where the first words are "Give me a list of cat breeds" and the next ones are "and I'll tell you which ones I like." If the model only assumed that you wanted a list of cats, it wouldn't be as good at content creation, classification, or other tasks.

As documented in [Completions Endpoint Prompt Design](), there are three basic guidelines for creating prompts:

- **Show and tell.** Make it clear what you want either through instructions, examples, or a combination of the two. If you want the model to rank a list of items in alphabetical order or to classify a paragraph by sentiment, then show that need.
- **Provide quality data.** If you are trying to build a classifier or get the model to follow a pattern, make sure that there are enough examples. Be sure to proofread your examples though the model is usually smart enough to see through basic spelling mistakes and give you a response, but the model might assume this is intentional and it can affect the response.
- **Check your settings.** The ‘temperature’ and ‘top_p’ settings control how deterministic the model is in response generation. If you're asking it for a response where there's only one right answer, then you'd want to set these settings to a lower level. If you're looking for more diverse responses, then you might want to set the settings to a higher level. A common error with regard to the settings is the assumption that these are "cleverness" or "creativity" controls.

### Alternatives

An alternative to Summarizer is the Azure CLU [(Conversational Language Understanding - Azure Cognitive Services | Microsoft Learn)](/azure/cognitive-services/language-service/conversational-language-understanding/overview). The main purpose of using Azure CLU is to build models to predict the overall intention of an incoming utterance, extract valuable information from it, and produce an appropriate response in line with the topic. It is useful in chatbot applications where it can refer an existing knowledgebase for finding the most appropriate solution or suggestion in correspondence for the incoming utterance. This wouldn’t help much when the input text doesn’t require a response. Our intent is to generate a short summary of long text content where the crux of the content is described in a very concise manner with all important information intact.

Let’s begin with a use case where we summarize a corpus of US bills passed through Congress and fine tune it to generate a summary closer to a human generated summary, referred to as *Ground Truth*. 

## Example scenarios

### Use Case 1: Summarizing Legal Documents 

This is a use case where **Zero-Shot** prompt engineering is used for summarizing legislative bills and the prompt & settings are modified to generate different summary outputs.

#### Dataset

The first dataset is the BillSum dataset for summarization of US Congressional and California state bills. For illustration purposes, we will look solely at the US bills. The corpus consists of bills from the 103rd to the 115th (1993-2018) sessions of US Congress. The data was split into 18,949 train bills and 3,269 test bills. The BillSum corpus focuses on mid-length legislation from 5,000 to 20,000 characters in length. It has already been cleaned/pre-processed.

More information on the dataset and downloading instructions can be found [here](https://github.com/FiscalNote/BillSum).

##### US Congressional Bills Schema

The schema of the BillSum dataset includes:
- bill_id: an identifier for the bill
- text: US bill text
- summary: human written bill summary
- title: bill title
- text_len: character length of the bill
- sum_len: character length of the bill summary

In our use case, we will use the text and summary components.

#### Zero-Shot

The goal here is to teach the GPT-3 model to learn conversation style input. We use the "Completion" to create an Azure OpenAI API and craft a prompt that would generate the best summary of the US bill. It is vital to create the prompts carefully to extract relevant information. To extract general summaries from the given US bill, we will be using the following format:
1.	Prefix: What do you want it to do
2.	Context primer: Describe what the context is
3.	Context: # The information needed to answer the question. In the case of summary, the prose that needs to be summarized.
4.	Suffix: Describe the intended form of the answer (should it be an answer, a completion, a summary, etc)

```python
API_KEY = # SET YOUR OWN API KEY HERE
RESOURCE_ENDPOINT = " -- # SET A LINK TO YOUR RESOURCE ENDPOINT -- " 

openai.api_type = "azure"
openai.api_key = API_KEY
openai.api_base = RESOURCE_ENDPOINT
openai.api_version = "2022-12-01-preview"
prompt_i = 'Summarize the legislative bill given the title and the text.\n\nTitle:\n'+" ".join([normalize_text(bill_title_1)])+ '\n\nText:\n'+ " ".join([normalize_text(bill_text_1)])+'\n\nSummary:\n'
response = openai.Completion.create(
    engine= TEXT_DAVINCI_001
    prompt = prompt_i,
    temperature = 0.4,
    max_tokens = 500,
    top_p = 1.0,
    frequency_penalty=0.5,
    presence_penalty = 0.5,
    stop=['\n\n###\n\n'], #the ending token used during inference, once reaches this token GPT-3 knows the completion is over
    best_of = 1
    )
 = 1
```

**Original text:** [Refer to SAMPLE_BILL_1](https://github.com/Azure/openai-solutions/blob/main/Solution_Notebooks/Summarization/SummarizationOverview.md#sample_bill_1)

**Ground Truth:** National Science Education Tax Incentive for Businesses Act of 2007 - Amends the Internal Revenue Code to allow a general business tax credit for contributions of property or services to elementary and secondary schools and for teacher training to promote instruction in science, technology, engineering, or mathematics.

**Zero-Shot model summary:** The National Science Education Tax Incentive for Businesses Act of 2007 would create a new tax credit for businesses that make contributions to science, technology, engineering, and mathematics (STEM) education at the elementary and secondary school level. The credit would be equal to 100 percent of the qualified STEM contributions of the taxpayer for the taxable year. Qualified STEM contributions would include STEM school contributions, STEM teacher externship expenses, and STEM teacher training expenses.

**Zero-Shot Observations**

As we can see, Zero-Shot model does an excellent job at generating a succinct summary of the legal document that is general in nature. It is very similar to the human written ground truth and captures those same key points. It flows like a human summary and stays direct to the point.

#### Fine-tuning

Fine-tuning lets you get more out of the models available through the API by providing:
- Higher quality results than prompt design
- Ability to train on more examples than what can fit in a prompt
- Token savings due to shorter prompts
- Lower latency requests

Fine-tuning improves on Few-Shot learning by training on many examples that can fit in the prompt, letting you achieve better results on a wide number of tasks. Once a model has been fine-tuned, you won't need to provide examples in the prompt anymore. This saves costs by saving the tokens required and enables lower-latency requests.

At a high level, Fine-tuning involves the following steps:
- Prepare and upload training data
- Train a new fine-tuned model
- Use your fine-tuned model

source: [How to customize a model with Azure OpenAI - Azure OpenAI | Microsoft Learn](/azure/cognitive-services/openai/how-to/fine-tuning?pivots=programming-language-studio) 

*Note: we will be fine-tuning only the legal bills dataset and not the financial reports dataset (second use case), since there is not enough data available for it.*

##### Preparing data for fine-tuning

This function allows us to leverage the power of the Zero-Shot model by injecting prompt engineering into the prompts used for fine-tuning. This helps give directions to the model on how to approach the prompt/completion pairs. Prompts are used to prime a fine-tune model by providing a starting point for the model to learn from. By providing a prompt, the model can begin to learn from the data it is given and make predictions based on the prompt. This allows the model to start with a basic understanding of the data, which can then be gradually improved upon as the model is exposed to more data. Additionally, prompts can help the model to identify patterns in the data that it may have otherwise missed.

The same prompt engineering structure is also used during inference once the model is finished training so that it recognizes the behaviors to follow that were taught to the model during training and can generate completions as "instructed".

```python
#adding variables used to design prompt consistently across all examples
#more info can be found here: https://learn.microsoft.com/azure/cognitive-services/openai/how-to/prepare-dataset

LINE_SEP = " \n "
PROMPT_END = " [end] "
#Injecting the Zero-Shot prompt into fine-tune dataset
def stage_examples(proc_df):
    proc_df['prompt'] = proc_df.apply(lambda x:"Summarize the legislative bill. Do not make up facts.\n\nText:\n"+" ".join([normalize_text(x['prompt'])])+'\n\nSummary:', axis=1)
    proc_df['completion'] = proc_df.apply(lambda x:" "+normalize_text(x['completion'])+PROMPT_END, axis=1)
    
    return proc_df

df_staged_full_train = stage_examples(df_prompt_completion_train)
df_staged_full_val = stage_examples(df_prompt_completion_val)
```

Now that the data is staged for fine-tuning in the proper format, we can start running the fine-tune commands.

Next, we use OpenAI's Command Line Interface (CLI) to assist with many of the data preparation steps. OpenAI has developed a tool which validates, gives suggestions, and reformats your data.

```python
openai tools fine_tunes.prepare_data -f data/billsum_v4_1/prompt_completion_staged_train.csv

openai tools fine_tunes.prepare_data -f data/billsum_v4_1/prompt_completion_staged_val.csv

openai tools fine_tunes.prepare_data -f data/billsum_v4_1/prompt_completion_staged_val.csv

```

##### Fine-tune dataset

```python
payload = {
  "model": "curie",
  "training_file": " -- INSERT TRAINING FILE ID -- ",
  "validation_file": "-- INSERT VALIDATION FILE ID --",
  "hyperparams": {
  "n_epochs": 1,
  "batch_size": 200,
  "learning_rate_multiplier": 0.1,
  "prompt_loss_weight": 0.0001    
  }
}

url = RESOURCE_ENDPOINT + "openai/fine-tunes?api-version=2022-12-01-preview"
r = requests.post(url, 
    headers={
    "api-key": API_KEY,
    "Content-Type": "application/json"
    },
    json = payload
)
data = r.json()
print(data)
fine_tune_id = data['id']
print('Endpoint Called: {endpoint}'.format(endpoint = url))
print('Status Code: {status}'.format(status= r.status_code))
print('Fine tuning job ID: {id}'.format(id=fine_tune_id))
print('Response Information \n\n {text}'.format(text=r.text))

```

##### Evaluation of fine-tuned model

This section will demonstrate how to evaluate a fine-tuned model.

```python
#Run this cell to check status
url = RESOURCE_ENDPOINT + "openai/fine-tunes/<--insert fine-tune id-->?api-version=2022-12-01-preview"
r = requests.get(url, 
    headers={

    "api-key": API_KEY,
    "Content-Type": "application/json"
    }
)

data = r.json()
print('Endpoint Called: {endpoint}'.format(endpoint = url))
print('Status Code: {status}'.format(status= r.status_code))
print('Fine tuning ID: {id}'.format(id=fine_tune_id))
print('Status: {status}'.format(status = data['status'])) 
print('Response Information \n\n {text}'.format(text=r.text))

```
**Original text:** Refer to [SAMPLE_BILL_1](https://github.com/Azure/openai-solutions/blob/main/Solution_Notebooks/Summarization/SummarizationOverview.md#sample_bill_1).

**Ground Truth:** National Science Education Tax Incentive for Businesses Act of 2007 - Amends the Internal Revenue Code to allow a general business tax credit for contributions of property or services to elementary and secondary schools and for teacher training to promote instruction in science, technology, engineering, or mathematics.

**Fine-tune model summary:** This bill provides a tax credit for contributions to elementary and secondary schools that benefit science, technology, engineering, and mathematics education. The credit is equal to 100% of qualified STEM contributions made by taxpayers during the taxable year. Qualified STEM contributions include: (1) STEM school contributions, (2) STEM teacher externship expenses, and (3) STEM teacher training expenses. The bill also provides a tax credit for contributions to elementary and secondary schools that benefit science, technology, engineering, or mathematics education. The credit is equal to 100% of qualified STEM service contributions made by taxpayers during the taxable year. Qualified STEM service contributions include: (1) STEM service contributions paid or incurred during the taxable year for services provided in the United States or on a military base outside the United States; and (2) STEM inventory property contributed during the taxable year which is used by an educational organization located in the United States or on a military base outside the United States in providing education in grades K-12 in science, technology, engineering or mathematics.

You may refer to a subset containing summary results of few more US bills and their performance with Zero-Shot and Fine-tune approaches [here](https://github.com/ajayc-ms/azureopenai/blob/9706c2f198ba191f83128a257f162bc735eb152a/notebooks/SemanticSearch_Summarization/SME_Summarization_Dataset_Appendix.md).

#### Fine-tune observations

Overall, the fine-tuned model does an excellent job in summarizing the bill. It captures the domain specific jargon and can capture the key points, that is represented but not explained in the human-written ground truth. It differentiates itself from the Zero-Shot model by providing a more detailed and comprehensive summary.

#### Zero-Shot Summary of Summaries

A key consideration while writing prompts is that GPT-3 prompt and the resulting completion must add up to fewer than 4000 tokens. Due to this, we are limited to a couple of pages of text for summarization. Therefore, for documents which are typically greater than 4000 tokens (roughly 3000 words), we will use a Summary of Summaries approach. In this case, the entire text is first chunked up based on the token constraints, then their corresponding summaries are derived and in the next step, the summary of summaries are created. We will now demonstrate the summary of summaries approach using a Zero-Shot model. This architecture is useful for long documents. Additionally, we will identify how different prompt engineering practices can vary the results.

### Use case 2: Financial Reports

This is a use case where Zero-Shot prompt engineering is used for creating the summary of financial reports. The prompt is modified and the Summary of Summaries approach is used to generate different summarization outputs.

#### Dataset

The dataset used for this use case is technical and includes key quantitative metrics to assess company performance.

The financial dataset includes:
- url: URL for the financial report
- pages: the page in the report with key information to be summarized (1 - indexed)
- completion: ground truth summary of report
- comments: any additional information needed.

The example from the dataset that we will focus on is [Rathbone's financial report](). Rathbone's is an individual investment and wealth management company for private clients. This report highlights Rathbone's performance in the 2020 calendar year, and mentions performance metrics such as profit, FUMA, and income. The key information we aim to summarize can be found on page 1 of the PDF.

```python
API_KEY = # SET YOUR OWN API KEY HERE
RESOURCE_ENDPOINT = "# SET A LINK TO YOUR RESOURCE ENDPOINT" 

openai.api_type = "azure"
openai.api_key = API_KEY
openai.api_base = RESOURCE_ENDPOINT
openai.api_version = "2022-12-01-preview"
name = os.path.abspath(os.path.join(os.getcwd(), '---INSERT PATH OF LOCALLY DOWNLOADED RATHBONES_2020_PRELIM_RESULTS---')).replace('\\', '/')

pages_to_summarize = [0]
# Using pdfminer.six ot extract the text 
# !pip install pdfminer.six
from pdfminer.high_level import extract_text
t = extract_text(name
, page_numbers=pages_to_summarize
)
print("Text extracted from " + name)
t

openai.api_version = "2022-12-01-preview"
name = os.path.abspath(os.path.join(os.getcwd(), '---INSERT PATH OF LOCALLY DOWNLOADED RATHBONES_2020_PRELIM_RESULTS---')).replace('\\', '/')

pages_to_summarize = [0]
# Using pdfminer.six ot extract the text 
# !pip install pdfminer.six
from pdfminer.high_level import extract_text
t = extract_text(name
, page_numbers=pages_to_summarize
)

print("Text extracted from " + name)
t
```

##### Zero-Shot approach

A Zero-Shot example gets zero solved examples. We only provide it with the command and the unsolved input. We will use the Instruct model that has specifically been created to take in an instruction and record an answer for it without an extra context, ideal for Zero-Shot.

Now that we have extracted the text, let's walk through the progression of prompt engineering to see how it can affect the summary quality.

```python
#Using the text above from the Rathbone's report, we can try different prompts to see how it impacts the summary

prompt_i = 'Summarize the key financial information in the report using qualitative metrics.\n\nText:\n'+" ".join([normalize_text(t)])+'\n\nKey metrics:\n'

response = openai.Completion.create(
        engine="davinci-instruct",
        prompt = prompt_i,
        temperature = 0,
        max_tokens = 2048-int(len(prompt_i.split())*1.5),
        top_p = 1.0,
        frequency_penalty=0.5,
        presence_penalty = 0.5,
        best_of = 1
    )
print(response.choices[0].text)
>>>
- Funds under management and administration (FUMA) reached £54.7 billion at 31 December 2020, up 8.5% from £50.4 billion at 31 December 2019
- Operating income totalled £366.1 million, 5.2% ahead of the prior year (2019: £348.1 million)
- Underlying1 profit before tax totalled £92.5 million, an increase of 4.3% (2019: £88.7 million); underlying operating margin of 25.3% (2019: 25.5%)

#Different prompt

prompt_i = 'Extract most significant money related values of financial performance of the business like revenue, profit, etc. from the below text in about two hundred words.\n\nText:\n'+" ".join([normalize_text(t)])+'\n\nKey metrics:\n'

response = openai.Completion.create(
        engine="davinci-instruct",
        prompt = prompt_i,
        temperature = 0,
        max_tokens = 2048-int(len(prompt_i.split())*1.5),
        top_p = 1.0,
        frequency_penalty=0.5,
        presence_penalty = 0.5,
        best_of = 1
    )
print(response.choices[0].text)
>>>
- Funds under management and administration (FUMA) grew by 8.5% to reach £54.7 billion at 31 December 2020
- Underlying profit before tax increased by 4.3% to £92.5 million, delivering an underlying operating margin of 25.3%
- The board is announcing a final 2020 dividend of 47 pence per share, which brings the total dividend to 72 pence per share, an increase of 2.9% over 2019
```

##### Challenges

1.	As we can see the model may come up with ghost metrics (never mentioned in the original text).
Proposed solution: This can be changed by altering the prompt.
2.	The summary may narrow on one section of the article, neglecting other important information.

    Proposed solution: We can try a summary of summaries approach. We will chunk the report into sections and gather smaller summaries that will be summarized together to form the output summary.

Let us check how implementing the above proposed solutions affect the result.

```python
# Body of function

from pdfminer.high_level import extract_text
    
text = extract_text(name
, page_numbers=pages_to_summarize
)

r = splitter(200, text)

tok_l = int(2000/len(r))
tok_l_w = num2words(tok_l)

res_lis = []
# Stage 1: Summaries
for i in range(len(r)):
    prompt_i = f'Extract and summarize the key financial numbers and percentages mentioned in the Text in less than {tok_l_w} 
words.\n\nText:\n'+normalize_text(r[i])+'\n\nSummary in one paragraph:'
    response = openai.Completion.create(
        engine=TEXT_DAVINCI_001,
    prompt_i = f'Extract and summarize the key financial numbers and percentages mentioned in the Text in less than {tok_l_w}
words.\n\nText:\n'+normalize_text(r[i])+'\n\nSummary in one paragraph:'
    response = openai.Completion.create(
        engine=TEXT_DAVINCI_001,
    prompt_i = f'Extract and summarize the key financial numbers and percentages mentioned in the Text in less than {tok_l_w}
words.\n\nText:\n'+normalize_text(r[i])+'\n\nSummary in one paragraph:'

    response = openai.Completion.create(
        engine=TEXT_DAVINCI_001,
        prompt = prompt_i,
        temperature = 0,
        max_tokens = tok_l,
        top_p = 1.0,
        frequency_penalty=0.5,
        presence_penalty = 0.5,
        best_of = 1
    )
    t = response.choices[0].text
        t = trim_incomplete(t)
res_lis.append(t)

# Stage 2: Summary of summaries
prompt_i = 'Summarize the financial performance of the business like revenue, profit, etc. in less than one hundred words. Do not make up values that are not mentioned in the Text.\n\nText:\n'+" ".join([normalize_text(res) for res in res_lis])+'\n\nSummary:\n'

response = openai.Completion.create(
        engine=TEXT_DAVINCI_001,
        prompt = prompt_i,
        temperature = 0,
        max_tokens = 200,
        top_p = 1.0,
        frequency_penalty=0.5,
        presence_penalty = 0.5,
        best_of = 1
)

print(trim_incomplete(response.choices[0].text))
```

The input prompt includes the original text scraped from Rathbone’s financial report for a specific year.

**Ground Truth:** Rathbones has reported revenue of £366.1m in 2020, up from £348.1m in 2019, and an increase in underlying profit before tax to £92.5m from £88.7m. Assets under management rose 8.5% from £50.4bn to £54.7bn, with assets in wealth management increasing 4.4% to £44.9bn. Net inflows were £2.1bn in 2020 compared with £600m in the previous year, driven primarily by £1.5bn inflows into its funds business and £400m due to the transfer of assets from Barclays Wealth.

**Zero-Shot summary of summaries model summary:** Rathbones delivered a strong performance in 2020, with funds under management and administration (FUMA) growing by 8.5% to reach £54.7 billion at the end of the year. Underlying profit before tax increased by 4.3% to £92.5 million, delivering an underlying operating margin of 25.3%. Total net inflows across the group were £2.1 billion, representing a growth rate of 4.2%. Profit before tax for the year was £43.8 million, with basic earnings per share totalling 49.6p. Operating income for the year was 5.2% ahead of the prior year, totalling £366.1 million.

##### Zero-Shot Summary of Summaries observations

The summary of summaries approach has generated a great result set and has overcome the challenges faced initially by providing a more detailed and comprehensive summary. It does a great job at capturing the domain-specific jargon and the key points, which has represented in the Ground Truth but not explained that well.

The Zero-Shot model works well for summarizing documents general in nature. If the data is industry- or topic-specific, containing industry specific jargons or needs industry specific understanding, then fine-tuning will perform the best. Documents such as medical journals, law forms, financial statements, etc., would qualify for such a use case. We use Few-Shot versus Zero-Shot to provide the model examples on how to formulate its summary, so it can learn to mimic the instructions provided. With Few-Shot, we are guiding the model on how to respond without retraining the model. However, for Zero-Shot and Few-Shot, we are not retraining the model. Therefore, its knowledge is based on what the GPT-3 models were trained on (which is most of the internet) and can perform well on tasks that do not require specific knowledge.

You may refer to a subset of results achieved using the Zero-Shot Summary of Summaries approach applied on the financial dataset [here]().

## Conclusions

There are many ways to approach summarization utilizing GPT-3. Each approach (Zero-Shot, Few-Shot, Fine-tuning) produces a different quality of summary. Based on your use case, you can explore which type of summary produces the best results for your intended use case.

### Recommendations

However, based on observations from our exploration, here are few recommendations that you can follow:
- **Zero-Shot** is best for documents that are general in nature and do not require specific domain knowledge. It will try to capture all the high-level information in a very succinct human-like manner and will provide a high-quality baseline summary. This approach resulted in high quality summary for the legal dataset used in this article.
- **Few-shot** proves difficult for long document summarization because providing an example text will surpass the token limitation. To combat this, a Zero-Shot summary of summaries approach can be used for long documents or increasing the dataset to enable successful fine-tuning. This approach generated excellent result for the financial dataset used in this article.
- **Fine-tuning** is most useful for technical or domain specific use cases where the information is not readily available. This requires a dataset of a couple thousand samples for the best results. Fine-tuning will capture the summary in a few templated ways, trying to conform to how the dataset presents the summaries. This approach generated a much higher quality summary than the Zero-Shot result for the legal dataset.

### Evaluating Summarization

There are multiple techniques to evaluate the performance of summarization models.

Here are some methods: 

**ROUGE (Recall-Oriented Understudy for Gisting Evaluation)** It includes measures to automatically determine the quality of a summary by comparing it to other (ideal) summaries created by humans. The measures count the number of overlapping units such as n-gram, word sequences, and word pairs between the computer-generated summary to be evaluated and the ideal summaries created by humans. 

```
reference_summary = "The cat ison porch by the tree"
generated_summary = "The cat is by the tree on the porch"
rouge = Rouge()
rouge.get_scores(generated_summary, reference_summary)
[{'rouge-1': {'r':1.0, 'p': 1.0, 'f': 0.999999995},
  'rouge-2': {'r': 0.5714285714285714, 'p': 0.5, 'f': 0.5333333283555556},
  'rouge-1': {'r': 0.75, 'p': 0.75, 'f': 0.749999995}}]
```

Figure 2: Rouge score example

**BertScore** (Zhang et al., 2020) computes similarity scores by aligning generated and reference summaries on a token-level. Token alignments are computed greedily to maximize the cosine similarity between contextualized token embeddings from BERT.

```
  import torchmetrics
  from torchmetrics.text.bert import BERTScore
  preds = "You should have ice cream in the summer"
  target = "Ice creams are great when the weather is hot"
  bertscore = BERTScore()
  score = bertscore(preds, target)
  print(score)
```

Figure 3: BERT score example

**Similarity Matrix** is a representation of the similarities between different entities in summarization evaluation. It is used to compare different summaries of the same text and measure their similarity and is represented by a two-dimensional grid, where each cell contains a measure of the similarity between two summaries. The similarity can be measured using a variety of methods, such as cosine similarity, Jaccard similarity, and edit distance. The matrix is then used to compare the summaries and determine which summary is the most accurate representation of the original text.

Following is a sample command to get the similarity matrix of BertScore comparing 2 similar sentences. 

```
bert-score-show --lang en -r "The cat is on the porch by the tree"
                          -c "The cat is by the tree on the porch"
                          -f out.png
```

The first sentence “The cat is on the porch by the tree” is referred as the candidate and the second one “The cat is by the tree on the porch” is referred as the reference and the command is using BertScore to compare both sentences for generating the matrix. 

Figure 4 is a similarity matrix example, which displays the output matrix generated by above command.

image 

Figure 4: Similarity matrix example

For a more comprehensive list and unified metrics in Pypi package, please refer to the following paper: https://direct.mit.edu/tacl/article/doi/10.1162/tacl_a_00373/100686/SummEval-Re-evaluating-Summarization-Evaluation and 
https://pypi.org/project/summ-eval/ 

## Contributors

## Next steps

- Azure OpenAI - Documentation, quickstarts, API reference - Azure Cognitive Services | Microsoft Learn
- What are intents in LUIS - Azure Cognitive Services | Microsoft Learn
- Conversational Language Understanding - Azure Cognitive Services | Microsoft Learn
- Jupyter notebook with technical details and execution of this use case can be found at: openai-solutions/SummarizationOverview.md at main · Azure/openai-solutions (github.com)
