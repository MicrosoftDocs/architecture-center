AI on the edge is one of the most popular edge scenarios. Implementations of this scenario include image classification, object detection, body, face, and gesture analysis, and image manipulation. This architecture guide describes how to use Azure IoT Edge to support these scenarios. 

You can improve AI accuracy by updating the AI model, but in some scenarios the edge device network environment isn't good. For example, in the wind power and oil industries, equipment might be located in the desert or the ocean.

IoT Edge module twins are used to implement the dynamically loaded AI model. IoT Edge modules are based on Docker. An image for an IoT Edge module in an AI environment typically has a size of at least 1 GB, so incrementally updating the AI model is important in a narrow-bandwidth network. That consideration is the main focus of this article. The idea is to create an IoT Edge AI module that can load TensorFlow Lite or Open Neural Network Exchange (ONNX) object detection models. You can also enable the module as a web API so that you can use it to benefit other applications or modules.

The solution described in this article can help you in these ways:

- Enable AI inference on edge devices.
- Minimize the network cost of deploying and updating AI models on the edge. The solution can save money for you or your customers, especially in a narrow-bandwidth network environment.
- Create and manage an AI model repository in an IoT edge device's local storage.
- Achieve almost zero downtime when the edge device switches AI models.

*[TensorFlow](https://www.tensorflow.org) is a trademark of Google Inc. No endorsement is implied by the use of this mark.*

## Architecture

:::image type="content" source="media/machine-learning-inference.png" alt-text="Diagram that shows an architecture that supports machine learning inference." lightbox="media/machine-learning-inference.png" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/machine-learning-inference.vsdx) of this architecture.*

### Dataflow

1.	The AI model is uploaded to Azure Blob Storage or a web service. The model can be a pre-trained TensorFlow Lite or ONNX model or a model created in Azure Machine Learning. The IoT Edge module can access this model and download it to the edge device later. If you need better security, consider using private endpoint connections between Blob Storage and the edge device.
2.	Azure IoT Hub syncs device module twins automatically with AI model information. The sync occurs even if IoT Edge has been offline. (In some cases, IoT devices are connected to networks at scheduled hourly, daily, or weekly times to save power or reduce network traffic.)
3.	The loader module monitors the updates of the module twins via API. When it detects an update, it gets the machine learning model SAS token and then downloads the AI model. 
    - For more information, see [Create SAS token for a container or blob](/azure/storage/blobs/sas-service-create).
    - You can use the **ExpiresOn** property to set the expiration date of resources. If your device will be offline for a long time, you can extend the expiration time.
4.	The loader module saves the AI model in the shared local storage of the IoT Edge module. You need to configure the shared local storage in the IoT Edge deployment JSON file.
5.	The loader module loads the AI model from local storage via the TensorFlow Lite or ONNX API.
6.	The loader module starts a web API that receives the binary photo via POST request and returns the results in a JSON file.

To update the AI model, you can upload the new version to Blob Storage and sync the device module twins again for an incremental update. There's no need to update the whole IoT Edge module image.

## Scenario details

In this solution, an IoT Edge module is used to download an AI model and then enable machine learning inference. You can use pre-trained TensorFlow Lite or ONNX models in this solution.

The next two sections clarify some concepts about machine learning inference modules, TensorFlow Lite, and ONNX.

### TensorFlow Lite

