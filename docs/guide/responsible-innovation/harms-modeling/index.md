---
title: Harms modeling
titleSuffix: Azure Application Architecture Guide
description: This article describes how to figure out harms and negative impact of a technology and ways to mitigate them.
author: RobBagby
ms.author: robbag
categories: azure
ms.date: 05/18/2020
ms.topic: conceptual
ms.service: azure-architecture-center
ms.subservice: architecture-guide
ms.category:
  - fcp
products:
  - office-word
ms.custom:
  - guide
---

# Foundations of assessing harm

Harms Modeling is a practice designed to help you anticipate the potential for harm, identify gaps in product that could put people at risk, and ultimately create approaches that proactively address harm.

## Why harms modeling?

This guidance is for architects who design algorithm-driven systems, such as custom-coded decision-making frameworks. It also applies to outsourced decision-making processes, such as processes that involve AI or machine learning models.

As technology builders, your work is global. To design algorithm-driven systems to be trustworthy, you need to create solutions that reflect ethical principles that are deeply rooted in important and timeless values. During the design and development process, it's essential to evaluate not only ideal outcomes but also possible negative outcomes, also known as *harms*. These harms can occur in any decision-making architecture that doesn't involve humans.

For guidance that's specific to Responsible AI, see [Responsible AI principles and approach](/ai/principles-and-approach).

## Human understanding

In addition to appreciating the importance of human rights, building trustworthy systems requires us to consider many people's perspectives. Asking who the stakeholders are, what they value, how they could benefit, and how they could be hurt by our technology, is a powerful step that allows us to design and build better products.

### Who does the technology impact?

#### Who are the customers?

- What do they value?
- How should they benefit?
- How could tech harm them?

#### Who are the non-customer stakeholders?

- What do they value?
- How should they benefit?
- How could tech harm them?

Ask these questions to get a better understanding of what's important to stakeholders and how those aspects play into their relationship with the product.

## Types of harm

The following table describes different types of harm that you might encounter. The list includes a diverse range of harms that can affect people in different scenarios, but it isn't exhaustive. Your scenario might involve other types of harms that aren't listed.

## Risk of injury

### Physical injury

Consider how technology could hurt people or create dangerous environments.

> |Harm|Description|Consideration(s)|Example|
> |-------------|----------|---------|---------|
> |**Overreliance on safety features**|This points out the dependence on technology to make decisions without adequate human oversight.|How might people rely on this technology to keep them safe? How could this technology reduce appropriate human oversight?|A healthcare agent could misdiagnose illness, leading to unnecessary treatment.|
> |**Inadequate fail-safes**|Real-world testing may insufficiently consider a diverse set of users and scenarios.|If this technology fails or is misused, how would people be impacted? At what point could a human intervene? Are there alternative uses that have not been tested for? How would a system failure impact users?|If an automatic door failed to detect a wheelchair during an emergency evacuation, a person could be trapped if there isn't an accessible override button.|
> |**Exposure to unhealthy agents**|Manufacturing, as well as disposal of technology, can jeopardize the health and well-being of workers and nearby inhabitants.|What negative outcomes could come from the manufacturing of your components or devices?|Inadequate safety measures could expose workers to toxins during digital component manufacturing.|

### Emotional or psychological injury

Misused technology can lead to severe emotional and psychological distress.

> |Harm|Description|Consideration(s)|Example|
> |-------------|----------|---------|---------|
> |**Overreliance on automation**|Misguided beliefs can lead users to trust the reliability of a digital agent over that of a human.|How could this technology reduce direct interpersonal feedback? How might this technology interface with trusted sources of information? How could sole dependence on an artificial agent impact a person?|A chatbot could be relied upon for relationship advice or mental health counseling instead of a trained professional.|
> |**Distortion of reality or gaslighting**|When intentionally misused, technology can undermine trust and distort someone's sense of reality.|Could this be used to modify digital media or physical environments?|An IoT device could enable monitoring and controlling of an ex-intimate partner from afar.|
> |**Reduced self-esteem/reputation damage**|Some shared content can be harmful, false, misleading, or denigrating.|How could this technology be used to share personal information inappropriately? How could it be manipulated to misuse information and misrepresent people?|Synthetic media "revenge porn" can swap faces, creating the illusion of a person participating in a video who did not.|
> |**Addiction/attention hijacking**|Technology could be designed for prolonged interaction, without regard for well-being.|In what ways might this technology reward or encourage continued interaction beyond delivering user value?|Variable drop rates in video game loot boxes could cause players to keep playing and neglect self-care.|
> |**Identity theft**|Identity theft may lead to loss of control over personal credentials, reputation, and representation.|How might an individual be impersonated with this technology? How might this technology mistakenly recognize the wrong individual as an authentic user?|Synthetic voice font could mimic the sound of a person's voice and be used to access a bank account.|
> |**Misattribution**|This includes crediting a person with an action or content they are not responsible for.|In what ways might this technology attribute an action to an individual or group? How could someone be affected if an action was incorrectly attributed to them?|Facial recognition can misidentify an individual during a police investigation.|

