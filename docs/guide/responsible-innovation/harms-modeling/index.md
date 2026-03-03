---
title: Foundations of Assessing Harm
description: Learn how to identify potential harms in your workload and create approaches to proactively address harms so that you can build trustworthy systems.
author: claytonsiemens77
ms.author: pnp
ms.date: 04/03/2025
ms.topic: concept-article
ms.subservice: architecture-guide
---

# Foundations of assessing harm

Harms modeling is a practice that helps you anticipate the potential for harm, identify gaps in product that could put people at risk, and ultimately create approaches that proactively address harm.

This guidance is for architects who design algorithm-driven systems, such as custom-coded decision-making frameworks. It also applies to outsourced decision-making processes, such as processes that involve AI or machine learning models.

As technology builders, your work has a global impact. To design trustworthy algorithm-driven systems, you need to create solutions that reflect ethical principles that are rooted in important and timeless human values. During the design and development process, you must evaluate not only ideal outcomes for your users but also possible negative outcomes, known as *harms*. These harms can occur in any decision-making architecture that doesn't involve human oversight.

> [!TIP]
> For guidance that's specific to responsible AI, see [Responsible AI principles and approach](https://www.microsoft.com/ai/principles-and-approach).

## Stakeholder considerations

To build trustworthy systems, recognize and value human rights as a fundamental aspect and consider the perspectives of many people. To design and build better products, you should ask who the stakeholders are, what they value, how they could benefit from your technology, and how they could be hurt by your technology.

Who are the customers for your technology?

- What do they value?
- How should they benefit from your technology?
- How could your technology harm them?

Who are the noncustomer stakeholders?

- What do they value?
- How should they benefit from your technology?
- How could your technology harm them?

Ask these questions to get a better understanding of what's important to stakeholders and how those aspects influence their relationship with the product.

## Types of harm

The following tables describe various types of harm that technology users might encounter. They include a diverse range of harms that can affect people in different scenarios, but it isn't exhaustive. Your workload might have the potential to lead to other types of harms that aren't listed.

### Risk of injury

#### Physical injury

Consider how technology might hurt people or create dangerous environments.

|Harm|Description|Considerations|Example|
|-------------|----------|---------|---------|
|**Overreliance on safety features**|A dependence on technology to make decisions without adequate human oversight.|How might people rely on this technology to keep them safe? <br><br> How could this technology reduce appropriate human oversight?|A healthcare agent misdiagnoses illness, which leads to unnecessary treatment.|
|**Inadequate fail-safes**|Real-world testing doesn't cover a diverse set of users and scenarios.|If this technology fails or is misused, how does it affect people? <br><br> At what point could a human intervene? <br><br> Are there alternative uses that you haven't tested? <br><br> How does a system failure affect users?|An automatic door doesn't detect a wheelchair during an emergency evacuation, so a person is trapped if there isn't an accessible override button.|
|**Exposure to unhealthy agents**|Manufacturing, as well as disposal of technology, jeopardizes the health and well-being of workers and nearby inhabitants.|What negative outcomes could arise from the manufacturing of your components or devices?|Inadequate safety measures expose workers to toxins during digital component manufacturing.|

#### Emotional or psychological injury

Misused technology can lead to severe emotional and psychological distress.

|Harm|Description|Considerations|Example|
|-------------|----------|---------|---------|
|**Overreliance on automation**|Misguided beliefs lead users to trust the reliability of a digital agent over a human.|How could this technology reduce direct interpersonal feedback? <br><br> How might this technology interface with trusted sources of information? <br><br> How could sole dependence on an artificial agent affect a person?|A person relies on a chatbot for relationship advice or mental health counseling instead of a trained professional.|
|**Distortion of reality or gaslighting**| Technology is intentionally misused to undermine trust and distort someone's sense of reality.|Could this technology be used to modify digital media or physical environments?|An IoT device enables monitoring and controlling of an ex-intimate partner from afar.|
|**Reduced self-esteem or reputation damage**|Shared content that's harmful, false, misleading, or denigrating.|How could this technology be used to share personal information inappropriately? <br><br> How could it be manipulated to misuse information and misrepresent people?|Synthetic media "revenge porn" swaps faces, which creates the illusion of a person participating in a video.|
|**Addiction or attention hijacking**|Technology that's designed for prolonged interaction, without regard for well-being.|How might this technology reward or encourage continued interaction beyond delivering user value?|Variable drop rates in video game loot boxes cause players to keep playing and neglect self-care.|
|**Identity theft**|Identity theft might lead to loss of control over personal credentials, reputation, and representation.|How might an individual be impersonated with this technology? <br><br> How might this technology mistakenly recognize the wrong individual as an authentic user?|Synthetic voice font mimics the sound of a person's voice and is used to access a bank account.|
|**Misattribution**|Technology credits a person with an action or content that they're not responsible for.|How might this technology attribute an action to an individual or group? <br><br> What impact could an incorrect attribution of an action have on someone? |Facial recognition misidentifies an individual during a police investigation.|

