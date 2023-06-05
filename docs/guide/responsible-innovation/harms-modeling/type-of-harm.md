---
title: Types of harm
titleSuffix: Azure Application Architecture Guide
description: Know the different types of harms and how to mitigate them. Categories include risk of injury, denial of consequential services, and human rights infringement.
author: dcass
ms.reviewer: tozimmergren
categories: azure
ms.date: 01/19/2023
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: guide
products:
  - azure-devops
ms.category:
  - fcp
ms.custom:
  - guide
  - engagement-fy23
---

# Types of harm

This article creates awareness of the different types of harm, so that appropriate mitigation steps can be implemented.

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

## Evaluate harms

Once you've generated a broad list of potential harms, you should complete your Harms Model by evaluating the potential magnitude for each harm category. This will allow you to prioritize your areas of focus. See the following example harms model for reference:

|Contributing factor   |Definition       |
|----------------------|-----------------|
|Severity        |How acutely could the technology impact an individual or group's well-being?        |
|Scale           |How broadly could the impact on well-being be experienced across populations or groups?    |
|Probability     |How likely is the technology to impact individual or group's well-being? |
|Frequency       |How often would an individual or group experience an impact on their well-being from the technology? |

## Next Steps

Use the Harms Model you developed to guide your product development work:

- Seek more information from stakeholders that you identified as potentially experiencing harm.
- Develop and validate the hypothesis for addressing the areas you identified as having the highest potential for harm.
- Integrate the insights into your decisions throughout the technology development process: data collection and model training, system architecture, user experience design, product documentation, feedback loops, and communication capabilities and limitations of the technology.
- Explore [Community Jury](../community-jury/index.md).
- Assess and mitigate unfairness using Azure Machine Learning and the open-source [FairLearn package](/azure/machine-learning/concept-fairness-ml).

Other Responsible AI tools:

- [Responsible AI resource center](https://www.microsoft.com/ai/responsible-ai-resources?activetab=pivot1%3aprimaryr4)
- [Guidelines for Human AI interaction](https://www.microsoft.com/en-us/research/project/guidelines-for-human-ai-interaction/)
- [Conversational AI guidelines](https://www.microsoft.com/en-us/research/publication/responsible-bots/)
- [Inclusive Design guidelines](https://www.microsoft.com/design/inclusive/)
- [AI Fairness checklist](https://www.microsoft.com/en-us/research/publication/co-designing-checklists-to-understand-organizational-challenges-and-opportunities-around-fairness-in-ai/)

Additional references:

- [Downloadable booklet for assessing harms](https://download.microsoft.com/download/d/f/9/df99822c-0b98-4e39-803a-fcd00f1cae56/AssessingHarmsBooklet.pdf)
- [Value Sensitive Design](https://vsdesign.org/)
