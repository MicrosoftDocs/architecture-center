


[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

The QnA Maker tool makes it easy for the content owners to maintain their knowledge base of Questions and Answers. Combined with Bot Service and Language Understanding, it becomes simple to setup a FAQ chatbot which responds from different knowledge bases depending on the intent of the query.

## Architecture

![Architecture diagram](../media/faq-chatbot-with-data-champion-model.png)
*Download an [SVG](../media/faq-chatbot-with-data-champion-model.svg) of this architecture.*

## Data Flow

1. Employee access FAQ Bot
1. Azure Active Director validates the employee's identity
1. Query is send to a LUIS model to get the intent of the query
1. Based in the intent, the query is redirected to the appropriate Knowledge base
1. QnA Maker gives the best match to the incoming query
1. The result is shown to the employee
1. Data Champions manage and update their QnA Knowledge base based on the feedback from user traffic
