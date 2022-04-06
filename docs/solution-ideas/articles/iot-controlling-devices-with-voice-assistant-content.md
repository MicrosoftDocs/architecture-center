<!-- cSpell:ignore khilscher -->

[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Create seamless conversational interfaces with all of your internet-accessible devices-from your connected television or fridge to devices in a connected power plant. By combining [Azure Speech Service](/azure/cognitive-services/speech-service/overview), [Language Understanding Service](/azure/cognitive-services/luis) (LUIS) and [Azure Bot Service](/azure/bot-service), developers can create natural, human-like conversational interfaces to control smart devices using [Azure IoT Hub](https://azure.microsoft.com/services/iot-hub).

## Architecture

![Architecture diagram](../media/controlling-iot-devices-using-voice.svg)

### Dataflow

1. Through a voice device, the user asks the voice assistant app to turn on the exterior house lights.
1. The app connects to [Direct Line Speech](/azure/cognitive-services/speech-service/direct-line-speech) by using the [Speech SDK](/azure/cognitive-services/speech-service/speech-sdk). If [keyword recognition](/azure/cognitive-services/speech-service/keyword-recognition-overview) confirms keywords, Direct Line Speech transcribes the [speech to text](/azure/cognitive-services/speech-service/speech-to-text) and sends the text to the Bot Service hosted on Azure App Service.
1. The Bot Service connects to the Language Understanding (LUIS) service. LUIS determines the intent of the user's request, *TurnOnLight*, and returns the intent to the Bot Service.
1. Bot Service relays the request to the IoT devices and turns on the exterior lights.

   If the devices are connected to Azure IoT Hub, Bot Service uses the [IoT Hub API](/rest/api/iothub) to send the command to the devices by using [direct methods](/azure/iot-hub/iot-hub-devguide-direct-methods), updating the [device twin's desired property](/azure/iot-hub/iot-hub-csharp-csharp-twin-getstarted), or sending a [cloud to device message](/azure/iot-hub/iot-hub-csharp-csharp-c2d). If the devices are connected to a third-party IoT installation, Bot Service connects to the third-party API to send a command to the devices.

1. The Bot Service returns the results of the command to the user by generating a response.
1. The [text-to-speech](/azure/cognitive-services/speech-service/text-to-speech) service turns the response into audio and passes it back to the voice assistant app with Direct Line Speech.
1. Application Insights gathers runtime telemetry for bot performance and usage development.

### Components

- [Bot Service]()
- [Speech Service]()
- [Language Understanding Service (LUIS)](/azure/cognitive-services/luis/)
- [IoT Hub](https://azure.microsoft.com/services/iot-hub/)
- [Application Insights]()


LUIS allows an application to understand what a person wants in their own words. 

## Next steps

- [Voice assistants documentation](/azure/cognitive-services/speech-service/index-voice-assistants)
- [Quickstart: Create a custom keyword](/azure/cognitive-services/speech-service/custom-keyword-basics)
- [Create a bot](/azure/bot-service/abs-quickstart)
- [Tutorial: Voice-enable your bot using the Speech SDK](/azure/cognitive-services/speech-service/tutorial-voice-enable-your-bot-speech-sdk)
- [Add natural language understanding (LUIS) to a bot](/azure/bot-service/bot-builder-howto-v4-luis)
- [Create a LUIS app](/azure/cognitive-services/luis/luis-how-to-start-new-app)
- [Add an intent and train a LUIS app](/azure/cognitive-services/luis/luis-how-to-add-intents)
- [Azure Iot Hub developer guide](/azure/iot-hub/iot-hub-devguide).

## Related resources

- [Build an enterprise-grade conversational bot](../../reference-architectures/ai/conversational-bot.yml)