### Denial of consequential services

#### Opportunity loss

Automated decisions can limit access to resources, services, and opportunities that are essential to well-being.

|Harm|Description|Considerations|Example|
|-------------|----------|---------|---------|
|**Employment discrimination**|Some people are denied access to apply for or secure a job based on characteristics that aren't related to merit.|How could this technology affect recommendations or decisions related to employment?|Hiring AI recommends fewer candidates that have female-sounding names for interviews.|
|**Housing discrimination**|Denying people access to housing or the ability to apply for housing.|How could this technology affect recommendations or decisions related to housing?| A public housing queuing algorithm causes people that have international-sounding names to wait longer for vouchers.|
|**Insurance and benefit discrimination**|Denying people insurance, social assistance, or access to a medical trial because of biased standards.|Could this technology be used to determine access, cost, or allocation of insurance or social benefits?|An insurance company charges higher rates for drivers that work night shifts because algorithmic predictions suggest an increased drunk driving risk.|
|**Educational discrimination**|Access to education is denied because of an unchangeable characteristic.|How might this technology be used to determine access, cost, accommodations, or other outcomes related to education?|An emotion classifier incorrectly reports that students of one racial group are less engaged than another racial group, leading to lower grades.|
|**Digital divide or technological discrimination**|Disproportionate access to the benefits of technology leaves some people less informed or equipped to participate in society.|What prerequisite skills, equipment, or connectivity are necessary to get the most out of this technology? <br><br> What could be the consequences of certain individuals gaining early access to this technology, in terms of equipment, connectivity, or other product functionalities?|Content throttling prevents rural students from accessing classroom instruction video feeds.|
|**Loss of choice/network and filter bubble**|Presenting people with only information that conforms to and reinforces their beliefs.|How might this technology affect the choices and information that are available to people? <br><br> What past behaviors or preferences might this technology rely on to predict future behaviors or preferences?|A news feed only presents information that confirms existing beliefs.|

#### Economic loss

Automated decisions that are related to financial instruments, economic opportunity, and resources can amplify existing societal inequities and obstruct well-being.

|Harm|Description|Considerations|Example|
|-------------|----------|---------|---------|
|**Credit discrimination**| Denying people access to financial instruments based on characteristics that are unrelated to economic merit.|How might this technology rely on existing credit structures to make decisions? <br><br> How might this technology affect the ability of an individual or group to obtain or maintain a credit score?|Higher introductory rate offers are sent only to homes in lower socioeconomic postal codes.|
|**Differential pricing of goods and services**|Goods or services are offered at different prices for reasons unrelated to the cost of production or delivery.|How could this technology be used to determine the pricing of goods or services? <br><br> What criteria are used to determine the cost to individuals for using this technology?| Products are offered at a higher price based on a gender determination.|
|**Economic exploitation**|People are compelled or misled to work on something that affects their dignity or well-being.| How does human labor influence the production of training data for this technology? How is this workforce acquired? <br><br> How does human labor support this technology? <br><br> Where is this workforce expected to come from?|Financially destitute people are paid for their biometric data to train AI systems.|
|**Devaluation of individual expertise**|Technology supplants the use of paid human expertise or labor.|How might this technology affect the need to employ an existing workforce?|AI agents replace doctors or radiographers for the evaluation of medical imaging.|

### Infringement on human rights

#### Dignity loss

Technology can influence how people perceive the world and how they recognize, engage, and value one another. Technology can interfere with the exchange of honor and respect between people.

|Harm|Description|Considerations|Example|
|-------------|----------|---------|---------|
|**Dehumanization**|Removing, reducing, or obscuring the visibility of a person's humanity.|How might this technology be used to simplify or abstract the representation of a person? <br><br> How might this technology reduce the distinction between humans and the digital world?|Entity recognition and virtual overlays in drone surveillance reduce the perceived accountability of human actions.|
|**Public shaming**| Exposing people's private, sensitive, or socially inappropriate material.|How might data aggregation reveal an individual's movements or actions?|A fitness app reveals a user's GPS location on social media, which indicates attendance at an Alcoholics Anonymous meeting.|