## Denial of consequential services

### Opportunity loss

Automated decisions could limit access to resources, services, and opportunities essential to well-being.

> |Harm|Description|Consideration(s)|Example|
> |-------------|----------|---------|---------|
> |**Employment discrimination**|Some people may be denied access to apply for or secure a job based on characteristics unrelated to merit.|Are there ways in which this technology could impact recommendations or decisions related to employment?|Hiring AI could recommend fewer candidates with female-sounding names for interviews.|
> |**Housing discrimination**|This includes denying people access to housing or the ability to apply for housing.|How could this technology impact recommendations or decisions related to housing?|Public housing queuing algorithm could cause people with international-sounding names to waiting longer for vouchers.|
> |**Insurance and benefit discrimination**|This includes denying people insurance, social assistance, or access to a medical trial due to biased standards.|Could this technology be used to determine access, cost, allocation of insurance or social benefits?|Insurance company might charge higher rates for drivers working night shifts due to algorithmic predictions suggesting increased drunk driving risk.|
> |**Educational discrimination**|Access to education may be denied because of an unchangeable characteristic.|How might this technology be used to determine access, cost, accommodations, or other outcomes related to education?|Emotion classifier could incorrectly report that students of color are less engaged than their white counterparts, leading to lower grades.|
> |**Digital divide/technological discrimination**|Disproportionate access to the benefits of technology may leave some people less informed or equipped to participate in society.|What prerequisite skills, equipment, or connectivity are necessary to get the most out of this technology? What might be the impact of select people gaining earlier access to this technology than others, in terms of equipment, connectivity, or other product functionality?|Content throttling could prevent rural students from accessing classroom instruction video feeds.|
> |**Loss of choice/network and filter bubble**|Presenting people with only information that conforms to and reinforces their beliefs.|How might this technology affect the choices and information available to people? What past behaviors or preferences might this technology rely on to predict future behaviors or preferences?|News feed could only present information that confirms existing beliefs.|

### Economic loss

Automating decisions related to financial instruments, economic opportunity, and resources can amplify existing societal inequities and obstruct well-being.

> |Harm|Description|Consideration(s)|Example|
> |-------------|----------|---------|---------|
> |**Credit discrimination**|People may be denied access to financial instruments based on characteristics unrelated to economic merit.|How might this technology rely on existing credit structures to make decisions? How might this technology affect the ability of an individual or group to obtain or maintain a credit score?|Higher introductory rate offers could be sent only to homes in lower socioeconomic postal codes.|
> |**Differential pricing of goods and services**|Goods or services may be offered at different prices for reasons unrelated to the cost of production or delivery.|How could this technology be used to determine the pricing of goods or services? What are the criteria for determining the cost to people for the use of this tech?|More could be charged for products based on designation for men or women.|
> |**Economic exploitation**|People might be compelled or misled to work on something that impacts their dignity or well-being.| What role did human labor play in producing training data for this technology? How was this workforce acquired? What role does human labor play in supporting this technology? Where is this workforce expected to come from?|Paying financially destitute people for their biometric data to train AI systems.|
> |**Devaluation of individual expertise**|Technology may supplant the use of paid human expertise or labor.|How might this technology impact the need to employ an existing workforce?|AI agents replace doctors/radiographers for evaluation of medical imaging.|

## Infringement on human rights

### Dignity loss

Technology can influence how people perceive the world and recognize, engage, and value one another. The exchange of honor and respect between people can be interfered with.

