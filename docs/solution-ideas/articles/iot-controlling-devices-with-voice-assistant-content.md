<!-- cSpell:ignore khilscher -->

[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Create seamless conversational interfaces with all of your internet-accessible devices-from your connected television or fridge to devices in a connected power plant. By combining [Azure Speech Service](/azure/cognitive-services/speech-service/overview), [Language Understanding Service](/azure/cognitive-services/luis/) (LUIS) and [Azure Bot Framework](/azure/bot-service/?view=azure-bot-service-4.0), developers can create natural, human-like conversational interfaces to control smart devices using [Azure IoT Hub](https://azure.microsoft.com/services/iot-hub/).

## Architecture

![Architecture diagram](../media/controlling-iot-devices-using-voice.svg)

### Data flow

1. Using voice, the user asks the voice assistant app to turn on the exterior house lights.
1. Using the Speech SDK, the app connects to Direct Line Speech. If keywords are confirmed by Keyword Verification, the speech is transcribed to text and sent to the Bot Service.
1. The Bot Service connects to Language Understanding service (LUIS). LUIS allows an application to understand what a person wants in their own words. The intent of the user's request (example: TurnOnLight) is returned to the Bot Service.
1. The request is relayed to the device.
    * If the device is connected to Azure IoT Hub, Bot Service connects to Azure IoT Hub Service API and sends the command to the device using either a Direct Method, an update to the device twin's Desired Property, or a Cloud to Device message.
    * If the device is connected to a third party IoT cloud, Bot Service connects to the third-party service API and sends a command to the device.
1. The Bot returns the results of the command to the user by generating a response that includes the text to speak.
1. The response is turned into audio using the Text-to-speech service and passed back to the voice assistant app by Direct Line Speech.
1. Application Insights gathers runtime telemetry to help development with bot performance and usage
1. Azure App Service hosts the Bot Service application.

### Components

1. [Voice assistants documentation](/azure/cognitive-services/speech-service/index-voice-assistants)
1. [Tutorial: Voice-enable your bot using the Speech SDK](/azure/cognitive-services/speech-service/tutorial-voice-enable-your-bot-speech-sdk)
1. [What is Direct Line Speech](/azure/cognitive-services/speech-service/direct-line-speech)
1. [Azure Bot Service](/azure/bot-service/?view=azure-bot-service-4.0)
1. [Speech to Text](/azure/cognitive-services/speech-service/speech-to-text)
1. [Text to Speech](/azure/cognitive-services/speech-service/text-to-speech)
1. [Custom Keywords](/azure/cognitive-services/speech-service/speech-devices-sdk-create-kws)
1. [Language Understanding Service (LUIS)](/azure/cognitive-services/luis/)
1. [Azure IoT Hub](https://azure.microsoft.com/services/iot-hub/)

## Next steps

- To learn how to create a LUIS app and add intents to your app, see these articles:
    * [Create a LUIS app](/azure/cognitive-services/luis/luis-how-to-start-new-app)
    * [Add an intent and train a LUIS app](/azure/cognitive-services/luis/luis-how-to-add-intents)
- Learn more about adding a LUIS app to a bot, including:
   * How to [create a bot](/azure/bot-service/abs-quickstart?view=azure-bot-service-4.0) by using the [Azure Bot Service](/azure/bot-service/?view=azure-bot-service-4.0)
   * How to [add natural language understanding (LUIS) to a bot](/azure/bot-service/bot-builder-howto-v4-luis?view=azure-bot-service-4.0&tabs=csharp)
- Learn about various methods you can use to send commands to an IoT device by using [Azure IoT Hub](https://azure.microsoft.com/services/iot-hub/), including:
   * Sending [cloud-to-device commands](/azure/iot-hub/iot-hub-csharp-csharp-c2d)
   * Using [device twins](/azure/iot-hub/iot-hub-csharp-csharp-twin-getstarted)
   * Using [direct methods](/azure/iot-hub/iot-hub-devguide-direct-methods)
- Learn how to [build an enterprise-grade conversational bot](../../reference-architectures/ai/conversational-bot.yml) by using the [Azure Bot Service](/azure/bot-service/?view=azure-bot-service-4.0).
- To learn more about developing solutions by using IoT Hub, see the [Azure Iot Hub developer guide](/azure/iot-hub/iot-hub-devguide).