#### Liberty loss

Automated legal, judicial, and social systems can reinforce biases and lead to detrimental consequences.

|Harm|Description|Considerations|Example|
|-------------|----------|---------|---------|
|**Predictive policing**|Inferring suspicious behavior or criminal intent based on historical records.|How could this technology support or replace human policing or criminal justice decision-making?|An algorithm predicts several area arrests, so police make sure they match or exceed that number.|
|**Social control**|Conformity is reinforced or encouraged by publicly designating human behaviors as positive or negative.|What types of personal or behavioral data feed this technology? How is it obtained? <br><br> What outputs are derived from this data? <br><br> Can this technology be used to encourage or discourage certain behaviors?|Authoritarian government uses social media and e-commerce data to determine a "trustworthy" score based on where people shop and who they spend time with.|
|**Loss of effective remedy**|An inability to explain the rationale or lack of opportunity to contest a decision.|How might people understand the reasoning for this technology's decisions? <br><br> How might an individual that relies on this technology explain its decisions? <br><br> How could people contest or question a decision that this technology makes?|An automated prison sentence or pre-trial release decision isn't explained to the accused person.|

#### Privacy loss

The information that technology generates can be used to determine facts or make assumptions about someone without their knowledge.

|Harm|Description|Considerations|Example|
|-------------|----------|---------|---------|
|**Interference with private life**|Revealing information that a person choses not to share.|How could this technology use information to infer portions of a person's private life? <br><br> How could decisions based on these inferences expose information that a person prefers to keep private?|A task-tracking feature monitors personal patterns from which it infers an extramarital affair.|
|**Forced association**|Requiring participation in the use of technology or surveillance to take part in society.|How might people need this technology to participate in society or organization membership?|A job offer letter requires biometric enrollment in a company's meeting room transcription AI.|
|**Inability to freely and fully develop personality**| Restriction of one's ability to truthfully express themselves or explore external avenues for self-development.|How does this technology ascribe positive versus negative connotations toward particular personality traits? <br><br> How does this technology reveal information to entities such as the government or employer and inhibit free expression?| An intelligent meeting system records all discussions between colleagues, including personal coaching and mentorship sessions.|
|**Never forgotten**|Digital files or records are never deleted.|What and where is data stored from this product, and who can access it? <br><br> How long is user data stored after technology interaction? <br><br> How is user data updated or deleted?|A teenager's social media history remains searchable long after they outgrow the platform.|
|**Loss of freedom of movement or assembly**| An inability to navigate the physical or virtual world with desired anonymity.|How might this technology monitor people across physical and virtual space?|A real name is required to sign up for a video game, which enables real-world stalking.|

#### Environmental impact

Every decision in a system or product life cycle can affect the environment, from the amount of required cloud computing to retail packaging. Environmental changes can affect entire communities.

|Harm|Description|Considerations|Example|
|-------------|----------|---------|---------|
|**Exploitation or depletion of resources**|Obtaining the raw materials for technology, including how it's powered, leads to negative consequences to the environment and its inhabitants.|What materials are needed to build or run this technology? <br><br> What energy requirements are needed to build or run this technology?|A local community is displaced because a calculation determines that harvesting rare earth minerals in this location can lead to a large return on investment.|
|**Electronic waste**|Reduced quality of collective well-being because of the inability to repair, recycle, or otherwise responsibly dispose of electronics.|How might this technology reduce electronic waste by recycling materials or allowing users to self-repair? <br><br> How might this technology contribute to electronic waste when new versions are released or when current or past versions stop working?|Toxic materials inside disposable electronic devices leach into the water supply, which makes local populations ill.|
|**Carbon emissions**|Running inefficient cloud solutions leads to unnecessary carbon emissions and electricity waste, which harms the climate.|Do you have insights into how optimized your cloud workloads and solutions are? <br><br> What impact does your solution have on the climate, and does it differ based on the region where you deploy your workloads?|Inefficient or improperly designed solutions for cloud efficiency lead to a heavier toll on the climate, which causes unnecessary carbon emissions and electricity waste.|

### Erosion of social and democratic structures

#### Manipulation

Technology's ability to create highly personalized and manipulative experiences can undermine an informed citizenry and trust in societal structures.