- A **.tflite* file is a pre-trained AI model. You can download one from [TensorFlow.org](https://www.tensorflow.org/lite/examples/object_detection/overview). It's a generic AI model that you can use in cross-platform applications like iOS and Android. For more information about metadata and associated fields (for example, `labels.txt`) see [Read the metadata from models](https://www.tensorflow.org/lite/models/convert/metadata#read_the_metadata_from_models).
- An object detection model is trained to detect the presence and location of multiple classes of objects. For example, a model might be trained with images that contain various pieces of fruit, along with a label that specifies the class of fruit that they represent (for example, apple) and data that specifies where each object appears in the image.

  When an image is provided to the model, it outputs a list of the objects that it detects, the location of a bounding box for each object, and a score that indicates the confidence of the detection.
- If you want to build or custom-tune an AI model, see [TensorFlow Lite Model Maker](https://www.tensorflow.org/lite/models/modify/model_maker).
- You can get more free pre-trained detection models, with various latency and precision characteristics, at [Detection Zoo](https://github.com/tensorflow/models/blob/master/research/object_detection/g3doc/tf1_detection_zoo.md#mobile-models). Each model uses the input and output signatures shown in the following code samples.

### ONNX

ONNX is an open-standard format for representing machine learning models. It's supported by a community of partners who have implemented it in many frameworks and tools.

- ONNX supports tools for building and deploying models and for accomplishing other tasks. For more information, see, [Supported ONNX tools](https://onnx.ai/supported-tools.html).
- You can use ONNX Runtime to run ONNX pre-trained models. For information about pre-trained models, see [ONNX Model Zoo](https://github.com/onnx/models).
- For this scenario, you can use an object detection and image segmentation model: [Tiny YOLOv3](https://github.com/onnx/models/tree/main/vision/object_detection_segmentation/tiny-yolov3).

The ONNX community [provides tools](https://onnx.ai/supported-tools.html) to help you create and deploy your deep learning model.

## Download trained AI models

To download trained AI models, we recommend that you use device twins to receive notifications when a new model is ready. Even if the device is offline, the message can be cached in IoT Hub until the edge device comes back online. The message will be  synchronized automatically.

Following is an example of Python code that registers notifications for the device twins and then downloads the AI model in a ZIP file. It also performs further operations on the downloaded file.

The code performs these tasks: 

1.	Receive the device twins notification. The notification includes the file name, file download address, and MD5 authentication token. (In the file name, you can include version information, like 1.0.)
2.	Download the AI model as a ZIP file to local storage.
3.	Optionally, perform MD5 checksum. MD5 verification helps prevent ZIP files that have been tampered with during network transmission.
4.	Unzip the ZIP file and save it locally.
5.	Send a notification to IoT Hub or a routing message to report that the new AI model is ready.

```python
# define behavior for receiving a twin patch
async def twin_patch_handler(patch):
    try:
        print( "######## The data in the desired properties patch was: %s" % patch)
        if "FileName" in patch:
            FileName = patch["FileName"]
        if "DownloadUrl" in patch:
            DownloadUrl = patch["DownloadUrl"]
        if "ContentMD5" in patch:
            ContentMD5 = patch["ContentMD5"]
        FilePath = "/iotedge/storage/" + FileName

        # download AI model
        r = requests.get(DownloadUrl)
        print ("######## download AI Model Succeeded.")
        ffw = open(FilePath, 'wb')
        ffw.write(r.content)
        ffw.close()
        print ("######## AI Model File: " + FilePath)

        # MD5 checksum
        md5str = content_encoding(FilePath)
        if md5str == ContentMD5:
            print ( "######## New AI Model MD5 checksum succeeded")
            # decompressing the ZIP file
            unZipSrc = FilePath
            targeDir = "/iotedge/storage/"
            filenamenoext = get_filename_and_ext(unZipSrc)[0]
            targeDir = targeDir + filenamenoext
            unzip_file(unZipSrc,targeDir)
            
            # ONNX
            local_model_path = targeDir + "/tiny-yolov3-11.onnx"
            local_labelmap_path = targeDir + "/coco_classes.txt"

            # TensorFlow flite
            # local_model_path = targeDir + "/ssd_mobilenet_v1_1_metadata_1.tflite"
            # local_labelmap_path = targeDir + "/labelmap.txt"

            # message to module
            if client is not None:
                print ( "######## Send AI Model Info AS Routing Message")
                data = "{\"local_model_path\": \"%s\",\"local_labelmap_path\": \"%s\"}" % (filenamenoext+"/tiny-yolov3-11.onnx", filenamenoext+"/coco_classes.txt")
                await client.send_message_to_output(data, "DLModelOutput")
                # update the reported properties
                reported_properties = {"LatestAIModelFileName": FileName }
                print("######## Setting reported LatestAIModelName to {}".format(reported_properties["LatestAIModelFileName"]))
                await client.patch_twin_reported_properties(reported_properties)
        else:
            print ( "######## New AI Model MD5 checksum failed")

    except Exception as ex:
        print ( "Unexpected error in twin_patch_handler: %s" % ex )
```

## Inference 

After the AI model is downloaded, the next step is to use the model on the edge device. You can dynamically load the model and perform object detection on edge devices. The following code example shows how to use the TensorFlow Lite AI model to detect objects on edge devices.

The code performs these tasks: 

1.	Dynamically load the TensorFlow Lite AI model.
2.	Perform image standardization.
3.	Detect objects.
4.	Compute detection scores.

```python
class InferenceProcedure():
    
    def detect_object(self, imgBytes):

        results = []
        try:
            model_full_path = AI_Model_Path.Get_Model_Path()
            if(model_full_path == ""):
                raise Exception ("PLEASE SET AI MODEL FIRST")
            if '.tflite' in model_full_path:
                interpreter = tf.lite.Interpreter(model_path=model_full_path)
                interpreter.allocate_tensors()
                input_details = interpreter.get_input_details()
                output_details = interpreter.get_output_details()
                input_shape = input_details[0]['shape']

                # bytes to numpy.ndarray
                im_arr = np.frombuffer(imgBytes, dtype=np.uint8)
                img = cv2.imdecode(im_arr, flags=cv2.IMREAD_COLOR)
                im_rgb = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
                im_rgb = cv2.resize(im_rgb, (input_shape[1], input_shape[2]))
                input_data = np.expand_dims(im_rgb, axis=0)

                interpreter.set_tensor(input_details[0]['index'], input_data)
                interpreter.invoke()
                output_data = interpreter.get_tensor(output_details[0]['index'])
                detection_boxes = interpreter.get_tensor(output_details[0]['index'])
                detection_classes = interpreter.get_tensor(output_details[1]['index'])
                detection_scores = interpreter.get_tensor(output_details[2]['index'])
                num_boxes = interpreter.get_tensor(output_details[3]['index'])

                label_names = [line.rstrip('\n') for line in open(AI_Model_Path.Get_Labelmap_Path())]
                label_names = np.array(label_names)
                new_label_names = list(filter(lambda x : x != '???', label_names))

                for i in range(int(num_boxes[0])):
                    if detection_scores[0, i] > .5:
                        class_id = int(detection_classes[0, i])
                        class_name = new_label_names[class_id]
                        # top,	left,	bottom,	right
                        results_json = "{'Class': '%s','Score': '%s','Location': '%s'}" % (class_name, detection_scores[0, i],detection_boxes[0, i])
                        results.append(results_json)
                        print(results_json)
        except Exception as e:
            print ( "detect_object unexpected error %s " % e )
            raise

        # return results
        return json.dumps(results)
```

Following is the ONNX version of the preceding code. The steps are mostly the same. The only difference is how the detection score is handled, because the `Labelmap` and model output parameters are different.

```python
class InferenceProcedure():

    def letterbox_image(self, image, size):
        '''resize image with unchanged aspect ratio using padding'''
        iw, ih = image.size
        w, h = size
        scale = min(w/iw, h/ih)
        nw = int(iw*scale)
        nh = int(ih*scale)

        image = image.resize((nw,nh), Image.BICUBIC)
        new_image = Image.new('RGB', size, (128,128,128))
        new_image.paste(image, ((w-nw)//2, (h-nh)//2))
        return new_image

    def preprocess(self, img):
        model_image_size = (416, 416)
        boxed_image = self.letterbox_image(img, tuple(reversed(model_image_size)))
        image_data = np.array(boxed_image, dtype='float32')
        image_data /= 255.
        image_data = np.transpose(image_data, [2, 0, 1])
        image_data = np.expand_dims(image_data, 0)
        return image_data

    def detect_object(self, imgBytes):
        results = []
        try:
            model_full_path = AI_Model_Path.Get_Model_Path()
            if(model_full_path == ""):
                raise Exception ("PLEASE SET AI MODEL FIRST")
            if '.onnx' in model_full_path:

                # input
                image_data = self.preprocess(imgBytes)
                image_size = np.array([imgBytes.size[1], imgBytes.size[0]], dtype=np.float32).reshape(1, 2)

                labels_file = open(AI_Model_Path.Get_Labelmap_Path())
                labels = labels_file.read().split("\n")

                # Loading ONNX model
                print("loading Tiny YOLO...")
                start_time = time.time()
                sess = rt.InferenceSession(model_full_path)
                print("loaded after", time.time() - start_time, "s")

                input_name00 = sess.get_inputs()[0].name
                input_name01 = sess.get_inputs()[1].name
                pred = sess.run(None, {input_name00: image_data,input_name01:image_size})
 
                boxes = pred[0]
                scores = pred[1]
                indices = pred[2]

                results = []
                out_boxes, out_scores, out_classes = [], [], []
                for idx_ in indices[0]:
                    out_classes.append(idx_[1])
                    out_scores.append(scores[tuple(idx_)])
                    idx_1 = (idx_[0], idx_[2])
                    out_boxes.append(boxes[idx_1])
                    results_json = "{'Class': '%s','Score': '%s','Location': '%s'}" % (labels[idx_[1]], scores[tuple(idx_)],boxes[idx_1])
                    results.append(results_json)
                    print(results_json)

        except Exception as e:
            print ( "detect_object unexpected error %s " % e )
            raise

        # return results
        return json.dumps(results)
```

If your IoT edge device incorporates the preceding code and features, your edge device has AI image object detection and supports dynamic update of AI models. If you want the edge module to provide AI functionality to other applications or modules via a web API, you can create a web API in your module.

Flask framework is one example of a tool that you can use to quickly create an API. You can receive images as binary data, use an AI model for detection, and then return the results in a JSON format. For more information, see [Flask: Flask Tutorial in Visual Studio Code](https://code.visualstudio.com/docs/python/tutorial-flask).

## Contributors 

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

 * [Bo Wang](https://www.linkedin.com/in/bo-wang-67755673) | Senior Software Engineer 

Other contributor: 

 * [Mick Alberts](https://www.linkedin.com/in/mick-alberts-a24a1414) | Technical Writer

*To see non-public LinkedIn profiles, sign in to LinkedIn.* 

## Next steps

- [Understand and use module twins in IoT Hub](/azure/iot-hub/iot-hub-devguide-module-twins)
- [Learn how to deploy modules and establish routes in IoT Edge](/azure/iot-edge/module-composition)
- [Give modules access to a device's local storage](/azure/iot-edge/how-to-access-host-storage-from-module#link-module-storage-to-device-storage)
- [Understand IoT Edge automatic deployments for single devices or at scale](/azure/iot-edge/module-deployment-monitoring)
- [Open Neural Network Exchange](https://github.com/onnx)
- [ONNX Tutorials](https://github.com/onnx/tutorials)
- [Deploy a machine learning model on IoT and edge devices](https://github.com/microsoft/onnxruntime/blob/gh-pages/docs/tutorials/iot-edge/index.md)

## Related resources

- [IoT architecture design](../../reference-architectures/iot/iot-architecture-overview.md)
- [Choose an IoT solution in Azure](../../example-scenario/iot/iot-central-iot-hub-cheat-sheet.yml)
- [AI architecture design](../../data-guide/big-data/ai-overview.md)
