Document for submission to the Azure Engineering Team – a story about Veriown.
From: Bob Rapp (Hybrid Cloud Gurus) v-rorapp@microsoft.com +1 425 442 0945
To: Derek Martin (Microsoft) derek.martin@microsoft.com  +1 (469) 7752918

First Draft – not for public release until agreed to by DWarne@Veriown.com – VP of Product – and Bob Rapp v-rorapp@microsoft.com – single-point-of-contact
June 9, 2020 2:58pm – first draft - 
Article starts below:

“We are using Microsoft Azure – machine learning, artificial intelligence, big data, real-time streaming, data bricks, cosmos db, sql warehouse (new name), IOT Edge and IOT Gateway, Power BI,  Docker containers, Kubernetes – all the ensure that power never goes out”  Shared Derek Martin, Vice President of Product at Veriown – who have the mission of replacing kerosene with solar, improving the lives of millions, and doing it all powered by Microsoft.

“One of the hardest problems of having a device in a customer’s home that provides power to their devices, entertainment and education to the entire family, communication for their business and light for their home, all in a package that they can afford to own – is that we have to provide it for pennies a day – with very high reliability and low downtime. “

Derek has been running massive scale infrastructure for many years in the network and telco space, but never at such a low cost and high scale – so he was very interested in how Azure could help “Keep the lights on – and the battery always charged”.  

There are two major workstreams that Azure powers – real-time telematics on each IOT device so that Veriown can see in real-time any anomaly – whether transient or long-running – and begin to respond with real-time chatbots and direct software reprogramming to help the customers device automatically reduce it’s power usages for usb charging or reduce the intensity of the lumanaries (led lights) so that the user gets a great experience, delivered via Azure.

The second workstream is the data analytics post-processing so that after an incident Veriown can analyze the anomaly and determine if there is an algorithm that can be used to improve preventative maintenance – sending the customer the part that will fail in the future, improve response time to an issue via a chat powered by AI and to see what customer usage patterns of the content streams can allow Veriown to target the customers with the right content, at the right time as bandwidth is very limited and expensive in emerging markets.

For case number one, we will show the data stream coming from the power subsystem to iot edge/hub, to sql warehouse, data bricks , to cosmodb and finally to power bi dashboard to show real-time customer view 

(three or four architecture  diagrams – 
1.	Data structure (not all some propr)
2.	Input and output by each azure subsystem used 
3.	A screen shot of the power bi 
4.	Possibly one more shot 

The second is a short workflow taking post-processing data and running through a trained ai model – about power or defect (prevent main)

Edit at will – please put revision marks on – so we can track

Thanks all 