> |Harm|Description|Consideration(s)|Example|
> |-------------|----------|---------|---------|
> |**Dehumanization**|Removing, reducing, or obscuring the visibility of a person's humanity.|How might this technology be used to simplify or abstract the way a person is represented? How might this technology reduce the distinction between humans and the digital world?|Entity recognition and virtual overlays in drone surveillance could reduce the perceived accountability of human actions.|
> |**Public shaming**|This may mean exposing people's private, sensitive, or socially inappropriate material.|How might movements or actions be revealed through data aggregation?|A fitness app could reveal a user's GPS location on social media, indicating attendance at an Alcoholics Anonymous meeting.|

### Liberty loss

Automating legal, judicial, and social systems can reinforce biases and lead to detrimental consequences.

> |Harm|Description|Consideration(s)|Example|
> |-------------|----------|---------|---------|
> |**Predictive policing**|Inferring suspicious behavior or criminal intent based on historical records.|How could this support or replace human policing or criminal justice decision-making?|An algorithm can predict several area arrests, so police make sure they match or exceed that number.|
> |**Social control**|Conformity may be reinforced or encouraged by publicly designating human behaviors as positive or negative.|What types of personal or behavioral data might feed this technology? How would it be obtained? What outputs would be derived from this data? Is this technology likely to be used to encourage or discourage certain behaviors?|Authoritarian government uses social media and e-commerce data to determine a "trustworthy" score based on where people shop and whom they spend time with.|
> |**Loss of effective remedy**|This means an inability to explain the rationale or lack of opportunity to contest a decision.|How might people understand the reasoning for decisions made by this technology? How might an individual relying on this technology explain its decisions? How could people contest or question a decision this technology makes?|Automated prison sentence or pre-trial release decision is not explained to the accused.|

### Privacy loss

The information generated by our use of technology can be used to determine facts or make assumptions about someone without their knowledge.

> |Harm|Description|Consideration(s)|Example|
> |-------------|----------|---------|---------|
> |**Interference with private life**|Revealing information a person has not chosen to share.|How could this technology use information to infer portions of private life? How could decisions based upon these inferences expose things that a person does not want made public?|Task-tracking AI could monitor personal patterns from which it infers an extramarital affair.|
> |**Forced association**|Requiring participation in the use of technology or surveillance to take part in society.|How might the use of this technology be required for participation in society or organization membership?|Biometric enrollment in a company's meeting room transcription AI is a stipulated requirement in the job offer letter.|
> |**Inability to freely and fully develop personality**|This may mean restriction of one's ability to truthfully express themselves or explore external avenues for self-development.|In what way does the system or product ascribe positive vs. negative connotations toward particular personality traits? How can using the product or system reveal information to entities such as the government or employer that inhibits free expression?|Intelligent meeting system could record all discussions between colleagues, including personal coaching and mentorship sessions.|
> |**Never forgiven**|Digital files or records may never be deleted.|What and where is data being stored from this product, and who can access it? How long is user data stored after technology interaction? How is user data updated or deleted?|A teenager's social media history could remain searchable long after they have outgrown the platform.|
> |**Loss of freedom of movement or assembly**|This means an inability to navigate the physical or virtual world with desired anonymity.|In what ways might this technology monitor people across physical and virtual space?|A real name could be required to sign up for a video game enabling real-world stalking.|

### Environmental impact

The environment can be impacted by every decision in a system or product life cycle, from the amount of cloud computing needed to retail packaging. Environmental changes can affect entire communities.

> |Harm|Description|Consideration(s)|Example|
> |-------------|----------|---------|---------|
> |**Exploitation or depletion of resources**|Obtaining the raw materials for technology, including how it's powered, leads to negative consequences to the environment and its inhabitants.|What materials are needed to build or run this technology? What energy requirements are needed to build or run this technology?|A local community could be displaced due to harvesting rare earth minerals and metals required for some electronic manufacturing.|
> |**Electronic waste**|Reduced quality of collective well-being because of the inability to repair, recycle, or otherwise responsibly dispose of electronics.|How might this technology reduce electronic waste by recycling materials or allowing users to self-repair? How might this technology contribute to electronic waste when new versions are released or when current/past versions stop working?|Toxic materials inside discarded electronic devices could leach into the water supply, making local populations ill.|
> |**Carbon emissions**|Running cloud solutions that are not optimized can lead to unnecessary carbon emissions and electricity waste, causing harm to the climate.|Do you have insights into how optimized your cloud workloads and solutions are? What impact does your solution have on the climate, and does it differ based on the region where you deploy your workloads?|Running solutions that are not optimized or properly designed for cloud efficiency can lead to a heavier toll on the climate, causing unnecessary carbon emissions and electricity waste.|