|Harm|Description|Considerations|Example|
|-------------|----------|---------|---------|
|**Misinformation**|Disguising fake information as legitimate or credible information.|How might this technology be used to generate misinformation? <br><br> How could it be used to spread credible misinformation?|Synthetic speech of a political leader is generated, which sways an election.|
|**Behavioral exploitation**|Exploiting personal preferences or patterns of behavior to induce a desired reaction.|How might this technology be used to observe behavior patterns? <br><br> How could this technology be used to encourage dysfunctional or maladaptive behaviors?|Monitoring shopping habits in the connected retail environment leads to personalized incentives for impulse shoppers and hoarders.|

#### Social detriment

At scale, the way that technology affects people shapes social and economic structures within communities. It can further ingrain elements that include or benefit some people while excluding others.

|Harm|Description|Considerations|Example|
|-------------|----------|---------|---------|
|**Amplification of power inequality**|Perpetuating existing class or privilege disparities.|How might this technology be used in contexts that have existing social, economic or class disparities? <br><br> How might people with more power or privilege disproportionately influence this technology?|A job website requires a residential address and phone number to register, which prevents a homeless person from applying.|
|**Stereotype reinforcement**|Perpetuating uninformed "conventional wisdom" about historically or statistically underrepresented people.|How might this technology be used to reinforce or amplify existing social norms or cultural stereotypes? <br><br> How might the data used by this technology cause it to reflect biases or stereotypes?|The results of an image search for "CEO" primarily shows photos of Caucasian men.|
|**Loss of individuality**| An inability to express a unique perspective.|How might this technology amplify majority opinions or "group-think"? <br><br> Conversely, how might this technology suppress unique forms of expression? <br><br> How might this technology use its gathered data as feedback to people?|Limited customization options for a video game avatar inhibit self-expression of a player's diversity.|
|**Loss of representation**|Broad categories of generalization obscure, diminish, or erase real identities.|How could this technology constrain identity options? <br><br> Could it be used to label or categorize people automatically?|An automated photo caption assigns the incorrect gender identity and age to a subject.|
|**Skill degradation and complacency**|Overreliance on automation leads to atrophy of manual skills.|How might this technology reduce the accessibility and ability to use manual controls?|Pilots can't gauge an airplane's true orientation because they're trained to rely on instruments only.|

## Define harms that are specific to your workloads

Use the previous categories, questions, and examples to generate specific ideas for how harm could occur within your workload. Adapt and adopt other categories that are relevant to your scenario.

You can complete this harms modeling activity individually, but ideally, you should collaborate with stakeholders. When you design and implement the technology, involve developers, data scientists, designers, user researchers, business decision-makers, and other disciplines.

- **Intended use:** If [feature] is used for [use case], then [stakeholder] could experience [harm description].

- **Unintended use:** If [user] tried to use [feature] for [use case], then [stakeholder] could experience [harm description].
- **System error:** If [feature] failed to function properly when used for [use case], then [stakeholder] could experience [harm description].
- **Misuse:** [Malicious actor] could potentially use [feature] to cause [harm description] to [stakeholder].

### Use transparency documents

Some services provide [transparency documents](https://www.microsoft.com/ai/principles-and-approach#transparency-report). Transparency documents provide insights into how the service operates, its capabilities, limitations, and ethical considerations. You can review these documents to understand the inner workings of the service and help ensure responsible use.
 
When you build solutions on Azure, read through any transparency documents that your service offers. Factor in how those solutions align with your workload's harms modeling. Consider whether the service's functionalities and limitations introduce or mitigate risks in your specific use case.

## Evaluate harms

After you generate a broad list of potential harms, evaluate the potential magnitude for each harm category. This step prioritizes your areas of focus. Consider the following factors.

| Contributing factor | Definition |
| :------------------ | :--------- |
| Severity            | How acutely could the technology affect an individual or group's well-being? |
| Scale               | How broadly could the impact on well-being be experienced across populations or groups? |
| Probability         | How likely is the technology to affect an individual or group's well-being? |
| Frequency           | How often could the technology affect an individual or group's well-being? |

## Next steps

- [Microsoft Inclusive Design](https://inclusive.microsoft.design/)

See relevant articles about Responsible AI:

- [Responsible AI in Azure workloads](/azure/well-architected/ai/responsible-ai)
- [What is Responsible AI?](/azure/machine-learning/concept-responsible-ai)