## Erosion of social & democratic structures

### Manipulation

Technology's ability to create highly personalized and manipulative experiences can undermine an informed citizenry and trust in societal structures.

> |Harm|Description|Consideration(s)|Example|
> |-------------|----------|---------|---------|
> |**Misinformation**|Disguising fake information as legitimate or credible information.|How might this technology be used to generate misinformation? How could it be used to spread credible misinformation?|Generation of synthetic speech of a political leader sways an election.|
> |**Behavioral exploitation**|This means exploiting personal preferences or patterns of behavior to induce a desired reaction.|How might this technology be used to observe behavior patterns? How could this technology be used to encourage dysfunctional or maladaptive behaviors?|Monitoring shopping habits in the connected retail environment leads to personalized incentives for impulse shoppers and hoarders.|

### Social detriment

At scale, the way technology impacts people shape social and economic structures within communities. It can further ingrain elements that include or benefit some while excluding others.

> |Harm|Description|Consideration(s)|Example|
> |-------------|----------|---------|---------|
> |**Amplification of power inequality**|This may perpetuate existing class or privilege disparities.|How might this technology be used in contexts where there are existing social, economic or class disparities? How might people with more power or privilege disproportionately influence the technology?|Requiring a residential address & phone number to register on a job website could prevent a homeless person from applying.|
> |**Stereotype reinforcement**|This may perpetuate uninformed "conventional wisdom" about historically or statistically underrepresented people.|How might this technology be used to reinforce or amplify existing social norms or cultural stereotypes? How might the data used by this technology cause it to reflect biases or stereotypes?|Results of an image search for "CEO" could primarily show photos of Caucasian men.|
> |**Loss of individuality**|This may be an inability to express a unique perspective.|How might this technology amplify majority opinions or "group-think"? Conversely, how might unique forms of expression be suppressed? In what ways might the data gathered by this technology be used in feedback to people?|Limited customization options in designing a video game avatar inhibit self-expression of a player's diversity.|
> |**Loss of representation**|Broad categories of generalization obscure, diminish, or erase real identities.|How could this technology constrain identity options? Could it be used to label or categorize people automatically?|Automatic photo caption assigns incorrect gender identity and age to the subject.|
> |**Skill degradation and complacency**|Overreliance on automation lead to atrophy of manual skills.|In what ways might this technology reduce the accessibility and ability to use manual controls?|Overreliance on automation could lead to an inability to gauge the airplane's true orientation because the pilots have been trained to rely on instruments only.|

## Define harms that are specific to your workloads

Use the categories, questions, and examples to generate specific ideas for how harm could occur. Adapt and adopt additional categories that are relevant to you.

- Intended use: If [feature] was used for [use case], then [stakeholder] could experience [harm description].

- Unintended use: If [user] tried to use [feature] for [use case], then [stakeholder] could experience [harm description].
- System error: If [feature] failed to function properly when used for [use case], then [stakeholder] could experience [harm description].
- Misuse: [Malicious actor] could potentially use [feature], to cause [harm description] to [stakeholder].

## Evaluate harms

Once you've generated a broad list of potential harms, you should complete your Harms Model by evaluating the potential magnitude for each harm category. This will allow you to prioritize your areas of focus. See the following example harms model for reference:

|Contributing factor   |Definition       |
|----------------------|-----------------|
|Severity        |How acutely could the technology impact an individual or group's well-being?        |
|Scale           |How broadly could the impact on well-being be experienced across populations or groups?    |
|Probability     |How likely is the technology to impact individual or group's well-being? |
|Frequency       |How often would an individual or group experience an impact on their well-being from the technology? |

## Transparency documents

Some services provide [transparency documents](https://www.microsoft.com/ai/principles-and-approach#transparency-report). Transparency documents provide insights into how the service operates, its capabilities, limitations, and ethical considerations. You can review these documents to understand the inner workings of a service and help ensure responsible use.
 
When you build solutions on Azure, read through any transparency documents that your service offers. Factor in how those solutions align with your workload's harms modeling. Consider whether the service's functionalities and limitations introduce or mitigate risks in your specific use case.

## Next steps

- [Microsoft Inclusive Design](https://inclusive.microsoft.design/)

See relevant articles about Responsible AI:

- [Responsible AI in Azure workloads](/azure/well-architected/ai/responsible-ai)
- [What is Responsible AI?](/azure/machine-learning/concept-responsible-ai)




